%project G and S to the line of free/bound NADH and calculate the ratio
%0: all free
%100: all bound

function pRatio = projFLIM(p,free,bound)
%data point
%p = [1,0.5];
%NADH free position
%free = [0,1];
%NADH bound position
%bound = [1,1];

%point to free distance
p2free = sqrt((p(1)-free(1))^2+((p(2)-free(2)))^2);

%free-bound range
xd = bound(1)-free(1);
yd = bound(2)-free(2);
fbr = sqrt(xd.^2+yd.^2);

%point to free-bound line distance
p2line = abs(xd*(free(2)-p(2))-yd*(free(1)-p(1)))/fbr;


%point free-bound ratio
%0: all free
%100: all bound
pRatio = sqrt(p2free.^2-p2line.^2)./fbr.*100;