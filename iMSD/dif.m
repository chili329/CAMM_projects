%simple 2D Gaussian 
%iMSDx = iMSDy = iMSD
%no rotation
function F = dif(x,xdata)
%[Amp,xo,iMSD,yo,bg]

X = xdata(:,:,1);
Y = xdata(:,:,2);

F = x(5)+...
    x(1)./x(3).*exp(-((X-x(2)).^2 + (Y-x(4)).^2)/x(3) );