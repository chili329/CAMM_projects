%ROI selection of images and get the averaged intensity over time
%manual polygon selection
clear all
close all

ch = 1;
z = 5;

%for LSM file
%mov = lsm_read(ch,z);
%mov = mov(:,:,60:200);
%for tiff file
mov = double(tiff2mat);

time = size(mov,3);
both_int = zeros(time,2);

%if cells move too much, break mov into several sections and select
%nucleus/cytoplasm positions for each section
%HERE

%select nuleus, then cytoplasm
for i = 1:2
    %use the first frame
    %I = imagesc(mov(:,:,1));
    %use average frame
    I = imagesc(mean(mov,3));
    %colormap(gray)
    axis image

    %select ROI
    BW = roipoly;
    mean_int = zeros(time,1);
    
    %apply ROI selection to all frames
    for t = 1:time
        mov_roi = mov(:,:,t).*BW;
        total_int(t) = sum(sum(mov_roi));
        %correct bleaching by normalizing through overall average
        mean_int(t) = total_int(t)./mean(mean(mov(:,:,t)));
    end
    both_int(:,i) = mean_int;
end

%normalize by max
both_int = both_int./max(both_int(:));
plot(both_int(:,1),'color','k','linewidth',2)
hold on
plot(both_int(:,2),'color','r','linewidth',2)
axis([0,size(mov,3),0,1])
set(gca,'FontSize',20)