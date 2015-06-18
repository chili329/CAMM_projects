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
    l_time = lsminf.TimeStamps.TimeStamps(2);
end
%%%%%%END FILE LOADING%%%%%%%%%%%%%%



%only analyze partial data
start_t = 1000;
end_t = 1030;
for i = 1:num_ch
    ch{i} = ch{i}(17:32,start_t:end_t);
    %for spatial correlation
    ch{i} = ch{i}';
end

%option = 1: fix distance
%option = 2: fix one column
%ch1, ch2: correlation channel of interest
%[G] = pCF(c1,c2,dis,option);
dis = 0;
option = 1;
ch1 = 2;
ch2 = 3;

G_total = 0;

for t = 1:(end_t-start_t)
    G = pCF(ch{ch1}(t,:),ch{ch2}(t,:),dis,option);
    plot(G)
    hold on
    G_total = G_total+G;
end
G_total = G_total./(end_t-start_t);
plot(G_total, 'linewidth',2,'color','k')
