function FCPlots(tPeriods, timeVect, dataDate, inputData, inputEst, ...
    minG, areaPop, BSsamples, days2FC, outputFCIncid, outputFCCurves, ...
    outputFCRepNo, beta4FC, days2test, dataMonitFC, dataHospFC, ...
    dataMonitMAFC, dataHospMAFC, FCNameResults, RPCName, HDCMName, outputSummary)

currDir = cd;
figsDir = 'fc_figs';
cd(figsDir)
if ~exist(FCNameResults, 'dir')
   mkdir(FCNameResults)
end
cd(FCNameResults)

csFCM = cumsum(dataMonitFC);
csFCH = cumsum(dataHospFC);
g = minG;
timeVectFC = timeVect(end) + 1: timeVect(end) + days2FC;
xlimVals = [timeVect(end) - days2FC, timeVect(end) + days2FC];
xlimValsFC = [0, timeVect(end) + days2FC];
ylimValsM = [0, max(dataMonitFC(end-10:end))*3 + 1];
ylimValsH = [0, max(dataHospFC(end-10:end))*3 + 1];
ylimValsMA = [0, max(csFCM(end-10:end))*10 + 1];
ylimValsHA = [0, max(csFCH(end-10:end))*10 + 1];
% ylimValsRo = [0, max(outputFCRepNo(end-30:end))*10 + 1];

FCDate = dataDate(1):(dataDate(end) + days2FC);
FC7 = (dataDate(end) + 1):(dataDate(end) + days2FC);
FCtest = (dataDate(end) + 1):(dataDate(end) + days2test);

color_model = 1/255*[30,144,255];
color_monit = 1/255*[255,160,122];
color_monitra = 1/255*[255,127,80];
color_hosp = 1/255*[255,69,0]';
color_hospra = 1/255*[255,0,0];
color_recov = 1/255*[144,238,144];
color_rmod = 1/255*[0,100,0];
color_S = 1/255*[255,218,185];
color_E = 1/255*[218,165,32];
color_M = 1/255*[255,160,122];
color_H = 1/255*[255,69,0];
color_R = 1/255*[144,238,144];
color_death = 1/255*[112,128,144];
color_dmod = 1/255*[47,79,79];
color_boot = 1/255*[75,0,130];

startMo = dataDate(end - 15);
endMo = dataDate(end) + days(15);

dateXLabels = linspace(startMo, endMo, 5);
dateX = datefind(dateXLabels, FCDate);
xDate = datestr(dateXLabels, 'mmm dd');

startMoFC = dateshift(dataDate(1), 'start', 'month');
endMoFC = dateshift(dataDate(end-days2test), 'start', 'month');
if startMoFC < dataDate(1)
    startMoFC = startMoFC + calmonths(1);
    duraMoFC = split(between(startMoFC, endMoFC, 'months'), 'months');
    dateXLabelsFC = sort([startMoFC + calmonths(0:1:duraMoFC)]);
    dateXFC = datefind(dateXLabelsFC, dataDate);
    xDateFC = datestr(dateXLabelsFC, 'mmm yyyy');
else
    duraMoFC = split(between(startMoFC, endMoFC, 'months'), 'months');
    dateXLabelsFC = sort([startMoFC + calmonths(0:1:duraMoFC)]);
    dateXFC = datefind(dateXLabelsFC, dataDate);
    xDateFC = datestr(dateXLabelsFC, 'mmm yyyy');
end


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
    for i = 1:(length(tPeriods))
        MAll(g, tPeriods{i} + 1) = outputFCIncid{g, i}(:, 1);
        HAll(g, tPeriods{i} + 1) = outputFCIncid{g, i}(:, 2);

        SAll(g, tPeriods{i} + 1) = outputFCCurves{g, i}(:, 1);
        EAll(g, tPeriods{i} + 1) = outputFCCurves{g, i}(:, 2);
        IhAll(g, tPeriods{i} + 1) = outputFCCurves{g, i}(:, 4);
        ImAll(g, tPeriods{i} + 1) = outputFCCurves{g, i}(:, 3);
        RAll(g, tPeriods{i} + 1) = outputFCCurves{g, i}(:, 5);
        DAll(g, tPeriods{i} + 1) = outputFCCurves{g, i}(:, 8);

        Ssol = outputFCCurves{g, i}(:, 1);
        Nsol = areaPop - outputFCCurves{g, i}(:, 8);
        R0All(g, tPeriods{i} + 1) = outputFCRepNo(g, i) .* (Ssol ./ Nsol);
    end
