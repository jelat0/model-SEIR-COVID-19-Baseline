function dataXLStoMAT11(inputCaseInfo11, RPCName, HDCMName, ...
    inputCityData, dateCuts, days2test, inputStatRt)

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
%  'HDCM'
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

optsRt = detectImportOptions(inputStatRt);
optsRt.SelectedVariableNames = {'Date', ...
    'Quantile025', ...
    'Median', ...
    'Quantile975'};

R = readtable(inputStatRt, optsRt);


% Comparing start and end of date cuts with the first and last days of
% onset, respectively
uniqueOnset = unique(T.dateOnset);
startDate = datetime(dateCuts{1}, 'Format', 'MM/dd/yyyy');
endDate = datetime(dateCuts{end}, 'Format', 'MM/dd/yyyy') + days2test;

disp(startDate)
disp(uniqueOnset(1))
disp(endDate)
disp(uniqueOnset(end));
if startDate ~= uniqueOnset(1)
    error(append('Error. Change the start date of dateCuts to ', string(uniqueOnset(1)), ...
        ' to match with the first date of onset.'))
end
if endDate ~= uniqueOnset(end)
    error(append('Error. Change the end date of dateCuts to ', string(uniqueOnset(end - 7)), ...
        ' to match with the last date of onset.'))
end

% Tabulating the time-series data
dates = startDate:endDate;
dataDate = dates;
dataMonit = zeros(1, length(dates)).';
dataHosp = zeros(1, length(dates)).';
dataDeath = zeros(1, length(dates)).';
dataRecov = zeros(1, length(dates)).';
dataRtLow = R.Quantile025;
dataRtMed = R.Median;
dataRtHigh = R.Quantile975;

for i = 1:length(dates)
    dateidx = find(T.dateOnset == dates(i));

    dataHosp(i) = length(find(contains(T(dateidx, :).admitHealthStatus, 'SEVERE') | ...
       contains(T(dateidx, :).admitHealthStatus, 'CRITICAL')));

    dataMonit(i) = length(find(contains(T(dateidx, :).admitHealthStatus, 'MILD') | ...
       contains(T(dateidx, :).admitHealthStatus, 'ASYMPTOMATIC')|...
       contains(T(dateidx, :).admitHealthStatus, 'MODERATE')));

    dataDeath(i) = length(find(contains(T(dateidx, :).disposition, 'DIED')));

    dataRecov(i) = length(find(contains(T(dateidx, :).disposition, 'DISCHARGED')));
end

% And saving the file
save(inputCityData, 'dataDate', 'dataMonit', 'dataHosp', 'dataDeath', ...
    'dataRecov', 'dataRtLow', 'dataRtMed','dataRtHigh');

end