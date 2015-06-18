%for LSM meta data, see lsm_read.m
%extract LSM file into xyzt(lambda) 

%HERE
%currently dealing with only xy(lambda)t and xyz(lambda) separately
function [ch1] = lsm_extract()
clear all

filename = uipickfiles;
filename = filename{1};
total_stack = tiffread29(filename);
[lsminf,scaninf,imfinf] = lsminfo(filename);

pixelx = lsminf.DIMENSIONS(1);
pixely = lsminf.DIMENSIONS(2);
pixelz = lsminf.DIMENSIONS(3);
time = lsminf.DimensionTime;
channel = lsminf.NUMBER_OF_CHANNELS;

%for xyz(lambda)
%only showing t = 1 at this moment...
if time == 1
    for i = 1:pixelz
        for j = 1:channel
            slice = total_stack(i);
            images = slice.data;
            eval(['ch' num2str(j) '{i}=images{j};']);
        end
    end
end

%for xyt(lambda)
if pixelz == 1
    for i = 1:time
        for j = 1:channel
            slice = total_stack(i);
            images = slice.data;
            eval(['ch' num2str(j) '{i}=images{j};']);
        end
    end
end

%to show total z stack
% new = uint16(zeros(pixely,pixelx));
% for i = 1:pixelz
%     new = new + ch2{i};
%     imagesc(new)
% end