end

j = length(tPeriods);

MAllFC = zeros(BSsamples, days2FC, 3);
HAllFC = zeros(BSsamples, days2FC, 3);
SAllFC = zeros(BSsamples, days2FC, 3);
EAllFC = zeros(BSsamples, days2FC, 3);
IhAllFC = zeros(BSsamples, days2FC, 3);
ImAllFC = zeros(BSsamples, days2FC, 3);
RAllFC = zeros(BSsamples, days2FC, 3);
DAllFC = zeros(BSsamples, days2FC, 3);
R0AllFC = zeros(BSsamples, days2FC, 3);
for g = 1:BSsamples
    for i = 1:3
        MAllFC(g, :, i) = outputFCIncid{g, j + i}(:, 1);
        HAllFC(g, :, i) = outputFCIncid{g, j + i}(:, 2);

        SAllFC(g, :, i) = outputFCCurves{g, j + i}(:, 1);
        EAllFC(g, :, i) = outputFCCurves{g, j + i}(:, 2);
        IhAllFC(g, :, i) = outputFCCurves{g, j + i}(:, 4);
        ImAllFC(g, :, i) = outputFCCurves{g, j + i}(:, 3);
        RAllFC(g, :, i) = outputFCCurves{g, j + i}(:, 5);
        DAllFC(g, :, i) = outputFCCurves{g, j + i}(:, 8);

        SsolFC = outputFCCurves{g, j + i}(:, 1);
        NsolFC = areaPop - outputFCCurves{g, j + i}(:, 8);
        R0AllFC(g, :, i) = outputFCRepNo(g, j + i) .* (SsolFC ./ NsolFC);
    end
end

NTV = [timeVect timeVect(end) + (1:days2test)];

