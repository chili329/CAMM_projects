%load multiple files and perform cell segmentation for each file
%calculate average G and S value of each cell
%compare experimental groups

%input:
%num_group - number of groups to compare
%cell_seg -
    %0: no segmentation
    %1: perform automatic cell segmentation (default)
    %2: manual cell segmentation
    %3: automatic grid segmentation --> each grid is 32x32 pixels, so the
    %total grid for 256x256 image is 64.
%folder_mode -
    %0: select files for each group
    %1: select folders (default)
function [G_total,S_total,exp_group,mask] = cell_phasor_groups(num_group,cell_seg,folder_mode)
%close all
%clear all

%file reading
ref_file = [];
num_file = [];

%default
if nargin == 1 
    cell_seg = 1;
    folder_mode = 1;
end 
if nargin == 2
    folder_mode = 1;
end


for m = 1:num_group
    %for directly selecting files
    if folder_mode == 0
        ref_file{m} = uipickfiles;
        num_file(m) = size(ref_file{m},2);
    end
end

G_total = [];
S_total = [];
exp_group = [];

%read multiple files
if folder_mode == 1
    ref_folder = uipickfiles;
end
for cell = 1:num_group
    if folder_mode == 1
        ref_file = getAllFiles(ref_folder{cell});
        num_file(cell) = size(ref_file,1);
    end
    for i = 1 : num_file(cell)
        if folder_mode == 0
            filename = ref_file{cell}{i};
        else
            filename = ref_file{i};
        end
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
        elseif cell_seg == 0
            mask = ones(256,256,1);
        %grid segmentation
        elseif cell_seg == 3
            gsize = 64;
            g_num = 256/gsize;
            mask = NaN(256,256,g_num^2);
            grid = 0;
            for hori = 1:g_num
                for verti = 1:g_num
                    grid = grid+1;
                    mask(1+(hori-1)*gsize:hori*gsize,1+(verti-1)*gsize:verti*gsize,grid) = ones(gsize,gsize);
                end
            end
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
                exp_group = cat(1,exp_group,cell);
            end
        end
        G_total = cat(1,G_total,Gmean_total);
        S_total = cat(1,S_total,Smean_total);
    end
end

%add S and G group mean
Ggm = zeros(num_group,1);
Sgm = zeros(num_group,1);

for cell = 1:num_group
    Glist = G_total(exp_group==cell);
    Slist = S_total(exp_group==cell);
    Ggm(cell) = mean(Glist);
    Sgm(cell) = mean(Slist);
end

%determine if the groups are significantly different using Hotelling's T-Squared test for two multivariate independent samples 
%with unequal covariance matrices.
stat_input = zeros(size(exp_group,1),3);
for i = 1:size(exp_group)
    stat_input(i,:) = [exp_group(i) G_total(i) S_total(i)];
end

%HERE: also perform p value only based on g value or linear NADH line
p_value = T2Hot2ihe(stat_input);

figure
%s_color = linspace(1,10,size(G_total,1));
%scatter(G_total,S_total,[],s_color,'filled','MarkerEdgeColor',[0 0 0])
gscatter(G_total,S_total,exp_group,'brbr','xxoo',14)
xlabel('g')
ylabel('s')

% for NADH channel
%should make equal axis?
axis([0.2 0.8 0 0.6]);
% for Coumarin
%axis([0.35 0.4 0.46 0.51])

%add reference line to show the control mean
meanG = 0.52;
meanS = 0.34;
hold on
h1 = line(xlim,[meanS,meanS]);
h2 = line([meanG,meanG],ylim);
h1.LineStyle = '--';
h2.LineStyle = '--';
h1.Color = [0.5 0.5 0.5];
h2.Color = [0.5 0.5 0.5];
%CHANGE FOR DIFFERENT GROUPS
%g1 = strcat('PC9 control,G:',num2str(Ggm(1),'%.2f'),',S:',num2str(Sgm(1),'%.2f'));
%g2 = strcat('PC9 E,G:',num2str(Ggm(2),'%.2f'),',S:',num2str(Sgm(2),'%.2f'));
%g3 = strcat('T790M control,G:',num2str(Ggm(3),'%.2f'),',S:',num2str(Sgm(3),'%.2f'));
%g4 = strcat('T790M E,G:',num2str(Ggm(4),'%.2f'),',S:',num2str(Sgm(4),'%.2f'));
%legend(g1,g2,g3,g4,'Location','Best')
title(num2str(p_value))
set(gca,'FontSize',20)
