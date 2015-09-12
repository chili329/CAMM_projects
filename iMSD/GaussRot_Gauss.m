%fit with rotational Gaussian (directional confined diffusion) + circular
%Gaussian (binding/main diffusion)
function F = GaussRot_Gauss(x,xdata)
%[Amp1,xo  ,sx  ,yo  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
%[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]
%[X,Y] = meshgrid(x,y) 
%  xdata(:,:,1) = X
%  xdata(:,:,2) = Y           
% Mrot = [cos(fi) -sin(fi); sin(fi) cos(fi)]
%

X = xdata(:,:,1);
Y = xdata(:,:,2);

xdatarot(:,:,1)= X*cos(x(6)) - Y*sin(x(6));
xdatarot(:,:,2)= X*sin(x(6)) + Y*cos(x(6));
x0rot = x(2)*cos(x(6)) - x(4)*sin(x(6));
y0rot = x(2)*sin(x(6)) + x(4)*cos(x(6));


F = x(7)+...
    x(1)*exp(-((xdatarot(:,:,1)-x0rot).^2/x(3) + (xdatarot(:,:,2)-y0rot).^2/x(5) ))+...
    x(8)*exp(-((X-x(9)).^2+(Y-x(11)).^2)/x(10));
