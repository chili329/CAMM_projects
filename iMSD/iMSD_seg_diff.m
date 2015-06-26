%fit with diffusion model
function [MSD,x0,y0,diff,sig0] = iMSD_seg_diff(scan,time,p_size,cx,cy)

%number of time points
t = size(scan,3);
t_series = (1:t).*time;

MSD = zeros(t,1);
x0 = zeros(t,1);
y0 = zeros(t,1);

%for all time point fitting
[xnew, residual] = diff_fit_stack(scan);
MSD = xnew(3,:)*p_size;
x0 = xnew(2,:)*p_size;
y0 = xnew(4,:)*p_size;
amp = xnew(1,1);

%fit with MSD = 4Dt+sig0
p = polyfit(t_series(2:end),MSD(2:end),1);
diff = p(1)/4;
sig0 = p(2);

figure(cx*1000+cy)
hold on
plot(t_series,MSD,'k','linewidth',2)
plot(t_series,x0,'g','linewidth',2)
plot(t_series,y0,'b','linewidth',2)
hline = refline(4*diff,sig0)
hline.Color = 'r';

str1 = strcat('D=',num2str(diff,'%.2f'));
legend('MSD','x0','y0',str1)
legend(gca,'Location','northwest')

str2 = strcat(num2str(cx),',',num2str(cy));
title(str2)

xlabel('time delay (s)','FontSize',16)
ylabel('um','FontSize',16)
set(gca,'FontSize',16)


