%simple 2D Gaussian 
%iMSDx = iMSDy = iMSD
%no rotation
function F = ricsDiff(x,xdata)
%x = [gamma/N,D]
%v = [tau p,tau l,w0,wz,delta r] 
v = [power(10,-6),power(10,-5),0.3,0.9,0.1];
p_shift = v(1)*xdata(:,:,1);
l_shift = v(2)*xdata(:,:,2);
t_shift = 4*(p_shift+l_shift);

%G = x(1).*(1+(t_shift*x(2)./v(3).^2))^(-1)*(1+(t_shift*x(2)./v(4).^2))^(-0.5);
%S = exp(-0.5*((2*v(5)*xdata(:,:,1)/v(3))^2+(2*v(5)*xdata(:,:,2)/v(3))^2)/(1+(t_shift*x(2)./v(3)^2)));
%F = G*S;

F = (x(1).*(1+(t_shift*x(2)./v(3).^2))^(-1)*(1+(t_shift*x(2)./v(4).^2))^(-0.5))*(exp(-0.5*((2*v(5)*xdata(:,:,1)/v(3))^2+(2*v(5)*xdata(:,:,2)/v(3))^2)/(1+(t_shift*x(2)./v(3)^2))));