%RICS fitting
%input: Corr2D
function [D] = ricsDfit(Corr2D)

%@ricsDiff(x,xdata)
%x = [gamma/N,D]

[xsize, ysize] = size(Corr2D);
[X,Y] = meshgrid(-xsize/2:xsize/2-1,-xsize/2:xsize/2-1);
xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;

lb = [0,0];
ub = [1,100];
x0 = [0.1,1];
options = optimset('TolFun',power(10,-7));
[x,resnorm,residual] = lsqcurvefit(@ricsDiff,x0,xdata,Corr2D,lb,ub,options);