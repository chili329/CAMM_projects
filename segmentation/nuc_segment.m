%segmentation for nucleus identification
%ch: channel to process
%fudgeFactor: 
function nuc = nuc_segment(mov,fudgeFactor,varargin)
time = size(mov,3);
nuc = zeros(size(mov,1),size(mov,2),time);
for i = 1:time
    I = mov(:,:,i);
    %figure, imagesc(I)
    I = medfilt2(I,[4 4]);
    
    if length(varargin) == 1
        for i = 1:varargin{1}
            I = medfilt2(I,[4 4]);
        end
    end

    [~, threshold] = edge(I, 'sobel');
    %fudgeFactor = 1.5;
    BWs = edge(I,'sobel', threshold * fudgeFactor);

    se90 = strel('line', 5, 90);
    se0 = strel('line', 5, 0);
    BWsdil = imdilate(BWs, [se90 se0]);

    BWdfill = imfill(BWsdil, 'holes');
    %figure, imshow(BWdfill)
    nuc(:,:,i) = BWdfill;
end
%display final result
% BWoutline = bwperim(BWdfill);
% Segout = I;
% Segout(BWoutline) = 255;
% figure, colormap gray, imagesc(Segout)
