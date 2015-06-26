%binding only equation
function F = bind(x,xdata)
%[bg,Nt,tauT,sigT]

F = x(1)+x(2).*exp(-xdata(:,:,:,3)/x(3)).*exp(((xdata(:,:,:,1)).^2+(xdata(:,:,:,2)).^2)./(-x(4)));
