%fit with diffusion + active transport model
function [MSD,x0,y0,diff,amp,v,sig0] = iMSD_seg_diff_v(scan,time,p_size,cx,cy)

str2 = [];
%number of time points
t = size(scan,3);
t_series = (1:t).*time;

MSD = zeros(t,1);
x0 = zeros(t,1);
y0 = zeros(t,1);

model = 2;
%for all time point fitting
if model == 1
    [xnew, residual] = diff_fit_stack(scan);
end

if model == 2
    %[Amp1,x0  ,sx  ,y0  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
    %[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]
    [xori, residual] = diff_fit_stack_2G(scan);
    xnew(3,:) = xori(10,:);
    xnew(2,:) = xori(9,:);
    xnew(4,:) = xori(11,:);
end

%MSD is um^2, need to square the pixel size as well!!
MSD = xnew(3,:)*p_size*p_size;
x0 = xnew(2,:)*p_size;
y0 = xnew(4,:)*p_size;
amp = xnew(1,1);%HERE: not sure about the unit

x1 = t_series(2:end);
y = MSD(2:end);

%fit with MSD = 4Dt+sig0
%[p1,S1,mu1] = polyfit(x1,y,1);
p1 = polyfit(x1,y,1);
%fit with MSD = v^2t^2+4Dt+sig0
p2 = polyfit(x1,y,2);

%statistical test to see which equation fits better
ypred1 = polyval(p1,x1);
ypred2 = polyval(p2,x1);
resid1 = y - ypred1;                 
resid2 = y - ypred2;
SSE1 = sum(resid1.^2); 
SSE2 = sum(resid2.^2);
%residt = y - mean(y);
%SStotal = sum(residt.^2);
SStotal = sum(y.^2);
df1 = t-2; %degree of freedom
df2 = t-3;
F = (SSE1-SSE2)/(SSE2/df2);
p_value = 1-fcdf(F,df1,df2);
%str2 = strcat(str2, num2str(p_value,'%.2f'),'pValue');

%diffusion+transport
if p_value < 0.0
    p = p2;
    %p = polyfit(x1,y,2);
    v = sqrt(p(1));
    diff = p(2)/4;
    sig0 = p(3);
    Rsquare = 1-SSE2/SStotal;
    %std of residuals
    ss = sqrt(SSE2/df2);
else
%diffusion only    
    p = p1;
    %p = polyfit(x1,y,1);
    v = 0;
    diff = p(1)/4;
    sig0 = p(2);
    Rsquare = 1-SSE1/SStotal;
    %std of residuals
    ss = sqrt(SSE1/df1);
    %qhi square, not very useful
    %chi = sum((ypred1-y).^2/ypred1);
    %chiP = chi2cdf(chi,df1);
end

sig0 = sig0*p_size;

%test goodness of fit by mean square error
%fit = goodnessOfFit(x1,polyval(p,x1),'MSE');
%str2 = strcat(str2,num2str(fit,'%.2f'),'MSE');

str2 = strcat(str2,'R^2',num2str(Rsquare,'%.2f'));
str2 = strcat(str2,'std residuals',num2str(ss,'%.2f'));
%str2 = strcat(str2,'Chi^2 P',num2str(chi,'%.2f'));
%diff and v cannot be less than 0
if diff < 0
    diff = 0;
    str2 = strcat(str2,'-diff');
end
if isreal(v) == 0
    v = 0;
    str2 = strcat(str2,'-v');
end
%figure_type:
%1: complete
%2: simple
figure_type = 2;
if figure_type == 1
    %for regular individual plot
    figure(cx*1000+cy)
    hold on
    plot(x1,y,'k','linewidth',4);
    plot(t_series,x0,'g','linewidth',2)
    plot(t_series,y0,'b','linewidth',2)
    f1 = polyval(p,x1);
    plot(x1,f1,'color','r','linewidth',4);

    str1 = strcat('D=',num2str(diff,'%.2f'),' ,v=',num2str(v,'%.2f'));
    legend('MSD','x0','y0',str1)
    legend(gca,'Location','northwest')

    str2 = {str2,strcat(num2str(cx),',',num2str(cy))};
    title(str2)

    xlabel('time delay (s)','FontSize',16)
    ylabel('um^2','FontSize',16)
    set(gca,'FontSize',16)
end

if figure_type == 2
    figure
    hold on
    plot(x1,y,'k','linewidth',4);
    f1 = polyval(p,x1);
    plot(x1,f1,'color','r','linewidth',4);
    %xlabel('time delay (s)','FontSize',24)
    %ylabel('um^2','FontSize',24)
    set(gca,'FontSize',36)
    diff
end

hold on

