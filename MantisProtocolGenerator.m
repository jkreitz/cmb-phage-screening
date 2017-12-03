function MantisProtocolGenerator(plateSkeleton, filename, newSheetName, numPhages, totalPhageVol, cocktailSize, cultureVol)

% Correspondence: Joseph Kreitz (joekreitz@gmail.com)
% Part of Excel code adapted from Kiran Chandrashekhar

% Generates a protocol compatible with the Mantis liquid handling 
% platform (Formulatrix) using a microplate schematic generated using 
% plateMap.m. Copies this protocol as a new worksheet into an existing
% Excel file. Can specify the total volume of phages and bacteria
% dispensed into each well. 

% If you don't want a dispense for bacteria, omit cultureVol from function
% call (don't use 0 for this parameter-- will throw an error on the Mantis)

% plateSkeleton: schematic of sample distribution (see plateMap.m)
% filename: file path of Excel document you want to add to
% newSheetName: name of the worksheet that will be added to the Excel file
% numPhages: number of phages to be tested (each will be given an integer designation)
% totalPhageVol: total phage volume you want pipetted into each well
% cocktailSize: number of phages per test cocktail
% cultureVol: total volume of cells you want pipetted into each well 

phageList = 1:1:numPhages;

if ~exist('cultureVol','var'), warning('Did not list a value for cultureVol; assuming you do not want a dispense for bacteria'); end

if numel(plateSkeleton) == 96
    plateHeight = 8;
    plateLength = 12;
elseif numel(plateSkeleton) == 384
    plateHeight = 16;
    plateLength = 24;
elseif numel(plateSkeleton) == 1536
    plateHeight = 32;
    plateLength = 48;
else 
    error('Plate size incompatible with Mantis platform. Choose from 96-, 384-, or 1536-well plates.')
end


if exist('cultureVol','var')
    bacteriaMap = zeros(plateHeight, plateLength); %%Generate first dispense: bacterial culture
    for k = 1:numel(bacteriaMap)
        bacteriaMap(k) = cultureVol;
    end
end

PhageArrays = {};  
phageDex = 1;
while phageDex <= numel(phageList)
   newArray = zeros(plateHeight, plateLength);
   for k = 1:numel(plateSkeleton)
       numOccurrences = sum(plateSkeleton{k}==phageList(phageDex));
       if numOccurrences > 0
           newArray(k) = numOccurrences * totalPhageVol;
%            if numel(plateSkeleton{k}) == 1   % This part assures that the total volume in the well is still totalPhageVol, even if there are multiple phages being added
%                newArray(k) = totalPhageVol;
%            elseif numel(plateSkeleton{k}) == 2
%                newArray(k) = (totalPhageVol / 2);
%            else
%                newArray(k) = (totalPhageVol / cocktailSize);
%            end
       end    
   end
   phageDex = phageDex + 1; 
%    PhageArrays = [PhageArrays ['NEXT']];
   PhageArrays = [PhageArrays newArray];  %%List containing platemaps for phage dispenses on Mantis
end

% Excel = actxserver('Excel.Application');  
% invoke(Excel,'Quit');
% delete(Excel);
xlswrite(filename, plateSkeleton,newSheetName,'A1')

xlswrite(filename,{'-----------------COPY BELOW INTO MANTIS EXCEL EDITOR-----------------'},newSheetName,'A1')

currentRow = 3;

disp('This can take a minute or more. Thanks for your patience!');


if exist('cultureVol','var')
    %Write in bacteria map into file with appropriate header   
    xlswrite(filename, {'Culture'}, newSheetName, ['A' num2str(currentRow)])
    xlswrite(filename, {'Normal'}, newSheetName, ['C' num2str(currentRow)])
    currentRow = currentRow + 1;
    xlswrite(filename, {'Well'}, newSheetName, ['A' num2str(currentRow)])
    xlswrite(filename, 1, newSheetName, ['B' num2str(currentRow)])
    currentRow = currentRow + 1;
    xlswrite(filename, bacteriaMap, newSheetName, ['A' num2str(currentRow)])
    currentRow = currentRow + plateHeight;
end

phageDex = 1;
while phageDex <= numel(PhageArrays)
   %Write in phage maps into file with appropriate headers 
    xlswrite(filename, {['Phage' num2str(phageList(phageDex))]}, newSheetName, ['A' num2str(currentRow)])
    xlswrite(filename, {'Normal'}, newSheetName, ['C' num2str(currentRow)])
    currentRow = currentRow + 1;
    xlswrite(filename, {'Well'}, newSheetName, ['A' num2str(currentRow)])
    xlswrite(filename, 1, newSheetName, ['B' num2str(currentRow)])
    currentRow = currentRow + 1;
    xlswrite(filename, PhageArrays{phageDex}, newSheetName, ['A' num2str(currentRow)])
    currentRow = currentRow + plateHeight;
    phageDex = phageDex + 1;
end

% Excel = actxserver('Excel.Application');  
% Workbook = invoke(Excel.Workbooks,'Open', [filename '.xls']);
% set(Excel, 'Visible', 1);   
% 
% invoke(Workbook,'Save');
% 
% invoke(Workbook,'Close');





 








% header1 = {'[ Version: 4 ]'};
% if plateSize == 96
%     header2 = {'PT3-96-Assay.pd.txt'};
% elseif plateSize == 384
%     header2 = {'PT9-384-Assay.pd.txt'};
% elseif plateSize == 1536
%     header2 = {'PT23-1536-Well Corning.pd.txt'};
% else 
%     error('Plate size incompatible with Mantis platform. Choose from 96, 384, or 1536.')
% end
% header3 = [2 0 0];
% 
% xlswrite(filename,header1,newSheetName,'A1')
% xlswrite(filename,header2,newSheetName,'A2')
% xlswrite(filename,header3,newSheetName,'A3')

end