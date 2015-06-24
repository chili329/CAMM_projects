%open one ref file and show its intensity and phasor

%calculate average G and S value based on intensity threshold
close all
clear all
%file reading
ref_file = uipickfiles;
ref_file = ref_file{1};
[ref_int, G, S, ref_ph1, ref_md1] = ref_read(ref_file);

%median filter for G and S
G = medfilt2(G, [5 5]);
S = medfilt2(S, [5 5]);

%select only points above certain intensity
int_min = 20;
G(int_min > ref_int) = NaN;
S(int_min > ref_int) = NaN;

%plot intensity
figure
imagesc(ref_int)
colormap gray
axis image

%plot histogram
figure
subplot(2,2,1)
hist(ref_int(:),[0:)
title('intensity histogram')
subplot(2,2,3)
histogram(G(:),[0:0.1:1])
title('G histogram')
subplot(2,2,4)
histogram(S(:),[0:0.1:1])
title('S histogram')

%plot phasor
plot_phasor(G,S)
