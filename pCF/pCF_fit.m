%pCF diffusion fitting. only consider time direction.
%Gnew: correlation carpet (time, pixel)
%w0: PSF xy
%wz: PSF z
%default unit: um
function [Dmap] = pCF_fit(Gnew,w0,wz,l_time)
    close all
    %diffusion dimensionality
    d = 2;
    xyterm = 2*d*l_time/(w0^2);
    if wz ~= 0
        zterm = 2*d*l_time/(wz^2);
    else
        zterm = 0;
    end

    %p(1): gamma/N
    %p(2): diffusion
    modelFun = @(p,x) p(1).*power((1+x.*p(2).*xyterm),-1).*power((1+x.*p(2).*zterm),-0.5);
    startingVals = [0.1 10];

    [g1 g2] = size(Gnew);
    %x = (l_time:l_time:l_time*g1)';
    x = (0:g1-1)';
    for i = 1:g2
        %use the first 100 time point for fitting
        y = Gnew(1:100,i);
        [coefEsts,residual] = nlinfit(x, y, modelFun, startingVals);

        %plotting
        line(x, modelFun(coefEsts, x), 'Color','r');
        hold on
        %semilogx(x,y,'Color','k');
        %semilogx(x,residual,'Color',[0.5 0.5 0.5])
        plot(x,y,'Color','k');
        plot(x,residual,'Color',[0.5 0.5 0.5])
        Dmap(i) = coefEsts(2);
    end

end






