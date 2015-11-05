function result = im_covar( im1, im2 )
%
% Figure out the mean product of pixels in two images
% across shifts that range across half the image size.
% Both images must be the same size and an even number
% of pixels in each dimension.

% Dan Ruderman 20151029

if sum(size(im2)==size(im1)) ~= 2
    error('Both arrays must be of the same size')
end

array_size = size(im1);
if sum(mod(array_size,2)) ~= 0
    error('Array dimensions must be even')
end

% Figure out the count at each offset for the correlation
horiz_half_size = array_size(1)/2;
vert_half_size = array_size(2)/2;
horiz_counts = tripuls((-horiz_half_size+1):horiz_half_size, 4*horiz_half_size) * 2 * horiz_half_size;
vert_counts = tripuls((-vert_half_size+1):vert_half_size, 4*vert_half_size) * 2 * vert_half_size;
counts = vert_counts' * horiz_counts;

% Perform the cross covariance sums (but do not subtract means).
% Divide by data counts at each offset to normalize
result = filter2(im1, im2) ./ counts;

end

