function new_bin = bin_write(newfile,mat,size)

% write matrix (mat) into int16 bin file (newfile)

fileid = fopen(newfile,'w');
fwrite(fileid,mat,'uint16');

new_bin = bin_read(newfile,size);
end