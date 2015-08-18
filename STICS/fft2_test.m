%generate a 2x2 matrix with 3 time points
test = [-11 1 1;1 1 1;1 1 1;1 1 1];
test = test.*2;
test = reshape(test,[2 2 3])
[x,y,t] = size(test);
mean_int = squeeze(mean(mean(test)));

tau = 1;
raw = fftshift(real(ifft2(fft2(test(:,:,tau)).*conj(fft2(test(:,:,tau+1))))));
avg_raw = test(:,:,tau).*test(:,:,tau+1)
norm_raw = raw/sum(avg_raw(:))


%norm_raw = raw/(x*y*mean_int(tau)*mean_int(tau))