%simple 2D Gaussian 
%iMSDx = iMSDy = iMSD
%no rotation
function F = dif(x,xdata)
%[Amp,xo,iMSD,yo,bg]

F = x(1)./x(3).*exp(-((xdata(:,:,1)-x(2)).^2/x(3) + (xdata(:,:,2)-x(4)).^2/x(3) ))+x(5);
