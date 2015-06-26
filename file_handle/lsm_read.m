%read the file into XYT{ch} format for each z plane
function [A, lsminf] = lsm_read(filename, varargin)

%MAY BE USED BY SOME CODES
%file = uipickfiles;
%filename = file{1};

%lsm file dimension
[lsminf,scaninf,imfinf] = lsminfo(filename);
%number of x pixels
x = lsminf.DimensionX;
%number of frames
t = lsminf.TIMESTACKSIZE;
%number of channels
ch = lsminf.NUMBER_OF_CHANNELS;
%number of z planes
%z = lsminf.DimensionZ;

%for z stack
if size(varargin) > 0
    z = varargin{1};
else
    z = 1;
end

%for line scan
if lsminf.DimensionY == 1
    t = 1;
end

%imports images using the BioFormats package
for i = 1:ch
    A{i} = imreadBF(filename,z,1:t,i);
    if lsminf.DimensionY == 1
        A{i} = A{i}';
    end
end