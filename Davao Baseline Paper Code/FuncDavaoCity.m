
% @ Loreniel Anonuevo
% Last modification: Nov 18, 2022 (by Loreniel Anonuevo)
% CODE FOR PARAMETER ESTIMATION, BOOTSTRAPPING, AND FORECASTING


clear
clc
close all

LHSsamples = 10000;
BSsamples = 10000;

%Output summary detailing the run, an appendix to naming LHS and BS files
outputSummary = ['Ran16Nov'];

% Case information XLSX file inside FOR EACH REGION\data

inputCaseInfo11 = 'DAVAOREGION (16).xlsx';
inputStatRt = 'StatRt.xlsx';
tic;
disp('STARTING DAVAO CITY')

% Parameters to be estimated
param2est = {'beta', 'r'};
% Data to be used (default is monitored and hospitalized cases)
data2use = {'M', 'H'}; 
% Number of days to be tested (meaning, last day of training is last day of
% onset minus days2test
days2test = 0;
% Number of days to forecast (this already includes days2test)
days2FC = 90;

% Area names for parameter estimation, bootstrapping, and forecasting
% For RPCName, you can consider the following
%   "DAVAO REGION" for region-level;
%   "DAVAO DE ORO", "DAVAO DEL NORTE", "DAVAO DEL SUR",
%   "DAVAO OCCIDENTAL", or "DAVAO ORIENTAL" for province-level; or
%   "DAVAO CITY" or "IGACOS" for HUC or island-level.
% For MDName, you can place in the following
%   the municipality or city given a specific province you inputted; or
%   the health district if you inputted "DAVAO CITY" in RPCName; or
%   blank ("") if you want to consider province or region-level only
% For muniOrDist, place "muni" if MDName is a municipality or city,
% place "dist" if a Davao City district, or "" if province or region-level.
RPCName = 'DAVAO CITY';
HDCMName = '';

areaPop = 1816987;

% Date cuts for each CQ or arbitrary cut to be considered
dateCuts = {'03/08/2020', ... % START
            '05/15/2020', ... % MECQ
            '06/30/2020', ... % GCQ 
            '11/19/2020', ... % Start of vaccination (GCQ)
            '03/05/2021'};    % Omicron uptick & AL2, Jan 15-31 AL3
% Name of each date cut
dateCQStr = {'ECQ', 'GCQ', 'MGCQ', 'GCQ'};

% Did you make changes to above conditions?
% true - reruns data file and parameter file
changes2Conds = true;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
betaSS = [];
%input the initial values by January 2022
E0 = 100;
Im0 = 1;
Ih0 = 0;
M0 = 1;
H0 = 0;
R0 = 0;
CSM0 = 1; %cumsum of Monitored cases as of Dec 31 2021
CSH0 = 0; %cumsum of Hospitalized cases as of Dec 31 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Names of data and parameter files based on case information file name
inputCityData = append('Data_',RPCName,'_',HDCMName,'_',...
                    erase(inputCaseInfo11, '.xlsx'), '.mat');
inputCityParams = append('Params_',RPCName,'_',HDCMName,'_',...
                    erase(inputCaseInfo11, '.xlsx'), '.mat');

% Processing data file
% If-condition checks if you have already processed the data file so that
% you don't have to run it again to save time
currDir = cd;
cd('data');
if ~isfile(inputCityData) || changes2Conds == true
    disp('Processing data file from XLSX file.')
    dataXLStoMAT11(inputCaseInfo11, RPCName, HDCMName, inputCityData, ...
        dateCuts, days2test, inputStatRt);
else
    disp('Data file from XLSX file already present.')
end
disp('Data file done.')
disp('=====================');


% Processing parameter file
% Same with data file, if-condition checks if the parameter file is already
% present
if ~isfile(inputCityParams) || changes2Conds == true
    disp('Processing parameter file from XLSX file.')
    cd(currDir)
    PEParams11(inputCaseInfo11, RPCName, HDCMName, ...
            dateCuts, inputCityParams, areaPop);
else
    disp('Parameter file from XLSX file already present.')
end
disp('Parameter file done.')
disp('=====================');
cd(currDir)



% Parameter estimation with Latin hypercube sampling
LHSNameResults = ParameterEstimation(inputCityData, inputCityParams, RPCName, HDCMName, ...
    areaPop, dateCuts, outputSummary, param2est, data2use, LHSsamples, days2test, E0, Im0, Ih0, M0, H0, R0, CSM0, CSH0);

% Parameter bootstrapping with short-term forecasting
Bootstrapping(LHSNameResults, inputCityData, inputCityParams, RPCName, HDCMName, ...
    areaPop, dateCuts, outputSummary, param2est, data2use, BSsamples, ...
    dateCQStr, days2FC, days2test, betaSS, E0, Im0, Ih0, M0, H0, R0, CSM0, CSH0);
