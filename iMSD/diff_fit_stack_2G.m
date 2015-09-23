% Fit two 2D gaussian function to image stack with rotational + isotropic
% Gaussian
% Uses lsqcurvefit to fit
%[Amp1,x0  ,sx  ,y0  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
%[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]

function [xnew, residual, serror] = diff_fit_stack_2G(scan)
%scan is the input image stack
[xsize, ysize, tsize] = size(scan);
residual = zeros(size(scan));
[X,Y] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1);

xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;


% --- Fit---------------------
% define lower and upper bounds

%Amp1: rotational Gaussian
%Amp2: iso Gaussian
Amp1l = 0;Amp1u = 1;
Amp2l = 0;Amp2u = 1;

%restrict center position
xylim = 10;
x0l = -xsize/xylim;x0u = xsize/xylim;
y0l = -ysize/xylim;y0u = ysize/xylim;
x1l = -xsize/xylim;x1u = xsize/xylim;
y1l = -ysize/xylim;y1u = ysize/xylim;

%s, sx, sy = 2*(FWHM/2.35)^2, use FWHM = xsize as the upper bound
%use FWHM = 2.35 as the lower bound, for the very sharp, single pixel peak
%is not of interest
sxl = 2;sxu = 2*(xsize/2.35)^2;
syl = 2;syu = 2*(xsize/2.35)^2;
sl = 2;su = 2*(xsize/2.35)^2;

thl = 0;thu = pi/2;
bgl = 0;bgu = 1;

lb = [Amp1l,x0l,sxl,y0l,syl,thl,bgl,Amp2l,x1l,sl,y1l];
ub = [Amp1u,x0u,sxu,y0u,syu,thu,bgu,Amp2u,x1u,su,y1u];
x0 = (lb+ub)./2; %Inital guess parameters 

xnew = zeros(11,tsize);
serror = zeros(11,tsize);

%first round fitting to get median amp
for t = 1:tsize
    
    %use the previous fit result as the initial guess
    if t > 1
        x0 = x;
    end
    mean_scan = mean(mean(mean(scan(:,:,t))));
    options = optimset('TolFun',power(10,-7));
    [x,resnorm,r,exitflag,output,lambda,J] = lsqcurvefit(@GaussRot_Gauss,x0,xdata,scan(:,:,t),lb,ub,options);
    
    %degenerate fit, only isotropic Gaussian
    [x2,resnorm2,r2,exitflag2,output2,lambda2,J2] = lsqcurvefit(@Gaussiso,x0(7:11),xdata,scan(:,:,t),lb(7:11),ub(7:11),options);
    
    %statistical test for goodness of fit
    SSE1 = resnorm; 
    SSE2 = resnorm2;
    SStotal = sum(sum((scan(:,:,t)-mean_scan*ones(xsize,ysize,1)).^2));
    rsquare = 1-SSE1/SStotal
    rsquare2 = 1-SSE2/SStotal
    
    %issue with F test: df too large, always return p_value = 0!
    %df1 = xsize.*ysize-11; %degree of freedom
    %df2 = xsize.*ysize-5;
    %F = ((SSE1-SSE2)/(df1-df2))/(SSE2/df2);
    %p_value = 1-fcdf(F,df1,df2);
    
    %rsquare(iso+rot) is always larger than rsquare2(iso)
    %rsquare2 <rt and rsquare <rt --> all 0
    %rsquare2 <rt and rsquare >rt --> iso+rot
    %rsauare2 >rt --> iso
    
    rt = 0.75;
    
    %poor fit, everything goes to 0
    if rsquare2 < rt/5 && rsquare < rt/5   
        x = zeros(1,11);
        r = zeros(size(r));
        J = zeros(size(J));
    end
    
    %only iso
    if rsquare2 > rt
        x = cat(2,zeros(1,6),x2);
        r = r2;
        J = J2;
    end
     
    %calculate standard errors from Jacobian and residuals
    [Q,R] = qr(J,0);
    mse = sum(sum(abs(r).^2))/(size(J,1)-size(J,2));
    Rinv = inv(R);
    Sigma = Rinv*Rinv'*mse;
    se = sqrt(diag(Sigma));
    
    residual(:,:,t) = r;
    xnew(:,t)=x;
    
    %poor fit, everything goes to 0
    if rsquare2 < rt/5 && rsquare < rt/5 
        serror(:,t) = zeros(size(se(:,1)));
    end
    %only iso
    if rsquare2 > rt
        serror(:,t) = cat(1,zeros(6,1),se(:,1));
    end
    
    if rsquare > rt && rsquare2 < rt
        serror(:,t) = se(:,1);
    end
    
    %if amp2 is smaller than 0.01, then the rest is 0
    %if amp2 is less than 1% amp1, then 0
    if xnew(8,t) < 0.0005 || xnew(8,t) < xnew(1,t)*0.01
        xnew(8,t) = 0;
        xnew(9,t) = 0;
        xnew(10,t) = 0;
        xnew(11,t) = 0;
    end
    
    %if amp1 is smaller than 0.01, then the rest is 0
    %OR if amp1 is less than 1% amp2, then 0
    if xnew(1,t) < 0.0005 || xnew(1,t) < xnew(8,t)*0.01
        xnew(1,t) = 0;
        xnew(2,t) = 0;
        xnew(3,t) = 0;
        xnew(4,t) = 0;
        xnew(5,t) = 0;
        xnew(6,t) = 0;
    end
    
    %x axis is the longer one
    if xnew(3,t)<xnew(5,t)
        [xnew(3,t),xnew(5,t)] = deal(xnew(5,t),xnew(3,t));
        [serror(3,t),serror(5,t)] = deal(serror(5,t),serror(3,t));
        %decide whether add pi/2 or subtract pi/2 by the difference with
        %previous point
        if t > 1
            if abs(xnew(6,t)-pi/2-xnew(6,t-1)) < abs(xnew(6,t)+pi/2-xnew(6,t-1))
                xnew(6,t) = xnew(6,t)-pi/2;
            else
                xnew(6,t) = xnew(6,t)+pi/2;
            end
        end
    end
    
end

%bring theta to the same level
if min(xnew(6,:)) > 0.9*pi/2
    xnew(6,:) = xnew(6,:)-ones(1,tsize).*pi;
elseif max(xnew(6,:)) < 0
    xnew(6,:) = xnew(6,:)+ones(1,tsize).*pi;
end
    
%for test purpose only, plot the fitting result
% for fr=1:tsize
%     plotgaussfit_new(scan(:,:,fr),xnew(:,fr),residual(:,:,fr));
% end