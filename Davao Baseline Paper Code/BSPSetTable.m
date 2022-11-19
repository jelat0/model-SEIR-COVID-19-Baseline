clear;
clc;
close all;
tic;

%% File data concerning parameters and other estimation variables
city = 'Davao City';
cityPop = 1816987;

inputCityData = 'DavCityDataFromCases.mat';
incidCityData = 'Cases-COVID-19-11132021-smaller.xlsx';
inputBSResults = 'Result_BS_100_13-Dec-2021_lsqcurvefit.mat';

dateCuts = {'03/08/2020', ... % START
            '05/15/2020', ... % CQ + ECQ
            '06/30/2020', ... % GCQ
            '11/18/2020', ... % MGCQ
            '12/31/2020', ... % End of the year (GCQ)
            '03/05/2021', ... % Start of vaccination (GCQ)
            '06/04/2021', ... % GCQ
            '07/15/2021', ... % MECQ
            '08/15/2021', ... % Arbitrary cut
            '08/30/2021', ... % Arbitrary cut
            '09/15/2021', ... % Arbitrary cut
            '09/30/2021', ... % GCQ with Heightened Restrictions
            '10/19/2021', ... % GCQ
            '11/13/2021'};    % Alert Level 3
dateCQStr = {'CQ + ECQ', 'GCQ1', 'MGCQ', 'GCQ2', 'GCQ3', 'GCQ4', 'MECQ', ...
                'GCQ HR1', 'GCQ HR2', 'GCQ HR3', 'GCQ HR4', 'GCQ5', 'AL3'};
paramNames = {'beta', 'deltaH', 'deltaM', 'psi', 'phiH', ...
                'gammaM', 'gammaH', 'muH',...
                'r', 'q', 'm', 'alpha', 'delta', ...
                'S0', 'E0', 'Im0', 'Ih0', 'R0', 'M0', 'H0', 'D0'};

BSsamples = 100;

currDir = cd; % Access data in the 'data' folder
cd('data');
dataDivD = load(inputCityData);
cd(currDir)

cd('bs_results');
BSFullResults = load(inputBSResults);
tPeriods = BSFullResults.tPeriods;
timeVect = BSFullResults.timeVect;
inputData = BSFullResults.inputData;
inputEst = BSFullResults.inputEst;
inputP0 = BSFullResults.inputP0;
BSoutputData = BSFullResults.outputData;
BSoutputCurves = BSFullResults.outputCurves;
BSoutputFCCurves = BSFullResults.outputFCCurves;
BSoutputIncid = BSFullResults.outputIncid;
BSoutputFCIncid = BSFullResults.outputFCIncid;
BSoutputPSet = BSFullResults.outputPSet;
BSoutputFCPSet = BSFullResults.outputFCPSet;
BSoutputP1 = BSFullResults.outputP1;
BSoutputRes = BSFullResults.outputRes;
BSoutputMet = BSFullResults.outputMet;
BSoutputModSelect = BSFullResults.outputModSelect;
BSoutputRepNo = BSFullResults.outputRepNo;
BSoutputFCRepNo = BSFullResults.outputFCRepNo;
BSoutputResid = BSFullResults.outputResid;
cd(currDir);

PSET1 = BSoutputPSet(1, :, :);
PSET1 = reshape(PSET1, length(paramNames), length(dateCQStr));

betarInd = [1, 9];
for i = 1:2
    for j = 1:length(tPeriods)
        PE2H = BSoutputP1(:, i, j);
    
        PEMed = plims(PE2H, 0.5);
        PEUp = plims(PE2H, 0.975);
        PELow = plims(PE2H, 0.025);

        PSET1(betarInd(i), j) = PEMed;
    end
end

dataDate = timeVect;
MAll = zeros(BSsamples, length(tPeriods));
HAll = zeros(BSsamples, length(tPeriods));
SAll = zeros(BSsamples, length(tPeriods));
EAll = zeros(BSsamples, length(tPeriods));
IhAll = zeros(BSsamples, length(tPeriods));
ImAll = zeros(BSsamples, length(tPeriods));
RAll = zeros(BSsamples, length(tPeriods));
DAll = zeros(BSsamples, length(tPeriods));
for g = 1:BSsamples
    for i = 1:length(tPeriods)
        MAll(g, i) = BSoutputIncid{g, i}(1, 1);
        HAll(g, i) = BSoutputIncid{g, i}(1, 2);

        SAll(g, i) = BSoutputCurves{g, i}(1, 1);
        EAll(g, i) = BSoutputCurves{g, i}(1, 2);
        IhAll(g, i) = BSoutputCurves{g, i}(1, 4);
        ImAll(g, i) = BSoutputCurves{g, i}(1, 3);
        RAll(g, i) = BSoutputCurves{g, i}(1, 5);
        DAll(g, i) = BSoutputCurves{g, i}(1, 8);
    end
end

cmpts = {'S', 'E', 'Im', 'Ih', 'R', 'M', 'H', 'D'};
for i = 1:length(cmpts)
    for j = 1:length(tPeriods)
        XMed = plims(eval(append(cmpts{i}, 'All(:, ', num2str(j), ')')), 0.5);

        PSET1(i + 13, j) = XMed;
    end
end

PSET2 = array2table(PSET1(:, :), ...
    'RowNames', paramNames, ...
    'VariableNames', dateCQStr(1:13));
save('BSPSetTable.mat', 'PSET2');



toc;