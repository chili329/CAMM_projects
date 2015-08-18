%plot AR RICS, calculate p value
%load AR_RICS.mat
boxplot(AR_loc_time)
%HERE
%xlabel('-0 c','-0 p','0-10 c','0-10 p','10-20 c','10-20 p','20-30 c','20-30 p','30- c','30- p')

%HERE
[h,p] = ttest2(AR_loc_time(:,1),AR_loc_time(:,2))