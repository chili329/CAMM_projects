% Fit a 2D gaussian function to image stack
% Uses lsqcurvefit to fit
%[Amp,xo,iMSD,yo,bg] where Amp is the same for all images

function [xnew, residual] = diff_fit_stack(scan)
%scan is the input image stack
[xsize, ysize, tsize] = size(scan);
residual = zeros(size(scan));
[X,Y] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1);

xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;


% --- Fit---------------------
% define lower and upper bounds
%x0 and y0 cannot be more than half image size away
%Amp/iMSD <1
%iMSD = 2*(FWHM/2.35)^2, use FWHM = xsize as the upper bound
%bg<1 
lb = [0,-xsize/2,0,-ysize/2,0];
ub = [2*(xsize/2.35)^2,xsize/2,2*(xsize/2.35)^2,xsize/2,1];
x0 = [1,0,10,0,0]; %Inital guess parameters 

xnew = zeros(5,tsize);
amp_init = zeros(tsize,1);

%first round fitting to get median amp
for t = 1:tsize
    options = optimset('TolFun',power(10,-7));
    [x,resnorm,residual(:,:,t)] = lsqcurvefit(@dif,x0,xdata,scan(:,:,t),lb,ub,options);
    amp_init(t) = x(1);
    xnew(:,t)=x;
end

%assume the particle number stays the same
%fix amp to the median of the initial fitting
medamp = median(amp_init);

lb = [medamp,-xsize/2,0,-ysize/2,0];
ub = [medamp,xsize/2,2*(xsize/2.35)^2,xsize/2,1];
x0 = [medamp,0,10,0,0];
for t = 1:tsize
    options = optimset('TolFun',power(10,-7));
    [x,resnorm,residual(:,:,t)] = lsqcurvefit(@dif,x0,xdata,scan(:,:,t),lb,ub,options);
    xnew(:,t) = x;
end

%for test purpose only, plot the fitting result
% for fr=1:tsize
%     plotgaussfit_new(scan(:,:,fr),xnew(:,fr),residual(:,:,fr));
% end