clear all

%filename = uigetfile('*.*','Pick LSM file');
filename = uipickfiles;
filename = filename{1};
total_stack = tiffread29(filename);
[lsminf,scaninf,imfinf] = lsminfo(filename);

%dimensions
pixelx = lsminf.DIMENSIONS(1);
pixely = lsminf.DIMENSIONS(2);
pixelz = lsminf.DIMENSIONS(3);
time = lsminf.DimensionTime;
channel = lsminf.NUMBER_OF_CHANNELS;

%size in um, time in sec (?)
xsize = 10^6*lsminf.VOXELSIZES(1);
ysize = 10^6*lsminf.VOXELSIZES(2);
zsize = 10^6*lsminf.VOXELSIZES(3);
time = scaninf.INTERVAL(1);

%laser info
%collection wavelength
scaninf.SPI_WAVE_LENGTH_START;
scaninf.SPI_WAVELENGTH_END;
%excitation wavelength
scaninf.WAVELENGTH;

%only showing t = 1 at this moment...
for i = 1:pixelz
    for j = 1:channel
        slice = total_stack(i);
        images = slice.data;
        eval(['ch' num2str(j) '{i}=images{j};'])
    end
end

%to show total z stack
new = uint16(zeros(pixelx,pixely));
for i = 1:pixelz
    new = new + ch2{i};
    imagesc(new)
end