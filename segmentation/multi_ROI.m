%multiple ROIpoly selection
%HERE: first mask not saved correctly
%HERE: S and G calculation not right, why?
function mask = multi_ROI(ref_int)
imagesc(ref_int);
sz=256;
totMask = false( sz ); % accumulate all single object masks to this one
h = imfreehand( gca ); setColor(h,'red');
position = wait( h );
BW = createMask( h );
mask(:,:,1) = double(BW);
i = 1;
while sum(BW(:)) > 10 % less than 10 pixels is considered empty mask
      totMask = totMask | BW; % add mask to global mask
      i = i+1;
      % ask user for another mask
      h = imfreehand( gca ); setColor(h,'red');
      position = wait( h );
      BW = createMask( h );
      mask(:,:,i) = double(BW);
end

mask(mask == 0) = NaN;
% show the resulting mask
figure; imshow( totMask ); title('multi-object mask');