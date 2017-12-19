function [ ER, RR, KL] = PrepareRecorders( EP )
global S

%% Prepare event record

% Create
switch S.Task
    case 'CEIL'
        ER = EventRecorder( EP.Header(1:3) , EP.EventCount );
    case 'RECOG'
        ER = EventRecorder( EP.Header(1:3) , EP.EventCount );
    case 'EyelinkCalibration'
end

% Prepare
ER.AddStartTime( 'StartTime' , 0 );


%% Response recorder

% Create
RR = EventRecorder( { 'event_name' , 'onset(s)' , 'duration(s)' , 'content' } , 5000 ); % high arbitrary value : preallocation of memory

% Prepare
RR.AddStartTime( 'StartTime' , 0 );

%% Prepare the logger of MRI triggers

KbName('UnifyKeyNames');

KL = KbLogger( ...
    [ struct2array(S.Parameters.Keybinds) S.Parameters.Fingers.All ] ,...
    [ KbName(struct2array(S.Parameters.Keybinds)) S.Parameters.Fingers.Names ] );

% Start recording events
KL.Start;


end % function
