%fit with rotational+isotropic Gaussian model
function [xnew] = iMSD_seg_rot_iso(scan,time,p_size,cx,cy)

str2 = [];
%number of time points
t = size(scan,3);
t_series = (2:t).*time;

MSD = zeros(t,1);
x0 = zeros(t,1);
y0 = zeros(t,1);

%for all time point fitting
%xnew:
%[Amp1,x0  ,sx  ,y0  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
%[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]
[xnew, residual] = diff_fit_stack_2G(scan);

%MSD is um^2, need to square the pixel size as well!!
% MSD = xnew(3,:)*p_size*p_size;
% x0 = xnew(2,:)*p_size;
% y0 = xnew(4,:)*p_size;
% amp = xnew(1,1);
xplot = xnew;
xplot(3,:) = xnew(3,:)./100;
xplot(5,:) = xnew(5,:)./100;
xplot(10,:) = xnew(10,:)./100;
xplot(1,:) = xnew(1,:).*100;
xplot(8,:) = xnew(8,:).*100;

%for regular individual plot
figure(cx*1000+cy)
hold on
for item = 1:11
    plot(t_series,xplot(item,2:end),'linewidth',2)
end
legend('Amp1*100','x0','sx/100','y0','sy/100','theta','bg','Amp2*100','x1','s/100','y1')
hold off
str2 = {str2,strcat(num2str(cx),',',num2str(cy))};
title(str2)

set(gca,'FontSize',16)
