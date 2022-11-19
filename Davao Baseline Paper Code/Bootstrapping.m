function Bootstrapping(LHSNameResults, inputCityData, inputCityParams, RPCName, HDCMName, ...
    areaPop, dateCuts, outputSummary, param2est, data2use, BSsamples, ...
    dateCQStr, days2FC, days2test, betaSS, E0, Im0, Ih0, M0, H0, R0, CSM0, CSH0)
tic;

inputLHSResults = append(LHSNameResults, '.mat');

maData = true;
maDays = 7;

popFactor = 1;

% E0 = 100 * (areaPop/1816987);

%% i) Training data

currDir = cd; % Access data in the 'data' folder
cd('data');
dataDiv = load(inputCityData);
paramsetFromFile = load(inputCityParams);
paramsetParams = paramsetFromFile.pset;
cd(currDir)

cd('lhs_results');
LHSFullResults = load(inputLHSResults);
% tPeriods = LHSFullResults.tPeriods;
% timeVect = LHSFullResults.timeVect;
% inputData = LHSFullResults.inputData;
% inputEst = LHSFullResults.inputEst;
% inputP0 = LHSFullResults.inputP0;
LHSoutputCurves = LHSFullResults.outputCurves;
LHSoutputIncid = LHSFullResults.outputIncid;
LHSoutputPSet = LHSFullResults.outputPSet;
LHSoutputP1 = LHSFullResults.outputP1;
LHSoutputRes = LHSFullResults.outputRes;
LHSoutputMet = LHSFullResults.outputMet;
LHSoutputModSelect = LHSFullResults.outputModSelect;
LHSoutputRepNo = LHSFullResults.outputRepNo;
LHSoutputResid = LHSFullResults.outputResid;
cd(currDir);


SSEVals = sum(sum(LHSoutputRes(:, 1:2, :), 3), 2);
[~, minG] = min(SSEVals);
p0Vals = LHSoutputP1(minG, :, :);
p0Vals = reshape(p0Vals, [length(dateCuts) - 1, length(param2est)]);


% Start and end of preferred whole period
startDate = find(dataDiv.dataDate == datetime(dateCuts{1}, 'Format', 'MM/dd/yyyy'));
Q1Date = find(dataDiv.dataDate == datetime(dateCuts{2}, 'Format', 'MM/dd/yyyy'));
Q2Date = find(dataDiv.dataDate == datetime(dateCuts{3}, 'Format', 'MM/dd/yyyy'));
Q3Date = find(dataDiv.dataDate == datetime(dateCuts{4}, 'Format', 'MM/dd/yyyy'));
endDate = find(dataDiv.dataDate == datetime(dateCuts{end}, 'Format', 'MM/dd/yyyy'));
endDateFC = find(dataDiv.dataDate == datetime(dateCuts{end}, 'Format', 'MM/dd/yyyy') + days2test);

dataDate = dataDiv.dataDate;
dataMonit = double(dataDiv.dataMonit(startDate:endDate));
dataHosp = double(dataDiv.dataHosp(startDate:endDate));
dataDeath = double(dataDiv.dataDeath(startDate:endDate));
dataRecov = double(dataDiv.dataRecov(startDate:endDate));
dataRtLow = double(dataDiv.dataRtLow(startDate:endDate));
dataRtMed = double(dataDiv.dataRtMed(startDate:endDate));
dataRtHigh = double(dataDiv.dataRtHigh(startDate:endDate));
dataRtMedQ1 = double(dataDiv.dataRtMed(startDate:Q1Date));
dataRtMedQ2 = double(dataDiv.dataRtMed(Q1Date:Q2Date));
dataRtMedQ3 = double(dataDiv.dataRtMed(Q2Date:Q3Date));
dataRtMedQ4 = double(dataDiv.dataRtMed(Q3Date:endDate));
a =mean(dataRtMedQ1); 
b =mean(dataRtMedQ2);
c =mean(dataRtMedQ3);
d =mean(dataRtMedQ4);


for i = 1:68
dataRtMedQ1s(i) = a;
end
for i = 1:46
dataRtMedQ2s(i) = b;
end
for i=1:142
dataRtMedQ3s(i) = c;
end
for i=1:107
dataRtMedQ4s(i) = d;
end
dataRtMedQ = [dataRtMedQ1s dataRtMedQ2s dataRtMedQ3s dataRtMedQ4s];

dataMonitMA = movmean(dataMonit, maDays);
dataHospMA = movmean(dataHosp, maDays);
dataDeathMA = movmean(dataDeath, maDays);
dataRecovMA = movmean(dataRecov, maDays);

dataMonitFC = double(dataDiv.dataMonit(startDate:endDateFC));
dataHospFC = double(dataDiv.dataHosp(startDate:endDateFC));
dataMonitMAFC = movmean(dataMonitFC, maDays);
dataHospMAFC = movmean(dataHospFC, maDays);

