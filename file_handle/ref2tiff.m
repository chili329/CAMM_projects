%safe the intensity from ref file to tiff

%file reading
ref_file = uipickfiles;
ref_file = ref_file{1};
[ref_int, G, S, ref_ph1, ref_md1] = ref_read(ref_file);
ref_int = mat2gray(ref_int);
%file writing
imwrite(ref_int,'test.tif')