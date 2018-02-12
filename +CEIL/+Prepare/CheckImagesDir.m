function  [ out ] = CheckImagesDir( SubjectID )
%CHECKIMAGESDIR will check if the architecture of dir + images name is correct

out = struct;


%% Parameters

Categories = {
    's' 'k' % sVSk
    's' 'u' % sVSu
    };

Values = {'-20' '-10' '0' '+10' '+20'};


nrCategories = size(Categories,1);
nrValues = length(Values);

% Save them
out.Categories = Categories;
out.Values     = Values;


%% Check if all dirs exist

assert( isdir( fullfile('..','img'                 ) ) , '../img    dir must exists'             )
assert( isdir( fullfile('..','img',SubjectID       ) ) , '../img/%s dir must exists' , SubjectID )

for c = 1 : nrCategories
    nameCat = [Categories{c,1} 'VS' Categories{c,2}];
    assert( isdir( fullfile('..','img',SubjectID,nameCat) ) , '../img/%s/%s dir must exists' , SubjectID, nameCat )
    out.nameCategory{c} = nameCat;
end


%% Check content of dirs

for c = 1 : nrCategories
    
    nameCat = [Categories{c,1} 'VS' Categories{c,2}];
    dirpath = fullfile('..','img',SubjectID,nameCat);
    
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
        
    end % value
    
end % category


end % function