tCuts = [0];
tPeriods = cell(1, length(dateCuts) - 1);
for i = 1:length(dateCuts)-1
    tCuts(end + 1) = days(datetime(dateCuts{i+1}, 'InputFormat', 'MM/dd/yyyy')...
                        - datetime(dateCuts{1}, 'InputFormat', 'MM/dd/yyyy'));
    tPeriods{i} = tCuts(i):1:tCuts(i+1);
end
timeVect = startDate-1:1:endDate-1;


%% Parameters and their Bounds
 
% parameter names in the order they are displayed in the results file
paramNames = {'beta', 'deltaH', 'deltaM', 'psi', 'phiH', ...
                'gammaM', 'gammaH', 'muH',...
                'r', 'q', 'm', 'alpha', 'delta', ...
                'S0', 'E0', 'Im0', 'Ih0', 'R0', 'M0', 'H0', 'D0'};

% Pre-allocate for the LB&UB of param2est
paramIdx = zeros(1,length(param2est));

pop = areaPop*popFactor;
if maData == true
    data2EstM = dataMonitMA;
    data2EstH = dataHospMA;
    data2EstD = dataDeathMA;
    data2EstR = dataRecovMA;
else
    data2EstM = dataMonit;
    data2EstH = dataHosp;
    data2EstD = dataDeath;
    data2EstR = dataRecov;
end

% Im0 = data2EstM(1);
% Ih0 = data2EstH(1);
% M0 = data2EstM(1);
% H0 = data2EstH(1);
% R0 = data2EstR(1);
D0 = data2EstD(1);
S0 = pop - E0 - Im0 - Ih0 - R0 - D0;

paramset = zeros(21, 1);
paramset(1:13) = paramsetParams(:, 1);
for i = 14:21
    paramset(i) = eval(paramNames{i});
end
paramsetReset = paramset;

% bounds for the parameters and variables
LBfull = 1e-5 * ones(1,length(paramNames));
UBfull = [10,1,1,1,1,1,1,1,1,1,1,1,1,areaPop,areaPop,areaPop,areaPop,areaPop,areaPop,areaPop,areaPop];
    
LB = zeros(1, length(param2est));
UB = zeros(1, length(param2est));

% Assign the LB and UB to the parameters in the param2est
for i = 1:length(param2est)
    k = 1;
    while strcmp(param2est(i),paramNames(k)) == 0 %e.g. false/not the same param name
        k = k + 1;
    end
    paramIdx(i) = k;
    LB(i) = LBfull(k);
    UB(i) = UBfull(k);
end

% LBcopy = LB;
% UBcopy = UB;

dependDir = 'dependencies';
cd(dependDir)
LHSmatrix = Model_LHS(LB, UB, BSsamples, 'unif', 1e20); % LHS call function
cd(currDir)

lenDateCuts = length(dateCuts) - 1;

% Pre-allocation of cells/matrices
inputData = [dataMonit dataHosp dataDeath dataRecov]; 
inputEst = [data2EstM data2EstH data2EstD data2EstR]; 
inputP0 = LHSmatrix;

outputIncid = cell(BSsamples, lenDateCuts);
outputCurves = cell(BSsamples, lenDateCuts);
outputData = cell(BSsamples, lenDateCuts);
outputPSet = zeros(BSsamples, 21, lenDateCuts);
outputP1 = zeros(BSsamples, length(paramIdx), lenDateCuts);
outputRes = zeros(BSsamples, 2 * 4, lenDateCuts);
outputMet = zeros(BSsamples, 4, lenDateCuts);
outputRepNo = zeros(BSsamples, lenDateCuts);
outputResid = cell(BSsamples, length(data2use), lenDateCuts);
outputModSelect = zeros(BSsamples, 8, lenDateCuts);

outputFCInits = zeros(BSsamples, 8);

popReset = pop;

disp('Start of parameter bootstrapping.')

for g = 1:BSsamples
    disp(append('   BS: ', string(g), ' out of ', string(BSsamples)));
    for j = 1:lenDateCuts
        p0 = p0Vals(j, :);

        options = optimoptions('lsqcurvefit', ...
                                'Algorithm', 'trust-region-reflective', ...
                                'MaxFunctionEvaluations', 1e4*length(p0), ...
                                'MaxIterations', 1e4*length(p0), ...
                                'Display', 'none');

        paramset(1:13) = paramsetParams(:, j);

        % Daily data
        dataDivM = LHSoutputIncid{minG, j}(:, 1);
        dataDivH = LHSoutputIncid{minG, j}(:, 2);

        data4Est = zeros(length(tPeriods{j}), length(data2use));
        for i = 1:length(data2use)
            incid2Poiss = eval(append('dataDiv', data2use{i}));
            caseData = zeros(length(incid2Poiss), 1);
            caseData(1) = incid2Poiss(1);
            for tt = 2:length(incid2Poiss)
                caseData(tt, 1) = poissrnd(incid2Poiss(tt), 1, 1);
            end 
            data4Est(:, i) = caseData;
        end
        outputData{g, j} = data4Est;

