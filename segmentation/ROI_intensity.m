%ROI selection of images and get the averaged intensity over time
clear all
close all

ch = 1;
z = 1;
%mov = tiff2mat;
mov = lsm_read(ch,z);
time = size(mov,3);
both_int = zeros(time,2);

%select nuleus, then cytoplasm
for i = 1:2
    %use the first frame
    %I = imagesc(mov(:,:,1));
    %use average frame
    I = imagesc(mean(mov,3));
    colormap(gray)
    axis image

    %select ROI
    BW = roipoly;
    mean_int = zeros(time,1);
    
    %apply ROI selection to all frames
    for t = 1:time
        mov_roi = mov(:,:,t).*BW;
        mean_int(t) = sum(sum(mov_roi))./sum(sum(mov_roi~=0));
        %correct bleaching by normalizing through overall average
        mean_int(t) = mean_int(t)./mean(mean(mov(:,:,t)));
    end
    both_int(:,i) = mean_int;
end

plot(both_int(:,1),'color','k','linewidth',2)
hold on
plot(both_int(:,2),'color','r','linewidth',2)
axis([0,size(mov,3),1,5])
set(gca,'FontSize',20)