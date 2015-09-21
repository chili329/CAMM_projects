% %automatically select nucleus position for each frame
% %20150515: added cytoplasm segmentation
% 
clear all
close all

AR_ch = 3;
nuc_ch = 1;
frame_rate = 20; %seconds/frame

files = uipickfiles;
filename = files{1};
[pathstr,name,ext] = fileparts(filename);

%from LSM file
if strcmp(ext, '.lsm')
    [ch, lsminf] = lsm_read(filename);
elseif strcmp(ext, '.tif')
    %from OMEtiff file
    num_ch = 2;
    ch = OMEtiff_read(filename, num_ch);
end

mov_ori = ch{AR_ch};
nuc_ori = ch{nuc_ch};

%only takes a portion of frames
mov = mov_ori(:,:,1:130);
nuc = nuc_ori(:,:,1:130);
% 
time = size(mov,3);
both_int = zeros(time,2);

%nuc = nuc_segment(ch,fudgeFactor)
BW_nuc = nuc_segment(nuc,2,2);

%cytoplasm segmentation
BW_cyt = nuc_segment(mov,1);

figure
subplot(2,2,1), imagesc(mean(mov,3)), title('\fontsize{20}AR'), axis image;
subplot(2,2,2), imagesc(mean(nuc,3)), title('\fontsize{20}nucleus'), axis image;
subplot(2,2,3), imshow(BW_cyt(:,:,1)-BW_nuc(:,:,1)), title('\fontsize{20}cytoplasm mask'), axis image;
subplot(2,2,4), imshow(BW_nuc(:,:,1)), title('\fontsize{20}nucleus mask'), axis image;

%select nuleus, then cytoplasm
for i = 1:2
    if i == 1
        BW = BW_nuc;
    elseif i == 2
        BW = BW_cyt-BW_nuc;
        %BW = imcomplement(BW);
    end
    
    mean_int = zeros(time,1);
    
    %apply ROI selection to all frames
    for t = 1:time
        mov_roi = mov(:,:,t).*BW(:,:,t);
        total_int(t) = sum(sum(mov_roi));
        %correct bleaching by normalizing through overall average
        mean_int(t) = total_int(t)./mean(mean(mov(:,:,t)));
    end
    both_int(:,i) = mean_int;
end

%from tiff file
%mov = double(tiff2mat);
%nuc = double(tiff2mat);


%normalize by max
both_int = both_int./max(both_int(:));
figure
plot(frame_rate/60*(1:time),both_int(:,1),'color','k','linewidth',6)
hold on
plot(frame_rate/60*(1:time),both_int(:,2),'color','r','linewidth',6)
axis([0,time*frame_rate/60,0,1])
set(gca,'FontSize',32)%,title('\fontsize{20}nuc(k) cyto(r)')