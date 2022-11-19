function [dstate] = BaselineModel(t, state, param)
% First COVID-19 model with two-type of vaccines and without logistic growth

% Assign values to the parameters
beta = param(1);
deltaH = param(2); 
deltaM = param(3);
psi = param(4);
phiH = param(5);
gammaM = param(6);
gammaH = param(7);
muH = param(8);
r = param(9);
q = param(10);
m = param(11);
alpha = param(12);
delta = param(13);
% theta1 = param(14);
% theta2 = param(15);
% theta3 = param(16);
% nu = param(17);
% omegaR = param(18);
% omega1 = param(19);
% omega2 = param(20);
% omega3 = param(21);
% epsilon1 = param(22);
% epsilon2 = param(23);
% epsilon3 = param(24);

% Assign values to the variables
S = state(1);
E = state(2);
Im = state(3);
Ih = state(4);
R = state(5);
M = state(6);
H = state(7);
D = state(8);
% V1 = state(9);
% V2 = state(10);
% V3 = state(11);
N = S + E + Im + Ih + R;

% Model Equations
dSdt = alpha ...
        - delta*S ...
        - (beta*Ih/N + beta*Im/N)*S ...
        + psi*(1-r)*E;
dEdt = (beta*Ih/N + beta*Im/N)*S ...
        - psi*(1-r)*E ...
        - deltaH*r*q*E ...
        - deltaM*r*(1-q)*E...
        - delta*E;
dImdt = deltaM*r*(1-q)*E ...
        - phiH*m*Im ...
        - gammaM*(1-m)*Im ...
        - delta*Im;
dIhdt = deltaH*r*q*E ...
        + phiH*m*Im ...
        - gammaH*Ih ...
        - muH*Ih ...
        - delta*Ih;
dRdt = gammaM*(1-m)*Im ...
        + gammaH*Ih ...
        - delta*R;
dMdt = deltaM*r*(1-q)*E;
dHdt = deltaH*r*q*E;
dDdt = muH*Ih;
% dV1dt = theta1*S ...
%         - omega1*(1-nu)*(1-epsilon1)*V1 ...
%         - theta2*nu ...
%         - delta*V1 ...
%         - epsilon1*(beta*Ih/N + beta*Im/N)*V1;
% dV2dt = theta2*nu*V1 ...
%         - omega2*(1-epsilon2)*V2 ...
%         - delta*V2 ...
%         - epsilon2*(beta*Ih/N + beta*Im/N)*V2;
% dV3dt = theta3*S ...
%         - omega3*(1-epsilon3)*V3 ...
%         - delta*V3 ...
%         - epsilon3*(beta*Ih/N + beta*Im/N)*V3;


% Create vector for state variables
dstate = zeros(8,1);

% Assign the equations to the model variables
dstate(1) = dSdt;
dstate(2) = dEdt;
dstate(3) = dImdt;
dstate(4) = dIhdt;
dstate(5) = dRdt;
dstate(6) = dMdt;
dstate(7) = dHdt;
dstate(8) = dDdt;
% dstate(9) = dV1dt;
% dstate(10) = dV2dt;
% dstate(11) = dV3dt;
