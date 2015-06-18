function g = dftfilt(f, H)
%Performs frequency domain filtering.
%   filters F in the frequency domain using the filter transfer function H.
%   The output G is the filtered image, which has the same size as F. 
%   It assumes that F is real and that H is a real, uncentered, circularly-symmetric filter function.

F = fft2(f, size(H, 1), size(H, 2));

g = real(ifft2(H.*F));

g = g(1:size(f,1), 1:size(f,2));

end