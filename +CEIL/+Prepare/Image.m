function [ imgObj ] = Image
global S

imgObj = struct;

list_img_files = dir( fullfile('..','img',S.SubjectID) );
list_img_files = list_img_files(3:end); % remove '.' and '..'

for file = 1 : length(list_img_files)
    
    [~,name,~] = fileparts(list_img_files(file).name);
    
    imgObj.(name) = Image( ...
        fullfile(list_img_files(file).folder,list_img_files(file).name), ...
        [S.PTB.CenterH S.PTB.CenterV], ...
        1);
    
    imgObj.(name).LinkToWindowPtr( S.PTB.wPtr );
    
    % imgObj.(name).AssertReady; % just to check
    
end

end % function
