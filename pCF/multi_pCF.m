%close everything
%clear everything
clear all
close all
%clear c1 and c2
clear c1 c2

%number of pixels per line
l_pixel =32;
%pixel size in us
s_pixel = 0.1;
%line time in s
l_time = 0.479*(10^(-3));

%load all channels
files = uipickfiles;
num_ch = size(files,2);

for i = 1:num_ch
    cname = files(i);
    cname = cname{1};
    ch{i} = bin_read(cname,l_pixel);
end

% c1name = files(1);
% c1name = c1name{1};
% c2name = files(2);
% c2name = c2name{1};
%c1 = bin_read(c1name,l_pixel);
%c2 = bin_read(c2name,l_pixel);

%option = 1: fix distance
%option = 2: fix one column
%function [G] = pCF(c1,c2,dis,option)
%[G] = pCF(c1,c2,dis,option);
dis = 0;
option = 1;

%correlation length
corr_div = 100;
corr_length = length(c1)/corr_div;

c1new = zeros(l_pixel,corr_length);
c2new = zeros(l_pixel,corr_length);
G_total = 0;

for i = 1:corr_div
    c1new = c1(:,1+(i-1)*corr_length:i*corr_length);
    c2new = c2(:,1+(i-1)*corr_length:i*corr_length);
    G_div = pCF(c1new, c1new, dis, option);
    G_total = G_total + G_div;
end

G = G_total./corr_div;

Gnew = G(2:corr_length,1:l_pixel);

%smoothing
h = fspecial('average',2);
Gsmooth = imfilter(Gnew, h);

figure
[X Y] = mesh


surf(Gsmooth,'EdgeColor','None')
%mesh(Gsmooth)
colormap jet
set(gca,'yscale','log');
view(0,-90)

%figure
%imagesc(Gsmooth)

figure
for i = 1:l_pixel
    i = 22;
    x = Gnew(:,i);
    x = x(:);
    y = l_time*(1:1*length(Gnew));
    semilogx(y,x);
    hold on;
end