% INPUT Script for data per province

city = 'Davao City';
cityData = 'DavCityAug28.mat';
cityPop = 1816987;

dateCuts = {'03/08/2020', '05/15/2020', '06/30/2020', '11/19/2020', ...
            '12/31/2020', '03/05/2021', '06/05/2021', ...
            '07/05/2021', '08/01/2021', '08/21/2021'};

param2est = {'beta', 'r'};
data2use = {'Imcases', 'Ihcases'}; 

LHSsamples = 100;
bootsamples = 1000;

maData = true;
maDays = 3;


%% Preprocessing the inputs
% Boundary dates for each time period
for i = 1:length(dateCuts)
    dateCuts{i} = datenum(dateCuts{i});
end

% Time periods
datePeriods = cell(1, length(dateCuts)-1);
peridx = cell(1, length(dateCuts)-1);
for i = 1:length(dateCuts)-1
    datePeriods{i} = dateCuts{i}:1:dateCuts{i+1};
    peridx{i} = datePeriods{i} - (dateCuts{1} - 1);
end

