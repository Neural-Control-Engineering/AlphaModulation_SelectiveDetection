function [x,y, theta_bar, R, kappa] = vonMises(data)

    % Compute the mean direction
    theta_bar = circ_mean(data);
    
    % Compute the resultant length
    R = circ_r(data);
    
    % Estimate the concentration parameter kappa
    kappa = circ_kappa(R);

    % Define the range for plotting the von Mises distribution
    x = linspace(-pi, pi, 100);
    
    % Evaluate the PDF of the fitted von Mises distribution
    y = exp(kappa * cos(x - theta_bar)) / (2 * pi * besseli(0, kappa));

end