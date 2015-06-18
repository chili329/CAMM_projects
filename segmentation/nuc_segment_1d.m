%find nuclear border from line scan
%data: nuc(XT)
function nuc = nuc_segment_1d(mov)
%find nucleus boundary based on threshold
[x time] = size(mov);
div = 4000;
time_int = time/div;

for t = 1:time_int
    ts = (t-1)*div+1;
    te = t*div;
    %find threshold value based on the minium value of first or last column
    mean1 = mean(mov(1,ts:te));
    mean2 = mean(mov(end,ts:te));
    thr = min(mean1,mean2);
    %average all lines
    nucline = mean(mov(:,ts:te),2);
    nuc_thr = (find(nucline>thr*2));
    if mean1>mean2
        nuc(((t-1)*div+1):t*div) = length(nuc_thr);
    else
        nuc(((t-1)*div+1):t*div) = x-length(nuc_thr);
    end
end
imagesc(mov)
colormap gray
hold on
plot(nuc,'color','r','LineWidth',2)
axis off


%find nucleus boundary by treating XT carpet as image, then apply
%nuc_segment
% [x time] = size(mov);
% nuc = nuc_segment(mov,thr,3);