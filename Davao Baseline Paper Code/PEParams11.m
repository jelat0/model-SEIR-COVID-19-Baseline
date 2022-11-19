function PEParams11(inputCaseInfo11, RPCName, HDCMName, ...
            dateCuts, inputCityParams, areaPop)

% Fixed parameter values
beta = 0.1; % transmission rate, placeholder
psi = 1/14; % duration from quarantine to graduation
phiH = 1/5; % rate of mild symptomatic indv becoming severe
r = 0.1; % reporting rate, placeholder
alpha = 69.8379; % recruitment rate
delta = 1/26017.2; % natural death rate
% Delta is from https://population.un.org/wpp/Download/Standard/Population/

% Getting parameter values based from data
currDir = cd;
cd('data');
[deltaMVals, gammaMVals, deltaHVals, ...
            gammaHVals, muHVals, qVals, mVals] = PEParamsFromData11...
            (inputCaseInfo11, RPCName, HDCMName, ...
            dateCuts);

pset = zeros(13, length(deltaHVals));

% Assign parameters to vector element
% Note that the parameter set is a 2D matrix since we have parameters for
% each CQ/date cut
pset(1, :) = beta .* ones(1, length(dateCuts) - 1);
pset(2, :) = deltaHVals;
pset(3, :) = deltaMVals;
pset(4, :) = psi .* ones(1, length(dateCuts) - 1);
pset(5, :) = phiH .* ones(1, length(dateCuts) - 1);
pset(6, :) = gammaMVals;
pset(7, :) = gammaHVals;
pset(8, :) = muHVals;
pset(9, :) = r .* ones(1, length(dateCuts) - 1);
pset(10, :) = qVals;
pset(11, :) = mVals;
pset(12, :) = alpha .* ones(1, length(dateCuts) - 1);
pset(13, :) = delta .* ones(1, length(dateCuts) - 1);

% And saving the parameter file
save(inputCityParams, 'pset');
cd(currDir)

end