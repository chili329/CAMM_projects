%find nuclear border from line scan
%data: nuc(XT)
[x time] = size(nuc);
time_int = time/1000;
imfilter
for t = 1:time_int
    nucline = nuc(:,t*1000);
    nuc_thr = (find(nucline>int_thr));
    max(nuc_thr);