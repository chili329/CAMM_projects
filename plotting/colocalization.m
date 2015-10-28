% close all
% clear all
% filename = uipickfiles;
% file = filename{1};
% [seri, metainf] = lsm_read(file);
% AR = seri{3};
% tub = seri{4};
% AR = csvread('GFPAR.csv');
% tub = csvread('tub.csv');

%option1: sub-location
% subAR = AR(200:400,400:700);
% subtub = tub(200:400,400:700);
% x = subAR(:);
% y = subtub(:);

%option2: filter by threshold
% AR1 = AR(:);
% tub1 = tub(:);
% %filter by AR intensity
% indices = find(AR<1000);
% AR1(indices) = [];
% tub1(indices) = [];
% indices2 = find(tub1<1000);
% AR1(indices2) = [];
% tub1(indices2) = [];
% x = AR1(:);
% y = tub1(:);

%option3: manual ROI
BW = roipoly(tub./max(tub(:)));
cellAR = AR.*BW;
celltub = tub.*BW;
x = cellAR(:);
y = celltub(:);
indices = find(x==0);
x(indices) = [];
y(indices) = [];

figure('Color',[1 1 1])
a1= dscatter(x,y,'PLOTTYPE','scatter','BINS',[100 100]);
colorbar
set(gca,'fontsize',30);
set(gca,'xlim',[0 1*10^4],'ylim',[0 1.5*10^4])
xlabel('GFP-AR')
ylabel('tub')
corr(x,y)