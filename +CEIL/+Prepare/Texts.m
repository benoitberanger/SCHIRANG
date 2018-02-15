function [ Yes, No, Question ] = Texts
global S

allTexts = Text.empty; % empty array of object

% Yes
Yes = Text(S.Parameters.Text.Color,...
    S.Parameters.CEIL.Yes.Content,...
    S.Parameters.CEIL.Yes.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.CEIL.Yes.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = Yes;

%No
No = Text(S.Parameters.Text.Color,...
    S.Parameters.CEIL.No.Content,...
    S.Parameters.CEIL.No.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.CEIL.No.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = No;

% Question
Question = Text(S.Parameters.Text.Color,...
    S.Parameters.CEIL.Question.Content,...
    S.Parameters.CEIL.Question.PositonXRatio*S.PTB.wRect(3),...
    S.Parameters.CEIL.Question.PositonYRatio*S.PTB.wRect(4));
allTexts(end+1) = Question;

for idx = 1 : length(allTexts)
    allTexts(idx).LinkToWindowPtr( S.PTB.wPtr )
    allTexts(idx).AssertReady % just to check
end

end % function
