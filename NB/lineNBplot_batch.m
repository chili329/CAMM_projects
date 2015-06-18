close all
clear all

files = uipickfiles;
for i = 1:length(files)
    filename = files{i};
    [ch, lsminf] = lsm_read(filename);
    num_ch = lsminf.NUMBER_OF_CHANNELS;

    %pixel size in um
    s_pixel = lsminf.VoxelSizeX*10^(6);

    %only analyze partial data
    start_t = 1;
    end_t = 20000;
    for i = 1:num_ch
        ch{i} = ch{i}(:,start_t:end_t);
    end

    figure
    line_nb_plot(s_pixel, ch{2})
    title(filename)
end