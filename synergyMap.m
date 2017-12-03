function [map,intValsForEachPhage] = synergyMap(plateSkeleton,plateData,numPhages)
% Key: phage, Value: array with [reduction value alone, reduction values when combined with all other phages]

% numPhages = numPhages - 5;

dex = 1;
while isequal(plateSkeleton{dex},'')
    dex = dex+1;
end

numReplicates = 0;
while isequal(plateSkeleton{dex},'null') % Infers numReplicates from plateSkeleton; only works if there was a negative control
    numReplicates = numReplicates + 1;
    dex = dex + 1;
end

[treatments treatmentData] = formatData(plateSkeleton, plateData, numReplicates);

mapKeys = {};   
for a = 1:numel(treatments)
    mapKeys = [mapKeys num2str(treatments{a})];
end
treatmentMap = containers.Map(mapKeys,treatmentData(1:numel(mapKeys)));

map = [];

phages = {};
for i = 1:numPhages
    phages = [phages num2str(i)];
end
intValsForEachPhage = containers.Map(phages,cell(1,numPhages)); % CI values of a given phage with all other phages ; for sorting phages according to mean synergy/antagonism
for i = 1:numPhages
    CIVec = zeros(1,numPhages); 
    for k = 1:numPhages
        if k < i
            CIVec(k) = NaN;
            continue; 
        else
            if i == 20 
                a = 5; % Debug breakpoint
            end
            combKey = [num2str(i) '  ' num2str(k)];
            CI = computeCI(removeOutliers((treatmentMap('null')')),removeOutliers((treatmentMap(num2str(i))')),removeOutliers((treatmentMap(num2str(k))')),removeOutliers((treatmentMap(combKey)')),'blissAlt');
            title(num2str(combKey));
            CIVec(k) = CI; 
            intValsForEachPhage(num2str(i)) = [intValsForEachPhage(num2str(i)) CI];
%             if ((k ~= 20) && (k ~= 18)) 
%                 close;
%             end
            if i ~= k
                intValsForEachPhage(num2str(k)) = [intValsForEachPhage(num2str(k)) CI];
            end
        end
        
    end
    
    map = [map;CIVec];
end  

% Sort phages based on relative CI values 
keys = 1:1:numPhages; 
means = [];
for i=1:1:numPhages 
    means = [means mean(intValsForEachPhage(num2str(i)))];
end 
[sortedVals, sortIdx] = sort(means);
sortedKeys = keys(sortIdx);
sortedCols = sortIdx;
newMap = [];
for i = 1:numel(sortedKeys)
    newCol = intValsForEachPhage(num2str(sortedKeys(i)));
    newMap = [newMap newCol(:)];
end  

%Sort rows
meansNewMap = [];
for i = 1:size(newMap,1)
    meansNewMap = [meansNewMap mean(newMap(i,:))];
end
newMap = [meansNewMap' newMap];
[newMap sortIndices] = sortrows(newMap); % Sorts based on first col, which has been set to the means
sortedRows = sortIndices;
map = newMap(:,2:24); % 19/24 for 1536 experiments
for i = 1:23 %18/23
    for k = 1:23 % 18/23
        if i > k 
            map(i,k) = NaN;
        end
    end
end
colLabels = sortedCols;
rowLabels = sortedRows;

% Generate heatmap depicting interaction values

colLabels = []; 
rowLabels = [];
for j = 2:numPhages
    colLabels = [colLabels num2str(j)];
end
for k = 1:numPhages-1
    rowLabels = [rowLabels num2str(k)];
end

load('heatmapColorMap','mycmap');
figure; hold on
heatmap(map,rowLabels,colLabels,[],'fontsize',2, 'Colormap', mycmap,'Colorbar', true, 'NaNColor', [0 0 0], 'MinColorValue', 0, 'MaxColorValue', 2, 'GridLines', '-');


% [1 1 1] for white, [.398 .398 .398] for nice grey
title('Example iNet');


% % Add x and y labels
% rowsStrings = [];
% colsStrings = [];
% for i = 1:numel(sortedRows)
%     rowsStrings = [rowsStrings num2str(sortedRows(i)) ' '];
%     colsStrings = [colsStrings num2str(sortedCols(i)) ' '];
% end
% ylabel(rowsStrings);
% xlabel(colsStrings);



end 

% for i=1:numPhages
%     % redVec = reductionValue(mean(treatmentData{i+1}'),mean(treatmentData{1}'),timepoint*4);
%     
%     for k = ((numPhages + 2)):numel(treatmentData)
%         if any(treatments{k} == i)
%             CI = computeCI(mean(treatmentData{1}'),mean(treatmentData{i+1}'),mean(treatmentData{k+1}'))
%             % for z = 1:numel(treatments{k}), if (treatments{k}(z) == i) == 0, companion = num2str(treatments{k}(z)); end; end
%             redVec = [redVec reductionValue(mean(treatmentData{k}'),mean(treatmentData{1}'),timepoint*4)];
%         end
%     end
%     map(num2str(i)) = redVec;
% end
% 
% end


% function [redVal] = reductionValue(dataPhage, dataControl, timepoint) % Produces normalized reduction values
% controlVal = dataControl(timepoint);
% phageVal = dataPhage(timepoint);
% redVal = (controlVal - phageVal) / controlVal;
% end