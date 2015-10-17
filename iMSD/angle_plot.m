%plot bar with angle to indicate the main axis of correlation
%overlap with original image
%input:
%   x,y: center coordinate
%   theta: angle from the fit
%   sx, sy, s: FWHM from the fit
function [] = angle_plot(x,y,theta,s,sx,sy,amp1,amp2,sc,cc)

% x = 17;
% y = 17;
% theta = 45;
% s = 5;
% sx = 10;
% sy = 5;

%divide FWHM to half
s = s./2;
sx = sx./2;
sy = sy./2;
s2 = 0;
%if sx = sy (within 5% differnece), then plot circle rather than cross
if sx == sy
    if s == 0
        s = sx;
    else
        s2 = sx;
    end
    sx = 0;
    sy = 0;
end

sint = sin(theta*pi/180);
cost = cos(theta*pi/180);

sint2 = sin((theta-90)*pi/180);
cost2 = cos((theta-90)*pi/180);

hold on
%sx
plot([sx*cost+y -sx*cost+y],[sx*sint+x -sx*sint+x],'linewidth',amp1,'color',sc)
%sy
plot([sy*cost2+y -sy*cost2+y],[sy*sint2+x -sy*sint2+x],'linewidth',amp1,'color',sc)
%s
circle(y,x,s,cc,amp2)
%s2
if s2 > 0
    circle(y,x,s2,sc,amp1);
end