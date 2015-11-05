% Code to test stics

filename = '/Users/chilic/Desktop/CAMM/data/20150807_lsm780/dish2_K22_AR_NLS_STICS_Cl4AS1_32min.lsm';


img_data = imreadBF(filename,1,1:1000,1);
size(img_data) % the img_data should be an 256x32x1000 matrix.

%start_col = 54;
start_col = 1;
width = 32;

% extract the raw data for the 32x32 region
raw_data = img_data(:,start_col:(start_col+width-1),:);
% compute the mobile portion
mobile = immfilter_new(raw_data);
%mobile = raw_data;

% perform stics both ways
max_delta = 2;
tc1 = stics(mobile, max_delta, 1); % this is done using the original method
tc2 = stics(mobile, max_delta, 2); % here we use the new method
compar = zeros(32, 64, max_delta);
compar(:,1:32,:) = tc1; % Chi-Li's Original
compar(:,33:64,:) = tc2; % New zero-pad FFT method

imagesc(compar(:,:,2))
% % write to AVI file
% % get max and min val in each frame and use to normalize frame by frame
% w = 64;
% h = 32;
% n = w * h; % elements per frame
% max_val = max(reshape(compar, [n, max_delta]), [], 1); % vector
% min_val = min(reshape(compar, [n, max_delta]), [], 1); % vector
% max_val_array = permute(repmat(max_val, [w, 1, h]), [3, 1, 2]); % array
% min_val_array = permute(repmat(min_val, [w, 1, h]), [3, 1, 2]); % array
% compar_norm = (compar-min_val_array) ./ (max_val_array - min_val_array);
% compar_im = zeros(32, 64, 1, max_delta);
% compar_im(:,:,1,:) = compar_norm;
% compar_im = compar_im(:,:,:,2:size(compar_im,4)); % remove the tau=0 image
% 
% v = VideoWriter(strcat('compar_',int2str(start_col),'.avi'), 'Grayscale AVI');
% open(v);
% writeVideo(v, compar_im);
% close(v);



