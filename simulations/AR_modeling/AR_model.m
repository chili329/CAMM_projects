%1D simulation for the AR translocation time
%assume 2 types of movement: dynein-dependent microtubule transport and diffusion 
%unit in um and s

%first version by Farzin

%probability of AR at diffusion state
%can be estimated by bound/unbound ratio?
diffusionProbability = 0.7;

%dynein dependent transport
velocityMean=0.3; 
velocityVar=0.2; 

%time distribution of diffusion molecules
diffusionTimeMean=3; %HERE need to adjust based on velocity to match diffusion probability?
diffusionTimeVar=0.5;
%diffusion distance
diffusionMovementMean=0;
diffusionMovementVar=0.4;
%diffusion rate = diffusionMovementVar^2/diffusionTimeMean?

%distance from cell edge to nucleus
microTubileLength=50;

numberOfSamples=10000;
totalTimes=zeros(numberOfSamples, 1);
%IC: uniform distribution of AR
locations= rand(numberOfSamples,1)*microTubileLength;

for i=1:numberOfSamples
    currentLocation= locations(i);    
    currentTime=0;
    while currentLocation<microTubileLength
        willDiffuse= rand;
        
        %diffusion
        if willDiffuse < diffusionProbability;
            currentTime= currentTime+ normrnd(diffusionTimeMean, diffusionTimeVar);
            currentLocation=currentLocation+ normrnd(diffusionMovementMean,diffusionMovementVar);
        
        %dynein transport
        else
            currentVelocity=normrnd(velocityMean, velocityVar);
            %HERE
            distance= distanceFunction(5);
            
             if distance+currentLocation>microTubileLength
                 distance= microTubileLength-currentLocation;
                 currentLocation=microTubileLength;
             else
                currentLocation=currentLocation+distance;
             end
            currentTime= currentTime+ distance/currentVelocity;
        end       
    end
    totalTimes(i,1)= currentTime;
end

hist(totalTimes,20)
fprintf('The average time is %5.2f \n', mean(totalTimes));
