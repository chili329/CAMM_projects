%TO DO:
%define nucleus position --> plot correlation with different color
%select segment for analysis
%directly load lsm file?
%detrend?
%diffusion fitting??

%close everything
%clear everything
clear all
close all

%%%%%FILE LOADING%%%%%%%

files = uipickfiles;
%file type: bin = 1, lsm = 2
f_type = 2;

%load bin file, all channels
if f_type == 1
    num_ch = size(files,2);

    for i = 1:num_ch
        cname = files(i);
        cname = cname{1};
        ch{i} = bin_read(cname,l_pixel);
    end
    %number of pixels per line
    l_pixel =32;
    %pixel size in us
    s_pixel = 0.1;
    %line time in s
    l_time = 0.479*(10^(-3));
end

%load LSM file
if f_type == 2
    filename = files{1};
    [lsminf,scaninf,imfinf] = lsminfo(filename);
    num_ch = lsminf.NUMBER_OF_CHANNELS;
    for i = 1:num_ch
        ch{i} = imreadBF(filename,1,1,i);
        ch{i} = ch{i}';
    end
    s_pixel = lsminf.VoxelSizeX*10^(3);
    l_pixel = lsminf.DimensionX;
    l_time = lsminf.TimeStamps.TimeStamps(2);
end
%%%%%%%%%%%%%%%%%%%%

%option = 1: fix distance
%option = 2: fix one column
%[G] = pCF(c1,c2,dis,option);
dis = 0;
option = 1;
%correlation channel of interest
ch1 = 2;
ch2 = 2;

%correlation length
corr_div = 100;
corr_length = length(ch{1})/corr_div;

c1new = zeros(l_pixel,corr_length);
c2new = zeros(l_pixel,corr_length);
G_total = 0;

for i = 1:corr_div
    c1new = ch{ch1}(:,1+(i-1)*corr_length:i*corr_length);
    c2new = ch{ch2}(:,1+(i-1)*corr_length:i*corr_length);
    G_div = pCF(c1new, c2new, dis, option);
    G_total = G_total + G_div;
end

%averaging
G = G_total./corr_div;
%take away correlation at t0
Gnew = G(2:corr_length,1:l_pixel);

%%%%%%%%%%%%%%%
%PLOTTING

% figure
% subplot(1,2,1)
% imagesc(ch{ch1}')
% title('\fontsize{20}intensity: ch1')
% subplot(1,2,2)
% imagesc(ch{ch2}')
% title('\fontsize{20}intensity: ch2')
% axis off

figure
[Gx, Gy] = size(Gnew);
axis_s = s_pixel*(0:(Gy-1));
axis_t = l_time*(1:Gx);
%smoothing
h = fspecial('average',[1,3]);
Gsmooth = imfilter(Gnew, h);
surf(axis_s, axis_t, Gsmooth,'EdgeColor','None')
%mesh(Gsmooth)
colormap jet
set(gca,'yscale','log');
view(0,-90)
ylim([min(axis_t) max(axis_t)])
xlim([min(axis_s) max(axis_s)])
set(gca,'FontSize',16)
pCF_title = strcat('opt',num2str(option),'dist ',num2str(dis),'ch ',num2str(ch1),', ',num2str(ch2));
title(pCF_title)

% figure
% for i = 1:l_pixel
%     %i = 22;
%     x = Gnew(:,i);
%     x = x(:);
%     y = l_time*(1:1*length(Gnew));
%     semilogx(y,x,'color',[i./l_pixel,0,0]);
%     hold on;
% end
% title('\fontsize{20}correlation plot')
% set(gca,'FontSize',20)

% figure
% x = l_time*(1:1*length(Gnew));
% x = x(:);
% x = repmat(x,1,l_pixel);
% y = 1:l_pixel;
% y = repmat(y,length(Gnew),1);
% plot3(x,y,Gnew,'color',[0,0,0,0.5]);
% set(gca,'xscale','log','linewidth',2)
% 
% title('\fontsize{20}3D line plot')
% set(gca,'FontSize',20)