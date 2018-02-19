function [ Yes, No, Question ] = Texts
global S

allTexts = Text.empty; % empty array of object

% Yes
Yes = Text(S.Parameters.Text.Color,...
    S.Parameters.DetectCEIL.Yes.Content,...
    S.Parameters.DetectCEIL.Yes.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.DetectCEIL.Yes.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = Yes;

%No
No = Text(S.Parameters.Text.Color,...
    S.Parameters.DetectCEIL.No.Content,...
    S.Parameters.DetectCEIL.No.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.DetectCEIL.No.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = No;

% Question
Question = Text(S.Parameters.Text.Color,...
    S.Parameters.DetectCEIL.Question.Content,...
    S.Parameters.DetectCEIL.Question.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.DetectCEIL.Question.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = Question;

for idx = 1 : length(allTexts)
    allTexts(idx).LinkToWindowPtr( S.PTB.wPtr )
    allTexts(idx).AssertReady % just to check
end

end % function
