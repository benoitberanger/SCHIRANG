function [ imgObj ] = Image
global S

imgObj = struct;

CatValDATA   = CEIL.Prepare.CheckImagesDir(S.SubjectID);
S.CatValDATA = CatValDATA;

for c = 1 : length(CatValDATA.nameCategory)
    
    nameCat = CatValDATA.nameCategory{c};
    
    for v = 1 : length(CatValDATA.Values)
        
        filename = CatValDATA.(nameCat){v};
        
        currentObject = Image( ...
            filename, ...
            [S.PTB.CenterH S.PTB.CenterV], ...
            1);
        
        currentObject.LinkToWindowPtr( S.PTB.wPtr );
        
        currentObject.MakeTexture;
        
        % currentObject.AssertReady; % just to check
        
        imgObj.(nameCat){v} = currentObject ;
        
    end % values
    
end % category

end % function
