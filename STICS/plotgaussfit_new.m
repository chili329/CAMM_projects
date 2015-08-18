%plot the original correlation, fitted result, and residual
%scan: original image
%x: fitted parameters
%residual: difference between scan and fitted result
function plotgaussfit_new(scan,x,residual);
[xsize,ysize] = size(scan);
[X,Y] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1);

xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;

F = x(1)./x(3).*exp(-((xdata(:,:,1)-x(2)).^2/x(3) + (xdata(:,:,2)-x(4)).^2/x(3) ))+x(5);

figure
subplot(1,2,1)
s=surf(scan);
set(s,'FaceColor','interp')
%set(s,'EdgeColor','none')
set(s,'FaceAlpha',0.7)
set(gca,'FontSize',20)
hold on
m = mesh(xdata(:,:,1),xdata(:,:,2),F);
set(m,'EdgeColor',[0.2 0.2 0.2])
str1 = strcat('Amp',num2str(x(1)),'iMSD',num2str(x(3)),'bg',num2str(x(5)));
title(str1)
set(gca,'FontSize',20)
subplot(1,2,2)
surf(residual)