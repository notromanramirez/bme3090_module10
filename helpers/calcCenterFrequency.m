function [cf, lower_wc, upper_wc] = calcCenterFrequency(labeledFrequency, nyquistFrequency)
    cf = labeledFrequency ./ nyquistFrequency;
    lower_wc = cf .* (1 - 0.4);
    upper_wc = cf .* (1 + 0.4);
end
