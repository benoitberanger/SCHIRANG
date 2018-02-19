function  [ out ] = CheckImagesDir( SubjectID , Task )
%CHECKIMAGESDIR will check if the architecture of dir + images name is correct

% if nargin < 2
% end

out = struct;
p   = GetParameters;


%% Check dirs : Part 1

% Echo
fprintf('\n')
fprintf('Checking %s dirs & images \n' , SubjectID )

% ../img
if isdir( fullfile('..','img') )
    fprintf('../img CHECKED \n')
else
    error  ('../img ERROR : dir must exists')
end

% SubjectID
if isdir( fullfile('..','img',SubjectID) )
    fprintf('../img/%s CHECKED \n', SubjectID )
else
    error  ('../img/%s ERROR : dir must exists', SubjectID )
end

% Task
if isdir( fullfile('..','img',SubjectID,Task) )
    fprintf('../img/%s/%s CHECKED \n', SubjectID , Task )
else
    error  ('../img/%s/%s ERROR : dir must exists', SubjectID , Task )
end



%% Load Task parameters

Categories = p.(Task).Images.Categories;
Values     = p.(Task).Images.Values;

nrCategories = size(Categories,1);
nrValues     = length(Values);

% Save them
out.Categories = Categories;
out.Values     = Values;


%% Check dirs : Part 2

for c = 1 : nrCategories
    
    nameCat = [Categories{c,1} 'VS' Categories{c,2}];
    
    % Category
    if isdir( fullfile('..','img',SubjectID,Task,nameCat) )
        fprintf('../img/%s/%s/%s CHECKED \n', SubjectID , Task , nameCat )
    else
        error  ('../img/%s/%s/%s ERROR : dir must exists', SubjectID , Task , nameCat )
    end
        
    out.nameCategory{c} = nameCat;
    
end


%% Check content of dirs

for c = 1 : nrCategories
    
    nameCat = [Categories{c,1} 'VS' Categories{c,2}];
    dirpath = fullfile('..','img',SubjectID,Task,nameCat);
    
    categ_dir_content = dir(dirpath);
    categ_dir_content = categ_dir_content(3:end); % remove "." and ".."
    
    cate_filename = cellstr(char(categ_dir_content.name));
    
    for v = 1 : nrValues
        
        pattern = [SubjectID '_' nameCat '_' Values{v}];
        result  = strfind( cate_filename , pattern );
        isfound = any(~cellfun(@isempty, result));
        
        assert( isfound , 'The pattern %s was not found in %s' , pattern , dirpath )
        
        % Save file path
        out.(nameCat){v} = fullfile(categ_dir_content(v).folder, categ_dir_content(v).name);
        fprintf('%s CHECKED \n',out.(nameCat){v})
        
    end % value
    
end % category


end % function
