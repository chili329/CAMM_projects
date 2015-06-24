function [ICS2DCorr] = partial_ICS(image_data,cx,cy,start_t,end_t,seg_size,tauLimit)

cx1 = cx-seg_size/2;
cx2 = cx+seg_size/2-1;
cy1 = cy-seg_size/2;
cy2 = cy+seg_size/2-1;

partial_data = image_data(cx1:cx2,cy1:cy2,start_t:end_t);

warning('off');

%plot correlation function
ICS2DCorr = stics(partial_data,tauLimit);
%ICS2DCorr = autocrop(ICS2DCorr,20);

end

