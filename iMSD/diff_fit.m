% Fit a 2D gaussian function to image
% Uses lsqcurvefit to fit
%[Amp,xo,iMSD,yo]

function [x, residual] = diff_fit(scan)
%scan is the input image
[xsize, ysize] = size(scan);
[X,Y] = meshgrid(-xsize/2:xsize/2-1);
%[X,Y] = meshgrid(1:xsize);
xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;
x0 = [0.1,0,20,0]; %Inital guess parameters
% --- Fit---------------------
% define lower and upper bounds 
    lb = [0,-xsize/2,0,-xsize/2];
    %ub = [realmax('double'),xsize/2,10*xsize,xsize/2];
    ub = [realmax('double'),xsize/2,10*xsize,xsize/2];


%[Amp,xo,iMSD,yo]
options = optimset('TolFun',power(10,-7));
[x,resnorm,residual] = lsqcurvefit(@dif,x0,xdata,scan,lb,ub,options);
