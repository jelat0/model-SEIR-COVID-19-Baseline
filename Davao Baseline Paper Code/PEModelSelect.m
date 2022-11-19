function [ModSelect] = PEModelSelect(dataDivM, dataDivH, param2est, SSEm, SSEh)

% Akaike Information Criteria
Nm = length(dataDivM); %No. of data points
Nh = length(dataDivH);

s = length(param2est); %No. of parameters fitted 

% AIC Rule of Thumb: n/K >= 40
Rule_m = Nm/s; %For monitored
Rule_h = Nh/s; %For hospitalized

% AIC equation
AIC_m = Nm*log(SSEm/Nm)+2*(s+1); %For monitored
AIC_h = Nh*log(SSEh/Nh)+2*(s+1); %For hospitalized

% AICc equation e.g. if n/K < 40
AICc_m = AIC_m + (2*s*(s+1))/(Nm-s-1); %For monitored
AICc_h = AIC_h + (2*s*(s+1))/(Nh-s-1); %For hospitalized

% Bayesian Information Criteria
BIC_m = Nm*log(SSEm/Nm)+ (s+1)*log(Nm)/Nm;
BIC_h = Nh*log(SSEh/Nh)+ (s+1)*log(Nh)/Nh; 

Rule = [Rule_m, Rule_h];
AIC = [AIC_m, AIC_h];
AICc = [AICc_m, AICc_h];
BIC = [BIC_m, BIC_h];

% Store results to a new cell
ModSelect = [Rule, AIC, AICc, BIC];

end