%edited on 20150820
%include binding component

%(1) does microtubule transport affect the concentration inside the nucleus, or
%only change the time scale? if only time scale changes (by few mins) then
%the major determining factor is nucleus permiability
%(2) after taxane treatment, possible AR 'sticking' to microtubule that
%decrease the affective AR pool?
%(3) affective AR needs to reach a certain concentration threshold inside nucleus to maintain cell growth?

%based on 20150204 discussion
%assume 3 states of AR: 
%   D - diffusion (state = 0)
%   A - attachment to microtubule (state = 1)
%   B - binding (state = 2)

clear all
close all

%probability of state transition
%run length = P_aa * v_mean, avg 2-10 um
%assuming before drug treatment, population is all D --> P_dd ~da_ratio

P_ad = 0.5;
P_ab = 0.3;
P_dd = 0.5;
P_db = 0.3;
P_ba = 0.2;
P_bd = 0.5;

P_aa = 1-P_ad-P_ab;
P_da = 1-P_dd-P_db;
P_bb = 1-P_ba-P_bd;

%data matrix
time_end = 1800; % total time of simulation. unit: second
total_AR = 1000; % total number of AR
total_length = 50.0; % from membrane to nucleus. unit: um
total_time = [1:time_end]';
total_position = zeros(time_end,total_AR);
current_state = zeros(total_AR,1);
final_time = ones(total_AR,1)*time_end;
processivity = zeros(time_end,total_AR);
%in_nuc = 0 --> in cytoplasm, in_nuc = 1 --> nucleus
in_nuc = zeros(time_end,total_AR);

%dynamics variables
da_ratio = P_dd; %initial ratio of D and A
diffusion = 9.0; %diffusion coefficient, um^2/s
v_mean = 0.2; %mean velocity of microtubule transport, um/s
              %from literature: 0.08 - 0.5 um
v_sig = v_mean/2; %velocity std of microtubule transport

%probability of getting into nucleu
%for increasing nuc_in
nuc_in = (1:time_end)*0.00003;
%for constant nuc_in
%nuc_in = ones(time_end,1)*0.05;

%probability of getting outside nucleus
nuc_out = 0;

%define the initial position
%uniform random distribution in the cytoplasm
%equal probability to be either state
for i = 1:total_AR
    total_position(1,i) = rand*total_length;
    rnd_state = rand;
    if rnd_state > 0.66
        current_state(i) = 2;
    elseif rnd_state < 0.33
        current_state(i) = 1;
    else
        current_state(i) = 0;
    end
end 

for AR = 1:total_AR
    for time = 2:time_end
        
        %if inside nucleus, certain probability to go out
        if in_nuc(time-1,AR) == 1
            prob = rand;
            if prob > nuc_out
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
                if prob > P_dd+P_da
                    current_state(i) = 2;
                elseif prob < P_dd
                    current_state(i) = 0;
                else
                    current_state(i) = 1;
                end
            end

            if current_state(i) == 1 %at microtubule attachment state
                if prob > P_ad+P_aa
                    current_state(i) = 2;            
                elseif prob < P_ad
                    current_state(i) = 0;
                else
                    current_state(i) = 1;
                    processivity(time, AR) = 1;
                end
            end

            if current_state(i) == 2 %at binding state
                if prob > P_bd+P_ba
                    current_state(i) = 2;
                elseif prob < P_bd
                    current_state(i) = 0;
                else
                    current_state(i) = 1;
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

            %binding
            if current_state(i) == 2
                new_pos = 0;
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
if total_AR > 5
    num_AR = 5;
else
    num_AR = total_AR;
end
h1 = subplot(4,1,1);
for i = 1:num_AR
    plot(total_position(:,i),'color',[0.1 double(i)/num_AR double(i)/num_AR])
    hold on
end
title('trajectory','FontSize',20)
set(h1,'FontSize',16)
set(h1,'Ydir','reverse')
xlim([0 time_end])
ylim([0 total_length+1])
set(h1,'XTick',[0:600:3600])
set(h1, 'XTickLabel', {'0','10','20','30','40','50','60'});


%nucleus intensity plot
h3 = subplot(4,1,3);
density_nuc = sum(in_nuc,2)./total_AR;
density_loc_avg = 1 - density_nuc;
plot(density_nuc,'color','k','linewidth',2)
hold on
plot(density_loc_avg,'color','r','linewidth',2)
legend('nucleus','cytoplasm','Location','east','Orientation','horizontal')
title('nucleus and cytoplasm intensity','FontSize',20)
set(h3,'FontSize',16)
xlim([0 time_end])
set(h3,'XTick',[0:600:3600])
set(h3, 'XTickLabel', {'0','10','20','30','40','50','60'});

%time to nucleus histogram
h4 = subplot(4,1,4);
final_time = final_time./60;
mean_final = mean(final_time(:));
hist(final_time,40)
title(strcat('time to nucleus:',num2str(mean_final,'%.1f'),'min'),'FontSize',20)
set(h4,'FontSize',16)
xlim([0 time_end/60])
xlabel('min')

%density versus time plot
h2 = subplot(4,1,2);
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
title('density plot','FontSize',20)
set(h2,'FontSize',16)
set(h2, 'YTickLabel', {});
colormap(h2,'gray')
hline = refline([0 length(xbins)+0.5]);
set(hline, 'color', 'r');
set(h2,'XTick',[0:600:3600])
set(h2, 'XTickLabel', {'0','10','20','30','40','50','60'});