%         % Optimization options
%         options = optimset('FunValCheck', 'on',...
%                            'MaxFunEvals',3e3*length(p0),...
%                            'MaxIter',3e3*length(p0),...
%                            'TolX',1e-7,...
%                            'TolFun',1e-7,...
%                            'Display', 'off');
%         [P, fval, exitflag, output] = fminsearchbnd(@PEObjective, ...
%             p0, LB, UB, options, tPeriods{j}, ...
%             paramIdx, paramset, pop, data4Est);

    
        xDataLCF = repmat(tPeriods{j}, 1, length(data2use));
        yDataLCF = reshape(data4Est, 1, numel(data4Est));
        [P, fval, ~, exitflag, output] = lsqcurvefit(@PEObjectiveLCF, ...
            p0, xDataLCF, yDataLCF, LB, UB, options, ...
            paramIdx, paramset, pop, data4Est, data2use);
        
        % For-loop placing the estimated values of parameters
        for i = 1:length(paramIdx)
            paramset(paramIdx(i)) = P(i);
        end
        outputP1(g, :, j) = P;
        outputPSet(g, :, j) = paramset;

        initCmpts = paramset(14:21);
        % Solving the ODE again using the parameter estimates and adjustments
        odeOptions = odeset('Reltol', 1e-6, 'Abstol', 1e-6);
        [~, sol] = ode15s(@BaselineModel, tPeriods{j}, initCmpts, ...
            odeOptions, paramset);
        outputCurves{g, j} = sol;

        Msol = sol(:, 6);
        Hsol = sol(:, 7);
%         Dsol = sol(:, 8);
%         Rsol = sol(:, 5);

        Mdiff = [Msol(1); diff(Msol)].';
        Hdiff = [Hsol(1); diff(Hsol)].';
%         Ddiff = [Dsol(1); diff(Dsol)].';
%         Rdiff = [Rsol(1); diff(Rsol)].';
        incidAll = [Mdiff.' Hdiff.'];
        outputIncid{g, j} = incidAll;

        for i = 1:8
            paramset(i + 13) = sol(end, i);
        end
        paramset(19) = Mdiff(end);
        paramset(20) = Hdiff(end);
