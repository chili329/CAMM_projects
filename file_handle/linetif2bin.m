% write tiff file to int16 bin file (filename)
function A = linetif2bin(filename,ch)

%tiff file to mat
fname = uipickfiles;
fname = fname{1};
A = imread(fname);
A =A';

%create new file
filesave = strcat(filename,num2str(ch),'000.bin');
fileid = fopen(filesave, 'w');
fwrite(fileid, A, 'uint16');
