
function [binread] = bin_read(filename, width)

%read int16 bin file and display with specified width

binfile = fopen(filename);
binread = fread(binfile, 'uint16');
[a, b] = size(binread);

length = max(a,b)/width;
close('all');

binread = reshape(binread, [width, length]);

%imagesc(binread);

end