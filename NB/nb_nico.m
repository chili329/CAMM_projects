% N&B analysis for Nicoletta
%input1: filename (for example: 'test.bin')
% I am assuming that you have 256x256 images
%input2: d_size: detrend size (for example: 10)

%output1: brightness
%output2: number
%output3: intensity (k_avg)

function [brightness,number,k_avg]=nb_nico(filename,d_size)

%reading data
binfile = fopen(filename);
binread = fread(binfile, 'uint16');
[a, b] = size(binread);

frame = max(a,b)/256/256;
data = reshape(binread,[256,256,frame]);

s = size(data);

%pre-allocation
k_avg = zeros(s(1),s(2));
k_var = zeros(s(1),s(2));
brightness= zeros(s(1),s(2));
number = zeros(s(1),s(2));
newdata = zeros(size(data));

%detrend
frag = floor(s(3)/d_size);
avg_cube = zeros(s(1),s(2),d_size);

for i = 0:(frag-1)
    %pre-allocation
    sub_data = zeros(s(1),s(2),d_size);
    sub_avg = zeros(s(1),s(2));
    avg_cube = zeros(s(1),s(2),d_size);
    avg_total = zeros(s(1),s(2),d_size);
    sub_fluc = zeros(s(1),s(2),d_size);
    
    sub_data = data(:,:,(1+i*d_size):(i+1)*d_size);
    sub_avg = mean(sub_data,3);
    for j = 1:d_size
        avg_cube(:,:,j) = sub_avg(:,:);
        avg_total(:,:,j) = mean(data,3);
    end
    sub_fluc = sub_data - avg_cube;
    newdata(:,:,(1+i*d_size):(i+1)*d_size) = sub_fluc + avg_total;
end

data = newdata;

%calculating k_avg
for i = 1:s(1)
    for j = 1:s(2)
        k_avg(i,j) = sum(data(i,j,:))/s(3);
    end
end

%calculate k_var
for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:s(3)
            k_var(i,j) = k_var(i,j) + (data(i,j,k) - k_avg(i,j))^2;
        end
    end
end

k_var = k_var/s(3);

brightness = k_var./k_avg;
number = k_avg./brightness;

b_array = reshape(brightness,s(1)*s(2),1);
n_array = reshape(number,s(1)*s(2),1);
int_array = reshape(k_avg,s(1)*s(2),1);


figure(1)
plot(b_array,n_array,'*');
set(figure(1),'name','brightness versus number','numbertitle','off')
xlabel('Brightness')
ylabel('Number')

figure(2)
plot(int_array,b_array,'*');
set(figure(2),'name','intensity versus brightness','numbertitle','off')
ylabel('Brightness')
xlabel('Intensity')

figure(3)
imagesc(brightness')
set(figure(3),'name','brightness map','numbertitle','off')

figure(4)
imagesc(number')
set(figure(4),'name','number map','numbertitle','off')
