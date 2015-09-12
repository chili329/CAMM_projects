%load multiple files, boxplot the free-bound ratio for pixels in each file
close all
clear all
ref_file = uipickfiles;
pRatio = NaN(256,256,length(ref_file));

%specify free/bound location (G,S)
free = [0.9,0.3];
bound = [0.3,0.5];
    
for k = 1 : length(ref_file)
    filename = ref_file{k};
    %save filenames
    filenames = strsplit(filename,'/');
    filenames = filenames(end);
    filenames = filenames{1};
    filenames = filenames(1:(end-9));
    files{k} = filenames;
    
    [ref_int, G, S, ref_ph1, ref_md1] = ref_read(filename);

    %median filter for G and S
    G = medfilt2(G, [5 5]);
    S = medfilt2(S, [5 5]);

    %select only points above certain intensity
    int_min = 30;

    new_int = ref_int;
    new_S = S;
    new_G = G;

    new_S(new_int<int_min) = NaN;
    new_G(new_int<int_min) = NaN;
    new_int(new_int<int_min) = NaN;

    for i = 1:256
        for j = 1:256
            p = [new_G(i,j),new_S(i,j)];
            if isnan(p(1)) == 0
                pRatio(i,j,k) = projFLIM(p,free,bound);
            end
        end
    end
end

pRatio = reshape(pRatio,[256*256,length(ref_file)]);
%0: all free
%100: all bound
boxplot(pRatio,'labels',files)
%hLegend = legend(findall(gca,'Tag','Box'),files);
title('free(0) bound(100) ratio')