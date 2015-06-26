% Fit binding function to image stack
% Uses lsqcurvefit to fit
% [bg,Nt,tauT,sigT]

function [xnew, residual] = bind_fit_stack(scan)
%scan is the input image stack
[xsize, ysize, tsize] = size(scan);
[X,Y,T] = meshgrid(-xsize/2:xsize/2-1,-xsize/2:xsize/2-1,1:tsize);

xdata = zeros(size(X,1),size(Y,2),size(T,3),3);
xdata(:,:,:,1) = X;
xdata(:,:,:,2) = Y;
xdata(:,:,:,3) = T;
x0 = [0.1,0.1,0.1,0.1]; %Inital guess parameters

% --- Fit---------------------
% define lower and upper bounds
lb = [0,0,0,0];
ub = [realmax('double'),realmax('double'),realmax('double'),realmax('double')]; 

options = optimset('TolFun',power(10,-7));
[xnew,resnorm,residual] = lsqcurvefit(@bind,x0,xdata,scan,lb,ub,options);
