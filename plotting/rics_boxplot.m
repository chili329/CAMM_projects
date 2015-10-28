%plot AR RICS, calculate p value
%read the data from RICS_total.xls
%AR_RICS(:,1): location, nucleus = 0, cytoplasm = 1
%AR_RICS(:,2): time, -1 = before ligand, 0 = 0-10 min, 1 = 10-20 min, 2 =
%20-30 min, 3 = 30 min longer
%AR_RICS(:,3): diffusion coefficient
%AR_RICS(:,4): G0
%AR_RICS(:,5): Chi square, fitting quality

close all
%count number of occurances
[x,y] = size(AR_RICS);

num_nuc = sum(AR_RICS(:,1) == 0);
num_cyt = sum(AR_RICS(:,1) == 1);

num_before = sum(AR_RICS(:,2) == -1);
num_0 = sum(AR_RICS(:,2) == 0);
num_1 = sum(AR_RICS(:,2) == 1);
num_2 = sum(AR_RICS(:,2) == 2);
num_3 = sum(AR_RICS(:,2) == 3);

%pre-allocation
AR_nuc = nan(x,1);
AR_cyt = nan(x,1);

AR_before = nan(x,1);
AR_0 = nan(x,1);
AR_1 = nan(x,1);
AR_2 = nan(x,1);
AR_3 = nan(x,1);

%grouping
for i = 1:x
    %filter
    if AR_RICS(i,5) < 20000
        
        %group by location
        if AR_RICS(i,1) == 0
            AR_nuc(i) = AR_RICS(i,3);
        elseif AR_RICS(i,1) == 1
            AR_cyt(i) = AR_RICS(i,3);
        end
        %group by time
        if AR_RICS(i,2) == -1
            AR_before(i) = AR_RICS(i,3);
        elseif AR_RICS(i,2) == 0
            AR_0(i) = AR_RICS(i,3);
        elseif AR_RICS(i,2) == 1
            AR_1(i) = AR_RICS(i,3);
        elseif AR_RICS(i,2) == 2
            AR_2(i) = AR_RICS(i,3);
        elseif AR_RICS(i,2) == 3
            AR_3(i) = AR_RICS(i,3);
        end
        
    end
end

%boxplot based on location
figure
b1 = boxplot([AR_nuc AR_cyt],'colors','k');
ylabel('D (um^2/s)','FontSize',24)
set(gca,'FontSize',24)
set(gca,'XTickLabel',{'Nucleus','Cytoplasm'})
set(b1,'linewidth',2);

%boxplot based on time
figure
b2 = boxplot([AR_before AR_0 AR_1 AR_2 AR_3],'color','k');
ylabel('D (um^2/s)','FontSize',24)
set(gca,'FontSize',24)
set(gca,'XTickLabel',{'No ligand','0-10 min','10-20 min','20-30 min','30- min'})
set(b2,'linewidth',2);
%ttest
[hn,pn] = ttest2(AR_nuc,AR_cyt);
[h0,p0] = ttest2(AR_before,AR_0);
[h1,p1] = ttest2(AR_before,AR_1);
[h2,p2] = ttest2(AR_before,AR_2);
[h3,p3] = ttest2(AR_before,AR_3);

