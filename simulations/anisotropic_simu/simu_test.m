%[postConv] = simul8tr_bound(sizeXdesired,sizeYdesired,sizeT,density,bleachType,...
%bleachDecay,qYield,pixelsize,timesize,PSFType,PSFSize,PSFZ,noBits,diffCoeff,flowX,flowY,flowZ,countingNoise,backgroundNoise);

sizeXdesired = 32;
sizeYdesired = 32;
sizeT = 10;
density = 10;
bleachType = 'none';
bleachDecay = 0;
qYield = 1;
pixelsize = 0.1;
timesize = 0.05;
PSFType = 'g';
PSFSize = 0.3;
PSFZ = 0;
noBits= 12;
diffCoeff = 0.1;
flowX = 0;
flowY = 0;
flowZ = 0;
countingNoise = 0;
backgroundNoise = 0;

[postConv] = simul8tr_bound(sizeXdesired,sizeYdesired,sizeT,density,bleachType,bleachDecay,qYield,pixelsize,timesize,PSFType,PSFSize,PSFZ,noBits,diffCoeff,flowX,flowY,flowZ,countingNoise,backgroundNoise);
imagesc(postConv(:,:,1))