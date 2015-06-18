function [Vx,Vy] = velocity_new(image_data,t,pixelsize,immobile,tauLimit,whitenoise);

xlim = t*tauLimit;
t = linspace(0,t*size(image_data,3),size(image_data,3))';

size(image_data)

% Calculates speed and direction given the coefficients of the 2D fits

% Filters immobile fraction
if strcmp('y',immobile)
    image_data = immfilter_new(image_data);
end

[Gtime] = stics_new(image_data,tauLimit);


% Does time fit
%[a, res] = gaussfit(corr,type,pixelsize,whitenoise);
[coeffGtime,resGtime] = gaussfit(Gtime,'time',pixelsize,whitenoise);


coeffGtime = coeffGtime(1:max(find(t<=xlim)),:);
t = t(1:max(find(t<=xlim)),:);
regressionX = polyfit(t,coeffGtime(:,4),1);
Vx = -regressionX(1);
regressionY = polyfit(t,coeffGtime(:,5),1);
Vy = -regressionY(1);