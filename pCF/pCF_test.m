

f_type = 1;

if f_type == 2
    clear all
    close all
    files = uipickfiles;
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

chnew{2} = ch{2}(:,1:20000);

%shift in space
%HERE
shift = 1;
mat1 = ch{2}(1:(32-shift),1:20000);
mat2 = ch{2}(1:shift,1:20000);
chnew{1} = vertcat(mat2,mat1); 

ch1 = 2;
ch2 = 2;
total_plot = 5;
corr_div = 100;

%option = 1: fix distance
%option = 2: fix one column
%option = 3: fix distance, reverse direction

for option = 3    
        figure
        for i = 1:total_plot
            if option == 2
                dis = i*8-4;
            elseif option == 1
                dis = i-1;
%                 shift = 25;
%                 %shift in time
%                 mat1 = ch{2}(:,20001:20000+shift);
%                 mat2 = ch{2}(:,1:20000-shift);
%                 chnew{1} = horzcat(mat1,mat2);
%                 j = i-1;
%                 %adding original image
%                 chnew{1} = chnew{1}*(j*0.01)+chnew{2}*(1-j*0.01);               
                
            elseif option == 3
                dis = i;
            end
            [Gx, axis_t,Gnew] = batch_pCF_plot(chnew, option, dis, ch1, ch2, s_pixel, l_time,total_plot,i,corr_div);
            if option == 2
                plot3(nuc(1)*s_pixel*ones(Gx,1),axis_t,-ones(Gx,1),'color','r','LineWidth',3,'LineStyle','--');
            end
            max(max(Gnew))
        end
end