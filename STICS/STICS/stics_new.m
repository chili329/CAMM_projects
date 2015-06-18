function [timecorr] = stics_new(imgser,upperTauLimit);

% tau is the lag
% pair is the nth pair of a lag time

       timecorr = zeros(size(imgser,1),size(imgser,2),upperTauLimit);  % preallocates lagcorr matrix for storing raw time corr functions    
       SeriesMean = squeeze(mean(mean(imgser)));
       
       for tau = 0:upperTauLimit-1
                  lagcorr = zeros(size(imgser,1),size(imgser,2),(size(imgser,3)-tau));      
           for pair=1:(size(imgser,3)-tau)
               lagcorr(:,:,pair) = fftshift(real(ifft2(fft2(imgser(:,:,pair)).*conj(fft2(imgser(:,:,(pair+tau)))))));
           end
           timecorr(:,:,(tau+1)) = mean(lagcorr,3);
       end