function [ EP, Parameters ] = Planning( S )


if nargin < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.PTB.FPS         = 60;
    S.Side            = 'Left';
    S.Environement    = 'MRI';
    S.Parameters      = GetParameters;
    
    S.OperationMode   = 'Acquisition';
    %     S.OperationMode   = 'FastDebug';
    %     S.OperationMode   = 'RealisticDebug';
    
    S.Task            = 'DetectCEIL';
    %     S.Task            = 'AroundCEIL';
    
end


%% Paradigme/mnt/data/benoit/Protocol/SCHIRANG/code
% Each picture has to be presented in each run.
% Each picture will be presented the same number of times (1x each, 2x each, ...)
% So the only parameter is this repetition factor : x1, x2, x3, ...

Parameters = struct;

switch S.OperationMode
    case 'Acquisition'
        Parameters.MinPauseBetweenTrials = 4.0; % seconds
        Parameters.MaxPauseBetweenTrials = 6.0; % seconds
        Parameters.Blank                 = 0.5; % seconds
        Parameters.DisplayPicture        = 2.0; % seconds
        Parameters.Answer                = 3.0; % seconds
        switch S.Task
            case 'DetectCEIL'
                Parameters.RepetitionFactor = 3;
            case 'AroundCEIL'
                Parameters.RepetitionFactor = 1;
        end
    case 'FastDebug'
        Parameters.MinPauseBetweenTrials = 0.2; % seconds
        Parameters.MaxPauseBetweenTrials = 0.3; % seconds
        Parameters.Blank                 = 0.2; % seconds
        Parameters.DisplayPicture        = 0.2; % seconds
        Parameters.Answer                = 0.2; % seconds
        switch S.Task
            case 'DetectCEIL'
                Parameters.RepetitionFactor = 1;
            case 'AroundCEIL'
                Parameters.RepetitionFactor = 1;
        end
    case 'RealisticDebug'
        Parameters.MinPauseBetweenTrials = 4.0; % seconds
        Parameters.MaxPauseBetweenTrials = 6.0; % seconds
        Parameters.Blank                 = 0.5; % seconds
        Parameters.DisplayPicture        = 2.0; % seconds
        Parameters.Answer                = 3.0; % seconds
        switch S.Task
            case 'DetectCEIL'
                Parameters.RepetitionFactor = 1;
            case 'AroundCEIL'
                Parameters.RepetitionFactor = 1;
        end
end

Categories = S.Parameters.(S.Task).Images.Categories;
Values     = S.Parameters.(S.Task).Images.Values;
nrCategories = size(Categories,1);
nrValues     = length(Values);

Paradigm = cell(nrCategories*nrValues*Parameters.RepetitionFactor,3);
nrEvents = size(Paradigm,1);

% Randomize the order of conditions
Sequence = [];
for rep = 1 : Parameters.RepetitionFactor
    
    beforeShuffle = [];
    for c = 1 : nrCategories
        beforeShuffle = [beforeShuffle ones(1,nrValues)*c]; %#ok<AGROW>
    end % categories
    Sequence = [Sequence Shuffle(beforeShuffle)]; %#ok<AGROW>
    
end

% Initialize the pool of Values
pool = struct;
for c = 1 : nrCategories
    pool.(sprintf('%sVS%s%s',Categories{c,1},Categories{c,2},Categories{c,3})) = Shuffle(1:nrValues);
end % categories

% Fill paradigm with randomized events
for evt = 1 : nrEvents
    
    catName = sprintf('%sVS%s%s',Categories{Sequence(evt),1},Categories{Sequence(evt),2},Categories{Sequence(evt),3});
    
    Paradigm{evt,1} = catName; % save condition name (str)
    
    if isempty(pool.(catName)) % refill the pool if necessary
        while 1
            pool.(catName) = Shuffle(1:nrValues);                     % shuffle a pool of values
            if ~strcmp(Paradigm{evt-1,2},Values{pool.(catName)(end)}) % be sure to not have 2 times the same value in a row (it can happen after a refill)
                break
            end
        end
    end
    
    Paradigm{evt,2} = Values{pool.(catName)(end)}; % save value name  (str)
    Paradigm{evt,3} = pool.(catName)(end);         % save value index (int)
    
    pool.(catName)(end) = []; % remove the Value used
    
end % events

% Just to check
for c = 1 : nrCategories
    catName = sprintf('%sVS%s%s',Categories{c,1},Categories{c,2},Categories{c,3});
    assert( isempty(pool.(catName)), 'pool of values for %s is not in the end', catName )
end % categories

Parameters.Paradigm = Paradigm;


%% Define a planning <--- paradigme

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'jitter(s)', 'Category (str)', 'Value (str)', 'Value index (uint)'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime', 0);

% --- Stim ----------------------------------------------------------------

for evt = 1 : nrEvents
    jitter = Parameters.MinPauseBetweenTrials + (Parameters.MaxPauseBetweenTrials-Parameters.MinPauseBetweenTrials)*rand; % seconds
    jitter = round(jitter*S.PTB.FPS)/S.PTB.FPS; % still seconds but it is rounded toward an integer number of frames
    
    duration = jitter + Parameters.Blank + Parameters.DisplayPicture + Parameters.Answer;
    
    EP.AddEvent({[Paradigm{evt,1} '_' Paradigm{evt,2}] NextOnset(EP) duration jitter Paradigm{evt,1} Paradigm{evt,2} Paradigm{evt,3}});
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
