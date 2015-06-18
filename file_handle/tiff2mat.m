function A = tiff2mat
fname = uipickfiles;
fname = fname{1};
info = imfinfo(fname);
num_images = numel(info);
for i = 1:num_images
    A(:,:,i) = imread(fname,i);
end