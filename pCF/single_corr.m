%calculate the correlation of d1 and d2
%d1 and d2 are n*1 array

function [G] = single_corr(d1,d2)

m1 = mean(mean(d1));
m2 = mean(mean(d2));

f1 = fft(double(d1));
f2 = fft(double(d2));

G(:,:) = real(ifft(f1.*conj(f2)))/(m1*m2*length(d1)) - 1;

%plot(G(:,1))

end