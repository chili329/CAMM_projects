%cell segmentation from ref file (FLIM acquisition)
%return mask(x,y,cell_num), each one represents a mask for a cell

function [mask] = flim_cell_seg(ref_int)

%clear all
%close all
% %file reading
%ref_file = uipickfiles;
%ref_file = ref_file{1};
%[ref_int, G, S, ref_ph1, ref_md1] = ref_read(ref_file);

%preprocessing: Gaussian filter
int1 = medfilt2(ref_int, [5 5]);
int2 = imgaussfilt(int1,3);

%background subtraction
int_min = 20;
int3 = int2;
int3(int3<int_min) = 0;

%pre-segmentation intensity plot
% figure
% colormap hot
% 
% subplot(2,3,1)
% imagesc(ref_int)
% subplot(2,3,2)
% imagesc(int1)
% subplot(2,3,3)
% imagesc(int2)
% subplot(2,3,4)
% imagesc(int3)
% subplot(2,3,5)
% hist(int3(:))

%segmentation: watershed
wa = watershed(int3);
%number of segmentations
num_cell = max(wa(:))+1;
mask = zeros(256,256,num_cell);
cell_img = zeros(256,256,num_cell);

for j = 1:num_cell
    wanew = wa;
    wanew(wanew~=(j-1)) = 0;
    mask(:,:,j) = wanew;
    mask(:,:,j) = mask(:,:,j)./max(max(mask(:,:,j)));
    mask( mask==0 )=NaN; 
    cell_img(:,:,j) = mask(:,:,j).*ref_int;
end









