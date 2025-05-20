function out = circ_ste(y)
    out = circ_std(y) ./ sqrt(sum(~isnan(y)));
end