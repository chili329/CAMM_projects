%TO DO:
%define nucleus position --> plot correlation with different color
%select segment for analysis
%directly load lsm file?
%detrend?
%diffusion fitting??

%close everything
%clear everything
clear all
close all

%%%%%FILE LOADING%%%%%%%

files = uipickfiles;
%file type: bin = 1, lsm = 2
f_type = 2;

%load bin file, all channels
if f_type == 1
    num_ch = size(files,2);

    for i = 1:num_ch
        cname = files(i);
        cname = cname{1};
        ch{i} = bin_read(cname,l_pixel);
    end
    %number of pixels per line
    l_pixel =32;
    %pixel size in um
    s_pixel = 0.1;
    %line time in s
    l_time = 0.479*(10^(-3));
end

%load LSM file
if f_type == 2
    filename = files{1};
    [ch, lsminf] = lsm_read(filename);
    num_ch = lsminf.NUMBER_OF_CHANNELS;
    
    %pixel size in um
    s_pixel = lsminf.VoxelSizeX*10^(6);
    %number of pixels
    l_pixel = lsminf.DimensionX;
    %line time in s
    l_time = lsminf.TimeInterval;
end
%%%%%%END FILE LOADING%%%%%%%%%%%%%%

%only analyze partial data
start_t = 1;
end_t = 40000;
for i = 1:num_ch
    ch{i} = ch{i}(:,start_t:end_t);
end

[x,t] = size(ch{1});

%nucleus boundary detection
nuc = nuc_segment_1d(ch{1});

%immobile removal
for i = 1:x
    ch{1}(i,:) = ch{1}(i,:)-ones(1,t)*(mean(ch{1}(i,:)-mean(mean(ch{1}))));
end

%calculate the nuc/cyt intensity
% figure
% plot(mean(ch{1}(1:nuc,:),1),'color','r');
% hold on
% plot(mean(ch{1}(nuc+1:end,:),1),'color','k');



%option = 1: fix distance
%option = 2: fix one column
%option = 3: fix distance, reverse direction
%ch1, ch2: correlation channel of interest
%[G] = pCF(c1,c2,dis,option);
dis = 0;
option = 1;
ch1 = 1;
ch2 = 1;
%dividing intensity carpet
corr_div = 50;
total_plot = 4;
i = 1;

counting = 0;
for option = 2
    for ch1 = 1
        figure
        for i = 1:total_plot
            if option == 2
                %dis = nuc(1)+(i*2-1)-total_plot;
                dis = i*8-4;
            elseif option == 1
                dis = i*2-2;
                %dis = 5;
            elseif option == 3
                dis = i*2-2;
            end
            [Gx, axis_t,Gnew] = batch_pCF_plot(ch, option, dis, ch1, ch2, s_pixel, l_time,total_plot,i,corr_div);
            if option == 2
                plot3(nuc(1)*s_pixel*ones(Gx,1),axis_t,-ones(Gx,1),'color','r','LineWidth',3,'LineStyle','--');
            end
            max(max(Gnew))
        end
    end
end


% total_plot = 3;
% dis = 0;
% figure
% for ch1 = 1:3
%     for i = 1:total_plot
%         batch_pCF_plot(ch, option, dis, ch1, ch1, s_pixel, l_time,total_plot,ch1,corr_div);
%     end
% end

%batch_pCF_plot(ch, option, dis, ch1, ch2, s_pixel, l_time,total_plot,i,corr_div);