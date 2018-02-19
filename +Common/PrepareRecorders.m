function [ ER, RR, KL, BR] = PrepareRecorders( EP )
global S

%% Prepare event record

% Create
switch S.Task
    case 'DetectCEIL'
        ER = EventRecorder( EP.Header(1:3) , EP.EventCount );
    case 'AroundCEIL'
        ER = EventRecorder( EP.Header(1:3) , EP.EventCount );
end

% Prepare
ER.AddStartTime( 'StartTime' , 0 );


%% Response recorder

% Create
RR = EventRecorder( { 'event_name' , 'onset(s)' , 'duration(s)' , 'content' } , 5000 ); % high arbitrary value : preallocation of memory

% Prepare
RR.AddStartTime( 'StartTime' , 0 );


%% Behaviour recorder

% Create
BR = EventRecorder( { 'event_name' , 'category' , 'value' , 'yes' , 'no' , 'missed' , 'ReactionTime (ms)' } , EP.EventCount ); % high arbitrary value : preallocation of memory


%% Prepare the logger of MRI triggers

KbName('UnifyKeyNames');

KL = KbLogger( ...
    [ struct2array(S.Parameters.Keybinds) S.Parameters.Fingers.Yes S.Parameters.Fingers.No ] ,...
    [ KbName(struct2array(S.Parameters.Keybinds)) S.Parameters.Fingers.Names ] );

% Start recording events
KL.Start;


end % function
