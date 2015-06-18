%simulating different orbit shape for STICS analysis

%get the simulation using ICS package

%simulation = simul8tr(sizeX,sizeY,sizeT,density,bleachType,bleachDecay,qYield,pixelsize, ...
%timesize,PSFType,PSFSize,PSFZ,noBits,diffCoeff,flowX,flowY,flowZ, countingNoise,backgroundNoise);

%imageSeries = simul8tr(256,256,100,10,'none',0,1,0.1,1,'g',0.4,0,12,0.01,0,0,0,0,0);
imagefast = simul8tr(256,256,100,10,'none',0,1,0.1,0.1,'g',0.4,0,12,0,10,0,0,0,0);

for i = 1:100
    imagesc(imagefast(:,:,i))
    M(i) = getframe
end
%croppedImageSeries = serimcrop(imageSeriesFlow);
%[Vx,Vy] = velocity(imageSeriesFlow,0.1,0.06,'y',20,'n')

%imagesc(imageSeries(:,:,1))
%axis image
%colormap(gray)

%acquire only on the particular pattern
%[x,y] = acquisition(pixel,shift,radius,mod_per,mod_num);
[x,y] = acquisition(256,0,40,1,4);
x = x';
y = y';

%get the orbit acquisition of the simulated 2D image
orbit = zeros(256,256,100);
for i = 1:256
        orbit(ceil(x(i)),ceil(y(i)),:) = imagefast(ceil(x(i)),ceil(y(i)),:);
        orbit_line(i,:) = imagefast(ceil(x(i)),ceil(y(i)),:);
end

bin_write('imagefast.bin',orbit_line,256);


%make a movie!
for i = 1:100
    imagesc(orbit(:,:,i))
	M(i) = getframe;
end
%movie(M,1)

%test = orbit;

%GtFlow = tics(test,0.1);
%flowCoeff = flowfit(GtFlow(1:60,1),GtFlow(1:60,2));

%ICS2DCorr = corrfunc(test);
%ICS2DCorrCrop = autocrop(ICS2DCorr,12);
%GtDiff = tics(imageSeries,1);
%figure(7)
%plot(GtDiff(1:20,1),GtDiff(1:20,2))
%diffCoeff = difffit(GtDiff(1:20,1),squeeze(GtDiff(1:20,2)));

%figure(5)
%s=surf(ICS2DCorr(:,:,1));
%axis tight
%colormap(jet)
%set(s,'LineStyle','none')
