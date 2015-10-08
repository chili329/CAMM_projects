%fit with only background term
function F = Background(x,xdata)
%[bg]
%[x(1)]    

X = xdata(:,:,1);
Y = xdata(:,:,2);

F = x(1)+X*0+Y*0;
