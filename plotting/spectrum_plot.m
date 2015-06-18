close all
%plot spectrum from tiff files
% FileName = uipickfiles;
% N = length(FileName);
% for i = 1:N
%     A(:,:,i) = double(imread(FileName{i}));
%     
%     %avgA(i) = mean(mean(A(:,:,i)));
% end
% 
% contour(A)

%spec_data = bfopen();
img = spec_data{1};
total_frame = size(img,1);

spectrum = zeros(32,1);
%ch1 = img{1+33*n,1}
%ch2 = img{2+33*n,1} etc.
n = 9;

figure(1)
total = 0;
for i = 1:32
    total = total + img{i+33*n,1};
end
imagesc(total)
colormap gray

y =linspace(410,695,32);
cx = 400;
cy = 400;
s = 4;
for i = 1:32
    spectrum(i,1) = mean(mean(img{i+33*n,1}(cx-s:cx+s,cy-s:cy+s)));
end

figure(2)
plot(y,spectrum,'color','k','linewidth',2)

figure(3)
for cx = 10:200:1000
    for cy = 10:200:1000
        for i = 1:32
            spectrum(i,1) = mean(mean(img{i+33*n,1}(cx-s:cx+s,cy-s:cy+s)));
        end
        spectrum = spectrum/mean(spectrum);
        plot(y,spectrum,'linewidth',2,'color',[0 cx./1000 0])
        hold on
    end    
end

    
    
    
    