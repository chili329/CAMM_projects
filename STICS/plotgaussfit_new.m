%plot the original correlation, fitted result, and residual
%scan: original image
%x: fitted parameters
%residual: difference between scan and fitted result
function plotgaussfit_new(scan,x,residual);
[xsize,ysize] = size(scan);
[X,Y] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1);

xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;

fit_option = 2;
if fit_option == 1
    %use @dif
    F = x(1)./x(3).*exp(-((xdata(:,:,1)-x(2)).^2/x(3) + (xdata(:,:,2)-x(4)).^2/x(3) ))+x(5);
    
    str1 = strcat('Amp',num2str(x(1),'%.2f'),'iMSD',num2str(x(3),'%.2f'),'bg',num2str(x(5),'%.2f'));
end

if fit_option == 2
    %use @GaussRot_Gauss
    xdatarot(:,:,1)= xdata(:,:,1)*cos(x(6)) - xdata(:,:,2)*sin(x(6));
    xdatarot(:,:,2)= xdata(:,:,1)*sin(x(6)) + xdata(:,:,2)*cos(x(6));
    x0rot = x(2)*cos(x(6)) - x(4)*sin(x(6));
    y0rot = x(2)*sin(x(6)) + x(4)*cos(x(6));

    F = x(7)+...
        x(1)*exp(-((xdatarot(:,:,1)-x0rot).^2/x(3) + (xdatarot(:,:,2)-y0rot).^2/x(5) ))+...
        x(8)*exp(-((xdata(:,:,1)-x(9)).^2+(xdata(:,:,2)-x(11)).^2)/x(10));
    %[Amp1,x0  ,sx  ,y0  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
    %[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]
    str1 = strcat('sx:',num2str(sqrt(x(3)./2)*2.35,'%.0f'),...
        '/sy:',num2str(sqrt(x(5)./2)*2.35,'%.0f'),...
        '/s:',num2str(sqrt(x(10)./2)*2.35,'%.0f'),...
        '/theta',num2str(x(6).*180/pi,'%.2f'),'/bg',num2str(x(7)));
end

figure
subplot(1,2,1)
s=surf(scan);
set(s,'FaceColor','interp')
%set(s,'EdgeColor','none')
set(s,'FaceAlpha',0.7)
set(gca,'FontSize',20)
hold on
m = mesh(xdata(:,:,1),xdata(:,:,2),F);
set(m,'EdgeColor',[0.2 0.2 0.2])

title(str1)
set(gca,'FontSize',16)
subplot(1,2,2)
surf(residual)