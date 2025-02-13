function R = circ_r(alpha)
    % Compute the resultant length
    N = length(alpha);
    sin_sum = sum(sin(alpha));
    cos_sum = sum(cos(alpha));
    R = sqrt(sin_sum^2 + cos_sum^2) / N;
end
