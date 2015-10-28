function [postConv] = simul8tr_bound(density,pixelsize,timesize,diffCoeff,flowX,flowY,countingNoise,backgroundNoise,bsizeX,bsizeY);

sizeXdesired = 32;
sizeYdesired = 32;
sizeT = 1000;
bleachType = 'none';
bleachDecay = [0 0];
qYield = [1 1];
PSFType = 'g';
PSFSize = 0.3;
PSFZ = 0;
noBits = 12;
flowZ = [0 0];

% Adds a "border" around simulation -- cropped at end
sizeX = round(PSFSize/pixelsize)*4+sizeXdesired;
sizeY = round(PSFSize/pixelsize)*4+sizeYdesired;
sizeZ = 0;
% sizeX = sizeXdesired;
% sizeY = sizeYdesired;

% Generates an odd (ie, not even!) sized filter for convolution
% '6' is arbitrary factor so Gaussian is small by edge of filter
if (strcmp(PSFType,'g') | strcmp(PSFType,'l'))
    if mod(ceil(PSFSize/pixelsize*6),2)==0
        filtersize = ceil(PSFSize/pixelsize*6)+1;
    else
        filtersize = ceil(PSFSize/pixelsize*6);
    end
end

% Preallocate output arrays
preConv = zeros(sizeY,sizeX,size(density,2));
postConv = zeros(sizeY,sizeX,sizeT);
numToBleach = zeros(size(sizeT,size(density,2)));

% Sets up "population" structure
for i=1:size(density,2)
    % Generate random "seed" for initial positions

    numParticles(i) = round(pixelsize^2*sizeX*sizeY*density(i));
 
    xCoor=sizeX*rand(numParticles(i), 1);
    yCoor=sizeY*rand(numParticles(i), 1);
    population(i).xCoor = xCoor;
    population(i).yCoor = yCoor;
    population(i).xCoorDisplay = xCoor;
    population(i).yCoorDisplay = yCoor;
    population(i).diffCoeff = diffCoeff(i);
    population(i).flowX = flowX(i);
    population(i).flowY = flowY(i);
    population(i).flowZ = flowZ(i);
    population(i).qYield = ones(numParticles(i), 1).*qYield(i);
    population(i).blink = ones(numParticles(i), sizeT);
    population(i).numToBleach(1) = 0;
    %Evaluate number of fluorophores left due to photobleaching
    switch lower(bleachType)
        case 'none'
            bleachHowMany = @(bleachDecay,timesize,numFromBefore,t) (0);
    end
    for j=1:sizeT-1;
        population(i).numToBleach(j+1) = bleachHowMany(bleachDecay,timesize,numParticles(i) - sum(population(i).numToBleach(1:j)),j*timesize);
    end
end

set(gcbf,'pointer','watch');

for i = 1:sizeT;
    %waitbar(i/(sizeT-1),h);
    for j = 1:size(density,2)
        % Adjust particle positions
        %HERE
        population(j) = simul8trMovement(population(j),timesize,pixelsize,bsizeX,bsizeY,sizeZ);
        %Bleaches stuff
        if (population(j).numToBleach(i) ~= 0) & (isnan(population(j).numToBleach(i)) ~= 1)
            population(j).qYield(find(population(j).qYield,population(j).numToBleach(i),'first'))=0;
        end
        % Creates object positions
        preConv(:,:,j)=full(sparse(population(j).yCoorDisplay,population(j).xCoorDisplay, population(j).qYield.*population(j).blink(:,i), sizeY, sizeX));
    end
    % Convolve new positions
    postConv(:,:,i) = convolveGaussian(sum(preConv,3),filtersize,PSFSize/pixelsize);
    
end
% Crops the "border" from the simulation
postConv = postConv(round(PSFSize/pixelsize)*2+1:sizeY-round(PSFSize/pixelsize)*2,round(PSFSize/pixelsize)*2+1:sizeX-round(PSFSize/pixelsize)*2,:);
% Adds background noise
if backgroundNoise > 0
    maxIntensity = mean(max(max(postConv)));
    postConv=addBackgroundNoise(postConv,backgroundNoise);
    StoB = maxIntensity/(backgroundNoise*0.60272);
else
    StoB = Inf;
end
postConv = formatSeriesLikeMicroscope(postConv, noBits);
% Adds counting noise
if countingNoise > 0
    postConv=addCountingNoise(postConv,countingNoise);
end
blink = population(1).blink;
% Adjusts the bit depth of the image
postConv = uint16(formatSeriesLikeMicroscope(postConv, noBits));
%close(h);