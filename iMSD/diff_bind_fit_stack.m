% Fit a 2D gaussian diffusion binding function to image stack
% Uses lsqcurvefit to fit
%[Amp,xo,iMSD,yo,bg] where Amp is the same for all images

function [xnew, residual] = diff_bind_fit_stack(scan)
%scan is the input image stack
[xsize, ysize, tsize] = size(scan);
[X,Y] = meshgrid(-xsize/2:xsize/2-1,-xsize/2:xsize/2-1);

xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;
%[Amp,xo,iMSD,yo,bg,Nt,tauT,sigT,tau]
x0 = [0.1,0,20,0,0.1,0.1,1,10,0]; %Inital guess parameters

% --- Fit---------------------

amp_init = zeros(tsize,1);
for t = 1:tsize
    options = optimset('TolFun',power(10,-9));
    % define lower and upper bounds
    lb = [0,-xsize/2,0,-xsize/2,0,0,0,0,t];
    ub = [realmax('double'),xsize/2,10*xsize,xsize/2,1,realmax('double'),realmax('double'),realmax('double'),t]; 
    [x,resnorm,residual] = lsqcurvefit(@diff_bind,x0,xdata,scan(:,:,t),lb,ub,options);
    amp_init(t) = x(1);
    Nt_init(t) = x(6);
    tauT_init(t) = x(7);
    sigT_init(t) = x(8);
end
xnew = zeros(9,tsize);
%fix amp to the median of the initial fitting
medamp = median(amp_init);
medNt =  median(Nt_init);
medtauT = median(tauT_init);
medsigT = median(sigT_init);

for t = 1:tsize
    options = optimset('TolFun',power(10,-9));
    lb = [medamp,-xsize/2,0,-xsize/2,0,medNt,medtauT,medsigT,t];
    ub = [medamp,xsize/2,10*xsize,xsize/2,1,medNt,medtauT,medsigT,t];
    [x,resnorm,residual] = lsqcurvefit(@diff_bind,x0,xdata,scan(:,:,t),lb,ub,options);
    figure(t)
    imagesc(residual)
    xnew(:,t) = x;
end