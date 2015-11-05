function [ICS2DCorr] = partial_ICS(image_data,cx,cy,start_t,end_t,seg_size,tauLimit,mob)

cx1 = cx-seg_size/2;
cx2 = cx+seg_size/2-1;
cy1 = cy-seg_size/2;
cy2 = cy+seg_size/2-1;

partial_data = image_data(cx1:cx2,cy1:cy2,start_t:end_t);

if mob == 1
    partial_data = immfilter_new(partial_data);
end

warning('off');

%plot correlation function
%method 1: original FFT
%method 2: zero-padding FFT
ICS2DCorr = stics(partial_data,tauLimit,2);
%ICS2DCorr = autocrop(ICS2DCorr,20);

end

