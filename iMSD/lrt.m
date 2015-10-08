%likelihood ratio test to determine whether a more complicated model should
%be used
%compare model 1 (a special case of model 2) and model 2
%input: 
%   mse1: mean square error from model 1 
%   mse2: mean square error from model 2 --> smaller than mse1
%   N: number of datapoint (image size)
%   df: degree of freedom difference between model 1 and 2

function [p_value] = lrt(mse1,mse2,N,df)

lambda = N*log((mse1/mse2)^2);
%if lambda is large, chi2cdf is large -> more likely model 2 is correct 
p_value = chi2cdf(lambda,df,'upper');

%p_value = 1 - chi2cdf(lambda,df);
