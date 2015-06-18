function [] = avi2jpg(filename)
obj = VideoReader(filename);
vid = read(obj);
frames = obj.NumberOfFrames;
for x = 1 : frames
    imwrite(vid(:,:,:,x),strcat('frame-',num2str(x),'.jpg'));
end