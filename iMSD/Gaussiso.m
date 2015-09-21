%fit with isotropic Gaussian (binding/main diffusion)
function F = Gaussiso(x,xdata)
%[bg,  Amp2,  x1,s    ,y1]
%[x(1),x(2),x(3),x(4),x(5)]    

X = xdata(:,:,1);
Y = xdata(:,:,2);

F = x(1)+...
    x(2)*exp(-((X-x(3)).^2+(Y-x(5)).^2)/x(4));
