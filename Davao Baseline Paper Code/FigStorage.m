function FigStorage(filecount,trainstart,period_q1,period_q2,period_q3,period_q4,period_q5,period_q6,period_q7,period_q8, period_q9,...
        end_q1,end_q2,end_q3,end_q4,end_q5,end_q6,end_q7,end_q8, end_q9, city,ma_data,madays,IMcasedata,IHcasedata,...
        cumsum_q1,cumsum_q2,cumsum_q3,cumsum_q4,cumsum_q5,cumsum_q6,cumsum_q7,cumsum_q8, cumsum_q9, Simdata,...
        Simstatedata,residCol,Ddata,Rdata,data_m,data_h)

myworkingdir = cd; % access current working directory
simulationsdir = 'simulations'; % create 'simulations' folder in the current directory
cd(simulationsdir); % go to 'simulations' folder directory

plotsdir = 'plots';
if ~exist(plotsdir, 'dir')
   mkdir(plotsdir)
end
cd(plotsdir);

%% Colors
color_model = 1/255*[30,144,255];
color_monit = 1/255*[255,160,122];
color_monitra = 1/255*[255,127,80];
color_hosp = 1/255*[255,69,0]';
color_hospra = 1/255*[255,0,0];
color_recov = 1/255*[144,238,144];
color_rmod = 1/255*[0,100,0];
color_smod = 1/255*[255,218,185];
color_emod = 1/255*[218,165,32];
color_death = 1/255*[112,128,144];
color_dmod = 1/255*[47,79,79];
color_boot = 1/255*[75,0,130];

%% Assigning to variables

