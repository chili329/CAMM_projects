%cell segmentation from ref file (FLIM acquisition)
%return mask(x,y,cell_num), each one represents a mask for a cell

function [mask,cell_img,int4] = flim_cell_seg(ref_int)

method = 2;
if method == 1
    %method 1: median filter+gauss filter
    %preprocessing: Gaussian filter
    int1 = imfill(ref_int);
    int2 = medfilt2(int1, [4 4]);
    int3 = imgaussfilt(int2,2);

    %background subtraction
    int_min = 30;
    int4 = int3;
    int4(int4<int_min) = 0;
    %segmentation: watershed
    wa = watershed(int4);
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
end

if method == 2
    int1 = imfill(ref_int)./max(ref_int(:));
    int1 = medfilt2(int1, [4 4]);
    level = graythresh(int1);
    int4 = im2bw(int1, level);
    int4 = -int4;
    cc = bwconncomp(int4, 4);
    for j = 1:cc.NumObjects
        cell = false(size(int4));
        cell(cc.PixelIdxList{j}) = true;
        mask(:,:,j) = double(cell);
        mask( mask==0 )=NaN;
        cell_img(:,:,j) = mask(:,:,j).*ref_int;
    end
end











