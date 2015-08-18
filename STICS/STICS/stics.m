function [timecorr] = stics(imgser,upperTauLimit)

set(gcbf,'pointer','watch');

h = waitbar(0,'Calculating time correlation functions...');

imgsize = size(imgser,1)*size(imgser,2);

% tau is the lag
% pair is the nth pair of a lag time

timecorr = zeros(size(imgser,1),size(imgser,2),upperTauLimit);  % preallocates lagcorr matrix for storing raw time corr functions    
SeriesMean = squeeze(mean(mean(imgser))); %size(SeriesMean) = number of frames %always the same if after immfilter_new

%starting from autocorrelation (tau = 0)
for tau = 0:upperTauLimit-1
    lagcorr = zeros(size(imgser,1),size(imgser,2),(size(imgser,3)-tau));      
    lagcorr1 = zeros(size(imgser,1),size(imgser,2),(size(imgser,3)-tau));
    
    %calculate the correlation for each time pair
    for pair=1:(size(imgser,3)-tau)
       lagcorr(:,:,pair) = fftshift(real(ifft2(fft2(imgser(:,:,pair)).*conj(fft2(imgser(:,:,(pair+tau)))))));
       %normalization
       norm_factor = imgser(:,:,pair).*imgser(:,:,pair);
       lagcorr1(:,:,pair) = lagcorr(:,:,pair)./sum(norm_factor(:));
       %WRONG
       %normalize by intensity
       %mean1 = SeriesMean(pair);
       %mean2 = SeriesMean(pair+tau);
       %norm_factor = mean1*mean2*imgsize;
       %lagcorr1(:,:,pair) = lagcorr(:,:,pair)./norm_factor-1;
    end
    
    timecorr(:,:,(tau+1)) = mean(lagcorr1,3);
    
    if ishandle(h)
       waitbar((tau+1)/(upperTauLimit),h)
    else
       break
    end
end



if ishandle(h)
close(h)
end
set(gcbf,'pointer','arrow');