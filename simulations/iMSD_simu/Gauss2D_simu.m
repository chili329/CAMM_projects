close all
x=linspace(-1.6,1.6,32);
y=x';               
[X,Y]=meshgrid(x,y);
for iMSD = 1:10
    subplot(2,5,iMSD)
    iMSD = iMSD*0.1;
    z=1/iMSD*exp(-(X.^2+Y.^2)/iMSD);
    surf(x,y,z,'lineStyle','none');
    view(2)
    zlim([0 1])
    axis image
    set(gca,'xtick',[],'ytick',[])
    titlestr = strcat('iMSD =',num2str(iMSD));
    title(titlestr)
    colormap jet
end