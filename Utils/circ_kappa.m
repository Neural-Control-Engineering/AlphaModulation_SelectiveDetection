function kappa = circ_kappa(R)
    % Estimate the concentration parameter kappa
    if R < 0.53
        kappa = 2*R + R^3 + (5*R^5)/6;
    elseif R < 0.85
        kappa = -0.4 + 1.39*R + 0.43/(1 - R);
    else
        kappa = 1/(R^3 - 4*R^2 + 3*R);
    end
end