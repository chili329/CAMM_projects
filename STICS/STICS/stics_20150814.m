function [timecorr] = stics_20150814(imgser,upperTauLimit);
test = 999
% July 10, 2003
% David Kolin
% Calculates the full time correlation function given 3D array of image series

set(gcbf,'pointer','watch');

h = waitbar(0,'Calculating time correlation functions...');

imgsize = size(imgser,1)*size(imgser,2);

% tau is the lag
% pair is the nth pair of a lag time

timecorr = zeros(size(imgser,1),size(imgser,2),upperTauLimit);  % preallocates lagcorr matrix for storing raw time corr functions    
SeriesMean = squeeze(mean(mean(imgser))); %size(SeriesMean) = number of frames

%starting from autocorrelation (tau = 0)
for tau = 0:upperTauLimit-1
          lagcorr = zeros(size(imgser,1),size(imgser,2),(size(imgser,3)-tau));      
    
    %calculate the correlation for each time pair
    for pair=1:(size(imgser,3)-tau)
       lagcorr(:,:,pair) = fftshift(real(ifft2(fft2(imgser(:,:,pair)).*conj(fft2(imgser(:,:,(pair+tau)))))));
       %CC
       %normalize by intensity
       mean1 = SeriesMean(pair);
       mean2 = SeriesMean(pair+tau);
       lagcorr(:,:,pair) = lagcorr(:,:,pair)/(mean1*mean2*imgsize)-1;
   end
   timecorr(:,:,(tau+1)) = mean(lagcorr,3);
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