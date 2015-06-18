%use PCA to find the direction of the image
clear all
close all
%sample image data
load('PCA_test.mat');
real_img = imread('pca_test2.png');
[x1,y1,ch] = size(real_img);
x1 = min(x1,y1);
%PCA_test = PCA_test';
%PCA_test = fliplr(PCA_test);

test_img = double(real_img(1:x1,1:x1,1));
%test_img = PCA_ver;
test_img = fliplr(test_img);

[x, y] = size(test_img);
int_total = reshape(test_img,x*y,1);
meshimg = meshgrid(1:x);
ygrid = reshape(meshimg,x*y,1);
xgrid = reshape(meshimg',x*y,1);

%%%%%%%%%%%attempt 2
%calculate covariance
ax = 0;
ay = 0;
for i = 1:x*y
    ax = ax + xgrid(i).*int_total(i);
    ay = ay + ygrid(i).*int_total(i);
end
at = sum(int_total);
%normalize intensity
int_total = int_total/at;

c11 = 0;
c12 = 0;
c22 = 0;
for i = 1:1*x*y
    c11 = c11 + int_total(i)*(xgrid(i)-x/2)^2;
    c22 = c22 + int_total(i)*(ygrid(i)-y/2)^2;
    c12 = c12 + int_total(i)*(xgrid(i)-x/2)*(ygrid(i)-y/2);
end

cov_matrix = [c11 c12;c12 c22];

%eigen decomposition of covariance matrix
%V: eigenvector -> direction of the data
%D: eigenvalue -> magnitude S = sqrt(D)
[V D] = eig(cov_matrix)

imagesc(test_img);
colormap gray
hold on
if D(1,1) > D(2,2)
    slope = V(1,2)/V(1,1)
else
    slope = V(2,1)/V(2,2)
end
%minus sign due to image plotting in MATLAB is inverted
if slope < 0
    refline(slope,x);
else
    refline(slope,0);
end

%sample scatter data
% total = 20;
% x1 = 1:total;
% x2 = x1*(-0.1)+rand(1,total);
% 
% 
% x1mean = mean(x1);
% x2mean = mean(x2);
% 
% %standardize data
% %send to origin
% x1new = x1-x1mean;
% x2new = x2-x2mean;
% X(:,1) = x1new;
% X(:,2) = x2new;
% 
% pcacoe = pca(X)
% scatter(x1,x2,'r*')
% hold on
% angle = (pcacoe(2,1)./pcacoe(1,1));
% refline(angle,-x2mean)