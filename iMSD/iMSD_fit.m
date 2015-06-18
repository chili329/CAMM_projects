%iMSD fitting
%input data: XYT
function iMSD_fit(Gnew)
    
    modelFun = @(p,x) p(1).*power((1+x.*p(2).*xyterm),-1).*power((1+x.*p(2).*zterm),-0.5);
    startingVals = [0.1 10];



end