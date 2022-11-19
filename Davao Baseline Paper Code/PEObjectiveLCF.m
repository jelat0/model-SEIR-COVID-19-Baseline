% A Function that will solve the ODE model to obtain cumulative cases/incidence

function APPENDSOLN = PEObjectiveLCF(p0,xDataLCF,paramIdx,paramset,pop,data4Est,data2use)

% Assign the initial values to the parameters that needed to be estimated
k=1;
for i=1:length(p0)
    paramset(paramIdx(k)) = p0(i);
    k=k+1;
end

% Assign the values (from the parameter set) to variable names here
E0 = paramset(15);
Im0 = paramset(16);
Ih0 = paramset(17);
R0 = paramset(18);
M0 = paramset(19);
H0 = paramset(20);
D0 = paramset(21);
% V10 = paramset(33);
% V20 = paramset(34);
% V30 = paramset(35);

S0 = pop - (E0 + Im0 + Ih0 + R0 + D0 );

init = [S0 E0 Im0 Ih0 R0 M0 H0 D0 ];

timeVect = xDataLCF(1:(length(xDataLCF)/length(data2use)));

options = odeset('Reltol',1e-12,'Abstol',1e-12);
[~, sol] = ode45(@BaselineModel,timeVect,init,options,paramset);

% Defining the output of the least-squares function
APPENDSOLN = zeros(size(data4Est));
for k = 1:2
    modelSoln = sol(:, k+5);
    modelDiff = [modelSoln(1); diff(modelSoln)].';
    APPENDSOLN(:, k) = modelDiff;
end

APPENDSOLN = reshape(APPENDSOLN, 1, numel(APPENDSOLN));

end
