%calculate average G and S value based on intensity threshold
close all
clear all
%file reading
ref_file = uipickfiles;
num_file = size(ref_file,2);
G_total = zeros(num_file,1);
S_total = zeros(num_file,1);
for i = 1 : num_file
    filename = ref_file{i};
    [ref_int, G, S, ref_ph1, ref_md1] = ref_read(filename);

    %median filter for G and S
    G = medfilt2(G, [5 5]);
    S = medfilt2(S, [5 5]);

    %select only points above certain intensity
    int_min = 20;
    G(int_min > ref_int) = NaN;
    S(int_min > ref_int) = NaN;
    
    %calculate the mean G and S value
    G_total(i) = nanmean(G(:));
    S_total(i) = nanmean(S(:));
    
    G_matrix(:,i) = G(:);
    S_matrix(:,i) = S(:);
end

%plot boxplot
figure
subplot(2,1,1)
boxplot(G_matrix)
title('G boxplot')
subplot(2,1,2)
boxplot(S_matrix)
title('S boxplot')
%plot phasor
figure
s_color = linspace(1,10,num_file);
scatter(G_total,S_total,[],s_color,'filled')
