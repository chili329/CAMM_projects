%edited on 20150330
%simulate also nucleus portion
%added nuc_out probability to transport from nucleus to cytoplasm
%added in_nuc matrix to record AR location

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

%data matrix
time_end = 3600; % total time of simulation. unit: second
total_AR = 1000; % total number of AR
total_length = 100.0; % from membrane to nucleus. unit: um
total_time = [1:time_end]';
total_position = zeros(time_end,total_AR);
current_state = zeros(total_AR,1);
final_time = ones(total_AR,1)*time_end;
processivity = zeros(time_end,total_AR);
%in_nuc = 0 --> in cytoplasm, in_nuc = 1 --> nucleus
in_nuc = zeros(time_end,total_AR);

%dynamics variables
da_ratio = P_dd; %initial ratio of D and A
diffusion = 10.0; %diffusion coefficient, um^2/s
v_mean = 0.2; %mean velocity of microtubule transport, um/s
              %from literature: 0.08 - 0.5 um
v_sig = v_mean/2; %velocity std of microtubule transport

%probability of getting into nucleus, suppose time-dependent
%for periodic oscillation: mean = nuc_in_c, modulation amplitude = in_mod
nuc_in_c = 0.2; 
f = 10;
in_mod = 0;

nuc_in = in_mod.*sin((1.0/time_end*2*pi*f):(1.0/time_end*2*pi*f):(2*pi*f))'+nuc_in_c;
nuc_in(nuc_in<0) = 0;

%probability of getting outside nucleus, suppose time-dependent
%for periodic oscillation with mean = nuc_out_c
nuc_out_c = 0.005;
f = 10;
out_mod = 0.005;

nuc_out = out_mod.*sin((1.0/time_end*2*pi*f):(1.0/time_end*2*pi*f):(2*pi*f))'+nuc_out_c;
nuc_out(nuc_out<0) = 0;

%define the initial position
%uniform random distribution in the cytoplasm
for i = 1:total_AR
    total_position(1,i) = rand*total_length;
    rnd_state = rand;
    if rnd_state > da_ratio
        current_state(i) = 1;
    end
end 

for AR = 1:total_AR
    for time = 2:time_end
        
        %if inside nucleus, certain probability to go out
        if in_nuc(time-1,AR) == 1
            prob = rand;
            if prob > nuc_out(time)
                total_position(time, AR) = total_length+1;
                in_nuc(time,AR) = 1;
            else
                total_position(time, AR) = total_length;
                in_nuc(time,AR) = 0;
            end
            
            %if outside nucleus, then move
        elseif in_nuc(time-1,AR) == 0
            
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
                new_pos = normrnd(v_mean,v_sig);
                total_position(time, AR) = total_position(time-1, AR) + new_pos;
            end

            %reaching membrane, then not moving
            if total_position(time,AR) < 0
                total_position(time,AR) = 0;
            end

            %reaching nucleus, either enter nucleus, or not moving
            if total_position(time, AR) > total_length
                prob = rand;
                %actually gets in the nucleus, stores AR in nucleus pool
                if prob < nuc_in(time)
                    final_time(AR) = time; %time AR first get into nucleus
                    %HERE: actually stores LAST time AR gets into nucleus
                    total_position(time,AR) = total_length+1; %total_length+1 indicates inside nucleus
                    in_nuc(time,AR) = 1;
                else
                    total_position(time, AR) = total_length;
                    in_nuc(time,AR) = 0;
                end
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

%trajectory plot
if total_AR > 10
    num_AR = 10;
else
    num_AR = total_AR;
end
h1 = subplot(4,1,1);
for i = 1:num_AR
    plot(total_position(:,i),'color',[0 double(i)/num_AR double(i)/num_AR])
    hold on
end
title('trajectory','FontSize',24)
set(h1,'FontSize',16)
xlim([0 time_end])
ylim([0 total_length+1])
xlabel('second')
ylabel('um')

%run length histogram
h2 = subplot(4,1,2);
[m, n] = size(total_proce);
total_proce = reshape(total_proce,m*n,1);
total_run = total_proce*v_mean;
hist(total_run,40);
title('run length','FontSize',24)
set(h2,'FontSize',16)
xlim([0 10])
xlabel('um')

%time to nucleus histogram
h3 = subplot(4,1,3);
final_time = final_time./60;
hist(final_time,40)
title('time to nucleus','FontSize',24)
set(h3,'FontSize',16)
xlim([0 time_end/60])
xlabel('min')

%density versus time plot
h4 = subplot(4,1,4);
xbins = 1:4:total_length;
density_loc = zeros(time_end,length(xbins));
density_nuc = zeros(time_end,1);
A = total_position;
A(A==total_length+1) = NaN;
for i = 1:time_end
    %density_loc(i,:) = hist(total_position(i,:),xbins);
    density_loc(i,:) = hist(A(i,:),xbins);
    density_nuc(i) = nnz(total_position(i,:)>total_length);
    %adjust density_nuc based on NC ratio = 1:1
    density_nuc(i) = density_nuc(i)./size(xbins,2);
end
total_density = [density_loc density_nuc];
caxis([0 100])
image(total_density')
title('density plot','FontSize',24)
set(h4,'FontSize',16)
xlabel('second')
ylabel('location')
title('density plot','FontSize',24)
set(h4, 'YTickLabel', {'0','','','','100'});
colormap(h4,'gray')
hline = refline([0 length(xbins)+0.5]);
set(hline, 'color', 'r');

figure('Color',[1 1 1])
%nucleus intensity plot
i1 = subplot(2,1,1);

density_nuc = sum(in_nuc,2)./total_AR;
density_loc_avg = 1 - density_nuc;
% density_loc_avg = mean(density_loc,2);
% max_int = max(max(density_nuc,density_loc_avg));
% %normalize with max intensity
% density_nuc = density_nuc./max_int;
% density_loc_avg = density_loc_avg./max_int;
plot(density_nuc,'color','k','linewidth',2)
hold on
plot(density_loc_avg,'color','r','linewidth',2)

legend('nucleus intensity','cytoplasm intensity','Location','northoutside','Orientation','horizontal')
%title('nucleus and cytoplasm intensity over time','FontSize',24)
set(i1,'FontSize',16)
xlabel('second')

%plot nuc_in, nuc_out
i2 = subplot(2,1,2);
plot(nuc_in,'color','b','linewidth',2);
hold on
plot(nuc_out,'color','g','linewidth',2);
legend('nuc in','nuc out');
set(i2,'Fontsize',16)
xlabel('second')
