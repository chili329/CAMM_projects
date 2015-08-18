function mobile = immfilter_new(img_data);

%20150227
%subtracting overall average from each frame. same as old code
[x,y,z] = size(img_data);
mobile1 = zeros(x,y,z);
total_mean = mean(img_data(:)); %scaler, mean of the entire series
self_mean = squeeze(mean(mean(img_data))); %mean of each frame, size(self_mean) = number of frames
%pixel_mean = mean(img_data,3);

for i = 1:z
    %for each frame, subtract its mean then add the total_mean back, so
    %that all frames have the same average
    mobile1(:,:,i) = double(img_data(:,:,i))-ones(x,y)*(self_mean(i)-total_mean);
end

%remove from each pixel its average in time and add the total_mean back
moviefft = zeros(size(img_data));
moviefft = fft(double(mobile1),[],3);
moviefft(:,:,1) = 0;
mobile = real(ifft(moviefft,[],3))+total_mean;
display mobile_done

% %from Carmine, same as above
% % Time detrend
% img_data=double(img_data)-repmat(mean(mean(img_data,1),2),[size(img_data,1) size(img_data,2) 1])+mean(img_data(:));
% 
% % Immobile removal 
% mobile=double(img_data)-repmat(mean(img_data,3),[1 1 size(img_data,3)])+mean(img_data(:));