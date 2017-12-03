function [globalBests,globalBestVals,cocktailSizeBests,cocktailSizeBestVals] = minIntValSolver(phageNames,intValsForEachPhage,pairwiseVals) 
% pairwiseVals: vector of interaction values of the form [p1p2 p1p3 p1p4
% ... p(n-1)pn] (in same format as combntns())

warning('off','all');

pairwiseVals = [];
j = 1;
for i = 1:numel(keys(intValsForEachPhage))
    curr = intValsForEachPhage(num2str(i));
    curr(i) = []; % Remove self-CI values 
    pairwiseVals = [pairwiseVals curr(j:end)];
    j = j+1;
end  

% 1.) Map phage pairs to interaction values
allPairs = combntns(phageNames,2);
allPairsCell = cell(size(allPairs,1));
for q = 1:size(allPairs,1)
    allPairsCell{q} = num2str(allPairs(q,:));
end
allPairsCell = allPairsCell(:,1)'; 
phageMap = containers.Map(allPairsCell,pairwiseVals);

% Initialize arrays/queues to store optimal cocktails + their CI values
bestVals = zeros(size(phageNames)); % Local optimal values for each cocktailSize
bests = cell(size(phageNames)); % Local optimal cocktails for each cocktailSize
import java.util.LinkedList
qVals = LinkedList(); % Queue of top 10 cocktail values
qVals.add(inf);
qCands = LinkedList(); % Queue of top 10 cocktails
 

for cocktailSize = 1:numel(phageNames)
    allCombsPhages = combntns(phageNames,cocktailSize);

    % 2.) Find phage combination with the best conglomerate interaction value
    intVal = inf; % Local best val (for current cocktailSize)
    bestComb = []; % Local best candidate (for current cocktailSize)
    i = 1;
    if cocktailSize > 2
    while i <= size(allCombsPhages,1)
        currComb = allCombsPhages(i,:); % Current set of phages of size cocktailSize
        pairsTemp = combntns(currComb,2); % All pairs within the current set
        intsTemp = zeros(1,size(pairsTemp,1)); % Will become a vector containing all pairwise interaction values of phages in the current set
        for k = 1:size(pairsTemp,1)
            intsTemp(k) = phageMap(num2str(pairsTemp(k,:))); % Populates vector of pairwise interaction values
        end
        score = prod(intsTemp); % Conglomerate interaction value
        
        % Update global queue if current combination has a lower value than top 
        if score < qVals.peekLast()
            if qVals.peekLast() == inf
                qVals.remove();
            end
            qVals.add(score);
            qCands.add(currComb);
            if qVals.size() >= 10
                qVals.remove();
                qCands.remove();
            end
            
        end
        
        if score < intVal % Checks to see if conglomerate interaction value is now the local best; if so, set it as new best 
            intVal = score; 
            bestComb = currComb;
        end 
        
        % Print an update to monitor progress
        if mod(i,500) == 0
            disp(i);
            disp(size(allCombsPhages,1));
        end
        i = i+1;
    end 

    else % in case cocktailSize <= 2
        bestComb = allPairsCell(find(pairwiseVals == min(pairwiseVals)));
        intVal = pairwiseVals(find(pairwiseVals == min(pairwiseVals)));
    end
    
    % Update local bests (for the current cocktailSize)
    bestValues(cocktailSize) = intVal;
    best{cocktailSize} = bestComb;

end

% Format output
cocktailSizeBests = best;
cocktailSizeBestVals = bestValues;

globalBests = cell(1,size(qCands));
globalBestVals = zeros(1,size(qVals));
for i = 1:size(qVals)
    globalBests{i} = qCands.remove();
    globalBestVals(i) = qVals.remove();
end

% warning('off','all');
% 
% allCombsPhages = combntns(phageNames,cocktailSize);
% allPairs = combntns(phageNames,2);
%  
% allPairsCell = cell(size(allPairs,1));
% for q = 1:size(allPairs,1)
%     allPairsCell{q} = num2str(allPairs(q,:));
% end
% allPairsCell = allPairsCell(:,1)'; 
% 
% % 1.) Map phages to interaction values
% 
% phageMap = containers.Map(allPairsCell,pairwiseVals);
% 
% % 2.) Find phage combination with the best conglomerate interaction value
% 
% intVal = inf;
% bestComb = [];
% i = 1;
% if cocktailSize > 2
% while i <= size(allCombsPhages,1)
%     currComb = allCombsPhages(i,:); % Current set of phages of size cocktailSize
%     pairsTemp = combntns(currComb,2); % All pairs within the current set
%     intsTemp = zeros(1,size(pairsTemp,1)); % Will become a vector containing all pairwise interaction values of phages in the current set
%     for k = 1:size(pairsTemp,1)
%         intsTemp(k) = phageMap(num2str(pairsTemp(k,:))); % Populates vector of pairwise interaction values
%     end
%     score = prod(intsTemp); % Conglomerate interaction value
%     if score < intVal % Checks to see if conglomerate interaction value is now the best; if so, set it as new best 
%         intVal = score; 
%         bestComb = currComb;
%     end 
%     if mod(i,500) == 0
%         disp(i);
%         disp(size(allCombsPhages,1));
%     end
%     i = i+1;
% end 
% 
% else
%     bestComb = allPairsCell(find(pairwiseVals == min(pairwiseVals)));
%     intVal = pairwiseVals(find(pairwiseVals == min(pairwiseVals)));
% end
% 
% 
% % intSums = sum(allCombs,2)'; 
% % dex = find(intSums == min(intSums));
% % best = allCombs(dex,:);
% % intVal = sum(best);
% % bestComb = allCombsPhages(dex);


end


