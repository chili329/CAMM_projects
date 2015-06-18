%simulating line scan for pCF analysis
%simul8tr from ICS package, Paul Wiseman group
for i = [-1 0 0.7 1 1.5 2]
    %clear all
    close all
    clearvars -except i

    sizeX = 32; sizeY = 1; sizeT = 10000;
    density = 5;
    bleachType = 'none'; bleachDecay = 0;
    qYield = 0.1;
    %in um
    pixelsize = 0.1;
    %line time in s
    timesize = 0.001;
    %'g' for Gaussian
    %IMPORTANT-- if PSFZ is not 0, then the diffusion is in 3D
    PSFType = 'g'; PSFSize = 0.3; PSFZ = 0;
    noBits = 12;
    diffCoeff = power(10,i);
    flowX = 0; flowY = 0; flowZ = 0;
    countingNoise = 0;
    backgroundNoise = 0;

    scan = simul8tr(sizeX,sizeY,sizeT,density,bleachType,bleachDecay,qYield,pixelsize, ...
    timesize,PSFType,PSFSize,PSFZ,noBits,diffCoeff,flowX,flowY,flowZ, countingNoise,backgroundNoise);

    %for movie
    % for i = 1:sizeT
    %     imagesc(scan(:,:,i))
    %     M(i) = getframe
    % end

    %line acquisition reshape matrix
    scan = reshape(scan,[sizeX,sizeT]);
    ch = cell(1);
    ch{1} = scan;

    %correlation
    %option 1: fix dis, 2: fix col, 3: fix -dis
    option = 1;
    dis = 0;

    %plot original image and correlation image
    subplot(1,2,1)
    imagesc(scan')
    [Gx,axis_t,Gnew] = batch_pCF_plot(ch, option, dis, 1, 1, pixelsize, timesize, 2, 2,10);
    colorbar
    %export_fig(sprintf('pCFdicY%d.png', diffCoeff));
    
    %fitting using the first 100 pixels
    wz = 0;
    [Dmap] = pCF_fit(Gnew(1:100,:),PSFSize,wz,timesize);
    power(10,i)
    mean(Dmap)
    var(Dmap)
end