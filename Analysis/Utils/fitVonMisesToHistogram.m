function fitVonMisesToHistogram(data, nbins)
    % Fit a von Mises distribution to the data
    % Compute the mean direction
    theta_bar = circ_mean(data);
    
    % Compute the resultant length
    R = circ_r(data);
    
    % Estimate the concentration parameter kappa
    kappa = circ_kappa(R);
    
    % Generate the histogram
    figure()
    histogram(data, nbins, 'Normalization', 'pdf');
    hold on;
    
    % Define the range for plotting the von Mises distribution
    x = linspace(-pi, pi, 100);
    
    % Evaluate the PDF of the fitted von Mises distribution
    y = exp(kappa * cos(x - theta_bar)) / (2 * pi * besseli(0, kappa));
    
    % Plot the PDF
    plot(x, y, 'LineWidth', 2);
    hold off;
    
    % Add labels and title
    xlabel('Data');
    ylabel('Density');
    title(sprintf('Kappa = %.2f', kappa));
end
