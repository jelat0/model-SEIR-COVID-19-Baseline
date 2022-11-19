function LHSNameResults = ParameterEstimation(inputCityData, inputCityParams, RPCName, HDCMName, ...
    areaPop, dateCuts, outputSummary, param2est, data2use, LHSsamples, days2test, E0, Im0, Ih0, M0, H0, R0, CSM0, CSH0)
tic;

maData = true;
maDays = 7;

popFactor = 1;

E0 = 100 * (areaPop/1816987);

%% i) Training data

currDir = cd; % Access data in the 'data' folder
cd('data');
dataDiv = load(inputCityData);
paramsetFromFile = load(inputCityParams);
paramsetParams = paramsetFromFile.pset;
cd(currDir)

% Start and end of preferred whole period
startDate = find(dataDiv.dataDate == datetime(dateCuts{1}, 'Format', 'MM/dd/yyyy'));
endDate = find(dataDiv.dataDate == datetime(dateCuts{end}, 'Format', 'MM/dd/yyyy'));

dataDate = dataDiv.dataDate;
dataMonit = double(dataDiv.dataMonit(startDate:endDate));
dataHosp = double(dataDiv.dataHosp(startDate:endDate));
dataDeath = double(dataDiv.dataDeath(startDate:endDate));
dataRecov = double(dataDiv.dataRecov(startDate:endDate));

dataMonitMA = movmean(dataMonit, maDays);
dataHospMA = movmean(dataHosp, maDays);
dataDeathMA = movmean(dataDeath, maDays);
dataRecovMA = movmean(dataRecov, maDays);

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

dependDir = 'dependencies';
cd(dependDir)
LHSmatrix = Model_LHS(LB, UB, LHSsamples, 'unif', 1e20); % LHS call function
cd(currDir)

lenDateCuts = length(dateCuts) - 1;

% Pre-allocation of cells/matrices
inputData = [dataMonit dataHosp dataDeath dataRecov]; 
inputEst = [data2EstM data2EstH data2EstD data2EstR]; 
inputP0 = LHSmatrix;

outputIncid = cell(LHSsamples, lenDateCuts);
outputCurves = cell(LHSsamples, lenDateCuts);
outputPSet = zeros(LHSsamples, 21, lenDateCuts);
outputP1 = zeros(LHSsamples, length(paramIdx), lenDateCuts);
outputRes = zeros(LHSsamples, 2 * 4, lenDateCuts);
outputMet = zeros(LHSsamples, 4, lenDateCuts);
outputRepNo = zeros(LHSsamples, lenDateCuts);
outputResid = cell(LHSsamples, length(data2use), lenDateCuts);
outputModSelect = zeros(LHSsamples, 8, lenDateCuts);

popReset = pop;

SSELHS = zeros(1, LHSsamples);

disp('Start of parameter estimation.')

for g = 1:LHSsamples
    p0 = LHSmatrix(g,:);

    options = optimoptions('lsqcurvefit', ...
                            'Algorithm', 'trust-region-reflective', ...
                            'MaxFunctionEvaluations', 1e4*length(p0), ...
                            'MaxIterations', 1e4*length(p0), ...
                            'FunctionTolerance', 1e-10, ...
                            'OptimalityTolerance', 1e-10, ...
                            'StepTolerance', 1e-10, ...
                            'Display', 'none');
    SSEg = 0;
    disp(append('   LHS: ', string(g), ' out of ', string(LHSsamples)));
    for j = 1:lenDateCuts
        paramset(1:13) = paramsetParams(:, j);
        k = 1;
        for l = 1:length(p0)
            paramset(paramIdx(k)) = p0(l);
            k = k+1;
        end

        % Daily data
        dataDivM = data2EstM(tPeriods{j}+1);
        dataDivH = data2EstH(tPeriods{j}+1);
%         dataDivD = data2EstD(tPeriods{j}+1);
%         dataDivR = data2EstR(tPeriods{j}+1);

        data4Est = zeros(length(tPeriods{j}), length(data2use));
        for i = 1:length(data2use)
            data4Est(:, i) = eval(append('dataDiv', data2use{i}));
        end

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
%      display(paramset)
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
%         paramset(15) = 20 * (sum(dataDivM(end-maDays+1:end)) ...
%                         + sum(dataDivH(end-maDays+1:end)));
        paramset(19) = Mdiff(end);
        paramset(20) = Hdiff(end);
%         paramset(21) = Ddiff(end);
%         paramset(18) = Rdiff(end);
%         pop = sol(end, 1) + sol(end, 2) + sol(end, 3) ...
%                 + sol(end, 4) + sol(end, 5);
        pop = pop - sol(end, 8);


        RepNo = PERepNo(paramset);
        outputRepNo(g, j) = RepNo;


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

        SSEg = SSEg + SSEm + SSEh;

        modSelectArray = PEModelSelect(dataDivM, dataDivH, ...
                                                param2est, SSEm, SSEh);
        outputModSelect(g, :, j) = modSelectArray;
    end
    SSELHS(g) = SSEg;
    paramset = paramsetReset;
    pop = popReset;
end
disp('End of parameter estimation.')
toc;

[~, minG] = min(SSELHS);

% Exporting data determined
if isempty(HDCMName)
    LHSNameResults = append('Result_LHS_',RPCName,'_',string(LHSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary,'_',inputCityData);
else
    LHSNameResults = append('Result_LHS_',RPCName,'_',HDCMName,'_',string(LHSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary,'_',inputCityData);
end

disp('File name of results:');
disp(LHSNameResults);
disp('=====================');

simsDir = 'lhs_results';
cd(simsDir);
save(append(LHSNameResults, '.mat'), ...
    'tPeriods', 'timeVect', 'inputData', 'inputEst', 'inputP0', ...
    'outputCurves', 'outputIncid', 'outputPSet', 'outputP1', 'outputRes', 'outputMet', ...
    'outputModSelect', 'outputRepNo', 'outputResid');
cd(currDir);

PEPlots(tPeriods, timeVect, dataDate, inputData, inputEst, ...
    outputCurves, outputIncid, outputRepNo, minG, areaPop, LHSNameResults, ...
    days2test, CSM0, CSH0)

end