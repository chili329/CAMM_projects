%ch: image for analysis
%option = 1: fix distance
%option = 2: fix one column
%[G] = pCF(c1,c2,dis,option);
%correlation channel of interest: ch1, ch2
function [Gx,axis_t,Gnew] = batch_pCF_plot(ch, option, dis, ch1, ch2, s_pixel, l_time,plot_total,plot_p, corr_div);

%correlation length
%corr_div = 10;
[l_pixel, total_l] = size(ch{1});
corr_length = total_l/corr_div;

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
%HERE
Gnew = G(2:corr_length,:);
%Gnew = G(1:corr_length,:);

%%%%%%%%%%%%%%%
%PLOTTING

%HERE: adding arrows/dashed lines to indicate the fixed column?

subplot(1,plot_total,plot_p)
[Gx, Gy] = size(Gnew);
axis_s = s_pixel*(0:(Gy-1));
axis_t = l_time*(1:Gx);
%smoothing
h = fspecial('average',[3,3]);
Gsmooth = imfilter(Gnew, h);
%Gsmooth = imfilter(Gsmooth, h);
% if option == 2
%     hold on
%     plot3(dis*s_pixel*ones(Gx,1),axis_t,ones(Gx,1),'color','r','LineWidth',3,'LineStyle','--');
% end

surf(axis_s, axis_t, Gsmooth,'EdgeColor','None')

shading interp
%mesh(Gsmooth)

%COLORMAP
colormap jet
max_G = max(max(Gsmooth));
caxis([0 max_G])
%caxis([-max_G max_G])
%create colormap with green = positive, red = negative, black = 0
% greenColorMap = [zeros(1, 132), linspace(0, 1, 124)];
% redColorMap = [linspace(1, 0, 124), zeros(1, 132)];
% colorMap = [redColorMap; greenColorMap; zeros(1, 256)]';
% colormap(colorMap);

%adding reference line for the column of correlation
if option == 2
    hold on
    plot3(dis*s_pixel*ones(Gx,1),axis_t,-ones(Gx,1),'color','w','LineWidth',3,'LineStyle','--');
end

set(gca,'yscale','log');
view(0,-90)
ylim([min(axis_t) max(axis_t/2)])
xlim([min(axis_s) s_pixel*l_pixel])

set(gca,'FontSize',16)
if option == 1
    pCF_title = strcat('fix dis. dist ',num2str(dis),'.ch ',num2str(ch1),', ',num2str(ch2));
elseif option == 2
    pCF_title = strcat('fix col. dist ',num2str(dis),'.ch ',num2str(ch1),', ',num2str(ch2));
elseif option == 3
    pCF_title = strcat('fix -dis. dist ',num2str(dis),'.ch ',num2str(ch1),', ',num2str(ch2));
end
title(pCF_title)


