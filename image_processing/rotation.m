theta = pi/3;
phi = pi;
xrot = [1 0 0 0; 0 cos(theta) -sin(theta) 0; 0 sin(theta) cos(theta) 0; 0 0 0 1];
yrot = [cos(phi) 0 -sin(phi) 0; 0 1 0 0; sin(phi) 0 cos(phi) 0; 0 0 0 1];
ori = [1; 1; 1; 1];
new = xrot*yrot*ori

