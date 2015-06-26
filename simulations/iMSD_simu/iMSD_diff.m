clear all
close all
%time delay
%frame rate in s
frame_rate = 0.01513;
tau = (1:100).*frame_rate;

%max MSD can be determined
pixel_size = 0.66;
total_pixel = 32;
maxMSD = pixel_size*total_pixel;

for i = 1:5
    diff = power(10,i-3);
    v = 0;
    iMSD = tau*4*diff+v.^2*tau.^2;    
    plot(tau,iMSD,'linewidth',3,'color',[double(i)/5 0.2 0.1]);
    ylim([0 maxMSD])
    str{i} = strcat('D=',num2str(diff));
    hold on
end
legend(str)
xlabel('time delay (s)')
ylabel('iMSD')
set(gca,'FontSize',16)