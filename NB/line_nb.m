%calculate line N&B. No calibration yet!
%data structure: data[pixel,time]
function [brightness,number] = line_nb(data)

%calculating k_avg, k_var
k_avg = mean(data,2);
k_var = var(data,0,2);
% v_total = zeros(size(data,1),1);
% k_var = v_total;
% for i = 1:size(data,1)
%     for j = 1:size(data,2)
%         vi = (data(i,j) - k_avg(i)).^2
%         v_total(i,1) = v_total(i,1) + vi;
%     end
% end
% k_var = v_total./size(data,2);

%calculate number and brightness
brightness = k_var./k_avg;
number = k_avg./brightness;