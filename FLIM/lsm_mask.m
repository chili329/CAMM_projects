%use lsm data as the mask
close all
clear all
file = uipickfiles;
for file_num = 1:size(file,2)
    filename = file{file_num};
    seri = lsm_read(filename);
    %for spectral acquisition
    [a b] = size(seri);
    [x y] = size(seri{1});
    total = zeros(x,y);
    
    spec = zeros(b-1,1);
    %plot the overal intensity
    for i = 1:b-1
        spec(i) = sum(sum(seri{i}));
        total = total + (seri{i});
    end
    
    figure
    subplot(2,1,1)
    total = imresize(total,0.3);
    imagesc(total);
    colormap gray
    axis equal

    %extract file name
    t_str = strsplit(filename,'/');
    t_str = t_str(end);
    t_str = strrep(t_str, '_', '\_');
    title(t_str)
    
    subplot(2,1,2)
    plot(spec,'linewidth',4)
end