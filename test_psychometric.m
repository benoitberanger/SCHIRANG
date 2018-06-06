%% init

close all
clear
clc

load /mnt/data/benoit/protocol/SCHIRANG/data/001/20180605T170212_001_Practice_DetectCEIL_run02.mat


%% Shortcuts

data = S.TaskData.BR.Data;

S.CatValDATA

Values = sort(str2double(S.CatValDATA.Values));


%% Fill the fake data to look like normal data

for line = 1 : size(data,1)
    
%     data{line,4} = str2double(data{line,3})/100 > rand;
    
end % data


%% Compute

s = struct;


nameCategory = {'sVSk', 'sVSu'};
nrCat = length(nameCategory);

figure('Name','001 - Detect ceil','NumberTitle','off')

for c = 1 : nrCat
    
    cat = nameCategory{c};
    
    cat_idx = regexp(data(:,2),cat);
    cat_idx = ~cellfun(@isempty,cat_idx);
    
    s.(cat).rawdata = data(cat_idx,:);
    
    s.(cat).valueCount = zeros(size(Values));
        
    for val = 1 : length(Values)
        
        val_idx = str2double(s.(cat).rawdata(:,3))==Values(val);
        s.(cat).valueCount(val) = sum( cell2mat(s.(cat).rawdata(val_idx,4)) );
        
        s.(cat).valueProbalility = s.(cat).valueCount/sum(val_idx);
        
    end % val
    
    s.(cat)
    
    subplot(1,2,c)
    plot(Values,s.(cat).valueProbalility,'LineStyle','-','Marker','s','MarkerEdgeColor','red','MarkerFaceColor','red')
    title(cat)
    xticks(0:5:100)
    
%     [phat,pci] = gamfit(Values, s.(cat).valueProbalility)
    
end % cat
