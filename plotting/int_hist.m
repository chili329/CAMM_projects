%plot intensity histogram of the entire image stack
function int_hist(ch)
    close all
    mov = lsm_read(ch);
    [x,y,t] = size(mov);
    mov = reshape(mov,x*y*t,1);
    hist(mov,40)
    xlim([1400,8000])
    set(gca,'FontSize',16)
    colormap(gca,'gray')