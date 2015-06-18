function [data] = consec_length(s)
    %use run-length encoding to find consecutive 1 (D_aa transition) 
    d_rle = rle(s==1);
    data = d_rle{2}(d_rle{1}==1);
end