% Daily data vs fit
figure(10)
tiledlayout(2, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:3
    nexttile;
    bar(timeVect, inputData(:, 1), 'FaceColor', color_monit, ...
        'EdgeColor', 'none')
    hold on
    semilogy(timeVect, inputEst(:, 1), 'color', color_monitra, 'LineWidth', 4);
%     plot(timeVect, inputEst(:, 1), 'color', color_monitra, 'LineWidth', 4);
   grid on
   hold on

    bar(timeVect(end) + (1:days2test), dataMonitFC(end-days2test+1:end), 'FaceColor', 'none', ...
        'EdgeColor', color_monit)
    hold on
     semilogy(timeVect(end) + (1:days2test), dataMonitMAFC(end-days2test+1:end), ...
         'color', color_monitra, 'LineWidth', 4, 'LineStyle', '--');
%     plot(timeVect(end) + (1:days2test), dataMonitMAFC(end-days2test+1:end), ...
%         'color', color_monitra, 'LineWidth', 4, 'LineStyle', '--');
    grid on
    hold on
    
    cd(currDir)
    MMed = plims(MAll, 0.5);
    MUp = plims(MAll, 0.75);
    MLow = plims(MAll, 0.25);
    cd(figsDir)
    cd(FCNameResults)   

    casesFit = semilogy(timeVect, MMed, '-', 'Color', color_model, ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [MLow, fliplr(MUp)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    cd(currDir)
    MMedFC = plims(MAllFC(:, :, i), 0.5);
    MUpFC = plims(MAllFC(:, :, i), 0.75);
    MLowFC = plims(MAllFC(:, :, i), 0.25);
    cd(figsDir)
    cd(FCNameResults)

    if i == 1
%         M4UIT(i) = [MMedFC; MLowFC; MUpFC];
        M4UIT(:, i) = [MMedFC];
        M4UIT(:, i + 1) = [MLowFC];
        M4UIT(:, i + 2) = [MUpFC];
    else
         M4UIT(:, 3*i - 2) = [MMedFC];
        M4UIT(:, 3*i - 1) = [MLowFC];
        M4UIT(:, 3*i) = [MUpFC];
    end

%     if i == 1
%         M4UITEST = [MMedFC; MLowFC; MUpFC; dataMonitFC(end-days2test+1:end)];
%     end


    casesFC = semilogy(timeVectFC, MMedFC, '-', 'Color', color_model, ...
    'LineWidth', 2, 'LineStyle', '--');
    hold on
    
    fillX = [timeVectFC, fliplr(timeVectFC)];
    fillY = [MLowFC, fliplr(MUpFC)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .25)
    hold on
    
    for l = 1:length(tPeriods)
        xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end
    xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
    'LineWidth', 2)
    
    if i == 1
        ylabel('new monitored cases', 'FontSize', 18)
    end
%     ylim(ylimValsM)
    xlim(xlimVals)
    xticks([])
    set(gca, 'FontSize', 15)

    title(append('\beta = ', num2str(beta4FC(i))));
end

for i = 1:3
    nexttile;
    bar(timeVect, inputData(:, 2), 'FaceColor', color_hosp, ...
        'EdgeColor', 'none')
    hold on
    semilogy(timeVect, inputEst(:, 2), 'color', color_hospra, 'LineWidth', 4);
    hold on
    
    bar(timeVect(end) + (1:days2test), dataHospFC(end-days2test+1:end), 'FaceColor', 'none', ...
        'EdgeColor', color_hosp)
    hold on
    semilogy(timeVect(end) + (1:days2test), dataHospMAFC(end-days2test+1:end), ...
        'color', color_hospra, 'LineWidth', 4, 'LineStyle', '--');
%     semilogy(timeVect(end) + (1:days2test), dataHospMAFC(end-days2test+1:end), ...
        %         'color', color_hospra, 'LineWidth', 4, 'LineStyle', '--');gr
    grid on
        hold on

    cd(currDir)
    HMed = plims(HAll, 0.5);
    HUp = plims(HAll, 0.75);
    HLow = plims(HAll, 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFit = semilogy(timeVect, HMed, '-', 'Color', color_model, ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [HLow, fliplr(HUp)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    cd(currDir)
    HMedFC = plims(HAllFC(:, :, i), 0.5);
    HUpFC = plims(HAllFC(:, :, i), 0.75);
    HLowFC = plims(HAllFC(:, :, i), 0.25);
    cd(figsDir)
    cd(FCNameResults)



         H4UIT(:, 3*i - 2) = [HMedFC];
        H4UIT(:, 3*i - 1) = [HLowFC];
        H4UIT(:, 3*i) = [HUpFC];


    casesFC = plot(timeVectFC, HMedFC, '-', 'Color', color_model, ...
    'LineWidth', 2, 'LineStyle', '--');
    hold on
    
    fillX = [timeVectFC, fliplr(timeVectFC)];
    fillY = [HLowFC, fliplr(HUpFC)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .25)
    hold on

    for l = 1:length(tPeriods)
        xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end
    xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
    'LineWidth', 2)

    if i == 1
        ylabel('new hospitalized cases', 'FontSize', 18)
    end
    if i == 2
        xlabel('dates', 'FontSize', 18)
    end

    set(gca, 'XTick', dateX - 1, ...
             'XTickLabel', xDate, ...
             'XTickLabelRotation', 45)
    set(gca, 'FontSize', 15)
%     ylim(ylimValsH)
    xlim(xlimVals)
end

saveas(gcf, 'FCDaily.fig')
exportgraphics(gcf, 'FCDaily.png', 'Resolution', 300)

% display(M4UIT);
% display(H4UIT);
% simsDir = 'bs_results';
% cd(simsDir);
% cd(currDir);
% save(append(BSNameResults, '.mat'), ...
%     'M4UIT', 'H4UIT');
cd(currDir);

% uifig = figure(11);
% uifig.Position = [500 500 1000 500];
% uit = uitable(uifig, 'Data', M4UIT(:, 1:days2FC).', ...
%                     'RowName', datestr(FC7), ...
%                     'ColumnName', {'Lowest', 'lower CI', 'upper CI', 'Median', 'lower CI', 'upper CI', 'Current', 'lower CI', 'upper CI', 'Average', 'lower CI', 'upper CI', 'Largest', 'lower CI', 'upper CI'});
% uit.Position = [20 30 360 160];
% 
% uifig = figure(12);
% uifig.Position = [500 500 420 220];
% uit = uitable(uifig, 'Data', H4UIT(:, 1:days2FC).', ...
%                     'RowName', datestr(FC7), ...
%                     'ColumnName', {'Lowest', 'lower CI', 'upper CI', 'Median', 'lower CI', 'upper CI', 'Current', 'lower CI', 'upper CI', 'Average', 'lower CI', 'upper CI', 'Largest', 'lower CI', 'upper CI'});
% uit.Position = [20 30 360 160];



% Cumulative data vs fit
figure(11)
tiledlayout(2, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:3
    nexttile;
    cs = cumsum(inputData(:, 1));
    bar(timeVect, cs, 'FaceColor', color_monit, ...
        'EdgeColor', 'none')
    hold on
    plot(timeVect, cumsum(inputEst(:, 1)), 'color', color_monitra, 'LineWidth', 4);
%         plot(timeVect, cumsum(inputEst(:, 1)), 'color', color_monitra, 'LineWidth', 4);
    grid on
    hold on
    
    csFC = cumsum(dataMonitFC);
    csMAFC = cumsum(dataMonitMAFC);
    bar(timeVect(end) + (1:days2test), csFC(end-days2test+1:end), 'FaceColor', 'none', ...
        'EdgeColor', color_monit)
    hold on
    semilogy(timeVect(end) + (1:days2test), csMAFC(end-days2test+1:end), ...
        'color', color_monitra, 'LineWidth', 4, 'LineStyle', '--');
    grid on
    hold on

    csM = cumsum(MAll, 2);
    cd(currDir)
    MMed = plims(csM, 0.5);
    MUp = plims(csM, 0.75);
    MLow = plims(csM, 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFit = semilogy(timeVect, MMed, '-', 'Color', color_model, ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [MLow, fliplr(MUp)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    cd(currDir)
    MMedFC = plims(csM(:, end) + cumsum(MAllFC(:, :, i), 2), 0.5);
    MUpFC = plims(csM(:, end) + cumsum(MAllFC(:, :, i), 2), 0.75);
    MLowFC = plims(csM(:, end) + cumsum(MAllFC(:, :, i), 2), 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFC = semilogy(timeVectFC, MMedFC, '-', 'Color', color_model, ...
    'LineWidth', 2, 'LineStyle', '--');
    hold on
    
    fillX = [timeVectFC, fliplr(timeVectFC)];
    fillY = [MLowFC, fliplr(MUpFC)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .25)
    hold on
    
    for l = 1:length(tPeriods)
        xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end
    xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
    'LineWidth', 2)
    
    if i == 1
        ylabel('new monitored cases', 'FontSize', 18)
    end
    xlim(xlimVals)
%     ylim([cs(xlimVals(1)), MUpFC(end) + 100])
%     ylim(ylimValsMA)
    xticks([])
    set(gca, 'FontSize', 15)

    title(append('\beta = ', num2str(beta4FC(i))));
end
%     ylim([cs(xlimVals(1)), MUpFC(end-2) + 100])

for i = 1:3
    nexttile;
    cs = cumsum(inputData(:, 2));
    bar(timeVect, cs, 'FaceColor', color_hosp, ...
        'EdgeColor', 'none')
    hold on
    semilogy(timeVect, cumsum(inputEst(:, 2)), 'color', color_hospra, 'LineWidth', 4);
    hold on
    
    csFC = cumsum(dataHospFC);
    csMAFC = cumsum(dataHospMAFC);
    bar(timeVect(end) + (1:days2test), csFC(end-days2test+1:end), 'FaceColor', 'none', ...
        'EdgeColor', color_hosp)
    hold on
    semilogy(timeVect(end) + (1:days2test), csMAFC(end-days2test+1:end), ...
        'color', color_hospra, 'LineWidth', 4, 'LineStyle', '--');
    hold on

    csH = cumsum(HAll, 2);
    cd(currDir)
    HMed = plims(csH, 0.5);
    HUp = plims(csH, 0.75);
    HLow = plims(csH, 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFit = semilogy(timeVect, HMed, '-', 'Color', color_model, ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [HLow, fliplr(HUp)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    cd(currDir)
    HMedFC = plims(csH(:, end) + cumsum(HAllFC(:, :, i), 2), 0.5);
    HUpFC = plims(csH(:, end) + cumsum(HAllFC(:, :, i), 2), 0.75);
    HLowFC = plims(csH(:, end) + cumsum(HAllFC(:, :, i), 2), 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFC = semilogy(timeVectFC, HMedFC, '-', 'Color', color_model, ...
    'LineWidth', 2, 'LineStyle', '--');
    hold on
    
    fillX = [timeVectFC, fliplr(timeVectFC)];
    fillY = [HLowFC, fliplr(HUpFC)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .25)
    hold on

    for l = 1:length(tPeriods)
        xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end
    xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
    'LineWidth', 2)

    if i == 1
        ylabel('new hospitalized cases', 'FontSize', 18)
    end
    if i == 2
        xlabel('dates', 'FontSize', 18)
    end

    set(gca, 'XTick', dateX - 1, ...
             'XTickLabel', xDate, ...
             'XTickLabelRotation', 45)
    set(gca, 'FontSize', 15)
    xlim(xlimVals)
%     ylim([cs(xlimVals(1)), HUpFC(end) + 100])
%     ylim(ylimValsHA)
end
%     ylim([cs(xlimVals(1)), HUpFC(end-2) + 100])
saveas(gcf, 'FCCumulative.fig')
exportgraphics(gcf, 'FCCumulative.png', 'Resolution', 300)



% Compartments
figure(12)
tiledlayout(5, 3, 'Padding', 'compact', 'TileSpacing', 'compact');
cmpts = {'S', 'E', 'M', 'H', 'R'};
cmpts1 = {'S', 'E', 'Im', 'Ih', 'R'};
compartments = {'susceptible', 'exposed', 'monitored', ...
            'hospitalized', 'recovered'};

for j = 1:length(cmpts)
    for i = 1:3
        nexttile;

        cd(currDir)
        XMed = plims(eval(append(cmpts1{j}, 'All')), 0.5);
        XUp = plims(eval(append(cmpts1{j}, 'All')), 0.75);
        XLow = plims(eval(append(cmpts1{j}, 'All')), 0.25);
        cd(figsDir)
        cd(FCNameResults)

        casesFit = plot(timeVect, XMed, '-', 'Color', eval(append('color_', cmpts{j})), ...
            'LineWidth', 2);
        hold on
        
        fillX = [timeVect, fliplr(timeVect)];
        fillY = [XLow, fliplr(XUp)];
        h = fill(fillX, fillY, eval(append('color_', cmpts{j})), 'linestyle', 'none');
        set(h,'facealpha', .5)
        hold on
        
        XVals = eval(append(cmpts1{j}, 'AllFC'));

        cd(currDir)
        XMedFC = plims(XVals(:, :, i), 0.5);
        XUpFC = plims(XVals(:, :, i), 0.75);
        XLowFC = plims(XVals(:, :, i), 0.25);
        cd(figsDir)
        cd(FCNameResults)

        casesFC = plot(timeVectFC, XMedFC, '-', 'Color', eval(append('color_', cmpts{j})), ...
        'LineWidth', 2, 'LineStyle', '--');
        hold on
        
        fillX = [timeVectFC, fliplr(timeVectFC)];
        fillY = [XLowFC, fliplr(XUpFC)];
        h = fill(fillX, fillY, eval(append('color_', cmpts{j})), 'linestyle', 'none');
        set(h,'facealpha', .25)
        hold on

        for l = 1:length(tPeriods)
            xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
                'LineWidth', 2)
            hold on
        end
        xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
        'LineWidth', 2)
    
        if j == 1
            title(append('\beta = ', num2str(beta4FC(i))));
        end

        if i == 1
            ylabel(compartments{j}, 'FontSize', 18)
        end
        xlim(xlimVals)
        set(gca, 'FontSize', 15)
        set(gca, 'XTick', [])

        if i == 2 && j == length(cmpts)
            xlabel('dates', 'FontSize', 18)
        end

        if j == length(cmpts)
            set(gca, 'XTick', dateX - 1, ...
                     'XTickLabel', xDate, ...
                     'XTickLabelRotation', 45)
        else
            xticks([])
        end

        set(gca, 'FontSize', 15)
    end
end

saveas(gcf, 'FCCompartments.fig')
exportgraphics(gcf, 'FCCompartments.png', 'Resolution', 300)



% Time-varying reproduction number
figure(13)
tiledlayout(1, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:3
    nexttile;

    cd(currDir)
    R0Med = plims(R0All, 0.5);
    R0Up = plims(R0All, 0.75);
    R0Low = plims(R0All, 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFit = semilogy(timeVect, R0Med, '-', 'Color', color_model, ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [R0Low, fliplr(R0Up)];
    h = fill(fillX, fillY, color_boot, 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    cd(currDir)
    R0MedFC = plims(R0AllFC(:, :, i), 0.5);
    R0UpFC = plims(R0AllFC(:, :, i), 0.75);
    R0LowFC = plims(R0AllFC(:, :, i), 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFC = semilogy(timeVectFC, R0MedFC, '-', 'Color', color_boot, ...
    'LineWidth', 2, 'LineStyle', '--');
    grid on
    hold on
    
    fillX = [timeVectFC, fliplr(timeVectFC)];
    fillY = [R0LowFC, fliplr(R0UpFC)];
    h = fill(fillX, fillY, color_boot, 'linestyle', 'none');
    set(h,'facealpha', .25)
    hold on

    for l = 1:length(tPeriods)
        xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end
    xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
    'LineWidth', 2)

    if i == 1
        ylabel('time-varying reproduction number', 'FontSize', 18)
    end
    
    yline(1, 'color', color_death, ...
            'LineStyle', '-', 'LineWidth', 4);
    
    if i == 2
        xlabel('dates', 'FontSize', 18)
    end
    set(gca, 'XTick', dateX - 1, ...
             'XTickLabel', xDate, ...
             'XTickLabelRotation', 45)
    set(gca, 'FontSize', 15)

        R0UIT(:, 3*i - 2) = [R0MedFC];
        R0UIT(:, 3*i - 1) = [R0LowFC];
        R0UIT(:, 3*i) = [R0UpFC];
    title(append('\beta = ', num2str(beta4FC(i))));
    xlim(xlimVals)
%     ylim(ylimValsRo)
end

saveas(gcf, 'FCRepNo.fig')
exportgraphics(gcf, 'FCRepNo.png', 'Resolution', 300)



figure(14)
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:3
    nexttile;
    bar(timeVect, inputData(:, 1), 'FaceColor', color_monit, ...
        'EdgeColor', 'none')
    hold on
    semilogy(timeVect, inputEst(:, 1), 'color', color_monitra, 'LineWidth', 4);
%     plot(timeVect, inputEst(:, 1), 'color', color_monitra, 'LineWidth', 4);
   grid on
   hold on

    bar(timeVect(end) + (1:days2test), dataMonitFC(end-days2test+1:end), 'FaceColor', 'none', ...
        'EdgeColor', color_monit)
    hold on
     semilogy(timeVect(end) + (1:days2test), dataMonitMAFC(end-days2test+1:end), ...
         'color', color_monitra, 'LineWidth', 4, 'LineStyle', '--');
%     plot(timeVect(end) + (1:days2test), dataMonitMAFC(end-days2test+1:end), ...
%         'color', color_monitra, 'LineWidth', 4, 'LineStyle', '--');
    grid on
    hold on
    
    cd(currDir)
    MMed = plims(MAll, 0.5);
    MUp = plims(MAll, 0.75);
    MLow = plims(MAll, 0.25);
    cd(figsDir)
    cd(FCNameResults)   

    casesFit = semilogy(timeVect, MMed, '-', 'Color', color_model, ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [MLow, fliplr(MUp)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    cd(currDir)
    MMedFC = plims(MAllFC(:, :, i), 0.5);
    MUpFC = plims(MAllFC(:, :, i), 0.75);
    MLowFC = plims(MAllFC(:, :, i), 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFC = semilogy(timeVectFC, MMedFC, '-', 'Color', color_model, ...
    'LineWidth', 2, 'LineStyle', '--');
    hold on
    
    fillX = [timeVectFC, fliplr(timeVectFC)];
    fillY = [MLowFC, fliplr(MUpFC)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .25)
    hold on
    
    for l = 1:length(tPeriods)
        xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end
    xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
    'LineWidth', 2)
    
    if i == 1
        ylabel('new monitored cases', 'FontSize', 18)
    end
     ylim(ylimValsM)
    xlim(xlimValsFC)
    xticks([])
    set(gca, 'FontSize', 15)

    title(append('\beta = ', num2str(beta4FC(i))));


        ylabel('new monitored cases', 'FontSize', 18)
    if i == 3
        xlabel('dates', 'FontSize', 18)
    

    set(gca, 'XTick', dateXFC - 1, ...
             'XTickLabel', xDateFC, ...
             'XTickLabelRotation', 45)
    set(gca, 'FontSize', 15)
%     ylim(ylimValsH)
    xlim(xlimValsFC)
end
end
saveas(gcf, 'FCDailyextended.fig')
exportgraphics(gcf, 'FCDailyextended.png', 'Resolution', 300)



%extend daily with forecast
figure(15)
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:3
    nexttile;
    bar(timeVect, inputData(:, 2), 'FaceColor', color_hosp, ...
        'EdgeColor', 'none')
    hold on
    semilogy(timeVect, inputEst(:, 2), 'color', color_hospra, 'LineWidth', 4);
    hold on
    
    bar(timeVect(end) + (1:days2test), dataHospFC(end-days2test+1:end), 'FaceColor', 'none', ...
        'EdgeColor', color_hosp)
    hold on
    semilogy(timeVect(end) + (1:days2test), dataHospMAFC(end-days2test+1:end), ...
        'color', color_hospra, 'LineWidth', 4, 'LineStyle', '--');
%     semilogy(timeVect(end) + (1:days2test), dataHospMAFC(end-days2test+1:end), ...
        %         'color', color_hospra, 'LineWidth', 4, 'LineStyle', '--');gr
    grid on
        hold on

    cd(currDir)
    HMed = plims(HAll, 0.5);
    HUp = plims(HAll, 0.75);
    HLow = plims(HAll, 0.25);
    cd(figsDir)
    cd(FCNameResults)

    casesFit = semilogy(timeVect, HMed, '-', 'Color', color_model, ...
        'LineWidth', 2);
    hold on
    
    fillX = [timeVect, fliplr(timeVect)];
    fillY = [HLow, fliplr(HUp)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .5)
    hold on
    
    cd(currDir)
    HMedFC = plims(HAllFC(:, :, i), 0.5);
    HUpFC = plims(HAllFC(:, :, i), 0.75);
    HLowFC = plims(HAllFC(:, :, i), 0.25);
    cd(figsDir)
    cd(FCNameResults)



    casesFC = plot(timeVectFC, HMedFC, '-', 'Color', color_model, ...
    'LineWidth', 2, 'LineStyle', '--');
    hold on
    
    fillX = [timeVectFC, fliplr(timeVectFC)];
    fillY = [HLowFC, fliplr(HUpFC)];
    h = fill(fillX, fillY, color_model, 'linestyle', 'none');
    set(h,'facealpha', .25)
    hold on

    for l = 1:length(tPeriods)
        xline(tPeriods{l}(1), 'color', color_death, 'LineStyle', '--', ...
            'LineWidth', 2)
        hold on
    end
    xline(timeVect(end) + 1, 'color', color_death, 'LineStyle', '-', ...
    'LineWidth', 2)

        ylabel('new hospitalized cases', 'FontSize', 18)
    if i == 3
        xlabel('dates', 'FontSize', 18)
    

    set(gca, 'XTick', dateXFC - 1, ...
             'XTickLabel', xDateFC, ...
             'XTickLabelRotation', 45)
    set(gca, 'FontSize', 15)
    end
    ylim(ylimValsH)
    xlim(xlimValsFC)

end
saveas(gcf, 'FCDailyHospitalizedFC.fig')
exportgraphics(gcf, 'FCDailyHospitalizedFC.png', 'Resolution', 300)

cd(currDir);

ActualMonit = dataMonitFC(end-days2test+1:end);
ActualHosp = dataHospFC(end-days2test+1:end);
MoveMeanMonit = dataMonitMAFC(end-days2test+1:end);
MoveMeanHosp = dataHospMAFC(end-days2test+1:end);
if isempty(HDCMName)
    FCNameResults = append('Result_FC_',RPCName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary);
else
    FCNameResults = append('Result_FC_',RPCName,'_',HDCMName,'_',string(BSsamples),'_',...
                            string(today('datetime')), '_', ...
                             outputSummary);
end

disp('File name of results:');
disp(FCNameResults);
disp('=====================');
simsDir = 'fc_results';
cd(simsDir);
save(append(FCNameResults, '.mat'), ...
    'M4UIT', 'H4UIT', 'R0UIT', 'ActualMonit', 'ActualHosp', 'MoveMeanMonit', 'MoveMeanHosp');
% simsDir = 'bs_results';
% cd(simsDir);
% save(append(BSNameResults, '.mat'), ...
%     'tPeriods', 'timeVect', 'inputData', 'inputEst', 'inputP0', ...
%     'outputCurves', 'outputData', 'outputIncid', 'outputPSet', ...
%     'outputP1', 'outputRes', 'outputMet', ...
%     'outputModSelect', 'outputRepNo', 'outputResid', ...
%     'outputFCIncid', 'outputFCCurves', 'outputFCPSet', ...
%     'outputFCRepNo','betaS', 'betaLast','betaMid','betaSmallest',...
%     'betaLargest','betaMedian', 'betaAve');
% cd(currDir);

cd(currDir)

end