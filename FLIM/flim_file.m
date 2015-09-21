%open one ref file and show its intensity and phasor

%calculate average G and S value based on intensity threshold
close all
clear all
%file reading
all_file = uipickfiles;
file_num = size(all_file,2);

%plot intensity + phasor
%figure('Position', [0, 0, 300, 150])
figure
for i = 1:file_num
    ref_file = all_file{i};
    [ref_int, G, S, ref_ph1, ref_md1] = ref_read(ref_file);

    %extract file name
    condition = strsplit(ref_file,'/');
    condition = condition(end);

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

    
    subplot(file_num,2,i*2-1)
    imagesc(new_int)
    colormap(gca,'gray')
    axis image
    title(condition)
    subplot(file_num,2,i*2)
    plot_phasor(new_G,new_S)
    set(gca,'color','white')
end

%plot intensity
% figure
% subplot(2,2,1)
% imagesc(ref_int)
% axis image
% title('original intensity')
% 
% subplot(2,2,2)
% imagesc(new_int)
% axis image
% title('intensity with threshold')
% 
% subplot(2,2,3)
% imagesc(new_S)
% caxis([0.2 0.8]) 
% axis image
% title('S')
% 
% subplot(2,2,4)
% imagesc(new_G)
% caxis([0.2 0.8])
% axis image
% title('G')
% colormap hot

%plot histogram
% figure
% subplot(2,2,1)
% hist(ref_int(:))
% title('intensity histogram')
% subplot(2,2,3)
% histogram(new_G(:),[0:0.1:1])
% title('G histogram')
% subplot(2,2,4)
% histogram(new_S(:),[0:0.1:1])
% title('S histogram')

%plot phasor
% plot_phasor(new_G,new_S)
