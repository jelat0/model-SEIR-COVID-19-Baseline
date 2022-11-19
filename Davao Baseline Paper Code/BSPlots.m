function BSPlots(tPeriods, timeVect, dataDate, inputData, inputEst, ...
    outputCurves, outputData, outputIncid, outputP1, ...
    outputRepNo, cityPop, BSsamples, dateCQStr, days2test, BSNameResults, RPCName, HDCMName, outputSummary,  dataRtLow, dataRtMed, dataRtHigh, dataRtMedQ)

currDir = cd;
figsDir = 'bs_figs';
cd(figsDir)
if ~exist(BSNameResults, 'dir')
   mkdir(BSNameResults)
end
cd(BSNameResults)

color_model = 1/255*[30,144,255];
color_monit = 1/255*[255,160,122];
color_monitra = 1/255*[255,127,80];
color_hosp = 1/255*[255,69,0]';
color_hospra = 1/255*[255,0,0];
% color_recov = 1/255*[144,238,144];
% color_rmod = 1/255*[0,100,0];
color_S = 1/255*[255,218,185];
color_E = 1/255*[218,165,32];
color_M = 1/255*[255,160,122];
color_H = 1/255*[255,69,0];
color_R = 1/255*[144,238,144];
color_death = 1/255*[112,128,144];
% color_dmod = 1/255*[47,79,79];
color_boot = 1/255*[75,0,130];

startMo = dateshift(dataDate(1), 'start', 'month');
endMo = dateshift(dataDate(end-days2test), 'start', 'month');
if startMo < dataDate(1)
    startMo = startMo + calmonths(1);
    duraMo = split(between(startMo, endMo, 'months'), 'months');
    dateXLabels = sort([startMo + calmonths(0:1:duraMo)]);
    dateX = datefind(dateXLabels, dataDate);
    xDate = datestr(dateXLabels, 'mmm yyyy');
else
    duraMo = split(between(startMo, endMo, 'months'), 'months');
    dateXLabels = sort([startMo + calmonths(0:1:duraMo)]);
    dateX = datefind(dateXLabels, dataDate);
    xDate = datestr(dateXLabels, 'mmm yyyy');
end

MDAll = zeros(BSsamples, length(timeVect));
HDAll = zeros(BSsamples, length(timeVect));
MAll = zeros(BSsamples, length(timeVect));
HAll = zeros(BSsamples, length(timeVect));
SAll = zeros(BSsamples, length(timeVect));
EAll = zeros(BSsamples, length(timeVect));
IhAll = zeros(BSsamples, length(timeVect));
ImAll = zeros(BSsamples, length(timeVect));
RAll = zeros(BSsamples, length(timeVect));
DAll = zeros(BSsamples, length(timeVect));
R0All = zeros(BSsamples, length(timeVect));
for g = 1:BSsamples
    for i = 1:length(tPeriods)
        MAll(g, tPeriods{i} + 1) = outputIncid{g, i}(:, 1);
        HAll(g, tPeriods{i} + 1) = outputIncid{g, i}(:, 2);
        MDAll(g, tPeriods{i} + 1) = outputData{g, i}(:, 1);
        HDAll(g, tPeriods{i} + 1) = outputData{g, i}(:, 2);

        SAll(g, tPeriods{i} + 1) = outputCurves{g, i}(:, 1);
        EAll(g, tPeriods{i} + 1) = outputCurves{g, i}(:, 2);
        IhAll(g, tPeriods{i} + 1) = outputCurves{g, i}(:, 4);
        ImAll(g, tPeriods{i} + 1) = outputCurves{g, i}(:, 3);
        RAll(g, tPeriods{i} + 1) = outputCurves{g, i}(:, 5);
        DAll(g, tPeriods{i} + 1) = outputCurves{g, i}(:, 8);

        Ssol = outputCurves{g, i}(:, 1);
        Nsol = cityPop - outputCurves{g, i}(:, 8);
        R0All(g, tPeriods{i} + 1) = outputRepNo(g, i) .* (Ssol ./ Nsol);
    end
