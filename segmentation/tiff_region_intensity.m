%ROI selection of images and get the averaged intensity over time
clear all
close all

%load AR: LSM
ch = 3;
z = 1;
mov = lsm_read(ch,z);

%load AR: TIFF
%mov = double(tiff2mat);
time = size(mov,3);
both_int = zeros(time,2);

%use the first frame
%I = imagesc(mov(:,:,1));
%use average frame
I = imagesc(mean(mov,3));
colormap(gray)
axis image

total_selection = 1;

if total_selection == 1
    %select ROI
    BW1 = roipoly;
    BW = repmat(BW1,[1 1 time]);
    %mean_int = zeros(time,1);
elseif total_selection == 0
    %load channel for nuclear segmentation (SiR-tubulin?)
    %use nuc_segment
    mov_seg = double(tiff2mat);
    mov_seg = mov;
    fudgeFactor = 1.5;
    BW = nuc_segment(mov_seg,fudgeFactor);
end

%apply ROI selection to all frames
for t = 1:time
    mov_roi = mov(:,:,t).*BW(:,:,t);
    total_int(t) = sum(sum(mov_roi)); 
    mean_int(t) = sum(sum(mov_roi))./sum(sum(mov_roi~=0));
    %correct bleaching by normalizing through overall average
    mean_int(t) = mean_int(t)./mean(mean(mov(:,:,t)));
end


if total_selection == 0
    subplot(4,1,1);
    imagesc(BW(:,:,1)); axis image;
    set(gca,'FontSize',20),title('\fontsize{20}first nucleus mask')
    axis off;

    subplot(4,1,2);
    imagesc(BW(:,:,time)); axis image;
    set(gca,'FontSize',20),title('\fontsize{20}last nucleus mask')
    axis off;

    subplot(4,1,3);
    plot(total_int,'color','k','linewidth',2)
    set(gca,'FontSize',20),title('\fontsize{20}nucleus intensity')
    %axis([0,size(mov,3),1,5])

    subplot(4,1,4);
    nuc_size = sum(sum(BW,1),2);
    nuc_size = nuc_size(:);
    plot(nuc_size);

    set(gca,'FontSize',20),title('\fontsize{20}nucleus size')
elseif total_selection ==1
    subplot(2,1,1);
    plot(total_int,'color','k','linewidth',2)
    set(gca,'FontSize',20),title('\fontsize{20}total intensity')
    
    subplot(2,1,2);
    plot(mean_int,'color','k','linewidth',2)
    set(gca,'FontSize',20),title('\fontsize{20}mean intensity')
end   
    
    