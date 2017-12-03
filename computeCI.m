function[CI,E1,E2,Ecomb,backgroundRegion,OD_of_broth] = computeCI(controlData,phage1Data,phage2Data,combData,framework)
% Framework: 'bliss' or 'response additivity'. Default: 'bliss'.
if ~exist('framework','var'), framework = 'bliss'; end
time = [0:size(controlData,2)-1].*15./60;

%%% Correct data for background OD of nutrient broth, using either first n elements or derivative thresholding %%% 
clist = controlData(:);
Onelist = phage1Data(:);
Twolist = phage2Data(:);
Comblist = combData(:);
OD_of_broth = mean(clist(2:5)); % range of control values to average over
ODBackground1 = mean(Onelist(2:5));
ODBackground2 = mean(Twolist(2:5));
ODBackgroundComb = mean(Comblist(2:5));

% OD_of_broth = 0;
backgroundRegion = time(1:4);

% movingdndt = movingslope(mean(controlData),3,2);
% firstPass = find(movingdndt >= 2e-3); % high-end extreme of derivative for averaging
% 
% if size(controlData,1) == 1
%     meanc = controlData;
% else
%     meanc = mean(controlData);
% end
% 
% OD_of_broth = mean(meanc(1:firstPass(1)));
% backgroundRegion = time(1:firstPass(1));

controlCorr = controlData - OD_of_broth;
phage1Corr = phage1Data - OD_of_broth;
phage2Corr = phage2Data - OD_of_broth;
combCorr = combData - OD_of_broth;

%%% Calculate integrals %%% 
if (size(controlData,1) > 1), intControl = trapz(mean(controlCorr(:,2:end)));
else intControl = trapz(controlCorr(2:end));
end
% if intControl < 0, intControl = 0; end
    
if (size(phage1Data,1) > 1), int1 = trapz(mean(phage1Corr(:,2:end)));
else int1 = trapz(phage1Corr(2:end));
end
% if int1 < 0, int1 = 0; end
% if int1 > intControl, int1 = intControl; end

if (size(phage2Data,1) > 1), int2 = trapz(mean(phage2Corr(:,2:end)));
else int2 = trapz(phage1Corr(2:end));
end
% if int2 < 0, int2 = 0; end
% if int2 > intControl, int2 = intControl; end


if (size(combData,1) > 1), intComb = trapz(mean(combCorr(:,2:end)));
else intComb = trapz(combCorr(2:end));
end
% if intComb < 0, intComb = 0; end
% if intComb > intControl, intComb = intControl; end

%%% Calculate effect + CI values according to various frameworks %%% 
if (strcmp(lower(framework),'bliss')) == 1
    E1 = (int1 / intControl);
    E2 = (int2 / intControl);
    Ecomb = 1 - (intComb / intControl);
    CI = (E1 + E2 - (E1*E2)) / Ecomb;
    
elseif (strcmp(lower(framework),'blissalt')) == 1
    E1 = (int1 / intControl);
    E2 = (int2 / intControl);
    Ecomb = (intComb / intControl);
    CI = ((E1 * E2) / Ecomb);
    
elseif (strcmp(lower(framework),'response additivity') || strcmp(lower(framework),'ra'))
    E1 = intControl -  int1;
    E2 = intControl - int2;
    Ecomb = intControl - intComb;
    CI = (E1 + E2) / Ecomb;
else 
    disp('Didnt pick anything ya dolt')
end


% 
% if (size(controlData,1) == 1)
%     figure(); hold on
%     plot(time,controlCorr,time,phage1Corr,time,phage2Corr,time,combCorr)
% else
%     figure(); hold on
%     plot(time,mean(controlCorr),time,mean(phage1Corr),time,mean(phage2Corr),time,mean(combCorr))
% end

% movingdndt = movingslope(mean(controlData),3,2);
% movingdndtPhage = movingslope(mean(phage1Data),3,2);
% figure(); hold on 
% plot(time,(movingdndt),time,movingdndtPhage)
% 

end