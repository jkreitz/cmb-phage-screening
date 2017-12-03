function[correctedData,numCorrected,numCantCorrect] = removeOutliers(rawData)
% Input nxm raw data matrices (m replicates for n treatments). Returns a nx1 matrix of values that
% represent means of each set of m replicates. If a value is beyond a sd
% away from the mean, remove it from consideration for that set. 

numCorrected = 0; % Keeps track of number of times the correction is made
numCantCorrect = 0; % Keeps track of number of times correction can't be made 
correctedData = [];
for n = 1:size(rawData,2)
    newDatum = rawData(:,n);
    correctedSet = [];
    for m = 1:numel(newDatum)
        if (newDatum(m) <= mean(newDatum) + std(newDatum)) && (newDatum(m) >= mean(newDatum) - std(newDatum))
            correctedSet = [correctedSet newDatum(m)];
        end
    end
    
    if numel(correctedSet) == 0 
        correctedData = [correctedData mean(newDatum)];
        numCantCorrect = numCantCorrect + 1;
    else 
        correctedData = [correctedData mean(correctedSet)];
        numCorrected = numCorrected + (numel(newDatum) - numel(correctedSet));
    end
    
end
% disp([numCorrected,numCantCorrect])

end