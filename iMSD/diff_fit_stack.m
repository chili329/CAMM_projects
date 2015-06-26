% Fit a 2D gaussian function to image stack
% Uses lsqcurvefit to fit
%[Amp,xo,iMSD,yo,bg] where Amp is the same for all images

function [xnew, residual] = diff_fit_stack(scan)
%scan is the input image stack
[xsize, ysize, tsize] = size(scan);
[X,Y] = meshgrid(-xsize/2:xsize/2-1,-xsize/2:xsize/2-1);

xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;
x0 = [0.1,0,20,0,0]; %Inital guess parameters

% --- Fit---------------------
% define lower and upper bounds
lb = [0,-xsize/2,0,-xsize/2,0];
ub = [realmax('double'),xsize/2,10*xsize,xsize/2,1]; 

amp_init = zeros(tsize,1);
for t = 1:tsize
    options = optimset('TolFun',power(10,-7));
    [x,resnorm,residual] = lsqcurvefit(@dif,x0,xdata,scan(:,:,t),lb,ub,options);
    amp_init(t) = x(1);
end
xnew = zeros(5,tsize);
%fix amp to the median of the initial fitting
medamp = median(amp_init);
lb = [medamp,-xsize/2,0,-xsize/2,0];
ub = [medamp,xsize/2,10*xsize,xsize/2,1];
for t = 1:tsize
    options = optimset('TolFun',power(10,-7));
    [x,resnorm,residual] = lsqcurvefit(@dif,x0,xdata,scan(:,:,t),lb,ub,options);
    figure(t)
    imagesc(residual)
    xnew(:,t) = x;
end