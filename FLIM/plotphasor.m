% from Applications of phasors to in vitro time-resolved fluorescence
% measurements (2011)

function [G,S,M,phi] = plotphasor(data, freq, delta_t, ph_cor, M_cor)

%freq = harmonic to show

%ph_cor and M_cor do not affect data point's relative position, 
%only affect the location of data point.

w = 2*pi*freq; 

Gn = 0;
Sn = 0;
area = 0;

for bin = 1:length(data)-1
    Gn = Gn + data(bin).*cos(w*delta_t.*(bin-0.5))*delta_t;
    Sn = Sn + data(bin).*sin(w*delta_t.*(bin-0.5))*delta_t;
    area = area + (data(bin)+data(bin+1)).*delta_t./2;
end

Gdec = Gn./area;
Sdec = Sn./area;
G = (Gdec.*cos(ph_cor) - Sdec.*sin(ph_cor))./M_cor;
S = (Gdec.*sin(ph_cor) + Sdec.*cos(ph_cor))./M_cor;

M = sqrt(G^2+S^2);
phi = atan(S/G);
end

