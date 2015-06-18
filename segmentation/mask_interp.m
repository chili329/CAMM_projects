%manually define nucleus boundary every x frames. Interpolate the rest
mov = double(tiff2mat);
time = size(mov,3);
I1 = imagesc(mov(:,:,1));
BW1 = roipoly;
I2 = imagesc(mov(:,:,time);
BW2 = roipoly;
ts1 = resample(ts, time);