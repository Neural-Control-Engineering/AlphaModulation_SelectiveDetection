function mu = circ_mean(alpha)
    % Compute the circular mean direction
    sin_sum = sum(sin(alpha));
    cos_sum = sum(cos(alpha));
    mu = atan2(sin_sum, cos_sum);
end