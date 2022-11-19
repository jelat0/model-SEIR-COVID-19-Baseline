function PEPlots(tPeriods, timeVect, dataDate, inputData, inputEst, ...
    outputCurves, outputIncid, outputRepNo, minG, areaPop, LHSNameResults, ...
    days2test, CSM0, CSH0)

currDir = cd;
figsDir = 'lhs_figs';
cd(figsDir)
if ~exist(LHSNameResults, 'dir')
   mkdir(LHSNameResults)
end
cd(LHSNameResults)

g = minG;

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
color_H = 1/255*[255,69,0]';
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


% Daily data vs fit
figure(1)
tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
bar(timeVect, inputData(:, 1), 'FaceColor', color_monit, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, inputEst(:, 1), 'color', color_monitra, 'LineWidth', 4);
hold on

MdiffWhole = zeros(1, length(timeVect));
for i = 1:length(tPeriods)
    MdiffWhole(tPeriods{i} + 1) = outputIncid{g, i}(:, 1);
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    hold on
end
plot(timeVect, MdiffWhole, 'color', color_model, 'LineWidth', 4);
hold on

ylabel('new monitored cases', 'FontSize', 18)
xticks([])
set(gca, 'FontSize', 15)

nexttile;
bar(timeVect+1, inputData(:, 2), 'FaceColor', color_hosp, ...
    'EdgeColor', 'none')
hold on
plot(timeVect+1, inputEst(:, 2), 'color', color_hospra, 'LineWidth', 4);
hold on

HdiffWhole = zeros(1, length(timeVect));
for i = 1:length(tPeriods)
    HdiffWhole(tPeriods{i} + 1) = outputIncid{g, i}(:, 2);
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    hold on
end
plot(timeVect, HdiffWhole, 'color', color_model, 'LineWidth', 4);
hold on

ylabel('new hospitalized cases', 'FontSize', 18)
xlabel('dates', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

saveas(gcf, 'PEDaily.fig')
exportgraphics(gcf, 'PEDaily.png', 'Resolution', 300)
% exportgraphics(gcf, 'PEDaily.tiff', 'Resolution', 300)
% exportgraphics(gcf, 'PEDaily.pdf', 'Resolution', 300)



% Cumulative data vs fit
figure(2)
tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
bar(timeVect, CSM0 + cumsum(inputData(:, 1)), 'FaceColor', color_monit, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, CSM0 + cumsum(inputEst(:, 1)), 'color', color_monitra, 'LineWidth', 4);
hold on

MdiffWhole = zeros(1, length(timeVect));
for i = 1:length(tPeriods)
    MdiffWhole(tPeriods{i} + 1) = outputIncid{g, i}(:, 1);
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    hold on
end
plot(timeVect, CSM0 + cumsum(MdiffWhole), 'color', color_model, 'LineWidth', 4);
hold on

ylabel('cumulative monitored cases', 'FontSize', 18)
xticks([])
set(gca, 'FontSize', 15)

nexttile;
bar(timeVect, CSH0 + cumsum(inputData(:, 2)), 'FaceColor', color_hosp, ...
    'EdgeColor', 'none')
hold on
plot(timeVect, CSH0 + cumsum(inputEst(:, 2)), 'color', color_hospra, 'LineWidth', 4);
hold on

HdiffWhole = zeros(1, length(timeVect));
for i = 1:length(tPeriods)
    HdiffWhole(tPeriods{i} + 1) = outputIncid{g, i}(:, 2);
    xline(tPeriods{i}(1), 'color', color_death, 'LineStyle', '--', ...
        'LineWidth', 2)
    hold on
end
plot(timeVect, CSH0 + cumsum(HdiffWhole), 'color', color_model, 'LineWidth', 4);
hold on

ylabel('cumulative hospitalized cases', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

saveas(gcf, 'PECumulative.fig')
exportgraphics(gcf, 'PECumulative.png', 'Resolution', 300)



% Compartments
figure(3)
tiledlayout(5, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
cmpts = {'S', 'E', 'M', 'H', 'R'};
compartments = {'susceptible', 'exposed', 'monitored', ...
            'hospitalized', 'recovered'};

for j = 1:length(cmpts)
    nexttile;
    XdiffWhole = zeros(1, length(timeVect));
    for i = 1:length(tPeriods)
        Xsol = outputCurves{g, i}(:, j);    
        XdiffWhole(tPeriods{i} + 1) = Xsol;
        xline(tPeriods{i}(1), 'color', color_death, ...
            'LineStyle', '--', 'LineWidth', 2)
        hold on
    end
    plot(timeVect, XdiffWhole, ...
        'color', eval(append('color_', cmpts{j})), ...
        'LineWidth', 4);
    hold on
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

saveas(gcf, 'PECompartments.fig')
exportgraphics(gcf, 'PECompartments.png', 'Resolution', 300)


% Time-varying reproduction number
figure(4)
tiledlayout(1, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
RtdiffWhole = zeros(1, length(timeVect));
for i = 1:length(tPeriods)
    Ssol = outputCurves{g, i}(:, 1);
    Nsol = areaPop - outputCurves{g, i}(:, 8);
    RtdiffWhole(tPeriods{i} + 1) = outputRepNo(g, i) .* (Ssol ./ Nsol);
    xline(tPeriods{i}(1), 'color', color_death, ...
        'LineStyle', '--', 'LineWidth', 2)
    hold on
end
plot(timeVect, RtdiffWhole, ...
    'color', color_boot, ...
    'LineWidth', 4);
hold on
ylabel('time-varying reproduction number', 'FontSize', 18)
xlim([0 tPeriods{i}(end)])

yline(1, 'color', color_death, ...
        'LineStyle', '-', 'LineWidth', 4);

xlabel('dates', 'FontSize', 18)
set(gca, 'XTick', dateX - 1, ...
         'XTickLabel', xDate, ...
         'XTickLabelRotation', 45)
set(gca, 'FontSize', 15)

saveas(gcf, 'PERepNo.fig')
exportgraphics(gcf, 'PERepNo.png', 'Resolution', 300)

cd(currDir)

end