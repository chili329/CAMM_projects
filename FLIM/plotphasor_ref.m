% from Applications of phasors to in vitro time-resolved fluorescence
% measurements (2011)

function [G,S,M,phi] = plotphasor_ref(data, ref, ref_tau, freq, delta_t)

%freq = harmonic to show

%ph_cor and M_cor do not affect data point's relative position, 
%only affect the location of data point.

w = 2*pi*freq; 

Gn_ref = 0;
Sn_ref = 0;
area_ref = 0;
for bin = 1:length(ref)-1
    Gn_ref = Gn_ref + ref(bin).*cos(w*delta_t.*(bin-0.5))*delta_t;
    Sn_ref = Sn_ref + ref(bin).*sin(w*delta_t.*(bin-0.5))*delta_t;
    area_ref = area_ref + (ref(bin) + ref(bin+1)).*delta_t./2;
end

G_ref = Gn_ref./area_ref;
S_ref = Sn_ref./area_ref;
M_ref = (1+(w*ref_tau).^2).^(-0.5);
ph_ref = atan(w*ref_tau);
M_cor = sqrt(G_ref.^2+S_ref.^2)./M_ref;
ph_cor = -atan2(S_ref,G_ref)+ph_ref;

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

