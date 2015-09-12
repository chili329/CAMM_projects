% Fit two 2D gaussian function to image stack with rotational + isotropic
% Gaussian
% Uses lsqcurvefit to fit
%[Amp1,x0  ,sx  ,y0  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
%[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]

function [xnew, residual] = diff_fit_stack_2G(scan)
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
%bg<1 
%s, sx, sy = 2*(FWHM/2.35)^2, use FWHM = xsize as the upper bound

%[Amp, xo,  iMSD, yo,  bg]
% Uses lsqcurvefit to fit

Amp1l = 0;Amp1u = 1;
Amp2l = 0;Amp2u = 1;
xylim = 10;
x0l = -xsize/xylim;x0u = xsize/xylim;
y0l = -ysize/xylim;y0u = ysize/xylim;
x1l = -xsize/xylim;x1u = xsize/xylim;
y1l = -ysize/xylim;y1u = ysize/xylim;
sxl = 0;sxu = 2*(xsize/2.35)^2;
syl = 0;syu = 2*(xsize/2.35)^2;
sl = 0;su = 2*(xsize/2.35)^2;
thl = 0;thu = pi/2;
bgl = 0;bgu = 1;

lb = [Amp1l,x0l,sxl,y0l,syl,thl,bgl,Amp2l,x1l,sl,y1l];
ub = [Amp1u,x0u,sxu,y0u,syu,thu,bgu,Amp2u,x1u,su,y1u];
x0 = (lb+ub)./2; %Inital guess parameters 

xnew = zeros(11,tsize);

%first round fitting to get median amp
for t = 1:tsize
    options = optimset('TolFun',power(10,-7));
    [x,resnorm,residual(:,:,t)] = lsqcurvefit(@GaussRot_Gauss,x0,xdata,scan(:,:,t),lb,ub,options);
    
    xnew(:,t)=x;
    
    %if amp1 is 0, then the rest is 0
    if xnew(1,t) == 0
        xnew(2,t) = 0;
        xnew(3,t) = 0;
        xnew(4,t) = 0;
        xnew(5,t) = 0;
        xnew(6,t) = 0;
    end
    %if amp2 is less than 5% amp1, then 0
    if xnew(8,t) < xnew(1,t)*0.05
        xnew(9,t) = 0;
        xnew(10,t) = 0;
        xnew(11,t) = 0;
    end
    %x axis is the longer one
    if xnew(3,t)<xnew(5,t)
        [xnew(3,t),xnew(5,t)] = deal(xnew(5,t),xnew(3,t));
        %decide whether add pi/4 or subtract pi/4 by the difference with
        %previous point
        if t > 1
            if abs(xnew(6,t)-pi/4-xnew(6,t-1)) < abs(xnew(6,t)+pi/4-xnew(6,t-1))
                xnew(6,t) = xnew(6,t)-pi/4;
            else
                xnew(6,t) = xnew(6,t)+pi/4;
            end
        end
    end
end

%for test purpose only, plot the fitting result
for fr=1:tsize
    plotgaussfit_new(scan(:,:,fr),xnew(:,fr),residual(:,:,fr));
end