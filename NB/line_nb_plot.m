%plot line N&B
function line_nb_plot(s_pixel, data)

[brightness,number] = line_nb(data);

pixel = 1:size(number,1);
pixel = s_pixel*pixel;
[hAx,hLine1,hLine2] = plotyy(pixel,number,pixel,brightness,'plot','plot');

set(hAx,{'ycolor'},{'r';'b'});
set(hLine1,'color','r','linewidth',2) 
set(hLine2,'color','b','linewidth',2)

title('line N&B')
xlabel('(\mum)','FontSize',20)

ylabel(hAx(2),'Brightness','FontSize',20)
ylabel(hAx(1),'Number','FontSize',20)
%set(hAx,'FontSize',16)