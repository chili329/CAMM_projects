%diffusion + binding
function F = diff_bind(x,xdata)
%[Amp,xo,iMSD,yo,bg,Nt,tauT,sigT,tau]

F = x(1)./x(3).*exp(-((xdata(:,:,1)-x(2)).^2/x(3) + (xdata(:,:,2)-x(4)).^2/x(3) ))+x(5)+x(6).*exp(-x(9)/x(7)).*exp(((xdata(:,:,1)).^2+(xdata(:,:,2)).^2)./(-x(8)));
