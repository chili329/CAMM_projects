% convert mat files into bin files

%load matrix
matName = uigetfile;

%convert to bin file
N = length(matName);
for i = 1:N
    load(matName{i});
    newfile = strcat(matName{i},'bin');
    fileid = fopen(newfile,'w');
    fwrite(fileid,mat,'uint16');
end