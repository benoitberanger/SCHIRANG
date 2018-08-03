function ParPortMessages = PrepareParPort
global S

if isempty(S)
    S.ParPort      = 'On';
    S.Environement = 'MRI';
    S.Side         = 'Left';
    S.Task         = 'AroundCEIL';
end


%% On ? Off ?

switch S.ParPort
    
    case 'On'
        
        % Open parallel port
        OpenParPort;
        
        % Set pp to 0
        WriteParPort(0)
        
    case 'Off'
        
end

%% Prepare messages

msg = struct;
idx = 0;

idx = idx + 1;
msg.FixationCross = idx;

idx = idx + 1;
msg.Blank = idx;

idx = idx + 1;
msg.Answer = idx;

% switch S
par = GetParameters;

Categories = par.DetectCEIL.Images.Categories;

Values     = par.DetectCEIL.Images.Values;
for cat = 1 : size(Categories,1)
    catName = sprintf('DetectCEIL_%sVS%s%s',Categories{cat,1},Categories{cat,2},Categories{cat,3});
    for val = 1 : length(Values)
        name = sprintf('%s_%s',catName,Values{val});
        idx = idx + 1;
        msg.(name) = idx;
    end
end

Values = par.AroundCEIL.Images.Values;
Values = regexprep(Values,'-','m');
Values = regexprep(Values,'+','p');
for cat = 1 : size(Categories,1)
    catName = sprintf('AroundCEIL_%sVS%s%s',Categories{cat,1},Categories{cat,2},Categories{cat,3});
    for val = 1 : length(Values)
        name = sprintf('%s_%s',catName,Values{val});
        idx = idx + 1;
        msg.(name) = idx;
    end
end


%% Finalize

% Pulse duration
msg.duration    = 0.003; % seconds

ParPortMessages = msg; % shortcut

end % function
