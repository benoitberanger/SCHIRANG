function [ EP, Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.Environement    = 'MRI';
    S.OperationMode   = 'Acquisition';
end


%% Paradigme

Parameters = struct;

switch S.OperationMode
    case 'Acquisition'
        Parameters.MinPauseBetweenTrials = 4.0; % seconds
        Parameters.MaxPauseBetweenTrials = 6.0; % seconds
        Parameters.Blank                 = 0.5; % seconds
        Parameters.DisplayPicture        = 2.0; % seconds
        Parameters.Answer                = 3.0; % seconds
    case 'FastDebug'
        Parameters.MinPauseBetweenTrials = 0.5; % seconds
        Parameters.MaxPauseBetweenTrials = 1.0; % seconds
        Parameters.Blank                 = 0.5; % seconds
        Parameters.DisplayPicture        = 2.0; % seconds
        Parameters.Answer                = 1.0; % seconds
    case 'RealisticDebug'
        Parameters.MinPauseBetweenTrials = 0.5; % seconds
        Parameters.MaxPauseBetweenTrials = 1.0; % seconds
        Parameters.Blank                 = 0.5; % seconds
        Parameters.DisplayPicture        = 2.0; % seconds
        Parameters.Answer                = 1.0; % seconds
end


%% Define a planning <--- paradigme

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'jitter(s)', 'blank(s)', 'picture(s)', 'answer(s)' };
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime', 0);

% --- Stim ----------------------------------------------------------------

for osef = 1:3
    jitter = Parameters.MinPauseBetweenTrials + (Parameters.MaxPauseBetweenTrials-Parameters.MinPauseBetweenTrials)*rand;
    EP.AddEvent({'test' NextOnset(EP) 16 jitter Parameters.Blank Parameters.DisplayPicture Parameters.Answer});
end

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime', NextOnset(EP));


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargout < 1
    
    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )
    
    EP.Plot
    
end

end % function
