%calculate average G and S value based on intensity threshold
close all
clear all
%file reading
ref_file = uipickfiles;
num_file = size(ref_file,2);
G_total = [];
S_total = [];
s_color = [];
%read multiple files
for i = 1 : num_file
    filename = ref_file{i};
    %HERE
    %take filename and identify the exp condition (cell type, days,
    %treatment etc.)
    condition = strsplit(filename,'/');
    condition = condition(end);
    
    [ref_int, G, S, ref_ph1, ref_md1] = ref_read(filename);
    
    %median filter for G and S
    G = medfilt2(G, [5 5]);
    S = medfilt2(S, [5 5]);
    
    %select only points above certain intensity
    int_min = 20;
    G(int_min > ref_int) = NaN;
    S(int_min > ref_int) = NaN;
    
    %HERE
    %cell segmentation, still pretty bad
    mask = flim_cell_seg(ref_int);
    
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
            s_color = cat(1,s_color,i);
        end
    end
    G_total = cat(1,G_total,Gmean_total);
    S_total = cat(1,S_total,Smean_total);
end

figure
%s_color = linspace(1,10,size(G_total,1));
scatter(G_total,S_total,[],s_color,'filled','MarkerEdgeColor',[0 0 0])
xlabel('g')
ylabel('s')
set(gca,'FontSize',16) 