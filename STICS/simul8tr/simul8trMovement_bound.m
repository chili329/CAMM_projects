function [population] = simul8trMovement_bound(population,timesize,pixelsize,sizeX,sizeY,sizeZ);
%introduce vibration by randomly choose + or - sign for the flow
vib = 1;
movb = 0;
sizeY = 44;
sizeX = 44;
% Simulates particle diffusion and flow, given a 2D matrix, inputObjects
% (containing only 0, 1, 2, etc) and diffCoeff, flowX,flowY
% Does not support multiple populations -- call a new simul8trMovement separately,
% and pass it the inputObjects matrix of a different population

%number of different populations: size(population,2)
%p1 = population(1)
%number of particles: size(p1.xCoor,1)
%individual coordinate: p1.xCoor(i)

% Do different kinds of particle movement here
if population.diffCoeff ~= 0;
    %population.xCoor = population.xCoor+randn((size(population.xCoor))).*sqrt(2*population.diffCoeff*timesize*population.xCoor/10)/pixelsize;
    population.xCoor = population.xCoor+randn((size(population.xCoor)))*sqrt(2*population.diffCoeff*timesize)/pixelsize;
    population.yCoor = population.yCoor+randn((size(population.yCoor)))*sqrt(2*population.diffCoeff*timesize)/pixelsize;
    if sizeZ ~= 0
        population.zCoor = population.zCoor+randn((size(population.zCoor)))*sqrt(2*population.diffCoeff*timesize)/pixelsize;
    end
end

%flow to vibration
if (population.flowX ~= 0) | (population.flowY ~= 0)
    %generate random direction
    if vib == 1
        randx = round(rand);
        if randx == 0
            randx = -1;
        end
        randy = round(rand);
        if randy == 0
            randy = -1;
        end
    else
        randx = 1;
        randy = 1;
    end
    population.xCoor = population.xCoor+(population.flowX*timesize)/pixelsize*randx;
    population.yCoor = population.yCoor+(population.flowY*timesize)/pixelsize*randy;
end

%moving boundary
if movb == 1
    sizeY = round(sizeY*(1+0.3*rand));
end

%HERE:not working properly
%set lower/upper bound
%set the boundary
% highX = 60;
% highY = 60;
% lowX = 0;
% lowY = 10;
% for i = 1:size(population.xCoor,1)
%     if lowX > 0
%         if population.xCoor(i) < lowX
%             population.xCoor(i) = 2*lowX - population.xCoor(i);
%         end
%     end
%     if population.xCoor(i) > highX
%         population.xCoor(i) = 2*highX - population.xCoor(i);
%     end
%     if lowY > 0
%         if population.yCoor(i) < lowY
%             population.yCoor(i) = 2*lowY - population.yCoor(i);
%         end
%     end
%     if population.yCoor(i) > highY
%         population.yCoor(i) = 2*highY - population.yCoor(i);
%     end
% end

% Fix BC problems here
population.xCoor = mod(population.xCoor,sizeX);
population.yCoor = mod(population.yCoor,sizeY);

population.xCoorDisplay = round(population.xCoor);
population.yCoorDisplay = round(population.yCoor);
xZeros = find(population.xCoorDisplay==0);
yZeros = find(population.yCoorDisplay==0);

population.xCoorDisplay(xZeros) = sizeX;
population.yCoorDisplay(yZeros) = sizeY;

if sizeZ ~= 0
    population.zCoor = mod(population.zCoor,sizeZ);
end