%plot (1) average intensity image (2) after immfilter the variance 

% clear movie_file
% close all
% clear all
% files = uipickfiles;
% num_file = length(files);

for file = 1:num_file
%     filename = files{file}
%     [seri, lsminf] = lsm_read(filename);

    ch = 3;
    image_data = seri{ch};
    imm_data = immfilter_new(image_data);


    %scale images to 3 times bigger
    image_data = imresize(image_data, 1);
    imm_data = imresize(imm_data, 1);

    %plot average
    figure
    
    %starting frame
    frame1 = 1;
    %number of frames to use
    num_avg = 100;
    
    %selected images
    imm_data = imm_data(:,:,frame1:frame1+num_avg);
    image_data = image_data(:,:,frame1:frame1+num_avg);
    
    subaxis(2,1,2, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
    mean_imm = mean(imm_data(:));
    diff_imm = imm_data - ones(size(imm_data))*mean_imm;
    var_imm = diff_imm.*diff_imm;
    var_imm_avg = mean(var_imm,3);
    imm_min = min(var_imm_avg(:));
    imm_max = max(var_imm_avg(:));
    imshow(var_imm_avg,[imm_min imm_max]);
    colorbar
    t_str = strcat('imm removed variance,',num2str(num_avg));
    title(t_str);

    %(1) average intensity image
    subaxis(2,1,1, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
    mean_raw = mean(image_data,3);
    image_min = min(min(mean_raw));
    image_max = max(max(mean_raw));
    imshow(mean_raw,[image_min image_max]);
    colorbar
    %save filenames
    filenames = strsplit(filename,'/');
    filenames = filenames(end);
    title(strcat(filenames,'.channel:',num2str(ch)), 'interpreter', 'none')

    colormap(jet(1024))
    %movie_file(tot) = getframe(gcf);

end