function [skeleton] = plateMap(ydim, xdim, numPhages, cocktailSize, numReplicates, controls)

% Correspondence: Joseph Kreitz (joekreitz@gmail.com)

% Generates a microplate map representing every combination of
% phage cocktail among the list of phages. Automatically sets up a
% phage-negative control and single-phage treatments. Can specify
% dimensions of plate, number of phages in each well, the number of
% technical replicates for each treatment, and whether or not to set up
% phage-negative controls and single-phage treatments. Couple with 
% MantisProtocolGenerator to produce a protocol for direct input into the
% Manstis liquid handling platform.

% xdim: horizontal dimension of microplate 
% ydim: vertical dimension of microplate
% numPhages: number of phages to be tested (each will be given an integer designation)
% cocktailSize: number of phages per test cocktail
% numReplicates: number of technical replicates for each cocktail
% filename: file path of Excel document you want the plate map
% printed into. 
% newSheetName: name of the worksheet that will be added to the 
% Excel file. 
% controls (optional): specifies whether you want controls (phage-negative
% and single-phage). Default: true.

phageList = 1:1:numPhages;
phageCombinations = combntns(phageList,cocktailSize);
phageCombinations2 = combntns(phageList,2);
plateSkeleton = cell([ydim-2 xdim-2]); % Leaves outer ring blank, since these wells are not reliable on 1536-well plates

doubleTreatments = []; % For tests involving the same phage twice; synergy control
for i = 1:numel(phageList)
    doubleTreatments = [doubleTreatments;[phageList(i) phageList(i)]];
end
phageCombinations2 = [doubleTreatments;phageCombinations2];

if size(phageCombinations,1)*numReplicates > numel(plateSkeleton)
     error('The given microplate cannot hold this many combinations. Decrease number of phages being tested, number of replicates, or cocktail size, or increase the size of the plate.')
end   

if ~exist('controls','var')
    if (size(phageCombinations,1) + numel(phageList) + 1)*numReplicates > (numel(plateSkeleton))
         error('Microplate with these dimensions is too small. Decrease number of phages being tested, number of replicates, or cocktail size, or increase the size of the plate.')
    end
end

%%Generate a matrix containing all possible combinations of phage
%%cocktails within the dimensions of the given microplate

plateDex = 1;
combCount = 1;
replicateCount = 1;
phageDex = 1;


if ~exist('controls','var')
    while replicateCount <= numReplicates   %%Controls with only bacteria
        plateSkeleton{plateDex} = 'null';
        plateDex = plateDex + 1;
        replicateCount = replicateCount + 1;
    end

    replicateCount = 1;

    while plateDex <= numel(plateSkeleton) && phageDex <= numel(phageList)  %%Controls with 1 phage 
        while replicateCount <= numReplicates
            plateSkeleton{plateDex} = phageList(phageDex);
            plateDex = plateDex + 1;
            replicateCount = replicateCount + 1;
        end
        replicateCount = 1;
        phageDex = phageDex + 1;
    end
end

replicateCount = 1;

if cocktailSize >= 2
    while ((plateDex <= (numel(plateSkeleton)-((numel(phageList)+1)*numReplicates))) && (combCount <= size(phageCombinations2,1)))  %%Fills in plate with all 2-phage combinations
        while replicateCount <= numReplicates
            plateSkeleton{plateDex} = phageCombinations2(combCount,:);
            plateDex = plateDex + 1;
            replicateCount = replicateCount + 1;
        end
        replicateCount = 1;
        combCount = combCount + 1;
    end
end

combCount = 1;

if cocktailSize > 2
% Buggy code: while ((plateDex <= (numel(plateSkeleton)-((numel(phageList)+1)*numReplicates))) && (combCount <= size(phageCombinations,1)))  %%Fills in plate with all n-phage combinations
while ((plateDex <= (numel(plateSkeleton))) && (combCount <= size(phageCombinations,1)))  %%Fills in plate with all n-phage combinations
    while replicateCount <= numReplicates
        plateSkeleton{plateDex} = phageCombinations(combCount,:);
        plateDex = plateDex + 1;
        replicateCount = replicateCount + 1;
    end
    replicateCount = 1;
    combCount = combCount + 1;
end
end

while plateDex <= numel(plateSkeleton)  %%Fills in the rest of the plate with null
    plateSkeleton{plateDex} = 'null';
    plateDex = plateDex + 1;
end

% disp(plateSkeleton)

% Shuffle platemap to combat area-dependent effects on 1536-well plate 
% plateSkeleton = plateSkeleton(reshape(randperm(size(plateSkeleton,1) * size(plateSkeleton,2)), size(plateSkeleton,1), size(plateSkeleton,2)));

% Add outer ring of zeros
nulls = cell(ydim,xdim);
nulls(2:ydim-1,2:xdim-1) = plateSkeleton;

skeleton = nulls;
end 