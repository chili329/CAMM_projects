%automatically select nucleus position for each frame
%20150515: added cytoplasm segmentation

clear all
close all

AR_ch = 1;
nuc_ch = 2;

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

mov = ch{AR_ch};
nuc = ch{nuc_ch};

%from tiff file
%mov = double(tiff2mat);
%nuc = double(tiff2mat);

time = size(mov,3);
both_int = zeros(time,2);

%nuc = nuc_segment(ch,fudgeFactor)
BW_nuc = nuc_segment(nuc,1.2);

%cytoplasm segmentation
BW_cyt = nuc_segment(mov,1);

subplot(2,2,2), imagesc(mean(nuc,3)), title('\fontsize{20}nucleus'), axis image;
subplot(2,2,1), imagesc(mean(mov,3)), title('\fontsize{20}AR'), axis image;
%subplot(2,2,3), imshow(BW(:,:,1)), title('\fontsize{20}mask'), axis image;
subplot(2,2,3), imshow(BW_cyt(:,:,1)-BW_nuc(:,:,1)), title('\fontsize{20}cytoplasm mask'), axis image;


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

%normalize by max
both_int = both_int./max(both_int(:));
subplot(2,2,4), plot(both_int(:,1),'color','k','linewidth',2)
hold on
plot(both_int(:,2),'color','r','linewidth',2)
axis([0,size(mov,3),0,1])
set(gca,'FontSize',20),title('\fontsize{20}nuc(k) cyto(r)')