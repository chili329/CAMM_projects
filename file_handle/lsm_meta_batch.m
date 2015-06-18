filenames = uipickfiles;
for i = 1:length(filenames)
    filename = filenames{i};
    new = strsplit(filename,'/');
    file = new(size(new,2));
    [lsminf,scaninf,imfinf] = lsminfo(filename);
    DimX = lsminf.DimensionX;
    DimY = lsminf.DimensionY;
    DimZ = lsminf.DimensionZ;
    DimT = lsminf.DimensionTime;
    Tint = lsminf.TimeInterval;
    Timestart = lsminf.TimeStamps.Stamps(1);
    strcat(file{1},' Timestamp ',num2str(Timestart))
end
