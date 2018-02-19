function [ EP, Parameters ] = Planning
global S

if isempty(S) % only to plot the paradigme when we execute the function outside of the main script
    S.Environement    = 'MRI';
    S.OperationMode   = 'Acquisition';
    %     S.OperationMode   = 'FastDebug';
    %     S.OperationMode   = 'RealisticDebug';
    S.Side            = 'Left';
    S.Parameters      = GetParameters;
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
                Parameters.RepetitionFactor = 1;
            case 'AroundCEIL'
                Parameters.RepetitionFactor = 5;
        end
    case 'FastDebug'
        Parameters.MinPauseBetweenTrials = 0.2; % seconds
        Parameters.MaxPauseBetweenTrials = 0.5; % seconds
        Parameters.Blank                 = 0.5; % seconds
        Parameters.DisplayPicture        = 0.5; % seconds
        Parameters.Answer                = 0.5; % seconds
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
                Parameters.RepetitionFactor = 5;
        end
end


Categories = S.Parameters.(S.Task).Images.Categories;
Values     = S.Parameters.(S.Task).Images.Values;

nrCategories = size(Categories,1);
nrValues     = length(Values);

Paradigm = cell(nrCategories*nrValues*Parameters.RepetitionFactor,3);
nrEvents = size(Paradigm,1);

nrEventsPerCondition = nrValues*Parameters.RepetitionFactor;
switch S.Task
    
    case 'DetectCEIL'
        switch S.OperationMode
            case 'Acquisition'
                [ SequenceHighLow ]  = Common.Randomize01( nrEventsPerCondition , nrEventsPerCondition                       );
            case 'FastDebug'
                [ SequenceHighLow ]  = Common.Randomize01( nrEventsPerCondition , nrEventsPerCondition                       );
            case 'RealisticDebug'
                [ SequenceHighLow ]  = Common.Randomize01( nrEventsPerCondition , nrEventsPerCondition                       );
        end
        
    case 'AroundCEIL'
        switch S.OperationMode
            case 'Acquisition'
                [ SequenceHighLow ]  = Common.Randomize01( nrEventsPerCondition , nrEventsPerCondition, 5                    );
            case 'FastDebug'
                [ SequenceHighLow ]  = Common.Randomize01( nrEventsPerCondition , nrEventsPerCondition                       );
            case 'RealisticDebug'
                [ SequenceHighLow ]  = Common.Randomize01( nrEventsPerCondition , nrEventsPerCondition, nrEventsPerCondition );
        end
        
end

pool = struct;
for c = 1 : nrCategories
    pool.(sprintf('%sVS%s',Categories{c,1},Categories{c,2})) = Shuffle(1:nrValues);
end % categories

% Fill paradigm with randomized events
for evt = 1 : nrEvents
    
    catName = sprintf('%sVS%s',Categories{SequenceHighLow(evt)+1,1},Categories{SequenceHighLow(evt)+1,2});
    
    Paradigm{evt,1} = catName; % save condition name (str)
    if isempty(pool.(catName)) % refill the pool
        while 1
            pool.(catName) = Shuffle(1:nrValues);                     % shuffle a pool of values
            if ~strcmp(Paradigm{evt-1,2},Values{pool.(catName)(end)}) % be sure to not have 2 times the same value in a row (it can happen after a refill)
                break
            end
        end
    end
    Paradigm{evt,2} = Values{pool.(catName)(end)}; % save value name  (str)
    Paradigm{evt,3} = pool.(catName)(end);         % save value index (int)
    
    pool.(catName)(end) = [];
    
end % events

% Just to check
for c = 1 : nrCategories
    catName = sprintf('%sVS%s',Categories{c,1},Categories{c,2});
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
    jitter = Parameters.MinPauseBetweenTrials + (Parameters.MaxPauseBetweenTrials-Parameters.MinPauseBetweenTrials)*rand;
    duration = jitter + Parameters.Blank + Parameters.DisplayPicture + Parameters.Answer;
    EP.AddEvent({[Paradigm{evt,1} Paradigm{evt,2}] NextOnset(EP) duration jitter Paradigm{evt,1} Paradigm{evt,2} Paradigm{evt,3}});
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
