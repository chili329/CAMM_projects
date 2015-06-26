% Fit a 2D gaussian function to image
% Uses lsqcurvefit to fit
%[Amp,xo,iMSDx,yo,iMSDy,theta]

function [x, residual] = rot_fit(scan)
%scan is the input image
[xsize, ysize] = size(scan);
[X,Y] = meshgrid(-xsize/2:xsize/2-1);
%[X,Y] = meshgrid(1:xsize);
xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;
x0 = [0.1,0,20,0,20,0]; %Inital guess parameters
% --- Fit---------------------
% define lower and upper bounds 
rotation = 1;
if rotation == 1
    lb = [0,-xsize/2,0,-xsize/2,0,-pi/4];
    %ub = [realmax('double'),xsize/2,(xsize/2)^2,xsize/2,(xsize/2)^2,pi/4];
    ub = [realmax('double'),xsize/2,10*xsize,xsize/2,10*xsize,pi/4];
else
    lb = [0,-xsize/2,0,-xsize/2,0,0];
    ub = [realmax('double'),xsize/2,10*xsize,xsize/2,10*xsize,0];
end

%[Amp,xo,iMSDx,yo,iMSDy,theta]
options = optimset('TolFun',power(10,-7));
[x,resnorm,residual] = lsqcurvefit(@GaussRot,x0,xdata,scan,lb,ub,options);

%make sure x is the larger axis
if rotation ==1
    if x(3) < x(5)
        x([3,5]) = x([5,3]);
        if x(6) < 0
            x(6) = x(6)+pi/2;
        else
            x(6) = x(6)-pi/2;
        end
    end
end

