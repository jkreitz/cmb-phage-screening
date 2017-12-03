% An example implementation of combinatorial phage screening using this
% package.
% 
% Experiment/analysis outline + relevant scripts: 
%   1.) Generate a plate map representing an exhaustive combinatorial screen
%           -plateMap.m
%   2.) Convert plate map to a liquid handler protocol (in this case, the
%       Formulatrix Mantis (TM))
%           -MantisProtocolGenerator.m 
%           -inscribeSkeleton.m 
%   3.) Re-format plate reader data into a convenient form for downstream
%       analysis 
%           -formatData.m
%   4.) Plot data 
%           -plotData.m
%           -plotIndivData.m
%   5.) Calculate interaction values + assemble iNets
%           -synergyMap.m 
%   6.) [IN PROGRESS] Infer higher-order cocktail efficacy + calculate
%       optimal cocktails
%           -minIntValSolver.m
% 
% Example data provided in exampleData.m. Experimental conditions: 
%   -23 phages tested @ MOI = 0.01 
%   -Cocktails up to size 2 tested 
%   -OD600 measurements taken at 15 minute intervals for 20 hours
%   -Plate reader: PerkinElmer Victor3
%   -Greiner 1536-well plate 
%
% Copyright (c) 2017 Joseph Kreitz (joekreitz@gmail.com).

clear all; close all;

% Store + reshape data
disp('Storing + Reshaping Data...');
exampleData;
data = reshape(example,48,32,[]); 

% Generate plate map with desired experimental conditions
disp('Generating Plate Map...');
mapMain = plateMap(32,48,23,2,3); % ydim, xdim, #phages, max cocktail size, number of replicates

% Store the plate map as an Excel file for future reference
% Currently commented because this function is still in progress (functional but SLOW)
% inscribeFileOut = 'PlateSkeletons';
% inscribeSkeleton(mapMain,inscribeFileOut,'newSheet');

% Generate a Mantis protocol (for automated plate loading)
disp('Generating Mantis Protocol...');
mantisFileOut = 'MantisScripts.xls';
MantisProtocolGenerator(mapMain,mantisFileOut,'newSheet',4,1,3,8); 

%%%%%%%%%% LOAD THE PLATE, TAKE TIMECOURSE MEASUREMENTS %%%%%%%%%%%%%%

% Plot all the data 
disp('Plotting All Data...');
phages = num2cell(1:1:23);
plotIndivData(mapMain(2:31,2:47),data(2:47,2:31,:),phages);

% Plot individual data (perhaps you noticed something odd in the previous plot)
disp('Plotting Individual Data...');
plotIndivData(mapMain(2:31,2:47),data(2:47,2:31,:),{4,6,[4,6]},'true',15);

% Generate interaction heatmap
disp('Generating iNet Heatmap...');
[synMap,intValsForEachPhage] = synergyMap(mapMain(2:31,2:47),data(2:47,2:31,:),23);
 
% Calculate optimal higher-order cocktails
% Currently trying to improve this beyond exhaustive search 
% Warning: can take a long time; currently commented for this reason
% disp('Calculating Best Cocktail...');
% phages = 1:1:23;
% [globalBests,globalBestVals,cocktailSizeBests,cocktailSizeBestVals] = minIntValSolver(phages,intValsForEachPhage);

