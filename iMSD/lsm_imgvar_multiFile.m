%plot (1) average intensity image (2) after immfilter the variance 
% 
clear movie_file
close all
clear all
files = uipickfiles;
num_file = length(files);

for file = 1:num_file
    filename = files{file}
    [seri, lsminf] = lsm_read(filename);
    
    %channel of interest
    ch = 1;
    nuc_ch = 2;
    %starting frame
    frame1 = 1;
    %number of frames to use
    num_avg = 500;
    
    image_data = seri{ch};
    if nuc_ch >0
        nuc_data = seri{nuc_ch};
    else
        nuc_data = zeros(size(image_data));
    end
    imm_data = immfilter_new(image_data);


    %scale images to 3 times bigger
    %image_data = imresize(image_data, 3);
    %imm_data = imresize(imm_data, 3);

    %plot average
    figure
    
    %selected images
    imm_data = imm_data(:,:,frame1:frame1+num_avg-1);
    image_data = image_data(:,:,frame1:frame1+num_avg-1);
    nuc_data = nuc_data(:,:,frame1:frame1+num_avg-1);
    
    %calculate the averaged original intensity
    mean_raw = mean(image_data,3);
    mean_nuc = mean(nuc_data,3);
    image_min = min(min(mean_raw));
    image_max = max(max(mean_raw));
    nuc_min = min(min(mean_nuc));
    nuc_max = max(max(mean_nuc));
    
    %calculate the variance from immobile removal, divided by the original intensity 
    mean_imm = mean(imm_data(:));
    diff_imm = imm_data - ones(size(imm_data))*mean_imm;
    var_imm = diff_imm.*diff_imm;
    var_imm_avg = mean(var_imm,3)./mean_raw;
    imm_min = min(var_imm_avg(:));
    imm_max = max(var_imm_avg(:));
   

    %---average intensity image---
    subaxis(2,1,1, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
    imshow(mean_raw,[image_min image_max]);
    colorbar
    %save filenames
    filenames = strsplit(filename,'/');
    filenames = filenames(end);
    title(strcat(filenames,'.channel:',num2str(ch)), 'interpreter', 'none')
   
    %---nuc image----
    subaxis(2,1,2, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
    imshow(mean_nuc,[nuc_min nuc_max]);
    colorbar
    title(strcat('channel:',num2str(nuc_ch)), 'interpreter', 'none')
    %---variance image----
%     subaxis(2,1,2, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
%     %imshow(var_imm_avg,[imm_min imm_max]);
%     imshow(var_imm_avg,[500 2000]);
%     colorbar
%     t_str = strcat('imm removed variance/avg,',num2str(num_avg));
%     title(t_str);
    colormap(gray(1024))
    
    %movie_file(tot) = getframe(gcf);

end