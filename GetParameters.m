function [ Parameters ] = GetParameters
% GETPARAMETERS Prepare common parameters
global S

if isempty(S)
    S.Environement = 'MRI';
    S.Side         = 'Left';
end


%% Echo in command window

EchoStart(mfilename)


%% Paths

% Parameters.Path.wav = ['wav' filesep];


%% Set parameters

%%%%%%%%%%%
%  Audio  %
%%%%%%%%%%%

% Parameters.Audio.SamplingRate            = 44100; % Hz
%
% Parameters.Audio.Playback_Mode           = 1; % 1 = playback, 2 = record
% Parameters.Audio.Playback_LowLatencyMode = 1; % {0,1,2,3,4}
% Parameters.Audio.Playback_freq           = Parameters.Audio.SamplingRate ;
% Parameters.Audio.Playback_Channels       = 2; % 1 = mono, 2 = stereo
%
% Parameters.Audio.Record_Mode             = 2; % 1 = playback, 2 = record
% Parameters.Audio.Record_LowLatencyMode   = 0; % {0,1,2,3,4}
% Parameters.Audio.Record_freq             = Parameters.Audio.SamplingRate;
% Parameters.Audio.Record_Channels         = 1; % 1 = mono, 2 = stereo


%%%%%%%%%%%%%%
%   Screen   %
%%%%%%%%%%%%%%
Parameters.Video.ScreenWidthPx   = 1024;  % Number of horizontal pixel in MRI video system @ CENIR
Parameters.Video.ScreenHeightPx  = 768;   % Number of vertical pixel in MRI video system @ CENIR
Parameters.Video.ScreenFrequency = 60;    % Refresh rate (in Hertz)
Parameters.Video.SubjectDistance = 0.120; % m
Parameters.Video.ScreenWidthM    = 0.040; % m
Parameters.Video.ScreenHeightM   = 0.030; % m

Parameters.Video.ScreenBackgroundColor = [170 170 170]; % [R G B] ( from 0 to 255 )

%%%%%%%%%%%%
%   Text   %
%%%%%%%%%%%%
Parameters.Text.SizeRatio   = 0.10; % Size = ScreenWide *ratio
Parameters.Text.Font        = 'Arial';
Parameters.Text.Color       = [128 128 128]; % [R G B] ( from 0 to 255 )
Parameters.Text.ClickCorlor = [0   255 0  ]; % [R G B] ( from 0 to 255 )

%%%%%%%%%%%%
%   CEIL    %
%%%%%%%%%%%%

% Fixation cross
Parameters.CEIL.FixationCross.ScreenRatio    = 0.10;          % ratio : dim   = ScreenWide *ratio_screen
Parameters.CEIL.FixationCross.lineWidthRatio = 0.05;          % ratio : width = dim        *ratio_width
Parameters.CEIL.FixationCross.Color          = [128 128 128]; % [R G B] ( from 0 to 255 )

Parameters.CEIL.Images.Categories = {
    's' 'k' % sVSk, condition 1
    's' 'u' % sVSu, condition 2
    };
Parameters.CEIL.Images.Values = {'-20' '-10' '0' '+10' '+20'}; % modulators : 1, 2, 3, 4, 5
Parameters.CEIL.Images.Values = sort(Parameters.CEIL.Images.Values); % need to sort : files names will be sorted

switch S.Side
    case 'Left'
        YesX = 1/4;
        NoX  = 3/4;
    case 'Right'
        YesX = 3/4;
        NoX  = 1/4;
end

Parameters.CEIL.Yes     .Content       = 'Oui';
Parameters.CEIL.Yes     .PositonXRatio = YesX; % Xpos = PositonXRatio * ScreenWidth
Parameters.CEIL.Yes     .PositonYRatio = 2/3;  % Ypos = PositonYRatio * ScreenHight

Parameters.CEIL.No      .Content       = 'Non';
Parameters.CEIL.No      .PositonXRatio = NoX;  % Xpos = PositonXRatio * ScreenWidth
Parameters.CEIL.No      .PositonYRatio = 2/3;  % Ypos = PositonYRatio * ScreenHight

Parameters.CEIL.Question.Content       = 'Est-ce vous ?';
Parameters.CEIL.Question.PositonXRatio = 0.5;  % Xpos = PositonXRatio * ScreenWidth
Parameters.CEIL.Question.PositonYRatio = 1/3;  % Ypos = PositonYRatio * ScreenHight

%%%%%%%%%%%%%%
%   RECOG    %
%%%%%%%%%%%%%%

% Fixation cross
Parameters.RECOG.FixationCross.ScreenRatio    = 0.10;          % ratio : dim   = ScreenWide *ratio_screen
Parameters.RECOG.FixationCross.lineWidthRatio = 0.05;          % ratio : width = dim        *ratio_width
Parameters.RECOG.FixationCross.Color          = [128 128 128]; % [R G B] ( from 0 to 255 )


%%%%%%%%%%%%%%
%  Keybinds  %
%%%%%%%%%%%%%%

KbName('UnifyKeyNames');

Parameters.Keybinds.TTL_t_ASCII          = KbName('t'); % MRI trigger has to be the first defined key
% Parameters.Keybinds.emulTTL_s_ASCII      = KbName('s');
Parameters.Keybinds.Stop_Escape_ASCII    = KbName('ESCAPE');

switch S.Environement
    
    case 'MRI'
        
        switch S.Side
            case 'Left'
                Parameters.Fingers.Yes = KbName('b');
                Parameters.Fingers.No  = KbName('y');
            case 'Right'
                Parameters.Fingers.Yes = KbName('y');
                Parameters.Fingers.No  = KbName('b');
        end
        
    case 'Practice'
        
        switch S.Side
            case 'Left'
                Parameters.Fingers.Yes = KbName('LeftArrow' );
                Parameters.Fingers.No  = KbName('RightArrow');
            case 'Right'
                Parameters.Fingers.Yes = KbName('RightArrow');
                Parameters.Fingers.No  = KbName('LeftArrow' );
        end
        
end

Parameters.Fingers.Names = {'Yes' 'No'};


%% Echo in command window

EchoStop(mfilename)


end