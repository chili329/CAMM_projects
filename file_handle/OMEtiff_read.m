%for images acquired with position option
%go to FIJI, open images without separating channels
%save images as OME-TIFF
function A = OMEtiff_read(filename, num_ch)
%file = uipickfiles;
%filename = file{1};
meta = imreadBFmeta(filename)
zsizes = meta.zsize;
width = meta.width;
height = meta.height;
time = meta.nframes;
%[vol]=imreadBF(datname,zplanes,tframes,channel)
%images = imreadBF(filename,1,1:time,1);

%specifically to separate channels
%num_ch = 2;
for i = 1:num_ch
    A{i} = imreadBF(filename,1,i:num_ch:time,1);
end
