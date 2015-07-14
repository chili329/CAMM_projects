%load multiple files and perform cell segmentation for each file
%calculate average G and S value of each cell
%compare experimental groups

%input:
%num_group - number of groups to compare
%cell_seg -
%0: no segmentation
%1: perform automatic cell segmentation
%2: manual cell segmentation
function [mask] = cell_phasor_groups(num_group,cell_seg)
%close all
%clear all

%file reading
ref_file = [];
num_file = [];
%num_group = 2;
for m = 1:num_group
    ref_file{m} = uipickfiles;
    num_file(m) = size(ref_file{m},2);
end

G_total = [];
S_total = [];
exp_group = [];

%read multiple files
for k = 1:num_group
    for i = 1 : num_file(k)
        filename = ref_file{k}{i};
        %HERE
        %take filename and identify the exp condition (cell type, days,
        %treatment etc.)
        %condition = strsplit(filename,'/');
        %condition = condition(end);

        [ref_int, G, S, ref_ph1, ref_md1] = ref_read(filename);

        %median filter for G and S
        G = medfilt2(G, [5 5]);
        S = medfilt2(S, [5 5]);

        %select only points above certain intensity
        int_min = 20;
        G(int_min > ref_int) = NaN;
        S(int_min > ref_int) = NaN;

        %HERE
        %automatic cell segmentation, still pretty bad
        if cell_seg == 1
            mask = flim_cell_seg(ref_int);
        %manual selection. save the mask?
        elseif cell_seg == 2
            mask = multi_ROI(ref_int);
        %no segmentation
        else
            mask = ones(256,256,1);
        end
        

        %from each file, extract cells
        cell_num = size(mask,3);
        Gmean_total = [];
        Smean_total = [];
        for j = 1:cell_num
            Gcell = double(mask(:,:,j)).*G;
            Scell = double(mask(:,:,j)).*S;
            Gmean=nanmean(Gcell(:));
            Smean=nanmean(Scell(:));
            if Gmean > 0 && Smean > 0
                
                Gmean_total = cat(1,Gmean_total,Gmean);
                Smean_total = cat(1,Smean_total,Smean);
                
                %color dots by files
                %s_color = cat(1,s_color,k);
                
                %create grouping
                exp_group = cat(1,exp_group,k);
            end
        end
        G_total = cat(1,G_total,Gmean_total);
        S_total = cat(1,S_total,Smean_total);
    end
end

%HERE: add group average?
%for k = 1:num_group
%    G_groupmean(k)
%    S_groupmean(k)
%end

figure
%s_color = linspace(1,10,size(G_total,1));
%scatter(G_total,S_total,[],s_color,'filled','MarkerEdgeColor',[0 0 0])
gscatter(G_total,S_total,exp_group)
xlabel('g')
ylabel('s')
%legend('group1','group2','Location','Best');
set(gca,'FontSize',16) 