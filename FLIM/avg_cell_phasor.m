%calculate average G and S value based on cell segmentation (flim_cell_seg)
%displays original intensity, segmentation image, cell phasor plot
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
    [mask_old,cell_img,int3] = flim_cell_seg(ref_int);
    [x,y,z] = size(mask_old);
    mask = NaN([x,y,z]);
    
    %discard if the mean intensity of selected region is too low
    n = 1;
    for m = 1:z    
        cell = cell_img(:,:,m);
        cell_int = nanmean(nanmean(cell));
        if cell_int > 1
            if numel(cell(cell>10)) > 100
                mask(:,:,n) = mask_old(:,:,m);
                n = n+1;
            end
        end
    end
    
    mask = mask(:,:,1:n-1);
    
    %from each file, extract cells
    cell_num = size(mask,3);
    Gmean_total = [];
    Smean_total = [];
    Gmask = [];
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
        %mask with Gcell number
        Gmask(:,:,j) = mask(:,:,j).*((Gmean-0.5)*10);
        Smask(:,:,j) = mask(:,:,j).*((Smean-0.3)*10);
    end
    G_total = cat(1,G_total,Gmean_total);
    S_total = cat(1,S_total,Smean_total);
end


figure
%original image
subplot(2,2,3)
imagesc(ref_int)
title(condition)
axis image
%filtered image
subplot(2,2,1)
total_Smask = nansum(Smask,3);
imagesc(total_Smask)
title('Smask')
axis image
%total mask
subplot(2,2,2)
total_Gmask = nansum(Gmask,3);
imagesc(total_Gmask)
title('Gmask')
axis image
colormap('jet')

%cell phasor
subplot(2,2,4)
%s_color = linspace(1,10,size(G_total,1));
scatter(G_total,S_total,[],s_color,'filled','MarkerEdgeColor',[0 0 0])
xlabel('g')
ylabel('s')
set(gca,'FontSize',16) 