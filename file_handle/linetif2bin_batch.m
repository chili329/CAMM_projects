%load multiple tiff files and convert into bin files
clear all;

fname = uipickfiles;

for i = 1:length(fname);
    A = 0;
    newfname = 0;
    
    newfname = fname(i);
    newfname = newfname{1};
    A = imread(newfname);
    A =A';

    %create new file
    ch = newfname(length(newfname)-4);
    filename = newfname(1:length(newfname)-6);
    filesave = strcat(filename,num2str(ch),'000.bin');
    fileid = fopen(filesave, 'w');
    fwrite(fileid, A, 'uint16');
end