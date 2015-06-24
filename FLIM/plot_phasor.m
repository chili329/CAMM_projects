function [] = plot_phasor(G,S)
%PLOT unit circle
theta = 0:0.01:pi;
%unit circle
figure
plot(0.5+cos(theta)*0.5,sin(theta)*0.5,'Color','Blue');
hold on

%calculating density map
g=reshape(G,size(G,1)*size(G,2),1);
s=reshape(S,size(S,1)*size(S,2),1);

%choose bin level
binlevel=1;
%figure
[n,c]=hist3([g(:,1) s(:,1)],[size(G,1)/binlevel size(G,2)/binlevel]);

n1 = n'; 
n1(find(n1==0))=NaN;
n1( size(n,1) + 1 ,size(n,2) + 1 ) = NaN; 
xb = linspace(c{1}(1),c{1}(size(G,1)),size(n,1)+1);
yb = linspace(c{2}(1),c{2}(size(G,2)),size(n,2)+1);
h = pcolor(xb, yb,n1);
set(h,'EdgeColor','None')
set(h, 'zdata', ones(size(n1)) * -max(max(n))) 
colormap(jet) % heat map 
xlabel('g','fontsize',16)
ylabel('s','fontsize',16)
axis equal
xlim([0 1])
ylim([0 0.6])
grid off

hold off

