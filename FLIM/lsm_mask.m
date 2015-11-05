%use lsm data as the mask
close all
clear all
file = uipickfiles;
for file_num = 1:size(file,2)
    filename = file{file_num};
    %extract file name
    t_str = strsplit(filename,'/');
    t_str = t_str(end);
    t_str = strrep(t_str, '_', '\_');
    
    seri = lsm_read(filename);
    %for spectral acquisition
    [a b] = size(seri);
    [x y] = size(seri{1});
    total = zeros(x,y);
    
    spec = zeros(b-1,1);
    %overal intensity
    %not including ch33: DIC
    for i = 1:b-1
        spec(i) = sum(sum(seri{i}));
        total = total + (seri{i});
    end
    %total 32 channels
    spec_range = 410.5:8.9:694.9;
    
    figure
    title(t_str);
    %plot overall intensity
    subplot(1,2,1)
    total = imresize(total,0.3);
    imagesc(total);
    colormap gray
    axis equal
    %plot spectrum
    subplot(1,2,2)
    plot(spec_range,spec,'linewidth',4)
end