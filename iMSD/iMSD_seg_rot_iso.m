%fit with rotational+isotropic Gaussian model
function [xnew, serror] = iMSD_seg_rot_iso(scan,time,p_size,cx,cy)

str2 = [];
%number of time points
t = size(scan,3);
t_series = (2:t)*time;

MSD = zeros(t,1);
x0 = zeros(t,1);
y0 = zeros(t,1);

%for all time point fitting
%xnew:
%[Amp1,x0  ,sx  ,y0  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
%[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]
[xnew, residual, serror] = diff_fit_stack_2G(scan);

%MSD is um^2, need to square the pixel size as well!!
% MSD = xnew(3,:)*p_size*p_size;
% x0 = xnew(2,:)*p_size;
% y0 = xnew(4,:)*p_size;
% amp = xnew(1,1);
xplot = xnew;
eplot = serror;

xplot(3,:) = sqrt(xnew(3,:)./2)*2.35;
xplot(5,:) = sqrt(xnew(5,:)./2)*2.35;
xplot(10,:) = sqrt(xnew(10,:)./2)*2.35;
xplot(1,:) = xnew(1,:).*1000;
xplot(8,:) = xnew(8,:).*1000;

eplot(3,:) = sqrt(serror(3,:)./2)*2.35;
eplot(5,:) = sqrt(serror(5,:)./2)*2.35;
eplot(10,:) = sqrt(serror(10,:)./2)*2.35;
eplot(1,:) = serror(1,:).*1000;
eplot(8,:) = serror(8,:).*1000;

%%%plotting%%%
series_plot = 0;
separate_plot = 1;
if series_plot == 1
    figure(cx*1000+cy)
    %str2 = {str2,strcat(num2str(cx),',',num2str(cy))};
    %title(str2)

    %iso Gaussian parameters
    subplot(2,1,1)
    hold on
    for item = [8 10 9 11]
        errorbar(t_series,xplot(item,2:end),eplot(item,2:end),'linewidth',2)
    end
    l1 = legend('Amp(iso)*1000','s','x1','y1','Location','eastoutside','Orientation','vertical');
    hold off
    set(gca,'FontSize',16)
    set(l1,'FontSize',18);

    %rot Gaussian parameters
    subplot(2,1,2)
    hold on
    for item = [1 3 5 2 4 6]
        errorbar(t_series,xplot(item,2:end),eplot(item,2:end),'linewidth',2)
    end
    l2 = legend('Amp(rot)*1000','sx','sy','x0','y0','theta','Location','eastoutside','Orientation','vertical');
    hold off
    set(gca,'FontSize',16)
    set(l2,'FontSize',18);
end
%%%combined plot%%%
% figure('units','normalized','position',[.1 .1 1 0.5])
% xplot(1,:) = xnew(1,:);
% xplot(8,:) = xnew(8,:);
% eplot(1,:) = serror(1,:);
% eplot(8,:) = serror(8,:);
% [hAx,h1,h2] = plotyy(t_series,xplot([1 8],2:end),t_series,xplot([3 5 10],2:end));
% 
% %add errorbar
% hold(hAx(1), 'on');
% errorbar(hAx(1),t_series,xplot(1,2:end),eplot(1,2:end),'Linewidth',3,'color',[.2 .2 .2]);
% errorbar(hAx(1),t_series,xplot(8,2:end),eplot(8,2:end),'Linewidth',3,'color',[.6 .6 .6]);
% hold(hAx(2), 'on');
% errorbar(hAx(2),t_series,xplot(3,2:end),eplot(3,2:end),'Linewidth',3,'color',[1 0 1]);
% errorbar(hAx(2),t_series,xplot(5,2:end),eplot(5,2:end),'Linewidth',3,'color',[0.5 0 1]);
% errorbar(hAx(2),t_series,xplot(10,2:end),eplot(10,2:end),'Linewidth',3,'color',[0 0 1]);
% 
% %lc = legend('Amp(rot)','Amp(iso)','sx','sy','s','Location','northoutside','Orientation','horizontal');
% set(hAx,'FontSize',18)
% set(hAx,{'ycolor'},{'k';'b'})
% ylabel(hAx(1),'Amp')
% ylabel(hAx(2),'FWHM(pixel)')
% set(hAx,'box','off')


%%%separate plot%%%
if separate_plot == 1
    figure('units','normalized','position',[.1 .1 0.2 0.3])
    hAx1 = subplot(1,1,1);
    hold(hAx1, 'on');
    xplot(1,:) = xnew(1,:);
    xplot(8,:) = xnew(8,:);
    eplot(1,:) = serror(1,:);
    eplot(8,:) = serror(8,:);
    errorbar(hAx1,t_series,xplot(1,2:end),eplot(1,2:end),'Linewidth',4,'color',[.2 .2 .2]);
    errorbar(hAx1,t_series,xplot(8,2:end),eplot(8,2:end),'Linewidth',4,'color',[.6 .6 .6]);
    set(hAx1,'FontSize',24)
    axis([-inf inf 0 inf])
    %legend('Amp(rot)','Amp(iso)')

%     hAx2 = subplot(2,1,2);
%     hold(hAx2, 'on');
%     errorbar(hAx2,t_series,xplot(3,2:end),eplot(3,2:end),'Linewidth',4,'color',[1 0 1]);
%     errorbar(hAx2,t_series,xplot(5,2:end),eplot(5,2:end),'Linewidth',4,'color',[0.5 0 1]);
%     errorbar(hAx2,t_series,xplot(10,2:end),eplot(10,2:end),'Linewidth',4,'color',[0 0 1]);
%     set(hAx2,'FontSize',24)
%     ylim(hAx2,[-50 50])
    %legend('sx','sy','s')
end