function PlotPsychometric( S )

fprintf('plotting : %s \n', S.DataFileName)

%% Shortcuts

data = S.TaskData.BR.Data;

S.CatValDATA

Values = sort(str2double(S.CatValDATA.Values));


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
    
    %     s.(cat)
    
    subplot(1,2,c)
    hold on
    plot(Values,s.(cat).valueProbalility,'LineStyle','-','Color','blue','Marker','s','MarkerEdgeColor','red','MarkerFaceColor','red')
    
    % Oversample the line
    XI = Values(1):1/1e3:Values(end);
    YI = interp1q(Values',s.(cat).valueProbalility',XI');
    plot(XI,YI,'LineStyle','-','Color','blue')
    
    title(cat)
    grid on
    grid minor
    
    %     xticks(0:5:100)
    
    %     [phat,pci] = gamfit(Values, s.(cat).valueProbalility)
    
    % Fetch the point where P(XI)=0.5
    [~,index_p05] = min(abs(YI - 0.5));
    X_p05 = XI(index_p05);
    cprintf('*UnterminatedStrings','%s : P(X)=0.5 => X=%g \n',cat,X_p05)
    
end % cat


end % function
