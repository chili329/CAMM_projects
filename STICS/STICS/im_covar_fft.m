function result = im_covar_fft(im1, im2)
%
% Figure out the mean product of pixels in two images
% across shifts that range across half the image size.
% Both images must be the same size and an even number
% of pixels in each dimension.

% Dan Ruderman 20151030

if sum(size(im2)==size(im1)) ~= 2
    error('Both arrays must be of the same size')
end

array_size = size(im1);
if sum(mod(array_size,2)) ~= 0
    error('Array dimensions must be even')
end

% zero pad to double the size of each array
h = array_size(1);
w = array_size(2);
im1_zp = zeros(2*h, 2*w);
im1_zp(1:h,1:w) = im1;
im2_zp = zeros(2*h, 2*w);
im2_zp(1:h,1:w) = im2;

% now perform fft based covariance
full_result = fftshift(real(ifft2(fft2(im1_zp) .* conj(fft2(im2_zp)))));
hh = h/2;
hw = w/2;
result = full_result((hh+1):(hh+h), (hw+1):(hw+w));


% Figure out the count at each offset for the correlation
horiz_half_size = array_size(1)/2;
vert_half_size = array_size(2)/2;
horiz_counts = tripuls((-horiz_half_size):(horiz_half_size-1), 4*horiz_half_size) * 2 * horiz_half_size;
vert_counts = tripuls((-vert_half_size):(vert_half_size-1), 4*vert_half_size) * 2 * vert_half_size;
counts = vert_counts' * horiz_counts;

result = result ./ counts;

end