%         paramset(21) = Ddiff(end);
%         paramset(18) = Rdiff(end);
        pop = sol(end, 1) + sol(end, 2) + sol(end, 3) ...
                + sol(end, 4) + sol(end, 5);

        outputFCInits(g, :) = paramset(14:21);

        RepNo = PERepNo(paramset);
        RepNoT = RepNo*paramset(14)/areaPop;
        outputRepNo(g, j) = RepNoT;


        % Residuals
        residM = Mdiff - dataDivM.';
        residH = Hdiff - dataDivH.';
        outputResid{g, 1, j} = residM;
        outputResid{g, 2, j} = residH;

        SSEm  = sum((Mdiff - dataDivM.').^2);
        RMSEm = sqrt(mean((Mdiff - dataDivM.').^2)); %root-mean-squared error
        MAEm  = mean(abs(Mdiff - dataDivM.')); %mean absolute error
        MAPEm = mean(abs((Mdiff - dataDivM.')./dataDivM.')); %mean absolute percentage error
        SSEh  = sum((Hdiff - dataDivH.').^2);
        RMSEh = sqrt(mean((Hdiff - dataDivH.').^2)); %root-mean-squared error
        MAEh  = mean(abs(Hdiff - dataDivH.')); %mean absolute error
        MAPEh = mean(abs((Hdiff - dataDivH.')./dataDivH.')); %mean absolute percentage error

        resultsArray = [SSEm, SSEh, ...
                        RMSEm, RMSEh, ...
                        MAEm, MAEh, ...
                        MAPEm, MAPEh];
        metricsArray = [exitflag, fval, ...
                        output.funcCount, output.iterations];
        outputRes(g, :, j) = resultsArray;
        outputMet(g, :, j) = metricsArray;

        modSelectArray = PEModelSelect(dataDivM, dataDivH, ...
                                                param2est, SSEm, SSEh);
        outputModSelect(g, :, j) = modSelectArray;
    end
    paramset = paramsetReset;
    pop = popReset;
end
disp('End of parameter bootstrapping.')
toc;


outputFCIncid = cell(BSsamples, lenDateCuts + 3);
outputFCCurves = cell(BSsamples, lenDateCuts + 3);
outputFCPSet = zeros(BSsamples, 21, lenDateCuts + 3);
outputFCRepNo = zeros(BSsamples, lenDateCuts + 3);

outputFCIncid(:, 1:lenDateCuts) = outputIncid;
outputFCCurves(:, 1:lenDateCuts) = outputCurves;
outputFCPSet(:, :, 1:lenDateCuts) = outputPSet;
outputFCRepNo(:, 1:lenDateCuts) = outputRepNo;

for i = 1:lenDateCuts
    betaS(i) = plims(outputP1(:,1 , i), 0.5);
end

betaS = [betaSS betaS];
betaMedian = median(betaS, 'all');
betaAve = mean(betaS, 'all');
betaLast = outputP1(:, 1, lenDateCuts);
betaMid = plims(betaLast, 0.5);
beta4FC = [betaMedian betaMid betaAve];

j = lenDateCuts;
tFCPeriod = (tPeriods{j}(end) + 1):(tPeriods{j}(end) + days2FC);
for k = 1:3
    disp(k);
    for g = 1:BSsamples
        paramset = outputPSet(g, :, j);
        paramset(1) = beta4FC(k);
        paramset(14:21) = outputFCInits(g, :);
        outputFCPSet(g, :, j + k) = paramset;
    
        initCmpts = paramset(14:21);
        % Solving the ODE again using the parameter estimates and adjustments
        odeOptions = odeset('Reltol', 1e-6, 'Abstol', 1e-6);
        [~, sol] = ode15s(@BaselineModel, tFCPeriod, initCmpts, ...
            odeOptions, paramset);
        outputFCCurves{g, j + k} = sol;
    
        Msol = sol(:, 6);
        Hsol = sol(:, 7);
    %         Dsol = sol(:, 8);
    %         Rsol = sol(:, 5);
    
        Mdiff = [Msol(1); diff(Msol)].';
        Hdiff = [Hsol(1); diff(Hsol)].';
    %         Ddiff = [Dsol(1); diff(Dsol)].';
    %         Rdiff = [Rsol(1); diff(Rsol)].';
        incidAll = [Mdiff.' Hdiff.'];
        outputFCIncid{g, j + k} = incidAll;
    
        for i = 1:8
            paramset(i + 13) = sol(end, i);
        end
        paramset(19) = Mdiff(end);
        paramset(20) = Hdiff(end);
    %         paramset(21) = Ddiff(end);
    %         paramset(18) = Rdiff(end);
%         pop = sol(end, 1) + sol(end, 2) + sol(end, 3) ...
%                 + sol(end, 4) + sol(end, 5);
    
        RepNo = PERepNo(paramset);
        outputFCRepNo(g, j + k) = RepNo;

    end
end


% Exporting data determined
if isempty(HDCMName)
    BSNameResults = append('Result_BS_',RPCName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary,'_',inputCityData);
else
    BSNameResults = append('Result_BS_',RPCName,'_',HDCMName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary,'_',inputCityData);
end

% Exporting data determined
if isempty(HDCMName)
    FCNameResults = append('Result_FC_',RPCName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary,'_',inputCityData);
else
    FCNameResults = append('Result_FC_',RPCName,'_',HDCMName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary,'_',inputCityData);
end

disp('File name of results:');
disp(BSNameResults);
disp('=====================');

simsDir = 'bs_results';
cd(simsDir);
save(append(BSNameResults, '.mat'), ...
    'tPeriods', 'timeVect', 'inputData', 'inputEst', 'inputP0', ...
    'outputCurves', 'outputData', 'outputIncid', 'outputPSet', ...
    'outputP1', 'outputRes', 'outputMet', ...
    'outputModSelect', 'outputRepNo', 'outputResid', ...
    'outputFCIncid', 'outputFCCurves', 'outputFCPSet', ...
    'outputFCRepNo','betaS', 'betaLast','betaMid',...
    'betaMedian', 'betaAve', 'dataRtMed','dataRtMedQ');
cd(currDir);

BSPlots(tPeriods, timeVect, dataDate, inputData, inputEst, ...
    outputCurves, outputData, outputIncid, outputP1, outputRepNo, ...
    areaPop, BSsamples, dateCQStr, days2test, BSNameResults, RPCName, HDCMName, outputSummary, dataRtLow, dataRtMed, dataRtHigh, dataRtMedQ)


FCPlots(tPeriods, timeVect, dataDate, inputData, inputEst, ...
    minG, areaPop, BSsamples, days2FC, outputFCIncid, outputFCCurves, ...
    outputFCRepNo, beta4FC, days2test, dataMonitFC, dataHospFC, ...
    dataMonitMAFC, dataHospMAFC, FCNameResults, RPCName, HDCMName, outputSummary)

end