end


% Daily data vs fit
figure(5)
tiledlayout(2, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
bar(timeVect, inputData(:, 1), 'FaceColor', color_monit, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, inputEst(:, 1), 'color', color_monitra, 'LineWidth', 4);
hold on

cd(currDir)
MMed = plims(MAll, 0.5);
MUp = plims(MAll, 0.975);
MLow = plims(MAll, 0.025);
cd(figsDir)
cd(BSNameResults)

casesFit = plot(timeVect, MMed, '-', 'Color', color_model, ...
    'LineWidth', 2);
hold on

fillX = [timeVect, fliplr(timeVect)];
fillY = [MLow, fliplr(MUp)];
h = fill(fillX, fillY, color_model, 'linestyle', 'none');
set(h,'facealpha', .5)
hold on

tPStart = zeros(1, length(tPeriods));
for i = 1:length(tPeriods)
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    tPStart(i) = tPeriods{i}(1);
    hold on
end

ylabel('new monitored cases', 'FontSize', 18)
set(gca, 'XTick', tPStart, ...
         'XTickLabel', dateCQStr, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

nexttile;
bar(timeVect, cumsum(inputData(:, 1)), 'FaceColor', color_monit, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, cumsum(inputEst(:, 1)), 'color', color_monitra, 'LineWidth', 4);
hold on

cd(currDir)
MMed = plims(cumsum(MAll, 2), 0.5);
MUp = plims(cumsum(MAll, 2), 0.975);
MLow = plims(cumsum(MAll, 2), 0.025);
cd(figsDir)
cd(BSNameResults)

casesFit = plot(timeVect, MMed, '-', 'Color', color_model, ...
    'LineWidth', 2);
hold on

fillX = [timeVect, fliplr(timeVect)];
fillY = [MLow, fliplr(MUp)];
h = fill(fillX, fillY, color_model, 'linestyle', 'none');
set(h,'facealpha', .5)
hold on

tPStart = zeros(1, length(tPeriods));
for i = 1:length(tPeriods)
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    tPStart(i) = tPeriods{i}(1);
    hold on
end
legend
ylabel('cumulative monitored cases', 'FontSize', 18)
set(gca, 'XTick', tPStart, ...
         'XTickLabel', dateCQStr, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

nexttile;
bar(timeVect, inputData(:, 2), 'FaceColor', color_hosp, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, inputEst(:, 2), 'color', color_hospra, 'LineWidth', 4);
hold on

cd(currDir)
HMed = plims(HAll, 0.5);
HUp = plims(HAll, 0.975);
HLow = plims(HAll, 0.025);
cd(figsDir)
cd(BSNameResults)

casesFit = plot(timeVect, HMed, '-', 'Color', color_model, ...
    'LineWidth', 2);
hold on

fillX = [timeVect, fliplr(timeVect)];
fillY = [HLow, fliplr(HUp)];
h = fill(fillX, fillY, color_model, 'linestyle', 'none');
set(h,'facealpha', .5)
hold on

tPStart = zeros(1, length(tPeriods));
for i = 1:length(tPeriods)
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    tPStart(i) = tPeriods{i}(1);
    hold on
end

ylabel('new hospitalized cases', 'FontSize', 18)
xlabel('dates', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

% saveas(gcf, 'BSDaily.fig')
% exportgraphics(gcf, 'BSDaily.png', 'Resolution', 300)



% Cumulative data vs fit
% figure(6)
% tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');



nexttile;
bar(timeVect, cumsum(inputData(:, 2)), 'FaceColor', color_hosp, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, cumsum(inputEst(:, 2)), 'color', color_hospra, 'LineWidth', 4);
hold on

cd(currDir)
HMed = plims(cumsum(HAll, 2), 0.5);
HUp = plims(cumsum(HAll, 2), 0.975);
HLow = plims(cumsum(HAll, 2), 0.025);
cd(figsDir)
cd(BSNameResults)

casesFit = plot(timeVect, HMed, '-', 'Color', color_model, ...
    'LineWidth', 2);
hold on

fillX = [timeVect, fliplr(timeVect)];
fillY = [HLow, fliplr(HUp)];
h = fill(fillX, fillY, color_model, 'linestyle', 'none');
set(h,'facealpha', .5)
hold on

for i = 1:length(tPeriods)
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    hold on
end

ylabel('cumulative hospitalized cases', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)
legend
saveas(gcf, 'BSCumulativeAll.fig')
exportgraphics(gcf, 'BSCumulativeAll.png', 'Resolution', 300)

% Cumulative data vs fit
figure(6)

tiledlayout(5, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
cmpts = {'S', 'E', 'M', 'H', 'R'};
cmpts1 = {'S', 'E', 'Im', 'Ih', 'R'};
compartments = {'susceptible', 'exposed', 'monitored', ...
            'hospitalized', 'recovered'};

for j = 1:length(cmpts)
    nexttile;

    cd(currDir)
    XMed = plims(eval(append(cmpts1{j}, 'All')), 0.5);
    XUp = plims(eval(append(cmpts1{j}, 'All')), 0.975);
    XLow = plims(eval(append(cmpts1{j}, 'All')), 0.025);
    cd(figsDir)
    cd(BSNameResults)

    casesFit = plot(timeVect, XMed, '-', 'Color', eval(append('color_', cmpts{j})), ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [XLow, fliplr(XUp)];
    h = fill(fillX, fillY, eval(append('color_', cmpts{j})), 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    for i = 1:length(tPeriods)
        xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end

    ylabel(compartments{j}, 'FontSize', 18)
    xlim([0 tPeriods{i}(end)])
    set(gca, 'FontSize', 15)
    set(gca, 'XTick', [])
end
xlabel('dates', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

saveas(gcf, 'BSCompartments.fig')
exportgraphics(gcf, 'BSCompartments.png', 'Resolution', 300)


% tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
% 
% nexttile;
% bar(timeVect, cumsum(inputData(:, 1)), 'FaceColor', color_monit, ...
%     'EdgeColor', 'none')
% hold on
% plot(timeVect, cumsum(inputEst(:, 1)), 'color', color_monitra, 'LineWidth', 4);
% hold on
% 
% cd(currDir)
% MMed = plims(cumsum(MAll, 2), 0.5);
% MUp = plims(cumsum(MAll, 2), 0.975);
% MLow = plims(cumsum(MAll, 2), 0.025);
% cd(figsDir)
% cd(BSNameResults)
% 
% casesFit = plot(timeVect, MMed, '-', 'Color', color_model, ...
%     'LineWidth', 2);
% hold on
% 
% fillX = [timeVect, fliplr(timeVect)];
% fillY = [MLow, fliplr(MUp)];
% h = fill(fillX, fillY, color_model, 'linestyle', 'none');
% set(h,'facealpha', .5)
% hold on
% 
% tPStart = zeros(1, length(tPeriods));
% for i = 1:length(tPeriods)
%     xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
%         'LineWidth', 2)
%     tPStart(i) = tPeriods{i}(1);
%     hold on
% end
% 
% ylabel('cumulative monitored cases', 'FontSize', 18)
% set(gca, 'XTick', tPStart, ...
%          'XTickLabel', dateCQStr, ...
%          'XTickLabelRotation', 45)
% set(gca, 'FontSize', 15)
% 
% nexttile;
% bar(timeVect, cumsum(inputData(:, 2)), 'FaceColor', color_hosp, ...
%     'EdgeColor', 'none')
% hold on
% plot(timeVect, cumsum(inputEst(:, 2)), 'color', color_hospra, 'LineWidth', 4);
% hold on
% 
% cd(currDir)
% HMed = plims(cumsum(HAll, 2), 0.5);
% HUp = plims(cumsum(HAll, 2), 0.975);
% HLow = plims(cumsum(HAll, 2), 0.025);
% cd(figsDir)
% cd(BSNameResults)
% 
% casesFit = plot(timeVect, HMed, '-', 'Color', color_model, ...
%     'LineWidth', 2);
% hold on
% 
% fillX = [timeVect, fliplr(timeVect)];
% fillY = [HLow, fliplr(HUp)];
% h = fill(fillX, fillY, color_model, 'linestyle', 'none');
% set(h,'facealpha', .5)
% hold on
% 
% for i = 1:length(tPeriods)
%     xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
%         'LineWidth', 2)
%     hold on
% end
% 
% ylabel('cumulative hospitalized cases', 'FontSize', 18)
% set(gca, 'XTick', dateX - 1, ...
%          'XTickLabel', xDate, ...
%          'XTickLabelRotation', 45)
% set(gca, 'FontSize', 15)
% legend
% saveas(gcf, 'BSCumulative.fig')
% exportgraphics(gcf, 'BSCumulative.png', 'Resolution', 300)


% Compartments
% figure(7)

% Daily data vs fit
figure(7)
tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
bar(timeVect, inputData(:, 1), 'FaceColor', color_monit, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, inputEst(:, 1), 'color', color_monitra, 'LineWidth', 4);
hold on

cd(currDir)
MMed = plims(MAll, 0.5);
MUp = plims(MAll, 0.975);
MLow = plims(MAll, 0.025);
cd(figsDir)
cd(BSNameResults)

casesFit = plot(timeVect, MMed, '-', 'Color', color_model, ...
    'LineWidth', 2);
hold on

fillX = [timeVect, fliplr(timeVect)];
fillY = [MLow, fliplr(MUp)];
h = fill(fillX, fillY, color_model, 'linestyle', 'none');
set(h,'facealpha', .5)
hold on

tPStart = zeros(1, length(tPeriods));
for i = 1:length(tPeriods)
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    tPStart(i) = tPeriods{i}(1);
    hold on
end

ylabel('new monitored cases', 'FontSize', 18)
set(gca, 'XTick', tPStart, ...
         'XTickLabel', dateCQStr, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)


nexttile;
bar(timeVect, inputData(:, 2), 'FaceColor', color_hosp, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, inputEst(:, 2), 'color', color_hospra, 'LineWidth', 4);
hold on

cd(currDir)
HMed = plims(HAll, 0.5);
HUp = plims(HAll, 0.975);
HLow = plims(HAll, 0.025);
cd(figsDir)
cd(BSNameResults)

casesFit = plot(timeVect, HMed, '-', 'Color', color_model, ...
    'LineWidth', 2);
hold on

fillX = [timeVect, fliplr(timeVect)];
fillY = [HLow, fliplr(HUp)];
h = fill(fillX, fillY, color_model, 'linestyle', 'none');
set(h,'facealpha', .5)
hold on

tPStart = zeros(1, length(tPeriods));
for i = 1:length(tPeriods)
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    tPStart(i) = tPeriods{i}(1);
    hold on
end

ylabel('new hospitalized cases', 'FontSize', 18)
xlabel('dates', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

saveas(gcf, 'BSDaily2.fig')
exportgraphics(gcf, 'BSDaily2.png', 'Resolution', 300)


% tiledlayout(5, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
% cmpts = {'S', 'E', 'M', 'H', 'R'};
% cmpts1 = {'S', 'E', 'Im', 'Ih', 'R'};
% compartments = {'susceptible', 'exposed', 'monitored', ...
%             'hospitalized', 'recovered'};
% 
% for j = 1:length(cmpts)
%     nexttile;
% 
%     cd(currDir)
%     XMed = plims(eval(append(cmpts1{j}, 'All')), 0.5);
%     XUp = plims(eval(append(cmpts1{j}, 'All')), 0.975);
%     XLow = plims(eval(append(cmpts1{j}, 'All')), 0.025);
%     cd(figsDir)
%     cd(BSNameResults)
% 
%     casesFit = plot(timeVect, XMed, '-', 'Color', eval(append('color_', cmpts{j})), ...
%         'LineWidth', 2);
%     hold on
%     
%     fillX = [timeVect, fliplr(timeVect)];
%     fillY = [XLow, fliplr(XUp)];
%     h = fill(fillX, fillY, eval(append('color_', cmpts{j})), 'linestyle', 'none');
%     set(h,'facealpha', .5)
%     hold on
%     
%     for i = 1:length(tPeriods)
%         xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
%             'LineWidth', 2)
%         hold on
%     end
% 
%     ylabel(compartments{j}, 'FontSize', 18)
%     xlim([0 tPeriods{i}(end)])
%     set(gca, 'FontSize', 15)
%     set(gca, 'XTick', [])
% end
% xlabel('dates', 'FontSize', 18)
% set(gca, 'XTick', dateX - 1, ...
%          'XTickLabel', xDate, ...
%          'XTickLabelRotation', 45)
% set(gca, 'FontSize', 15)
% 
% saveas(gcf, 'BSCompartments.fig')
% exportgraphics(gcf, 'BSCompartments.png', 'Resolution', 300)



% Time-varying reproduction number
figure(8)
tiledlayout(1, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;

cd(currDir)
R0Med = plims(R0All, 0.5);
R0Up = plims(R0All, 0.975);
R0Low = plims(R0All, 0.025);


STDDailyRt = std(R0Med)/std(dataRtMed);
STDQRt = std(R0Med)/std(dataRtMedQ);
MADDailyRt = mad(R0Med)/mad(dataRtMed);
MADQRt = mad(R0Med)/mad(dataRtMedQ);

cd(figsDir)
cd(BSNameResults)

casesFit = plot(timeVect, R0Med, '-', 'Color', color_model, ...
    'LineWidth', 4);
% casesFit = plot(timeVect, R0Med, '-', 'Color', color_model, ...
%     'LineWidth', 2);
grid on
hold on

% plot(timeVect, dataRtLow, '-', 'Color', color_M, ...
%     'LineWidth', 2);
% 
% hold on
% 
% plot(timeVect, dataRtHigh, '-', 'Color', color_M, ...
%     'LineWidth', 2);

% hold on

plot(timeVect, dataRtMed, '-', 'Color', color_monitra, ...
    'LineWidth', 4);
% casesFit = plot(timeVect, R0Med, '-', 'Color', color_model, ...
%     'LineWidth', 2);
hold on

plot(timeVect, dataRtMedQ, '-', 'Color', color_hospra, ...
    'LineWidth', 4);
% casesFit = plot(timeVect, R0Med, '-', 'Color', color_model, ...
%     'LineWidth', 2);
hold on

R0BSCI(:, 1) = [R0Med];
R0BSCI(:, 2) = [R0Low];
R0BSCI(:, 3) = [R0Up];
fillX = [timeVect, fliplr(timeVect)];
fillY = [R0Low, fliplr(R0Up)];

disp(length(fillX))
disp(length(fillY));
h = fill(fillX, fillY, color_boot, 'linestyle', 'none');
set(h,'facealpha', .5)
hold on
dataRtL = dataRtLow.';
dataRtH = dataRtHigh.';

fillRX = [timeVect, fliplr(timeVect)];
fillRY = [dataRtL, fliplr(dataRtH)];
disp(length(fillRX))
disp(length(fillRY));

rt = fill(fillRX, fillRY, color_M, 'linestyle', 'none');
set(rt,'facealpha', .5)
hold on



for i = 1:length(tPeriods)
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 4)
    hold on
end

ylabel('time-varying reproduction number', 'FontSize', 18)
xlim([0 tPeriods{i}(end)])

yline(1, 'color', color_death, ...
        'LineStyle', '-', 'LineWidth', 4);

xlabel('dates', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

saveas(gcf, 'BSRepNo.fig')
exportgraphics(gcf, 'BSRepNo.png', 'Resolution', 300)
for i=1:length(dataRtMedQ)
    diffRT(i) = dataRtMed(i)-dataRtMedQ(i);
end

% Histogram of estimates
figure(9)
tiledlayout(3, length(tPeriods), 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:2
    for j = 1:length(tPeriods)
        nexttile
        PE2H = outputP1(:, i, j);
    
        cd(currDir)
        PEMed = plims(PE2H, 0.5);
        PEUp = plims(PE2H, 0.975);
        PELow = plims(PE2H, 0.025);
% disp(i)
% disp(j)        
% display(PEMed)
% display(PEUp)
% display(PELow)
    if i==1
        betasCI(:, 3*j - 2) = [PEMed];
        betasCI(:, 3*j - 1) = [PELow];
        betasCI(:, 3*j) = [PEUp];
    else
        rCI(:, 3*j - 2) = [PEMed];
        rCI(:, 3*j - 1) = [PELow];
        rCI(:, 3*j) = [PEUp];
    end
        cd(figsDir)
        cd(BSNameResults)

        xline(PEMed, '-', 'Color', color_boot, ...
            'LineWidth', 2, ...
            'Label', {['mean:',num2str(round(PEMed, 2))];...
                        ['97.5% CI:']; ['[', num2str(round(PELow, 2)),'-', num2str(round(PEUp, 2)), ']']}, ...
            'LabelOrientation', 'horizontal');
        hold on
        
        fillX = [PELow, PELow, PEUp, PEUp];
        fillY = [0, 1000, 1000, 0];

        h = fill(fillX, fillY, color_boot, 'linestyle', 'none');
        set(h,'facealpha', 0.2)
        hold on

        histplot = histogram(PE2H, 'EdgeColor', 'white', ...
            'FaceColor', color_boot, 'NumBins', 10);
        ylim([0, max(histplot.Values) + mod(-max(histplot.Values), BSsamples)])
    
        if j == 1 && i == 1
            ylabel('\beta');
        elseif j == 1 && i == 2
            ylabel('r');
        end
        set(gca, 'FontSize', 15)
    end
end

%adding the Rt
for j = 1:length(tPeriods)
        nexttile
        R02H = outputRepNo(:,j);
    
        cd(currDir)
        R0Med = plims(R02H, 0.5);
        R0Up = plims(R02H, 0.975);
        R0Low = plims(R02H, 0.025);
        
        xline(R0Med, '-', 'Color', color_boot, ...
            'LineWidth', 4, ...
            'Label', {['mean:',num2str(round(R0Med, 2))];...
                        ['97.5% CI:'];['[', num2str(round(R0Low, 2)),'-', num2str(round(R0Up, 2)), ']']}, ...
            'LabelOrientation', 'horizontal');
        hold on
        
        fillX = [R0Low, R0Low, R0Up, R0Up];
        fillY = [0, 1000, 1000, 0];

        h = fill(fillX, fillY, color_boot, 'linestyle', 'none');
        set(h,'facealpha', 0.2)
        hold on

        histplot = histogram(R02H, 'EdgeColor', 'white', ...
            'FaceColor', color_boot, 'NumBins', 10);
        ylim([0, max(histplot.Values) + mod(-max(histplot.Values), BSsamples)])
        if j==1
        ylabel('\R_t');
        end
  end  
        set(gca, 'FontSize', 15)

        cd(figsDir)
        cd(BSNameResults)

saveas(gcf, 'BSHistEsts.fig')
exportgraphics(gcf, 'BSHistEsts.png', 'Resolution', 300)

if isempty(HDCMName)
    BS2NameResults = append('Result_BS2_',RPCName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary);
else
    BS2NameResults = append('Result_BS2_',RPCName,'_',HDCMName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary);
end

disp('File name of results:');
disp(BS2NameResults);
disp('=====================');
save(append(BS2NameResults, '.mat'), ...
    'betasCI', 'rCI', 'R0BSCI', 'R0All', 'diffRT', 'STDDailyRt','STDQRt', 'MADDailyRt', 'MADQRt');


cd(currDir)

end