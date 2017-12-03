function plotIndivData(plateSkeleton, phageData, targetPhages, errorbars, tstep)
% Default tstep: 15 minutes
% Default errorbar: null (i.e. no errorbars)
% targetPhages is a CELL ARRAY

dex = 1;
while isequal(plateSkeleton{dex},'')
    dex = dex+1;
end

numReplicates = 0;
while isequal(plateSkeleton{dex},'null') % Infers numReplicates from plateSkeleton; only works if there was a negative control
    numReplicates = numReplicates + 1;
    dex = dex + 1;
end

[treatments treatmentData] = formatData(plateSkeleton, phageData, numReplicates);



xdim = size(plateSkeleton, 2);
ydim = size(plateSkeleton, 1);
Q = reshape(phageData,xdim,ydim,[]);   

if ~exist('tstep','var'), tstep = 15; end
time = [0:length(Q)-1].*tstep./60;

legendEntries = {};
legendEntries = [legendEntries 'Control'];                                

figure; hold on
grid on;
set(gca,'fontsize',12);

if exist('errorbars','var')
    errorbar(time,mean(treatmentData{1}'), std(treatmentData{1}'), 'linewidth', 1.25); hold on
else
    plot(time,mean(treatmentData{1}'), 'linewidth', 3); hold on
end

for i = 1:numel(targetPhages)
    for k = 1:numel(treatments)
        if isequal(targetPhages{i},treatments{k}) | isequal(fliplr(targetPhages{i}),treatments{k})
            if exist('errorbars','var')
                errorbar(time,mean(treatmentData{k}'), std(treatmentData{k}'),'linewidth',1); hold on
                set(gca, 'ColorOrder', varycolor(numel(targetPhages)));
                newEntry = ['Phage ' mat2str(treatments{k})]; 
                legendEntries = [legendEntries newEntry];
            else
                plot(time, mean(treatmentData{k}'),'linewidth',3); hold on;
                set(gca, 'ColorOrder', varycolor(numel(targetPhages)));
                newEntry = ['Phage ' mat2str(treatments{k})]; 
                legendEntries = [legendEntries newEntry];
            end
        end
    end
end

legend(legendEntries);
% legend('Control','Phage')
xlabel('Hours');
ylabel('OD600');

% 
% for i = 1:length(targetPhages)
%     legendEntries = {};
%     figure(); hold on
%     title(num2str(targetPhages(i)));
%     if strcmp(treatments{1},'null') 
%         plot(time, mean(treatmentData{1}')); hold on; 
%         set(gca, 'ColorOrder', varycolor(11));
%         legendEntries = [legendEntries 'Control'];
%     end
%     for k = 1:length(treatments)
%         if any(treatments{k} == targetPhages(i))
%             plot(time,mean(treatmentData{k}'));
%             legendEntries = [legendEntries mat2str(treatments{k})];
%         end
%     end
%     legend(legendEntries);
% end






end