
clear movie_file
close all
clear all
files = uipickfiles;
filename = files{1};
[seri, lsminf] = lsm_read(filename);

ch = 1;
image_data = seri{ch};
imm_data = immfilter_new(image_data);

% image_min = min(image_data(:));
% image_max = max(image_data(:));
% imm_min = min(imm_data(:));
% imm_max = max(imm_data(:));

%only a 32x32 window
% seg_size = 32;
% cx = 17;
% cy = 100;
% cx1 = cx-seg_size/2;
% cx2 = cx+seg_size/2-1;
% cy1 = cy-seg_size/2;
% cy2 = cy+seg_size/2-1;
% image_data = image_data(cx1:cx2,cy1:cy2,:);
% imm_data = imm_data(cx1:cx2,cy1:cy2,:);

image_data = imresize(image_data, 3);
imm_data = imresize(imm_data, 3);
%diff_data = image_data-imm_data;

frame = 0;

%plot individual time point
figure
raw_min = min(min(image_data(:,:,frame+1)));
raw_max = max(max(image_data(:,:,frame+1)));
imm_min = min(min(imm_data(:,:,frame+1)));
imm_max = max(max(imm_data(:,:,frame+1)));
for i = 1 : 50
    %subaxis(8,1,i, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0);
    imshow(image_data(:,:,frame+i),[imm_min imm_max]);
    colormap(jet(1024))
    title(num2str(frame+i))
    axis tight
    axis off
    movie_file(i) = getframe(gcf);
end



%plot average
% figure
% 
% for tot = 1
%     subaxis(5,1,1, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
%     mean_raw = mean(image_data(:,:,tot:tot+num_avg),3);
%     image_min = min(min(mean_raw));
%     image_max = max(max(mean_raw));
%     imshow(mean_raw,[image_min image_max]);
%     colorbar
%     title('raw average')
%     
%     for n_avg = 2:5
%         subaxis(5,1,n_avg, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
%         num_avg = n_avg*20;
%         mean_imm = mean(imm_data(:,:,tot:tot+num_avg),3);
%         imm_min = min(min(mean_imm));
%         imm_max = max(max(mean_imm));
%         imshow(mean_imm,[imm_min imm_max]);
%         colorbar
%         t_str = strcat('imm removed average,',num2str(num_avg));
%         title(t_str);
%     end
% 
% %     subaxis(3,1,3, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
% %     diff_data = mean_raw-mean_imm;
% %     diff_min = min(min(diff_data));
% %     diff_max = max(max(diff_data));
% %     imshow(diff_data,[diff_min diff_max]);
% %     colorbar
% %     title('immobile average')
%     
%     colormap(jet(1024))
% end

%plot accumulative average
% figure
% start = 1;
% for i = 1 : 16
%     subaxis(2,8,i, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0);
%     %mean_imm = mean(imm_data(:,:,start:2:start+2*i),3);
%     mean_imm = mean(image_data(:,:,start+i*10:start+40+i*10),3);
%     imm_min = min(mean_imm(:));
%     imm_max = max(mean_imm(:));
%     imshow(mean_imm,[imm_min imm_max]);
%     colormap(jet(1024))
%     title(num2str(10*i+start))
%     %colorbar
%     axis tight
%     axis off
% end

%HERE
% %overlay 2 channels
% imshow(imm_data(:,:,32))
% % Make a truecolor all-green image.
% green = cat(3, zeros(size(E)),... ones(size(E)), zeros(size(E)));
% hold on 
% h = imshow(green); 
% hold off
% % Use our influence map as the 
% % AlphaData for the solid green image.
% set(h, 'AlphaData', I)