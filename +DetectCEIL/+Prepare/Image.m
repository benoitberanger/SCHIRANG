function [ imgObj ] = Image
global S

%% Prepare

imgObj = struct;
allObj = Image.empty; % create empty aray of object, this array is just for convenience

CatValDATA   = CheckImagesDir( S.SubjectID , S.Task ); % condition x modulator structure
S.CatValDATA = CatValDATA;

baseRect = zeros(length(CatValDATA.nameCategory)*length(CatValDATA.Values),4); % to store all images sizes
counter  = 0;


%% Create objects == load images in PTB

for c = 1 : length(CatValDATA.nameCategory)
    
    nameCat = CatValDATA.nameCategory{c};
    
    for v = 1 : length(CatValDATA.Values)
        
        counter = counter + 1;
        
        filename = CatValDATA.(nameCat){v};
        
        currentObject = Image( ...
            filename, ...
            [S.PTB.CenterH S.PTB.CenterV], ...
            1);
        
        currentObject.LinkToWindowPtr( S.PTB.wPtr );
        
        currentObject.MakeTexture;
        
        % currentObject.AssertReady; % just to check
        
        imgObj.(nameCat){v} = currentObject; % store object in formated structure
        allObj(counter)     = currentObject; % store object very simply, for latter user
        
        baseRect(counter,:) = currentObject.baseRect; % store image size
        
    end % values
    
end % category


%% Resize if necesseary

sizeX = baseRect(:,3) - baseRect(:,1);
sizeY = baseRect(:,4) - baseRect(:,2);

ratioX = sizeX/S.PTB.wRect(3);
ratioY = sizeY/S.PTB.wRect(4);

maxRatio = max([ratioX;ratioY]);

if maxRatio > 1 % image bigger than the screen
    shrinkRation = 1/maxRatio;
    for img = 1 : length(allObj)
        allObj(img).Rescale(shrinkRation); % shrink all images with the same factor
    end
else
    % nothing to do, all images will fit the screen
end


end % function
