function [treatments,treatmentData] = formatData(plateSkeleton, plateData, numReplicates)

import containers.Map;

xdim = size(plateSkeleton, 2); 
ydim = size(plateSkeleton, 1);
Q = reshape(plateData,xdim,ydim,[]);   

uniqueTreatments = {};   %will become KEYS in map
treatmentData = {};   %Will become VALUES in map

skeletonDex = 1;   %Assembles cell array of unique treatment combinations (uniqueTreatments)
while skeletonDex <= numel(plateSkeleton)
    uniqueTreatments = [uniqueTreatments plateSkeleton{skeletonDex}];
    skeletonDex = skeletonDex + numReplicates;
    if isequal(plateSkeleton{skeletonDex}, 'null') && skeletonDex > numReplicates
        break;
    end
end
 
uniqueTreatmentsPos = 1;
replicateCount = 1;
row = 1;
col = 1;
while (col <= xdim)  %Assembles cell array of arrays with data for single treatments (treatmentData)
    temp = [];
    if uniqueTreatmentsPos == 45
        hello = 5;
    end
    if numel(uniqueTreatments) == numel(treatmentData), break; end
    while replicateCount <= numReplicates
        if row > ydim
            row = 1;
            col = col + 1;
        end  
        if col > xdim, break; end  % in case plate size is not divisible by the number of replicates (so that the last treatment simply has fewer replicates rather than throwing an error)
        temp = [temp squeeze(Q(col,row,:))];
        row = row + 1;
        replicateCount = replicateCount + 1;        
    end
    treatmentData = [treatmentData temp];
    replicateCount = 1;
    uniqueTreatmentsPos = uniqueTreatmentsPos + 1;
end

% dataMap = containers.Map(phageCombs,treatmentData);  %End result: dataMap maps unique treatment groups to timeseries data for those treatments

% Shift all data down to where first point is a OD = 0
% for i = 1:numel(treatmentData)
%     currData = treatmentData{i};
%     first = currData(1);
%     treatmentData{i} = currData - first;
% end
        


treatments = uniqueTreatments;
treatmentData = treatmentData;
end
