%test different properties of phasor plot
%function [G,S,M,phi] = plotphasor(data, freq, delta_t, ph_cor, M_cor)

% w*delta_t*length(data) = pi
% ---> delta_t = 1/(2*freq*length(data))
clear all
%normal distribution data
%cosine function
modelFun = @(p,x) exp(-((x-p(1))/p(2)).^2);
decayFun = @(p,x) exp(-(x/p(1)));
cosFun = @(p,x) cos(p(1)*x);
sinFun = @(p,x) sin(p(1)*x);

%number of z slices
zs = 32;
harmonic = 1;

zgrid = 1:zs;

p_matrix = zeros(zs);
G = zeros(1,zs);
S = zeros(1,zs);
M = zeros(1,zs);
phi = zeros(1,zs);
diff_phi = zeros(1,zs-1);
sumGS = zeros(1,zs);


%p_matrix = modelFun([20 zs], zgrid);
%cos_matrix = cosFun(pi/zs, zgrid);
%sin_matrix = sinFun(pi/zs, zgrid);
%cos_matrix2 = cosFun(2*pi/zs, zgrid);
%sin_matrix2 = sinFun(2*pi/zs, zgrid);

%plot(p_matrix,'ro');
%hold on;
%plot(cos_matrix,'b*-');
%plot(sin_matrix,'g*-');
%plot(cos_matrix2,'b*-');
%plot(sin_matrix2,'g*-');

%change variables
phasorplot = 0;
option = 0.1;



%with triangle background fluorescence
if option == 0
    backf = zeros(zs);
    FAf = zeros(zs);
    for i = 1 : zs
        backf((1:i*3/4)+zs/4,i) = 1;
        FAf(zs/4:zs/4+3,i) = 5;
    end
    p_matrix = backf + FAf;
    
    for i = 1:zs
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i), 1/zs*harmonic, 1, 0, 1);
    end
end

%with different degree of S/N ratio. can be used to assess accuracy.
if option == 0.1
    var = 50;
    for j = 1:var
        for i = 1:zs
            p_matrix(:,i,j) = modelFun([zs/2 zs/2], zgrid) + rand(1,zs)*j/var;
            [G(i,j),S(i,j),M(i,j),phi(i,j)] = plotphasor(p_matrix(:,i,j),1/zs*harmonic, 1, 0, 1);
            angle(i,j) = atan2(S(i,j),G(i,j));
        end
        stdAngle(j) = std(angle(:,j));    
    end
    plot(stdAngle)
    figure(4)
    imagesc(p_matrix(:,:,50))
end

%change p(1), peak position
if option == 1
    for i = 1:zs
        %modelFun = @(p,x) exp(-((x-p(1))/p(2)).^2);
        p_matrix(:,i) = modelFun([i 14], zgrid);
        %plotphasor(data, freq, delta_t, ph_cor, M_cor)
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i), 1/zs*harmonic, 1, 0, 1);
    end
end

%change both peak position and thickness
if option == 1.5
    for i = 1:8:zs
        for j = 1:30
            p_matrix(:,i,j) = modelFun([i j], zgrid);
            [G(i,j),S(i,j),M(i,j),phi(i,j)] = plotphasor(p_matrix(:,i,j), 1/zs*harmonic, 1, 0, 1);
        end
    end
end

%change p(2), width of gaussian
if option == 2
    for i = 1:zs
        p_matrix(:,i) = modelFun([zs/2 i], zgrid);
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i),1/zs*harmonic, 1, 0, 1);
    end
end

%single exponential decay
if option == 3
    for i = 1:zs
        %decayFun = @(p,x) exp(-(x/p(1)));
        p_matrix(:,i) = decayFun(i, zgrid);
        
    %function [G,S,M,phi] = plotphasor(data, freq, delta_t, ph_cor, M_cor)
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i),1/zs*harmonic, 1, 0, 1);
    end
end

%combination of two single exponential
if option == 4
    for i = 1:zs
        decayFun = @(p,x) exp(-(x/p(1)));
        p_matrix(:,i) = rand*decayFun([4], zgrid) + rand*decayFun([14], zgrid);
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i), 1/zs*harmonic, 1, 0, 1);
    end
end

%change p(1), 2 peaks with identical width
if option == 5
    for i = 1:zs
        %modelFun = @(p,x) exp(-((x-p(1))/p(2)).^2);
        p_matrix(:,i) = modelFun([i 14], zgrid) + modelFun([zs/8 14], zgrid);
        %plotphasor(data, freq, delta_t, ph_cor, M_cor)
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i), 1/zs*harmonic, 1, 0, 1);
    end
end

%change p(1), 2 peaks with identical width
if option == 6
    for i = 1:zs
        %modelFun = @(p,x) exp(-((x-p(1))/p(2)).^2);
        p_matrix(:,i) = i*0.01*modelFun([zs/2 50], zgrid) + modelFun([zs/8 14], zgrid);
        %plotphasor(data, freq, delta_t, ph_cor, M_cor)
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i), 1/zs*harmonic, 1, 0, 1);
    end
end

%uniform triangle
if option == 7
    for i = 1:zs
        %modelFun = @(p,x) exp(-((x-p(1))/p(2)).^2);
        p_matrix(:,i) = i;
        %plotphasor(data, freq, delta_t, ph_cor, M_cor)
        [G(i),S(i),M(i),phi(i)] = plotphasor(p_matrix(:,i), 1/zs*harmonic, 1, 0, 1);
    end
end

%reshape G and S
[ga gb] = size(G);
[sa sb] = size(S);
newG = reshape(G,1,ga*gb);
newS = reshape(S,1,sa*sb);

%plot phasor
if phasorplot ==1
    theta = 0:0.01:2*pi;
    %universal circle
    plot(cos(theta),sin(theta));
    axis([-1 1 -1 1]);
    hold on;
    xlabel('G');
    ylabel('S');
    plot(newG,newS,'b*');
    figure(10);
    imagesc(p_matrix)
end



%calculate difference of phi
for i = 1:(zs-1)
    diff_phi(i) = abs(abs(phi(i+1))-abs(phi(i)));
end