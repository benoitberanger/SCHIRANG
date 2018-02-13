function [ Parameters ] = GetParameters
% GETPARAMETERS Prepare common parameters
global S

if isempty(S)
    S.Environement = 'MRI';
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
        
        Parameters.Fingers.Right(1) = 1;           % Thumb, not on the response buttons, arbitrary number
        Parameters.Fingers.Right(2) = KbName('b'); % Index finger
        Parameters.Fingers.Right(3) = KbName('y'); % Middle finger
        Parameters.Fingers.Right(4) = KbName('g'); % Ring finger
        Parameters.Fingers.Right(5) = KbName('r'); % Little finger
        
        Parameters.Fingers.Left (1) = 2;           % Thumb, not on the response buttons, arbitrary number
        Parameters.Fingers.Left (2) = KbName('e'); % Index finger
        Parameters.Fingers.Left (3) = KbName('z'); % Middle finger
        Parameters.Fingers.Left (4) = KbName('n'); % Ring finger
        Parameters.Fingers.Left (5) = KbName('d'); % Little finger
        
    case 'Practice'
        
        Parameters.Fingers.Left (1) = KbName('v'); % Thumb, not on the response buttons, arbitrary number
        Parameters.Fingers.Left (2) = KbName('f'); % Index finger
        Parameters.Fingers.Left (3) = KbName('d'); % Middle finger
        Parameters.Fingers.Left (4) = KbName('s'); % Ring finger
        Parameters.Fingers.Left (5) = KbName('q'); % Little finger
        
        Parameters.Fingers.Right(1) = KbName('b'); % Thumb, not on the response buttons, arbitrary number
        Parameters.Fingers.Right(2) = KbName('h'); % Index finger
        Parameters.Fingers.Right(3) = KbName('j'); % Middle finger
        Parameters.Fingers.Right(4) = KbName('k'); % Ring finger
        Parameters.Fingers.Right(5) = KbName('l'); % Little finger
        
end

Parameters.Fingers.All      = [fliplr(Parameters.Fingers.Left) Parameters.Fingers.Right];
Parameters.Fingers.Names    = {'L5' 'L4' 'L3' 'L2' 'L1' 'R1' 'R2' 'R3' 'R4' 'R5'};


%% Echo in command window

EchoStop(mfilename)


end