function [ Yes, No, Question ] = Texts
global S

allTexts = Text.empty; % empty array of object

% Yes
Yes = Text(S.Parameters.Text.Color,...
    S.Parameters.(S.Task).Yes.Content,...
    S.Parameters.(S.Task).Yes.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.(S.Task).Yes.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = Yes;

%No
No = Text(S.Parameters.Text.Color,...
    S.Parameters.(S.Task).No.Content,...
    S.Parameters.(S.Task).No.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.(S.Task).No.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = No;

% Question
Question = Text(S.Parameters.Text.Color,...
    S.Parameters.(S.Task).Question.Content,...
    S.Parameters.(S.Task).Question.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.(S.Task).Question.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = Question;

for idx = 1 : length(allTexts)
    allTexts(idx).LinkToWindowPtr( S.PTB.wPtr )
    allTexts(idx).AssertReady % just to check
end

end % function
