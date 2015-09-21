function F = Gauss(x,xdata)
X = xdata(:,:,1);
Y = xdata(:,:,2);

 F = x(1)*exp(-((X-x(2)).^2/(2*x(3)^2) + (Y-x(4)).^2/(2*x(5)^2)));