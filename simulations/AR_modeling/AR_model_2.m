%TO DO:
%simulate also nucleus portion
%density plot?

%(1) does microtubule transport affect the concentration inside the nucleus, or
%only change the time scale? if only time scale changes (by few mins) then
%the major determining factor is nucleus permiability
%(2) after taxane treatment, possible AR 'sticking' to microtubule that
%decrease the affective AR pool?
%(3) affective AR needs to reach a certain concentration threshold inside nucleus to maintain cell growth?

%based on 20150204 discussion
%assume 2 states of AR: 
%   D - diffusion (state = 0)
%   A - attachment to microtubule (state = 1)

clear all
close all

%probability of state transition
%run length = P_aa * v_mean, avg 2-10 um
%assuming before drug treatment, population is all D --> P_dd ~da_ratio
P_ad = 0.3;
P_aa = 1 - P_ad;
P_dd = 0.8;
P_da = 1 - P_dd;


%dynamics variables
da_ratio = P_dd; %initial ratio of D and A
diffusion = 10.0; %diffusion coefficient, um^2/s
v_mean = 0.3; %mean velocity of microtubule transport, um/s
              %from literature: 0.08 - 0.5 um
v_var = 0.1; %velocity variance of microtubule transport
%HERE
%diffusing and binding AR may have different nuc_in?
%nuc_out?
nuc_in = 0.1; %probability of getting into nucleus

%data matrix
time_end = 3000; % unit: second
total_AR = 1000;
total_length = 100.0; % from membrane to nucleus. unit: um
total_time = [1:time_end]';
total_position = zeros(time_end,total_AR);
current_state = zeros(total_AR,1);
final_time = ones(total_AR,1)*time_end*1.2;
processivity = zeros(time_end,total_AR);

%define the initial position
for i = 1:total_AR
    total_position(1,i) = rand*total_length;
    rnd_state = rand;
    if rnd_state > da_ratio
        current_state(i) = 1;
    end
end 

%HERE: 
%calculate processivity: movement during P_aa

for AR = 1:total_AR
    for time = 2:time_end

        %determine the state for each time point
        prob = rand; %random number [0 1]
        if current_state(i) == 0 %at diffusion state
            if P_dd > prob
                current_state(i) = 0;
            else
                current_state(i) = 1;
            end
        end
        
        if current_state(i) == 1 %at microtubule attachment state
            if P_ad > prob
                current_state(i) = 0;            
            else
                current_state(i) = 1;
                processivity(time, AR) = 1;
            end
        end

        %move by diffusion
        if current_state(i) == 0
            %diff_dis = sqrt(2*D*time)
            new_pos = normrnd(0, sqrt(2*diffusion));
            total_position(time, AR) = total_position(time-1, AR) + new_pos;
        end

        %move by dynein transport
        if current_state(i) == 1
            new_pos = normrnd(v_mean,v_var);
            total_position(time, AR) = total_position(time-1, AR) + new_pos;
        end
        
        %reaching membrane, then not moving
        if total_position(time,AR) < 0
            total_position(time,AR) = 0;
        end
        
        %reaching nucleus, either enter nucleus and terminate, or not
        %moving
        if total_position(time, AR) > total_length
            prob = rand;
            %actually gets in the nucleus, stop simulation
            if prob < nuc_in
                final_time(AR) = time;
                total_position(time:end,AR) = total_length;
                break
            else
                total_position(time, AR) = total_length;
            end
        end
    end
end

%calculate run length based on processivity
total_proce = 0;
data = 0;
for i = 1:total_AR
    s = processivity(:,i);
    data = consec_length(s);
    total_proce = [total_proce;data'];
end

%plotting
figure('Color',[1 1 1])

num_AR = 50;
subplot(4,1,1)
plot(total_position(:,1:num_AR),'k')
title('trajectory','FontSize',24)
set(gca,'FontSize',18)
xlim([0 time_end])
xlabel('second')
ylabel('um')

subplot(4,1,2)
[m, n] = size(total_proce);
total_proce = reshape(total_proce,m*n,1);
total_run = total_proce*v_mean;
hist(total_run,40);
title('processivity','FontSize',24)
set(gca,'FontSize',18)
xlim([0 10])
xlabel('um')

subplot(4,1,3)
final_time = final_time./60;
hist(final_time,40)
title('time to nucleus','FontSize',24)
set(gca,'FontSize',18)
xlim([0 time_end/60])
xlabel('min')

subplot(4,1,4)
density_loc = zeros(time_end,10);
for i = 1:time_end
    density_loc(i,:) = hist(total_position(i,:),1:10:100);
end
caxis([0 100])
image(density_loc')
colormap gray
