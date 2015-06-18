total_z = 8;
total_time = 62;
AR = lsm_read(1,[1:total_z]);

mean_AR = reshape(mean(mean(AR,1),2),[size(AR,3) 1]);

for z = 1:total_z
    time = zeros(total_time,1);
    for t = 1:total_time
        time(t) = mean_AR(z+(t-1)*total_z);
    end
    plot(time,'Color',[z/20,z/10,z/10],'LineWidth',2)
    hold on
end
legend('z1','z2','z3','z4','z5','z6','z7','z8')
