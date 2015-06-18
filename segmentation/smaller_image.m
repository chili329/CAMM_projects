
%divide big image into smaller images (256*256)

[a,b] = size(raw_image);
seg1 = a/256;
seg2 = b/256;
for i = 0:(seg1-1)
    for j = 0:(seg2-1)
        
        s = raw_image((1+i*256):(256*(i+1)),(1+j*256):(256*(j+1))) ;
        eval(['new_' num2str(i) num2str(j) '= s']);
        
    end
end