% Period per data set per quarantine type
mtraindate_q1 = trainstart{1,1}:1:end_q1; %plot(mtraindate_q1, monitored_q1
mtraindate_q2 = trainstart{2,1}:1:end_q2;
mtraindate_q3 = trainstart{3,1}:1:end_q3;
mtraindate_q4 = trainstart{4,1}:1:end_q4;
mtraindate_q5 = trainstart{5,1}:1:end_q5;
mtraindate_q6 = trainstart{6,1}:1:end_q6;
mtraindate_q7 = trainstart{7,1}:1:end_q7;
mtraindate_q8 = trainstart{8,1}:1:end_q8;
mtraindate_q9 = trainstart{9,1}:1:end_q9;

htraindate_q1 = trainstart{1,2}:1:end_q1;
htraindate_q2 = trainstart{2,2}:1:end_q2;
htraindate_q3 = trainstart{3,2}:1:end_q3;
htraindate_q4 = trainstart{4,2}:1:end_q4;
htraindate_q5 = trainstart{5,2}:1:end_q5;
htraindate_q6 = trainstart{6,2}:1:end_q6;
htraindate_q7 = trainstart{7,2}:1:end_q7;
htraindate_q8 = trainstart{8,2}:1:end_q8;
htraindate_q9 = trainstart{9,2}:1:end_q9;

dtraindate_q1 = trainstart{1,3}:1:end_q1;
dtraindate_q2 = trainstart{2,3}:1:end_q2;
dtraindate_q3 = trainstart{3,3}:1:end_q3;
dtraindate_q4 = trainstart{4,3}:1:end_q4;
dtraindate_q5 = trainstart{5,3}:1:end_q5;
dtraindate_q6 = trainstart{6,3}:1:end_q6;
dtraindate_q7 = trainstart{7,3}:1:end_q7;
dtraindate_q8 = trainstart{8,3}:1:end_q8;
dtraindate_q9 = trainstart{9,3}:1:end_q9;

rtraindate_q1 = trainstart{1,4}:1:end_q1;
rtraindate_q2 = trainstart{2,4}:1:end_q2;
rtraindate_q3 = trainstart{3,4}:1:end_q3;
rtraindate_q4 = trainstart{4,4}:1:end_q4;
rtraindate_q5 = trainstart{5,4}:1:end_q5;
rtraindate_q6 = trainstart{6,4}:1:end_q6;
rtraindate_q7 = trainstart{7,4}:1:end_q7;
rtraindate_q8 = trainstart{8,4}:1:end_q8;
rtraindate_q9 = trainstart{9,4}:1:end_q9;

% v1traindate_q1 = trainstart{1,6}:1:end_q1;
% v1traindate_q2 = trainstart{2,6}:1:end_q2;
% v1traindate_q3 = trainstart{3,6}:1:end_q3;
% v1traindate_q4 = trainstart{4,6}:1:end_q4;
% v1traindate_q5 = trainstart{5,6}:1:end_q5;
% v1traindate_q6 = trainstart{6,6}:1:end_q6;
% v1traindate_q7 = trainstart{7,6}:1:end_q7;
% 
% v2traindate_q6 = trainstart{6,6}:1:end_q6;
% v2traindate_q7 = trainstart{7,6}:1:end_q7;
% 
% v3traindate_q6 = trainstart{6,6}:1:end_q6;
% v3traindate_q7 = trainstart{7,6}:1:end_q7;

%%should I add the Vaccs?

% Assign daily reported data to variables
IMdata_q1 = IMcasedata{1};
IMdata_q2 = IMcasedata{2};
IMdata_q3 = IMcasedata{3};
IMdata_q4 = IMcasedata{4};
IMdata_q5 = IMcasedata{5};
IMdata_q6 = IMcasedata{6};
IMdata_q7 = IMcasedata{7};
IMdata_q8 = IMcasedata{8};
IMdata_q9 = IMcasedata{9};

IHdata_q1 = IHcasedata{1};
IHdata_q2 = IHcasedata{2};
IHdata_q3 = IHcasedata{3};
IHdata_q4 = IHcasedata{4};
IHdata_q5 = IHcasedata{5};
IHdata_q6 = IHcasedata{6};
IHdata_q7 = IHcasedata{7};
IHdata_q8 = IHcasedata{8};
IHdata_q9 = IHcasedata{9};

Ddata_q1 = Ddata{1};
Ddata_q2 = Ddata{2};
Ddata_q3 = Ddata{3};
Ddata_q4 = Ddata{4};
Ddata_q5 = Ddata{5};
Ddata_q6 = Ddata{6};
Ddata_q7 = Ddata{7};
Ddata_q8 = Ddata{8};
Ddata_q9 = Ddata{9};

Rdata_q1 = Rdata{1};
Rdata_q2 = Rdata{2};
Rdata_q3 = Rdata{3};
Rdata_q4 = Rdata{4};
Rdata_q5 = Rdata{5};
Rdata_q6 = Rdata{6};
Rdata_q7 = Rdata{7};
Rdata_q8 = Rdata{8};
Rdata_q9 = Rdata{9};

% V1data_q1 = V1data{1};
% V1data_q2 = V1data{2};
% V1data_q3 = V1data{3};
% V1data_q4 = V1data{4};
% V1data_q5 = V1data{5};
% V1data_q6 = V1data{6};
% V1data_q7 = V1data{7};
% 
% V2data_q6 = V2data{6};
% V2data_q7 = V2data{7};
% 
% V3data_q6 = V3data{6};
% V3data_q7 = V3data{7};

% Impose moving averages to the daily data
ma_Imtrain1 = movmean(IMdata_q1, madays);
ma_Imtrain2 = movmean(IMdata_q2, madays);
ma_Imtrain3 = movmean(IMdata_q3, madays);
ma_Imtrain4 = movmean(IMdata_q4, madays);
ma_Imtrain5 = movmean(IMdata_q5, madays);
ma_Imtrain6 = movmean(IMdata_q6, madays);
ma_Imtrain7 = movmean(IMdata_q7, madays);
ma_Imtrain8 = movmean(IMdata_q8, madays);
ma_Imtrain9 = movmean(IMdata_q9, madays);

ma_Ihtrain1 = movmean(IHdata_q1, madays);
ma_Ihtrain2 = movmean(IHdata_q2, madays);
ma_Ihtrain3 = movmean(IHdata_q3, madays);
ma_Ihtrain4 = movmean(IHdata_q4, madays);
ma_Ihtrain5 = movmean(IHdata_q5, madays);
ma_Ihtrain6 = movmean(IHdata_q6, madays);
ma_Ihtrain7 = movmean(IHdata_q7, madays);
ma_Ihtrain8 = movmean(IHdata_q8, madays);
ma_Ihtrain9 = movmean(IHdata_q9, madays);

% Assign simulated daily data to variables
monitored_q1 = Simdata{filecount,1}{1,1};
monitored_q2 = Simdata{filecount,2}{1,1};
monitored_q3 = Simdata{filecount,3}{1,1};
monitored_q4 = Simdata{filecount,4}{1,1};
monitored_q5 = Simdata{filecount,5}{1,1};
monitored_q6 = Simdata{filecount,6}{1,1};
monitored_q7 = Simdata{filecount,7}{1,1};
monitored_q8 = Simdata{filecount,8}{1,1};
monitored_q9 = Simdata{filecount,9}{1,1};

hospitalized_q1 = Simdata{filecount,1}{1,2};
hospitalized_q2 = Simdata{filecount,2}{1,2};
hospitalized_q3 = Simdata{filecount,3}{1,2};
hospitalized_q4 = Simdata{filecount,4}{1,2};
hospitalized_q5 = Simdata{filecount,5}{1,2};
hospitalized_q6 = Simdata{filecount,6}{1,2};
hospitalized_q7 = Simdata{filecount,7}{1,2};
hospitalized_q8 = Simdata{filecount,8}{1,2};
hospitalized_q9 = Simdata{filecount,9}{1,2};

deaths_q1 = Simdata{filecount,1}{1,3};
deaths_q2 = Simdata{filecount,2}{1,3};
deaths_q3 = Simdata{filecount,3}{1,3};
deaths_q4 = Simdata{filecount,4}{1,3};
deaths_q5 = Simdata{filecount,5}{1,3};
deaths_q6 = Simdata{filecount,6}{1,3};
deaths_q7 = Simdata{filecount,7}{1,3};
deaths_q8 = Simdata{filecount,8}{1,3}
deaths_q9 = Simdata{filecount,9}{1,3}

recovered_q1 = Simdata{filecount,1}{1,4};
recovered_q2 = Simdata{filecount,2}{1,4};
recovered_q3 = Simdata{filecount,3}{1,4};
recovered_q4 = Simdata{filecount,4}{1,4};
recovered_q5 = Simdata{filecount,5}{1,4};
recovered_q6 = Simdata{filecount,6}{1,4};
recovered_q7 = Simdata{filecount,7}{1,4};
recovered_q8 = Simdata{filecount,8}{1,4};
recovered_q9 = Simdata{filecount,9}{1,4};

% vax1_q1 = Simdata{filecount,1}{1,9};
% vax1_q2 = Simdata{filecount,2}{1,9};
% vax1_q3 = Simdata{filecount,3}{1,9};
% vax1_q4 = Simdata{filecount,4}{1,9};
% vax1_q5 = Simdata{filecount,5}{1,9};
% vax1_q6 = Simdata{filecount,6}{1,9};
% vax1_q7 = Simdata{filecount,7}{1,9};
% 
% vax2_q6 = Simdata{filecount,6}{1,10};
% vax2_q7 = Simdata{filecount,7}{1,10};
% 
% vax3_q6 = Simdata{filecount,6}{1,11};
% vax3_q7 = Simdata{filecount,7}{1,11};
%Simdata{g,j} = {monitored, hospitalized, deceased, removed, IM, IH, D, Rec, vax1, vax2, vax3};
%Simstatedata{g,j} = {Smod, Emod, Immod, Ihmod, Rmod, V1mod, V2mod, V3mod, Rt};

% Assign simulated cumulative data to variables
cumulativeIM_q1 = Simdata{filecount,1}{1,5};
cumulativeIM_q2 = Simdata{filecount,2}{1,5};
cumulativeIM_q3 = Simdata{filecount,3}{1,5};
cumulativeIM_q4 = Simdata{filecount,4}{1,5};
cumulativeIM_q5 = Simdata{filecount,5}{1,5};
cumulativeIM_q6 = Simdata{filecount,6}{1,5};
cumulativeIM_q7 = Simdata{filecount,7}{1,5};
cumulativeIM_q8 = Simdata{filecount,8}{1,5};
cumulativeIM_q9 = Simdata{filecount,9}{1,5};

cumulativeIH_q1 = Simdata{filecount,1}{1,6};
cumulativeIH_q2 = Simdata{filecount,2}{1,6};
cumulativeIH_q3 = Simdata{filecount,3}{1,6};
cumulativeIH_q4 = Simdata{filecount,4}{1,6};
cumulativeIH_q5 = Simdata{filecount,5}{1,6};
cumulativeIH_q6 = Simdata{filecount,6}{1,6};
cumulativeIH_q7 = Simdata{filecount,7}{1,6};
cumulativeIH_q8 = Simdata{filecount,8}{1,6};
cumulativeIH_q9 = Simdata{filecount,9}{1,6};

% Assign state variables
Smod_q1 = Simstatedata{filecount,1}{1,1};
Smod_q2 = Simstatedata{filecount,2}{1,1};
Smod_q3 = Simstatedata{filecount,3}{1,1};
Smod_q4 = Simstatedata{filecount,4}{1,1};
Smod_q5 = Simstatedata{filecount,5}{1,1};
Smod_q6 = Simstatedata{filecount,6}{1,1};
Smod_q7 = Simstatedata{filecount,7}{1,1};
Smod_q8 = Simstatedata{filecount,8}{1,1};
Smod_q9 = Simstatedata{filecount,9}{1,1};

Emod_q1 = Simstatedata{filecount,1}{1,2};
Emod_q2 = Simstatedata{filecount,2}{1,2};
Emod_q3 = Simstatedata{filecount,3}{1,2};
Emod_q4 = Simstatedata{filecount,4}{1,2};
Emod_q5 = Simstatedata{filecount,5}{1,2};
Emod_q6 = Simstatedata{filecount,6}{1,2};
Emod_q7 = Simstatedata{filecount,7}{1,2};
Emod_q8 = Simstatedata{filecount,8}{1,2};
Emod_q9 = Simstatedata{filecount,9}{1,2};

Immod_q1 = Simstatedata{filecount,1}{1,3};
Immod_q2 = Simstatedata{filecount,2}{1,3};
Immod_q3 = Simstatedata{filecount,3}{1,3};
Immod_q4 = Simstatedata{filecount,4}{1,3};
Immod_q5 = Simstatedata{filecount,5}{1,3};
Immod_q6 = Simstatedata{filecount,6}{1,3};
Immod_q7 = Simstatedata{filecount,7}{1,3};
Immod_q8 = Simstatedata{filecount,8}{1,3};
Immod_q9 = Simstatedata{filecount,9}{1,3};

Ihmod_q1 = Simstatedata{filecount,1}{1,4};
Ihmod_q2 = Simstatedata{filecount,2}{1,4};
Ihmod_q3 = Simstatedata{filecount,3}{1,4};
Ihmod_q4 = Simstatedata{filecount,4}{1,4};
Ihmod_q5 = Simstatedata{filecount,5}{1,4};
Ihmod_q6 = Simstatedata{filecount,6}{1,4};
Ihmod_q7 = Simstatedata{filecount,7}{1,4};
Ihmod_q8 = Simstatedata{filecount,8}{1,4};
Ihmod_q9 = Simstatedata{filecount,9}{1,4};

Rmod_q1 = Simstatedata{filecount,1}{1,5};
Rmod_q2 = Simstatedata{filecount,2}{1,5};
Rmod_q3 = Simstatedata{filecount,3}{1,5};
Rmod_q4 = Simstatedata{filecount,4}{1,5};
Rmod_q5 = Simstatedata{filecount,5}{1,5};
Rmod_q6 = Simstatedata{filecount,6}{1,5};
Rmod_q7 = Simstatedata{filecount,7}{1,5};
Rmod_q8 = Simstatedata{filecount,8}{1,5};
Rmod_q9 = Simstatedata{filecount,9}{1,5};

% V1mod_q6 = Simstatedata{filecount,6}{1,6};
% V2mod_q6 = Simstatedata{filecount,6}{1,7};
% V3mod_q6 = Simstatedata{filecount,6}{1,8};
% V1mod_q7 = Simstatedata{filecount,7}{1,6};
% V2mod_q7 = Simstatedata{filecount,7}{1,7};
% V3mod_q7 = Simstatedata{filecount,7}{1,8};

% Residuals
residM_q1 = residCol{filecount,1}{1,1};
residM_q2 = residCol{filecount,2}{1,1};
residM_q3 = residCol{filecount,3}{1,1};
residM_q4 = residCol{filecount,4}{1,1};
residM_q5 = residCol{filecount,5}{1,1};
residM_q6 = residCol{filecount,6}{1,1};
residM_q7 = residCol{filecount,7}{1,1};
residM_q8 = residCol{filecount,8}{1,1};
residM_q9 = residCol{filecount,9}{1,1};

residH_q1 = residCol{filecount,1}{1,2};
residH_q2 = residCol{filecount,2}{1,2};
residH_q3 = residCol{filecount,3}{1,2};
residH_q4 = residCol{filecount,4}{1,2};
residH_q5 = residCol{filecount,5}{1,2};
residH_q6 = residCol{filecount,6}{1,2};
residH_q7 = residCol{filecount,7}{1,2};
residH_q8 = residCol{filecount,8}{1,2};
residH_q9 = residCol{filecount,9}{1,2};

% Reproduction Number
Rt_q1 = Simstatedata{filecount,1}{1,6};
Rt_q2 = Simstatedata{filecount,2}{1,6};
Rt_q3 = Simstatedata{filecount,3}{1,6};
Rt_q4 = Simstatedata{filecount,4}{1,6};
Rt_q5 = Simstatedata{filecount,5}{1,6};
Rt_q6 = Simstatedata{filecount,6}{1,6};
Rt_q7 = Simstatedata{filecount,7}{1,6};
Rt_q8 = Simstatedata{filecount,8}{1,6};
Rt_q9 = Simstatedata{filecount,9}{1,6};

%% 1) Model fit and daily data: IM
% Naming of figures for the fit
mynewfigname1 = strcat('datafit_IM',int2str(filecount+1),'.fig');
mynewpngname1 = strcat('datafit_IM',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% 1a. I_M cases
bar(period_q1, IMdata_q1,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q1, ma_Imtrain1, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q1, monitored_q1,'Color',color_model,'Linewidth',2)
hold on

bar(period_q2, IMdata_q2,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q2, ma_Imtrain2, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q2, monitored_q2,'Color',color_model,'Linewidth',2)
hold on

bar(period_q3, IMdata_q3,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q3, ma_Imtrain3, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q3, monitored_q3,'Color',color_model,'Linewidth',2)
hold on

bar(period_q4, IMdata_q4,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q4, ma_Imtrain4, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q4, monitored_q4,'Color',color_model,'Linewidth',2)
hold on

bar(period_q5, IMdata_q5,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q5, ma_Imtrain5, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q5, monitored_q5,'Color',color_model,'Linewidth',2)
hold on

bar(period_q6, IMdata_q6,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q6, ma_Imtrain6, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q6, monitored_q6,'Color',color_model,'Linewidth',2)
hold on

bar(period_q7, IMdata_q7,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q7, ma_Imtrain7, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q7, monitored_q7,'Color',color_model,'Linewidth',2)
hold on

bar(period_q8, IMdata_q8,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q8, ma_Imtrain8, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q8, monitored_q8,'Color',color_model,'Linewidth',2)
hold on

bar(period_q9, IMdata_q9,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q9, ma_Imtrain9, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q9, monitored_q9,'Color',color_model,'Linewidth',2)


line1=[mtraindate_q1(end) 0;mtraindate_q1(end) max(IMdata_q3)];
plot(line1(:,1),line1(:,2),'k--','LineWidth',2)
line2=[mtraindate_q2(end) 0;mtraindate_q2(end) max(IMdata_q3)];
plot(line2(:,1),line2(:,2),'k--','LineWidth',2)
line3=[mtraindate_q3(end) 0;mtraindate_q3(end) max(IMdata_q3)];
plot(line3(:,1),line3(:,2),'k--','LineWidth',2)
line4=[mtraindate_q4(end) 0;mtraindate_q4(end) max(IMdata_q3)];
plot(line4(:,1),line4(:,2),'k--','LineWidth',2)
line5=[mtraindate_q5(end) 0;mtraindate_q5(end) max(IMdata_q3)];
plot(line5(:,1),line5(:,2),'k--','LineWidth',2)
line6=[mtraindate_q6(end) 0;mtraindate_q6(end) max(IMdata_q3)];
plot(line6(:,1),line6(:,2),'k--','LineWidth',2)
line7=[mtraindate_q7(end) 0;mtraindate_q7(end) max(IMdata_q3)];
plot(line7(:,1),line7(:,2),'k--','LineWidth',2)
line8=[mtraindate_q8(end) 0;mtraindate_q8(end) max(IMdata_q3)];
plot(line8(:,1),line8(:,2),'k--','LineWidth',2)


datetick('x','mmm-dd-yy','keeplimits')
title(strcat('Model Fitting of Daily Number of Asymptomatic-Mild Patients in ',{' '},city))
xlabel('Onset Date'),ylabel('Daily number of Asymptomatic-Mild COVID-19 patients')
if ma_data == true
    legend({'daily data','running ave','model'},'Fontsize',12,'Location','Northwest')
else
    legend({'daily data','model'},'Fontsize',12,'Location','Northwest')
end
set(gca,'FontSize',13,'XTickLabelRotation',45)
saveas(gcf,mynewfigname1)
saveas(gcf,mynewpngname1)

%% 2) Model fit and daily data: IH
% Naming of figures for the fit
mynewfigname2 = strcat('datafit_IH',int2str(filecount+1),'.fig');
mynewpngname2 = strcat('datafit_IH',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% 1a. I_H cases
%bar(period_q1, IHdata_q1,'FaceColor',color_hosp,'EdgeColor','none')
%hold on
%if ma_data == true
%    plot(period_q1, ma_Ihtrain1, 'Color', color_hospra, 'LineWidth', 2)
%    hold on
%end
%plot(htraindate_q1, hospitalized_q1,'Color',color_model,'Linewidth',2)
%hold on

bar(period_q2, IHdata_q2,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q2, ma_Ihtrain2, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q2, hospitalized_q2,'Color',color_model,'Linewidth',2)
hold on

bar(period_q3, IHdata_q3,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q3, ma_Ihtrain3, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q3, hospitalized_q3,'Color',color_model,'Linewidth',2)
hold on

bar(period_q4, IHdata_q4,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q4, ma_Ihtrain4, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q4, hospitalized_q4,'Color',color_model,'Linewidth',2)
hold on

bar(period_q5, IHdata_q5,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q5, ma_Ihtrain5, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q5, hospitalized_q5,'Color',color_model,'Linewidth',2)
hold on

bar(period_q6, IHdata_q6,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q6, ma_Ihtrain6, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q6, hospitalized_q6,'Color',color_model,'Linewidth',2)
hold on

bar(period_q7, IHdata_q7,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q7, ma_Ihtrain7, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q7, hospitalized_q7,'Color',color_model,'Linewidth',2)
hold on

bar(period_q8, IHdata_q8,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q8, ma_Ihtrain8, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q8, hospitalized_q8,'Color',color_model,'Linewidth',2)
hold on

bar(period_q9, IHdata_q9,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q9, ma_Ihtrain9, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q9, hospitalized_q9,'Color',color_model,'Linewidth',2)

line1=[htraindate_q1(end) 0;htraindate_q1(end) max(IHdata_q3)];
plot(line1(:,1),line1(:,2),'k--','LineWidth',2)
line2=[htraindate_q2(end) 0;htraindate_q2(end) max(IHdata_q3)];
plot(line2(:,1),line2(:,2),'k--','LineWidth',2)
line3=[htraindate_q3(end) 0;htraindate_q3(end) max(IHdata_q3)];
plot(line3(:,1),line3(:,2),'k--','LineWidth',2)
line4=[htraindate_q4(end) 0;htraindate_q4(end) max(IHdata_q3)];
plot(line4(:,1),line4(:,2),'k--','LineWidth',2)
line5=[htraindate_q5(end) 0;htraindate_q5(end) max(IHdata_q3)];
plot(line5(:,1),line5(:,2),'k--','LineWidth',2)
line6=[htraindate_q6(end) 0;htraindate_q6(end) max(IHdata_q3)];
plot(line6(:,1),line6(:,2),'k--','LineWidth',2)
line7=[htraindate_q7(end) 0;htraindate_q7(end) max(IHdata_q3)];
plot(line7(:,1),line7(:,2),'k--','LineWidth',2)
line8=[htraindate_q8(end) 0;htraindate_q8(end) max(IHdata_q3)];
plot(line8(:,1),line8(:,2),'k--','LineWidth',2)

datetick('x','mmm-dd-yy','keeplimits')
title(strcat('Model Fitting of Daily Number of Moderate-Critical Patients in ',{' '},city))
xlabel('Onset Date'),ylabel('Daily number of Moderate-Critical COVID-19 patients')
if ma_data == true
    legend({'daily data','running ave','model'},'Fontsize',12,'Location','Northwest')
else
    legend({'daily data','model'},'Fontsize',12,'Location','Northwest')
end
set(gca,'FontSize',13,'XTickLabelRotation',45)
saveas(gcf,mynewfigname2)
saveas(gcf,mynewpngname2)

%% 3) Model fit and cumulative data: IM
% Naming of figures for the fit
mynewfigname3 = strcat('cumudatafit_IM',int2str(filecount+1),'.fig');
mynewpngname3 = strcat('cumudatafit_IM',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% 1a. I_M cases
bar(period_q1, cumsum_q1(1)+cumsum(IMdata_q1),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q1, cumsum_q1(1)+cumsum(ma_Imtrain1), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q1, cumsum_q1(1)+cumulativeIM_q1,'Color',color_model,'Linewidth',2)
hold on

bar(period_q2, cumsum_q2(1)+cumsum(IMdata_q2),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q2, cumsum_q2(1)+cumsum(ma_Imtrain2), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q2, cumsum_q2(1)+cumulativeIM_q2,'Color',color_model,'Linewidth',2)
hold on

bar(period_q3, cumsum_q3(1)+cumsum(IMdata_q3),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q3, cumsum_q3(1)+cumsum(ma_Imtrain3), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q3, cumsum_q3(1)+cumulativeIM_q3,'Color',color_model,'Linewidth',2)
hold on

bar(period_q4, cumsum_q4(1)+cumsum(IMdata_q4),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q4, cumsum_q4(1)+cumsum(ma_Imtrain4), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q4, cumsum_q4(1)+cumulativeIM_q4,'Color',color_model,'Linewidth',2)
hold on

bar(period_q5, cumsum_q5(1)+cumsum(IMdata_q5),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q5, cumsum_q5(1)+cumsum(ma_Imtrain5), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q5, cumsum_q5(1)+cumulativeIM_q5,'Color',color_model,'Linewidth',2)
hold on

bar(period_q6, cumsum_q6(1)+cumsum(IMdata_q6),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q6, cumsum_q6(1)+cumsum(ma_Imtrain6), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q6, cumsum_q6(1)+cumulativeIM_q6,'Color',color_model,'Linewidth',2)
hold on

bar(period_q7, cumsum_q7(1)+cumsum(IMdata_q7),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q7, cumsum_q7(1)+cumsum(ma_Imtrain7), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q7, cumsum_q7(1)+cumulativeIM_q7,'Color',color_model,'Linewidth',2)
hold on

bar(period_q8, cumsum_q8(1)+cumsum(IMdata_q8),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q8, cumsum_q8(1)+cumsum(ma_Imtrain8), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q8, cumsum_q8(1)+cumulativeIM_q8,'Color',color_model,'Linewidth',2)
hold on

bar(period_q9, cumsum_q9(1)+cumsum(IMdata_q9),'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q9, cumsum_q9(1)+cumsum(ma_Imtrain9), 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q9, cumsum_q9(1)+cumulativeIM_q9,'Color',color_model,'Linewidth',2)


line1=[mtraindate_q1(end) 0;mtraindate_q1(end)  max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line1(:,1),line1(:,2),'k--','LineWidth',2)
line2=[mtraindate_q2(end) 0;mtraindate_q2(end)  max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line2(:,1),line2(:,2),'k--','LineWidth',2)
line3=[mtraindate_q3(end) 0;mtraindate_q3(end) max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line3(:,1),line3(:,2),'k--','LineWidth',2)
line4=[mtraindate_q4(end) 0;mtraindate_q4(end) max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line4(:,1),line4(:,2),'k--','LineWidth',2)
line5=[mtraindate_q5(end) 0;mtraindate_q5(end)  max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line5(:,1),line5(:,2),'k--','LineWidth',2)
line6=[mtraindate_q6(end) 0;mtraindate_q6(end)  max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line6(:,1),line6(:,2),'k--','LineWidth',2)
line7=[mtraindate_q7(end) 0;mtraindate_q7(end)  max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line7(:,1),line7(:,2),'k--','LineWidth',2)
line8=[mtraindate_q8(end) 0;mtraindate_q8(end) max(cumsum_q9(1)+cumulativeIM_q9)*1.1];
plot(line8(:,1),line8(:,2),'k--','LineWidth',2)

datetick('x','mmm-dd-yy','keeplimits')
title(strcat('Model Fitting of Cumulative Number of Asymptomatic-Mild Patients in ',{' '},city))
xlabel('Onset Date'),ylabel('Cumulative number of Asymptomatic-Mild COVID-19 patients')
if ma_data == true
    legend({'cumulative data','running ave','model'},'Fontsize',12,'Location','Northwest')
else
    legend({'cumulative data','model'},'Fontsize',12,'Location','Northwest')
end
set(gca,'FontSize',13,'XTickLabelRotation',45)
saveas(gcf,mynewfigname3)
saveas(gcf,mynewpngname3)

%% 4) Model fit and cumulative data: IH
% Naming of figures for the fit
mynewfigname4 = strcat('cumudatafit_IH',int2str(filecount+1),'.fig');
mynewpngname4 = strcat('cumudatafit_IH',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% 1a. I_H cases
%bar(period_q1, cumsum_q1(2)+cumsum(IHdata_q1),'FaceColor',color_hosp,'EdgeColor','none')
%hold on
% if ma_data == true
%     plot(period_q1, cumsum_q1(2)+cumsum(ma_Ihtrain1), 'Color', color_hospra, 'LineWidth', 2)
%     hold on
% end
% plot(htraindate_q1, cumsum_q1(2)+cumulativeIH_q1,'Color',color_model,'Linewidth',2)
% hold on

bar(period_q2, cumsum_q2(2)+cumsum(IHdata_q2),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q2, cumsum_q2(2)+cumsum(ma_Ihtrain2), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q2, cumsum_q2(2)+cumulativeIH_q2,'Color',color_model,'Linewidth',2)
hold on

bar(period_q3, cumsum_q3(2)+cumsum(IHdata_q3),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q3, cumsum_q3(2)+cumsum(ma_Ihtrain3), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q3, cumsum_q3(2)+cumulativeIH_q3,'Color',color_model,'Linewidth',2)
hold on

bar(period_q4, cumsum_q4(2)+cumsum(IHdata_q4),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q4, cumsum_q4(2)+cumsum(ma_Ihtrain4), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q4, cumsum_q4(2)+cumulativeIH_q4,'Color',color_model,'Linewidth',2)
hold on

bar(period_q5, cumsum_q5(2)+cumsum(IHdata_q5),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q5, cumsum_q5(2)+cumsum(ma_Ihtrain5), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q5, cumsum_q5(2)+cumulativeIH_q5,'Color',color_model,'Linewidth',2)
hold on

bar(period_q6, cumsum_q6(2)+cumsum(IHdata_q6),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q6, cumsum_q6(2)+cumsum(ma_Ihtrain6), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q6, cumsum_q6(2)+cumulativeIH_q6,'Color',color_model,'Linewidth',2)
hold on

bar(period_q7, cumsum_q7(2)+cumsum(IHdata_q7),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q7, cumsum_q7(2)+cumsum(ma_Ihtrain7), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q7, cumsum_q7(2)+cumulativeIH_q7,'Color',color_model,'Linewidth',2)
hold on

bar(period_q8, cumsum_q8(2)+cumsum(IHdata_q8),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q8, cumsum_q8(2)+cumsum(ma_Ihtrain8), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q8, cumsum_q8(2)+cumulativeIH_q8,'Color',color_model,'Linewidth',2)
hold on

bar(period_q9, cumsum_q9(2)+cumsum(IHdata_q9),'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q9, cumsum_q9(2)+cumsum(ma_Ihtrain9), 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q9, cumsum_q9(2)+cumulativeIH_q9,'Color',color_model,'Linewidth',2)

line1=[htraindate_q1(end) 0;htraindate_q1(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line1(:,1),line1(:,2),'k--','LineWidth',2)
line2=[htraindate_q2(end) 0;htraindate_q2(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line2(:,1),line2(:,2),'k--','LineWidth',2)
line3=[htraindate_q3(end) 0;htraindate_q3(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line3(:,1),line3(:,2),'k--','LineWidth',2)
line4=[htraindate_q4(end) 0;htraindate_q4(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line4(:,1),line4(:,2),'k--','LineWidth',2)
line5=[htraindate_q5(end) 0;htraindate_q5(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line5(:,1),line5(:,2),'k--','LineWidth',2)
line6=[htraindate_q6(end) 0;htraindate_q6(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line6(:,1),line6(:,2),'k--','LineWidth',2)
line7=[htraindate_q7(end) 0;htraindate_q7(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line7(:,1),line7(:,2),'k--','LineWidth',2)
line8=[htraindate_q8(end) 0;htraindate_q8(end) max(cumsum_q9(2)+cumulativeIH_q9)*1.1];
plot(line8(:,1),line8(:,2),'k--','LineWidth',2)

datetick('x','mmm-dd-yy','keeplimits')
title(strcat('Model Fitting of Cumulative Number of Moderate-Critical Patients in ',{' '},city))
xlabel('Onset Date'),ylabel('Cumulative number of Moderate-Critical COVID-19 patients')
if ma_data == true
    legend({'cumulative data','running ave','model'},'Fontsize',12,'Location','Northwest')
else
    legend({'cumulative data','model'},'Fontsize',12,'Location','Northwest')
end
set(gca,'FontSize',13,'XTickLabelRotation',45)
saveas(gcf,mynewfigname4)
saveas(gcf,mynewpngname4)

%% 5) State Variables
% Naming of figures for the fit
mynewfigname5 = strcat('statevar',int2str(filecount+1),'.fig');
mynewpngname5 = strcat('statevar',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
semilogy(mtraindate_q1, Smod_q1, 'Linewidth',2)
hold on
semilogy(mtraindate_q1, Emod_q1,'Linewidth',2)
hold on
semilogy(mtraindate_q1, Immod_q1,'Linewidth',2)
hold on
semilogy(mtraindate_q1, Ihmod_q1,'Linewidth',2)
hold on
semilogy(mtraindate_q1, Rmod_q1,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q1')
xlabel('Onset Date'),ylabel('Number of Individuals')
set(gca,'FontSize',12)

% Q2 period
subplot(3,3,2)
semilogy(mtraindate_q2, Smod_q2,'Linewidth',2)
hold on
semilogy(mtraindate_q2, Emod_q2,'Linewidth',2)
hold on
semilogy(mtraindate_q2, Immod_q2,'Linewidth',2)
hold on
semilogy(mtraindate_q2, Ihmod_q2,'Linewidth',2)
hold on
semilogy(mtraindate_q2, Rmod_q2,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q2')
xlabel('Onset Date'),ylabel('Number of Individuals')
set(gca,'FontSize',12)

% Q3 period
subplot(3,3,3)
semilogy(mtraindate_q3, Smod_q3,'Linewidth',2)
hold on
semilogy(mtraindate_q3, Emod_q3,'Linewidth',2)
hold on
semilogy(mtraindate_q3, Immod_q3,'Linewidth',2)
hold on
semilogy(mtraindate_q3, Ihmod_q3,'Linewidth',2)
hold on
semilogy(mtraindate_q3, Rmod_q3,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q3')
xlabel('Onset Date'),ylabel('Number of Individuals')
set(gca,'FontSize',12)

% Q4 period
subplot(3,3,4)
semilogy(mtraindate_q4, Smod_q4,'Linewidth',2)
hold on
semilogy(mtraindate_q4, Emod_q4,'Linewidth',2)
hold on
semilogy(mtraindate_q4, Immod_q4,'Linewidth',2)
hold on
semilogy(mtraindate_q4, Ihmod_q4,'Linewidth',2)
hold on
semilogy(mtraindate_q4, Rmod_q4,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q4')
xlabel('Onset Date'),ylabel('Number of Individuals')
set(gca,'FontSize',12)

% Q5 period
subplot(3,3,5)
semilogy(mtraindate_q5, Smod_q5,'Linewidth',2)
hold on
semilogy(mtraindate_q5, Emod_q5,'Linewidth',2)
hold on
semilogy(mtraindate_q5, Immod_q5,'Linewidth',2)
hold on
semilogy(mtraindate_q5, Ihmod_q5,'Linewidth',2)
hold on
semilogy(mtraindate_q5, Rmod_q5,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q5')
xlabel('Onset Date'),ylabel('Number of Individuals')
set(gca,'FontSize',12)

% Q6 period
subplot(3,3,6)
semilogy(mtraindate_q6, Smod_q6,'Linewidth',2)
hold on
semilogy(mtraindate_q6, Emod_q6,'Linewidth',2)
hold on
semilogy(mtraindate_q6, Immod_q6,'Linewidth',2)
hold on
semilogy(mtraindate_q6, Ihmod_q6,'Linewidth',2)
% hold on
% semilogy(mtraindate_q6, Rmod_q6,'Linewidth',2)
% hold on
% semilogy(mtraindate_q6, V1mod_q6,'Linewidth',2)
% hold on
% semilogy(mtraindate_q6, V2mod_q6,'Linewidth',2)
% hold on
% semilogy(mtraindate_q6, V3mod_q6,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R-V123 model: Q6')

% Q7 period
subplot(3,3,7)
semilogy(mtraindate_q7, Smod_q7,'Linewidth',2)
hold on
semilogy(mtraindate_q7, Emod_q7,'Linewidth',2)
hold on
semilogy(mtraindate_q7, Immod_q7,'Linewidth',2)
hold on
semilogy(mtraindate_q7, Ihmod_q7,'Linewidth',2)
hold on
semilogy(mtraindate_q7, Rmod_q7,'Linewidth',2)
% hold on
% semilogy(mtraindate_q7, V1mod_q7,'Linewidth',2)
% hold on
% semilogy(mtraindate_q7, V2mod_q7,'Linewidth',2)
% hold on
% semilogy(mtraindate_q7, V3mod_q7,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q7')

% Q8 period
subplot(3,3,8)
semilogy(mtraindate_q8, Smod_q8,'Linewidth',2)
hold on
semilogy(mtraindate_q8, Emod_q8,'Linewidth',2)
hold on
semilogy(mtraindate_q8, Immod_q8,'Linewidth',2)
hold on
semilogy(mtraindate_q8, Ihmod_q8,'Linewidth',2)
hold on
semilogy(mtraindate_q8, Rmod_q8,'Linewidth',2)
% hold on
% semilogy(mtraindate_q8, V1mod_q8,'Linewidth',2)
% hold on
% semilogy(mtraindate_q8, V2mod_q8,'Linewidth',2)
% hold on
% semilogy(mtraindate_q8, V3mod_q8,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q8')

% Q9 period
subplot(3,3,9)
semilogy(mtraindate_q9, Smod_q9,'Linewidth',2)
hold on
semilogy(mtraindate_q9, Emod_q9,'Linewidth',2)
hold on
semilogy(mtraindate_q9, Immod_q9,'Linewidth',2)
hold on
semilogy(mtraindate_q9, Ihmod_q9,'Linewidth',2)
hold on
semilogy(mtraindate_q9, Rmod_q9,'Linewidth',2)
% hold on
% semilogy(mtraindate_q7, V1mod_q7,'Linewidth',2)
% hold on
% semilogy(mtraindate_q7, V2mod_q7,'Linewidth',2)
% hold on
% semilogy(mtraindate_q7, V3mod_q7,'Linewidth',2)
hold off
datetick('x','mmm-dd','keeplimits')
title('S-E-I_M-I_H-R model: Q9')

xlabel('Onset Date'),ylabel('Number of Individuals')
hL=legend({'Susceptible','Exposed','Infectious(M)','Infectious(H)','Recovered'}); %'FirstDose', 'SecondDose', 'SingleDose'
newPosition = [0.9 0.8 0.1 0.1];
set(hL,'Position', newPosition,'Units', 'normalized', 'Fontsize',11);
set(gca,'FontSize',12)

saveas(gcf,mynewfigname5)
saveas(gcf,mynewpngname5)

%% 6) Individual IM plots
% Naming of figures for the fit
mynewfigname6 = strcat('mcases',int2str(filecount+1),'.fig');
mynewpngname6 = strcat('mcases',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
bar(period_q1, IMdata_q1,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q1, ma_Imtrain1, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q1, monitored_q1,'Color',color_model,'Linewidth',2)
hold on
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q1')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q2 period
subplot(3,3,2)
bar(period_q2, IMdata_q2,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q2, ma_Imtrain2, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q2, monitored_q2,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q3')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q3 period
subplot(3,3,3)
bar(period_q3, IMdata_q3,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q3, ma_Imtrain3, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q3, monitored_q3,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q3')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q4 period
subplot(3,3,4)
bar(period_q4, IMdata_q4,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q4, ma_Imtrain4, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q4, monitored_q4,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q4')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q5 period
subplot(3,3,5)
bar(period_q5, IMdata_q5,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q5, ma_Imtrain5, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q5, monitored_q5,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q5')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q6 period
subplot(3,3,6)
bar(period_q6, IMdata_q6,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q6, ma_Imtrain6, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q6, monitored_q6,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q6')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q7 period
subplot(3,3,7)
bar(period_q7, IMdata_q7,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q7, ma_Imtrain7, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q7, monitored_q7,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q7')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q8 period
subplot(3,3,8)
bar(period_q8, IMdata_q8,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q8, ma_Imtrain8, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q8, monitored_q8,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q8')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')

% Q9 period
subplot(3,3,9)
bar(period_q9, IMdata_q9,'FaceColor',color_monit,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q9, ma_Imtrain9, 'Color', color_monitra, 'LineWidth', 2)
    hold on
end
plot(mtraindate_q9, monitored_q9,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Monitored): Q9')
xlabel('Onset Date'),ylabel('Daily Asymptomatic-Mild patients')


if ma_data == true
    hL=legend({'daily data','running ave','model'});
else
    hL=legend({'daily data','model'});
end
newPosition = [0.9 0.8 0.1 0.1];
set(hL,'Position', newPosition,'Units', 'normalized', 'Fontsize',13);

saveas(gcf,mynewfigname6)
saveas(gcf,mynewpngname6)

%% 7) Individual IH plots
% Naming of figures for the fit
mynewfigname7 = strcat('hcases',int2str(filecount+1),'.fig');
mynewpngname7 = strcat('hcases',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
bar(period_q1, IHdata_q1,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q1, ma_Ihtrain1, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q1, hospitalized_q1,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q1')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q2 period
subplot(3,3,2)
bar(period_q2, IHdata_q2,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q2, ma_Ihtrain2, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q2, hospitalized_q2,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q2')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q3 period
subplot(3,3,3)
bar(period_q3, IHdata_q3,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q3, ma_Ihtrain3, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q3, hospitalized_q3,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q1')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q4 period
subplot(3,3,4)
bar(period_q4, IHdata_q4,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q4, ma_Ihtrain4, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q4, hospitalized_q4,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q4')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q5 period
subplot(3,3,5)
bar(period_q5, IHdata_q5,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q5, ma_Ihtrain5, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q5, hospitalized_q5,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q5')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q6 period
subplot(3,3,6)
bar(period_q6, IHdata_q6,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q6, ma_Ihtrain6, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q6, hospitalized_q6,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q6')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q7 period
subplot(3,3,7)
bar(period_q7, IHdata_q7,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q7, ma_Ihtrain7, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q7, hospitalized_q7,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q7')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q8 period
subplot(3,3,8)
bar(period_q8, IHdata_q8,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q8, ma_Ihtrain8, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q8, hospitalized_q8,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q8')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')

% Q9 period
subplot(3,3,9)
bar(period_q9, IHdata_q9,'FaceColor',color_hosp,'EdgeColor','none')
hold on
if ma_data == true
    plot(period_q9, ma_Ihtrain9, 'Color', color_hospra, 'LineWidth', 2)
    hold on
end
plot(htraindate_q9, hospitalized_q9,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Infectious (Hospitalized): Q9')
xlabel('Onset Date'),ylabel('Daily Moderate-Critical patients')


if ma_data == true
    hL=legend({'daily data','running ave','model'});
else
    hL=legend({'daily data','model'});
end
newPosition = [0.9 0.8 0.1 0.1];
set(hL,'Position', newPosition,'Units', 'normalized', 'Fontsize',13);

saveas(gcf,mynewfigname7)
saveas(gcf,mynewpngname7)

%% 8) Plot the residuals: IM
% Naming of figures for residuals
mynewfigname8 = strcat('residuals_IM',int2str(filecount+1),'.fig');
mynewpngname8 = strcat('residuals_IM',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
stem(mtraindate_q1,residM_q1,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q1')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q2 period
subplot(3,3,2)
stem(mtraindate_q2,residM_q2,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q2')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q3 period
subplot(3,3,3)
stem(mtraindate_q3,residM_q3,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q3')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q4 period
subplot(3,3,4)
stem(mtraindate_q4,residM_q4,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q4')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q5 period
subplot(3,3,5)
stem(mtraindate_q5,residM_q5,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q5')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q6 period
subplot(3,3,6)
stem(mtraindate_q6,residM_q6,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q6')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q7 period
subplot(3,3,7)
stem(mtraindate_q7,residM_q7,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q7')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q8 period
subplot(3,3,8)
stem(mtraindate_q8,residM_q8,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q8')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q9 period
subplot(3,3,9)
stem(mtraindate_q9,residM_q9,'Linewidth',1.1,'Color',color_monit)
ylabel('model vs I_M cases: Q9')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

saveas(gcf,mynewfigname8)
saveas(gcf,mynewpngname8)

%% 9) Plot the residuals : IH
% Naming of figures for residuals
mynewfigname9 = strcat('residuals_IH',int2str(filecount+1),'.fig');
mynewpngname9 = strcat('residuals_IH',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
stem(htraindate_q1,residH_q1,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q1')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q2 period
subplot(3,3,2)
stem(htraindate_q2,residH_q2,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q2')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q3 period
subplot(3,3,3)
stem(htraindate_q3,residH_q3,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q3')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q4 period
subplot(3,3,4)
stem(htraindate_q4,residH_q4,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q4')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q5 period
subplot(3,3,5)
stem(htraindate_q5,residH_q5,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q5')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q6 period
subplot(3,3,6)
stem(htraindate_q6,residH_q6,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q6')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q7 period
subplot(3,3,7)
stem(htraindate_q7,residH_q7,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q7')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q8 period
subplot(3,3,8)
stem(htraindate_q8,residH_q8,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q8')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

% Q9 period
subplot(3,3,9)
stem(htraindate_q9,residH_q9,'Linewidth',1.1,'Color',color_hosp)
ylabel('model vs I_H cases: Q9')
set(gca,'FontSize', 14)
datetick('x','mmm-dd-yy','keeplimits')

saveas(gcf,mynewfigname9)
saveas(gcf,mynewpngname9)

%% 10) Deaths plots
% Naming of figures for the fit
mynewfigname10 = strcat('deaths',int2str(filecount+1),'.fig');
mynewpngname10 = strcat('deaths',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
bar(period_q1, Ddata_q1,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q1, deaths_q1,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q1')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q2 period
subplot(3,3,2)
bar(period_q2, Ddata_q2,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q2, deaths_q2,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q2')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q3 period
subplot(3,3,3)
bar(period_q3, Ddata_q3,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q3, deaths_q3,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q3')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q4 period
subplot(3,3,4)
bar(period_q4, Ddata_q4,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q4, deaths_q4,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q4')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q5 period
subplot(3,3,5)
bar(period_q5, Ddata_q5,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q5, deaths_q5,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q5')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q6 period
subplot(3,3,6)
bar(period_q6, Ddata_q6,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q6, deaths_q6,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q6')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q7 period
subplot(3,3,7)
bar(period_q7, Ddata_q7,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q7, deaths_q7,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q7')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q8 period
subplot(3,3,8)
bar(period_q8, Ddata_q8,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q8, deaths_q8,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q8')
xlabel('Time (days)'),ylabel('Daily deaths')

% Q9 period
subplot(3,3,9)
bar(period_q9, Ddata_q9,'FaceColor',color_dmod,'EdgeColor','none')
hold on
plot(dtraindate_q9, deaths_q9,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Deaths: Q9')
xlabel('Time (days)'),ylabel('Daily deaths')

hL=legend({'daily data','model'});
newPosition = [0.9 0.8 0.1 0.1];
set(hL,'Position', newPosition,'Units', 'normalized', 'Fontsize',13);

saveas(gcf,mynewfigname10)
saveas(gcf,mynewpngname10)

%% 11) Recovered plots
% Naming of figures for the fit
mynewfigname11 = strcat('recovered',int2str(filecount+1),'.fig');
mynewpngname11 = strcat('recovered',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
bar(period_q1, Rdata_q1,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q1, recovered_q1,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q1')
xlabel('Time (days)'),ylabel('Daily recoveries')

% Q2 period
subplot(3,3,2)
bar(period_q2, Rdata_q2,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q2, recovered_q2,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q2')
xlabel('Time (days)'),ylabel('Daily recoveries')

% Q3 period
subplot(3,3,3)
bar(period_q3, Rdata_q3,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q3, recovered_q3,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q3')
xlabel('Time (days)'),ylabel('Daily recoveries')

% Q4 period
subplot(3,3,4)
bar(period_q4, Rdata_q4,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q4, recovered_q4,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q4')
xlabel('Time (days)'),ylabel('Daily recoveries')

% Q5 period
subplot(3,3,5)
bar(period_q5, Rdata_q5,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q5, recovered_q5,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q5')
xlabel('Time (days)'),ylabel('Daily recoveries')

% Q6 period
subplot(3,3,6)
bar(period_q6, Rdata_q6,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q6, recovered_q6,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q6')
xlabel('Time (days)'),ylabel('Daily recoveries')


% Q7 period
subplot(3,3,7)
bar(period_q7, Rdata_q7,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q7, recovered_q7,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q7')
xlabel('Time (days)'),ylabel('Daily recoveries')

% Q8 period
subplot(3,3,8)
bar(period_q8, Rdata_q8,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q8, recovered_q8,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q8')
xlabel('Time (days)'),ylabel('Daily recoveries')

% Q9 period
subplot(3,3,9)
bar(period_q9, Rdata_q9,'FaceColor',color_recov,'EdgeColor','none')
hold on
plot(rtraindate_q9, recovered_q9,'Color',color_model,'Linewidth',2)
datetick('x','mmm-dd-yy','keeplimits')
title('Daily COVID-19 Recoveries: Q9')
xlabel('Time (days)'),ylabel('Daily recoveries')

hL=legend({'daily data','model'});
newPosition = [0.9 0.8 0.1 0.1];
set(hL,'Position', newPosition,'Units', 'normalized', 'Fontsize',11);

saveas(gcf,mynewfigname11)
saveas(gcf,mynewpngname11)

%% 12) Rt plot
% Naming of figures for residuals
mynewfigname12 = strcat('Rt',int2str(filecount+1),'.fig');
mynewpngname12 = strcat('Rt',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

% Q1 period
subplot(3,3,1)
plot(mtraindate_q1, Rt_q1,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q1')
datetick('x','mmm-dd-yy','keeplimits')

% Q2 period
subplot(3,3,2)
plot(mtraindate_q2, Rt_q2,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q2')
datetick('x','mmm-dd-yy','keeplimits')

% Q3 period
subplot(3,3,3)
plot(mtraindate_q3, Rt_q3,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q3')
datetick('x','mmm-dd-yy','keeplimits')

% Q4 period
subplot(3,3,4)
plot(mtraindate_q4, Rt_q4,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q4')
datetick('x','mmm-dd-yy','keeplimits')

% Q5 period
subplot(3,3,5)
plot(mtraindate_q5, Rt_q5,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q5')
datetick('x','mmm-dd-yy','keeplimits')

% Q6 period
subplot(3,3,6)
plot(mtraindate_q6, Rt_q6,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q6')
datetick('x','mmm-dd-yy','keeplimits')

% Q7 period
subplot(3,3,7)
plot(mtraindate_q7, Rt_q7,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q7')
datetick('x','mmm-dd-yy','keeplimits')

% Q8 period
subplot(3,3,8)
plot(mtraindate_q8, Rt_q8,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q8')
datetick('x','mmm-dd-yy','keeplimits')

% Q9 period
subplot(3,3,9)
plot(mtraindate_q9, Rt_q9,'Color',color_model,'Linewidth',2)
xlabel('Time (days)')
ylabel('R_t')
title('Time-varying Reproduction Number: Q9')
datetick('x','mmm-dd-yy','keeplimits')

saveas(gcf,mynewfigname12)
saveas(gcf,mynewpngname12)

%% 13) Model vs % data
% Naming of figures for the fit
mynewfigname13 = strcat('combineddata',int2str(filecount+1),'.fig');
mynewpngname13 = strcat('combineddata',int2str(filecount+1),'.png');

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
set(gcf, 'Color', 'white')

percentIMdata_q1 = IMdata_q1./max(data_m);
percentIMdata_q2 = IMdata_q2./max(data_m);
percentIMdata_q3 = IMdata_q3./max(data_m);
percentIMdata_q4 = IMdata_q4./max(data_m);
percentIMdata_q5 = IMdata_q5./max(data_m);
percentIMdata_q6 = IMdata_q6./max(data_m);
percentIMdata_q7 = IMdata_q7./max(data_m);
percentIMdata_q8 = IMdata_q8./max(data_m);
percentIMdata_q9 = IMdata_q9./max(data_m);

modpercentIMdata_q1 = monitored_q1./max(data_m);
modpercentIMdata_q2 = monitored_q2./max(data_m);
modpercentIMdata_q3 = monitored_q3./max(data_m);
modpercentIMdata_q4 = monitored_q4./max(data_m);
modpercentIMdata_q5 = monitored_q5./max(data_m);
modpercentIMdata_q6 = monitored_q6./max(data_m);
modpercentIMdata_q7 = monitored_q7./max(data_m);
modpercentIMdata_q8 = monitored_q8./max(data_m);
modpercentIMdata_q9 = monitored_q9./max(data_m);

percentIHdata_q1 = IHdata_q1./18;%max(data_h);
percentIHdata_q2 = IHdata_q2./18;%max(data_h);
percentIHdata_q3 = IHdata_q3./18;%max(data_h);
percentIHdata_q4 = IHdata_q4./18;%max(data_h);
percentIHdata_q5 = IHdata_q5./18;%max(data_h);
percentIHdata_q6 = IHdata_q6./18;%max(data_h);
percentIHdata_q7 = IHdata_q7./18;%max(data_h);
percentIHdata_q8 = IHdata_q8./18;%max(data_h);
percentIHdata_q9 = IHdata_q9./18;%max(data_h);


modpercentIHdata_q1 = hospitalized_q1./18;%max(data_h);
modpercentIHdata_q2 = hospitalized_q2./18;%max(data_h);
modpercentIHdata_q3 = hospitalized_q3./18;%max(data_h);
modpercentIHdata_q4 = hospitalized_q4./18;%max(data_h);
modpercentIHdata_q5 = hospitalized_q5./18;%max(data_h);
modpercentIHdata_q6 = hospitalized_q6./18;%max(data_h);
modpercentIHdata_q7 = hospitalized_q7./18;%max(data_h);
modpercentIHdata_q8 = hospitalized_q8./18;%max(data_h);
modpercentIHdata_q9 = hospitalized_q9./18;%max(data_h);

t = tiledlayout(2,1);
% 1a. I_M cases
nexttile
% bar(period_q1, percentIMdata_q1,'FaceColor',color_monit,'EdgeColor','none')
% hold on
% plot(mtraindate_q1, modpercentIMdata_q1,'Color',color_model,'Linewidth',2)
% hold on

bar(period_q2, percentIMdata_q2,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q2, modpercentIMdata_q2,'Color',color_model,'Linewidth',2)
hold on

bar(period_q3, percentIMdata_q3,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q3, modpercentIMdata_q3,'Color',color_model,'Linewidth',2)

bar(period_q4, percentIMdata_q4,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q4, modpercentIMdata_q4,'Color',color_model,'Linewidth',2)
hold on

bar(period_q5, percentIMdata_q5,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q5, modpercentIMdata_q5,'Color',color_model,'Linewidth',2)
hold on

bar(period_q6, percentIMdata_q6,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q6, modpercentIMdata_q6,'Color',color_model,'Linewidth',2)
hold on

bar(period_q7, percentIMdata_q7,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q7, modpercentIMdata_q7,'Color',color_model,'Linewidth',2)
hold on

bar(period_q8, percentIMdata_q8,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q8, modpercentIMdata_q8,'Color',color_model,'Linewidth',2)
hold on

bar(period_q9, percentIMdata_q9,'FaceColor',color_monit,'EdgeColor','none')
hold on
plot(mtraindate_q9, modpercentIMdata_q9,'Color',color_model,'Linewidth',2)


% line1=[mtraindate_q1(end) 0;mtraindate_q1(end) 1];
% plot(line1(:,1),line1(:,2),'k--','LineWidth',2)
line2=[mtraindate_q2(end) 0;mtraindate_q2(end) 1];
plot(line2(:,1),line2(:,2),'k--','LineWidth',2)
line3=[mtraindate_q3(end) 0;mtraindate_q3(end) 1];
plot(line3(:,1),line3(:,2),'k--','LineWidth',2)
line4=[mtraindate_q4(end) 0;mtraindate_q4(end) 1];
plot(line4(:,1),line4(:,2),'k--','LineWidth',2)
line5=[mtraindate_q5(end) 0;mtraindate_q5(end) 1];
plot(line5(:,1),line5(:,2),'k--','LineWidth',2)
line6=[mtraindate_q6(end) 0;mtraindate_q6(end) 1];
plot(line6(:,1),line6(:,2),'k--','LineWidth',2)
line7=[mtraindate_q7(end) 0;mtraindate_q7(end) 1];
plot(line7(:,1),line7(:,2),'k--','LineWidth',2)
line8=[mtraindate_q8(end) 0;mtraindate_q8(end) 1];
plot(line8(:,1),line8(:,2),'k--','LineWidth',2)

title(strcat('Model Fitting of Asymptomatic-Mild Infectious Individuals in ',{' '},city))
legend({'data','model'},'Fontsize',12,'Location','Northwest')
set(gca,'FontSize',13,'XTick',[])

% IH cases
nexttile
% bar(period_q1, percentIHdata_q1,'FaceColor',color_hosp,'EdgeColor','none')
% hold on
% plot(htraindate_q1, modpercentIHdata_q1,'Color',color_model,'Linewidth',2)
% hold on

bar(period_q2, percentIHdata_q2,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q2, modpercentIHdata_q2,'Color',color_model,'Linewidth',2)
hold on

bar(period_q3, percentIHdata_q3,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q3, modpercentIHdata_q3,'Color',color_model,'Linewidth',2)
hold on

bar(period_q4, percentIHdata_q4,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q4, modpercentIHdata_q4,'Color',color_model,'Linewidth',2)
hold on

bar(period_q5, percentIHdata_q5,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q5, modpercentIHdata_q5,'Color',color_model,'Linewidth',2)
hold on

bar(period_q6, percentIHdata_q6,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q6, modpercentIHdata_q6,'Color',color_model,'Linewidth',2)
hold on

bar(period_q7, percentIHdata_q7,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q7, modpercentIHdata_q7,'Color',color_model,'Linewidth',2)
hold on

bar(period_q8, percentIHdata_q8,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q8, modpercentIHdata_q8,'Color',color_model,'Linewidth',2)
hold on

bar(period_q9, percentIHdata_q9,'FaceColor',color_hosp,'EdgeColor','none')
hold on
plot(htraindate_q9, modpercentIHdata_q9,'Color',color_model,'Linewidth',2)

% line1=[htraindate_q1(end) 0;htraindate_q1(end) 1];
% plot(line1(:,1),line1(:,2),'k--','LineWidth',2)
line2=[htraindate_q2(end) 0;htraindate_q2(end) 1];
plot(line2(:,1),line2(:,2),'k--','LineWidth',2)
line3=[htraindate_q3(end) 0;htraindate_q3(end) 1];
plot(line3(:,1),line3(:,2),'k--','LineWidth',2)
line4=[htraindate_q4(end) 0;htraindate_q4(end) 1];
plot(line4(:,1),line4(:,2),'k--','LineWidth',2)
line5=[htraindate_q5(end) 0;htraindate_q5(end) 1];
plot(line5(:,1),line5(:,2),'k--','LineWidth',2)
line6=[htraindate_q6(end) 0;htraindate_q6(end) 1];
plot(line6(:,1),line6(:,2),'k--','LineWidth',2)
line7=[htraindate_q7(end) 0;htraindate_q7(end) 1];
plot(line7(:,1),line7(:,2),'k--','LineWidth',2)
line8=[htraindate_q8(end) 0;htraindate_q8(end) 1];
plot(line8(:,1),line8(:,2),'k--','LineWidth',2)

title(strcat('Model Fitting of Moderate-Critical Infectious Individuals in ',{' '},city))
legend({'data','model'},'Fontsize',12,'Location','Northwest')
set(gca,'FontSize',13,'XTickLabelRotation',45)

datetick('x','mmm-dd-yy','keeplimits')
xlabel(t,'Onset Date','FontSize',13),ylabel(t,'Daily number of COVID-19 patients (%)','FontSize',13)

saveas(gcf,mynewfigname13)
saveas(gcf,mynewpngname13)

% %% 14) Vaccination plots
% % Naming of figures for the fit
% mynewfigname14 = strcat('vaccination',int2str(filecount+1),'.fig');
% mynewpngname14 = strcat('vaccination',int2str(filecount+1),'.png');
% 
% figure
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
% set(gcf, 'Color', 'white')
% 
% % first dose
% subplot(2,3,1)
% bar(period_q6, V1data_q6,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q6, vax1_q6,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily First Dose Vaccination: Q6')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % second dose
% subplot(2,3,2)
% bar(period_q6, V2data_q6,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v2traindate_q6, vax2_q6,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily second dose Vaccination: Q6')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % Single dose vaccination
% subplot(2,3,3)
% bar(period_q6, V3data_q6,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v3traindate_q6, vax3_q6,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily Single dose Vaccination: Q6')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % first dose
% subplot(2,3,4)
% bar(period_q7, V1data_q7,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q7, vax1_q7,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily First Dose Vaccination: Q7')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % second dose
% subplot(2,3,5)
% bar(period_q7, V2data_q7,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v2traindate_q7, vax2_q7,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily second dose Vaccination: Q7')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % Single dose vaccination
% subplot(2,3,6)
% bar(period_q7, V3data_q7,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v3traindate_q7, vax3_q7,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily Single dose Vaccination: Q7')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% hL=legend({'daily data','model'});
% newPosition = [0.9 0.8 0.1 0.1];
% set(hL,'Position', newPosition,'Units', 'normalized', 'Fontsize',11);
% 
% saveas(gcf,mynewfigname14)
% saveas(gcf,mynewpngname14)
% 
% %% 15) Vaccination1 exploratory plots
% % Naming of figures for the fit
% mynewfigname15 = strcat('vaccination1',int2str(filecount+1),'.fig');
% mynewpngname15 = strcat('vaccination1',int2str(filecount+1),'.png');
% 
% figure
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 1]);
% set(gcf, 'Color', 'white')
% 
% % first dose q1
% subplot(2,3,1)
% bar(period_q1, V1data_q1,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q1, vax1_q1,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily First Dose Vaccination: Q1')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % first dose q2
% subplot(2,3,2)
% bar(period_q2, V1data_q2,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q2, vax1_q2,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily second dose Vaccination1: Q2')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % Single dose vaccination
% subplot(2,3,3)
% bar(period_q3, V1data_q3,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q3, vax1_q3,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily Vaccination1: Q3')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % Single dose vaccination q4
% subplot(2,3,4)
% bar(period_q4, V1data_q4,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q4, vax1_q4,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily Vaccination1: Q4')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % Single dose vaccination q5
% subplot(2,3,5)
% bar(period_q5, V1data_q5,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q5, vax1_q5,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily Vaccination1: Q5')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% % Single dose vaccination q6
% subplot(2,3,6)
% bar(period_q6, V1data_q6,'FaceColor',color_recov,'EdgeColor','none')
% hold on
% plot(v1traindate_q6, vax1_q6,'Color',color_model,'Linewidth',2)
% datetick('x','mmm-dd-yy','keeplimits')
% title('Daily Vaccination1: Q6')
% xlabel('Time (days)'),ylabel('Daily Vaccination')
% 
% hL=legend({'daily data','model'});
% newPosition = [0.9 0.8 0.1 0.1];
% set(hL,'Position', newPosition,'Units', 'normalized', 'Fontsize',11);
% 
% saveas(gcf,mynewfigname15)
% saveas(gcf,mynewpngname15)


cd(myworkingdir)