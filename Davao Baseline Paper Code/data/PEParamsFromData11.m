function [deltaMVals, gammaMVals, deltaHVals, ...
            gammaHVals, muHVals, qVals, mVals] = PEParamsFromData11...
            (inputCaseInfo11, RPCName, HDCMName, ...
            dateCuts)

% Getting specific columns of the case information file
opts = detectImportOptions(inputCaseInfo11);
opts.SelectedVariableNames = {'dateReport', ...
    'provinceCity', ...
    'municipality', ...
    'district', ...
    'dateOnset', ...
    'disposition', ...
    'dateAdmit', ...
    'currentHealthStatus', ...
    'admitHealthStatus', ...
    'dateDied', ...
    'dateDischarge'};
%     'DateReportedAsDischarged_IfDischarge', ...
%     'ACTUAL_DateOfDischarge_IfDischarged_', ...
% ...
%     'HDCM'
% Reading the file
T = readtable(inputCaseInfo11, opts);

% Capitalizing string columns to make the data uniform
T.provinceCity = upper(T.provinceCity);
T.municipality = upper(T.municipality);
T.district = upper(T.district);
T.admitHealthStatus = upper(T.admitHealthStatus);
T.currentHealthStatus = upper(T.currentHealthStatus);
T.disposition = upper(T.disposition);
% T.HDCM = upper(T.HDCM);

% Converting IGACOS to a province-level area
igacosIdx = contains(T.municipality, 'IGACOS');
T.provinceCity(igacosIdx) = {'IGACOS'};

% Filtering of province or city-level area
% If false, we consider region-level
if strcmp(RPCName, 'DAVAO REGION') == false
    PCIdx = contains(T.provinceCity, RPCName);
    T = T(PCIdx, :);
   
    % Considering municipality or district-level if there is an input;
    % except davao City
    if strcmp(RPCName, 'DAVAO CITY') == true
        if ~isempty(HDCMName)
            HDCMIdx = contains(T.district, HDCMName);
            T = T(HDCMIdx, :);
        end
    else
        if ~isempty(HDCMName)
            HDCMIdx = contains(T.municipality, HDCMName);
            T = T(HDCMIdx, :);
        end
    end
end

deltaMVals = zeros(1, length(dateCuts) - 1);
gammaMVals = zeros(1, length(dateCuts) - 1);
deltaHVals = zeros(1, length(dateCuts) - 1);
gammaHVals = zeros(1, length(dateCuts) - 1);
muHVals = zeros(1, length(dateCuts) - 1);
qVals = zeros(1, length(dateCuts) - 1);
mVals = zeros(1, length(dateCuts) - 1);


% figure(40)
% tiledlayout(length(dateCuts) - 1, 5, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:length(dateCuts) - 1
    if i == 1
        deltaMVals(i) = 1/3;
        gammaMVals(i) = 1/19;
        deltaHVals(i) = 1/7;
        gammaHVals(i) =  0.0238;
        muHVals(i) =  0.1223;
        qVals(i) = 0.2271;
        mVals(i) = 0;
    end
    if i==2
        deltaMVals(i) = 1/3;
        gammaMVals(i) = 1/16;
        deltaHVals(i) = 1/5;
        gammaHVals(i) =  0.0257;
        muHVals(i) =  0.1579;
        qVals(i) = 0.0788;
        mVals(i) = 0;
    end
    if i==3
        deltaMVals(i) = 1/3;
        gammaMVals(i) = 1/14;
        deltaHVals(i) = 1/3;
        gammaHVals(i) =  0.0244;
        muHVals(i) =  0.2928;
        qVals(i) = 0.0842;
        mVals(i) = 0.0002;
    end
    if i==4 
        deltaMVals(i) = 1/3;
        gammaMVals(i) = 1/11;
        deltaHVals(i) = 1/3;
        gammaHVals(i) = 0.0193;
        muHVals(i) = 0.3002;
        qVals(i) = 0.0742;
        mVals(i) = 0.0054;
    end
    end
end