close all
t = size(ICS2DCorr,3);
msdx = zeros(t,1);
msdy = zeros(t,1);
amp = zeros(t,1);
x0 = zeros(t,1);
y0 = zeros(t,1);
for i = 1:t
    scan = ICS2DCorr(:,:,i);
    [x, residual] = D2GaussFitRot(scan);
    msdx(i) = x(3);
    msdy(i) = x(5);
    amp(i) = x(1);
    x0(i) = x(2);
    y0(i) = x(4);
    if amp(i) < 0.0001
        break
    end
end

plot(msdx,'r','linewidth',2)
hold on
plot(msdy,'k','linewidth',2)
plot(amp,'b','linewidth',2)
plot(x0,'g','linewidth',2)
plot(y0,'m','linewidth',2)