function RepNo = PERepNo(paramset)

    % Reproduction number
    beta = paramset(1);
    deltaH = paramset(2);
    deltaM = paramset(3);
    psi = paramset(4);
    phiH = paramset(5);
    gammaM = paramset(6);
    gammaH = paramset(7);
    muH = paramset(8);
    r = paramset(9);
    q = paramset(10);
    m = paramset(11);
    alpha = paramset(12);
    delta = paramset(13);

    % Basic Rep. No equation:
    W = psi*(1-r) + deltaH*r*q + deltaM*r*(1-q)+ delta; %A
    X = phiH*m + gammaM*(1-m) + delta;  %B
    Y = gammaH + muH + delta;  %C

    RepNo = (beta*deltaM*r*(1-q)*Y + beta*(deltaH*r*q*X + phiH*m*deltaM*r*...
        (1-q)))/(W*X*Y);

end