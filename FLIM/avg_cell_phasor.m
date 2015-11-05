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
    condition = strrep(condition, '_', '\_');
    
    [ref_int, G, S, ref_ph1, ref_md1] = ref_read(filename);
    
    %median filter for G and S
    G = medfilt2(G, [5 5]);
    S = medfilt2(S, [5 5]);
    
    %select only points above certain intensity
    int_min = 20;
    G(int_min > ref_int) = NaN;
    S(int_min > ref_int) = NaN;
    
    
    %cell segmentation
    [mask_old,cell_img,int3] = flim_cell_seg(ref_int);
    [x,y,z] = size(mask_old);
    
    %pre-allocation 
    mask = NaN([x,y,z]);
    
    %discard if the mean intensity of selected region is too low (currently redundant cuz already set int_min = 20)
    %discard if the area is too small (> 100 pixels)
    n = 1;
    for m = 1:z    
        cell = cell_img(:,:,m);
        cell_int = nanmean(nanmean(cell));
        if cell_int > 20
            if numel(cell(cell>0)) > 100
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
    Gmask = NaN(size(mask));
    Smask = NaN(size(mask));
    
    %calculate Gmean and Smean for each cell
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
        
        %create Gmask and Smask to show Gmean and Smean of the cell
        Gmask(:,:,j) = mask(:,:,j).*Gmean;
        Smask(:,:,j) = mask(:,:,j).*Smean;
    end
    
    %for G and S for multiple files
    %currently not used in the plot
    G_total = cat(1,G_total,Gmean_total);
    S_total = cat(1,S_total,Smean_total);
    
    
    %PLOT
    figure
    %original image
    subplot(2,2,3)
    imagesc(ref_int)
    title(condition)
    axis image
    axis off
    
    %show Smask
    subplot(2,2,1)
    total_Smask = nansum(Smask,3);
    imagesc(total_Smask)
    title('Smask')
    axis image
    axis off
    caxis([min(total_Smask(total_Smask > 0))-0.01 max(total_Smask(:))])
    colorbar
    set(gca,'FontSize',16)
    
    %show Gmask
    subplot(2,2,2)
    total_Gmask = nansum(Gmask,3);
    imagesc(total_Gmask)
    title('Gmask')
    axis image
    axis off
    colormap gray
    caxis([min(total_Gmask(total_Gmask > 0))-0.05 max(total_Gmask(:))])
    colorbar
    set(gca,'FontSize',16)

    %cell phasor
    subplot(2,2,4)
    %s_color = linspace(1,10,size(G_total,1));
    scatter(Gmean_total,Smean_total,[],s_color,'filled','MarkerEdgeColor',[0 0 0])
    axis([0.2 0.8 0 0.6]);
    axis on
    xlabel('g')
    ylabel('s')
    set(gca,'FontSize',16) 
end


