function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = DetectCEIL.Planning;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybinf logger
    
    [ ER, RR, KL, BR ] = Common.PrepareRecorders( EP );
    
    
    %% Prepare objects
    
    Cross  = DetectCEIL.Prepare.Cross;
    [ CatValImg , imageArray ]= DetectCEIL.Prepare.Image;
    
    [ Yes, No, Question ] = DetectCEIL.Prepare.Texts;
    
    
    %% Eyelink
    
    Common.StartRecordingEyelink
    
    
    %% Go
    
    % Initialize some variables
    EXIT = 0;
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        Common.CommandWindowDisplay( EP, evt );
        
        eventName     = EP.Get('name'    ,evt);
        eventCategory = EP.Get('Category',evt);
        eventValue    = EP.Get('Value'   ,evt);
        eventValueIDX = EP.Get('index'   ,evt);
        
        switch eventName
            
            case 'StartTime' % --------------------------------------------
                
                Cross.Draw
                Screen('DrawingFinished',S.PTB.wPtr);
                Screen('Flip',S.PTB.wPtr);
                
                StartTime = Common.StartTimeEvent;
                lastFlipOnset = StartTime - Parameters.Answer; % just to conpensate @ first trial
                
            case 'StopTime' % ---------------------------------------------
                
                % Fixation duration handeling
                
                StopTime = WaitSecs('UntilTime', lastFlipOnset + Parameters.Answer );
                
                % Record StopTime
                ER.AddStopTime( 'StopTime' , StopTime - StartTime );
                RR.AddStopTime( 'StopTime' , StopTime - StartTime );
                
                ShowCursor;
                Priority( 0 );
                
            otherwise % ---------------------------------------------------
                %% ~~~ Step 1 : Jitter between trials ~~~
                
                Cross.Draw
                when = lastFlipOnset + Parameters.Answer - S.PTB.slack;
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                ER.AddEvent({eventName lastFlipOnset-StartTime []})
                RR.AddEvent({['Jitter__' eventName] lastFlipOnset-StartTime [] []})
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % when = lastFlipOnset + EP.Get('jitter',evt) - S.PTB.slack;
                when = StartTime + EP.Get('onset',evt) + EP.Get('jitter',evt) - S.PTB.slack; % more accurate ? conpensate the delay introduced by the machine
                while 1
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    if secs >= when
                        break
                    end
                end
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %% ~~~ Step 2 : Blank screen ~~~
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                RR.AddEvent({['Blank__' eventName] lastFlipOnset-StartTime [] []})
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                when = lastFlipOnset + Parameters.Blank - S.PTB.slack;
                while 1
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    if secs >= when
                        break
                    end
                end
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %% ~~~ Step 3 : Picture ~~~
                
                % Image selector
                currentImage = CatValImg.(eventCategory){eventValueIDX};
                fprintf('%s \n',currentImage.filename)
                currentImage.Draw
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                RR.AddEvent({['Picture__' eventName] lastFlipOnset-StartTime [] []})
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                when = lastFlipOnset + Parameters.DisplayPicture - S.PTB.slack;
                while 1
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    if secs >= when
                        break
                    end
                end
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %% ~~~ Step 4 : Answer ~~~
                
                Yes.Draw
                No.Draw
                Question.Draw
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                RR.AddEvent({['Answer__' eventName] lastFlipOnset-StartTime [] []})
                
                when = lastFlipOnset + Parameters.Answer - S.PTB.slack;
                has_clicked = 0;
                while 1
                    
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    
                    if keyIsDown
                        
                        if ~has_clicked
                            if keyCode(S.Parameters.Fingers.Yes) % YES
                                Yes.color = S.Parameters.Text.ClickCorlor;
                                Yes.Draw
                                Screen('DrawingFinished',S.PTB.wPtr);
                                Screen('Flip', S.PTB.wPtr);
                                BR.AddEvent({eventName eventCategory eventValue 1 0 0 round((secs-lastFlipOnset)*1000)})
                                has_clicked = 1;
                            elseif keyCode(S.Parameters.Fingers.No) % NO
                                No.color  = S.Parameters.Text.ClickCorlor;
                                No.Draw
                                Screen('DrawingFinished',S.PTB.wPtr);
                                Screen('Flip', S.PTB.wPtr);
                                BR.AddEvent({eventName eventCategory eventValue 0 1 0 round((secs-lastFlipOnset)*1000)})
                                has_clicked = 1;
                            end
                        end
                        
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                        
                    end
                    
                    if secs >= when
                        break
                    end
                    
                end % while
                
                if EXIT
                    break
                end
                
                Yes.color = S.Parameters.Text.Color;
                No .color = S.Parameters.Text.Color;
                
                if ~has_clicked
                    BR.AddEvent({eventName eventCategory eventValue 0 0 1 -1})
                end
                
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
    
    %% End of stimulation
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, StartTime, StopTime );
    TaskData.Parameters = Parameters;
    
    % Behaviour recordings
    BR.ClearEmptyEvents;
    TaskData.BR = BR;
    assignin('base','BR',BR)
    
    % Close all PTB textures
    Screen('Close', [imageArray.texPtr])
    
    
catch err
    
    Common.Catch( err );
    
end

end % function
