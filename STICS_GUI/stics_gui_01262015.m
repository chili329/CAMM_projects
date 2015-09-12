function varargout = stics_gui_01262015(varargin)
% STICS_GUI_01262015 MATLAB code for stics_gui_01262015.fig
%      STICS_GUI_01262015, by itself, creates a new STICS_GUI_01262015 or raises the existing
%      singleton*.
%
%      H = STICS_GUI_01262015 returns the handle to a new STICS_GUI_01262015 or the handle to
%      the existing singleton*.
%
%      STICS_GUI_01262015('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STICS_GUI_01262015.M with the given input arguments.
%
%      STICS_GUI_01262015('Property','Value',...) creates a new STICS_GUI_01262015 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stics_gui_01262015_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stics_gui_01262015_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stics_gui_01262015

% Last Modified by GUIDE v2.5 19-Aug-2015 20:59:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stics_gui_01262015_OpeningFcn, ...
                   'gui_OutputFcn',  @stics_gui_01262015_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before stics_gui_01262015 is made visible.
function stics_gui_01262015_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stics_gui_01262015 (see VARARGIN)

% Choose default command line output for stics_gui_01262015
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stics_gui_01262015 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stics_gui_01262015_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%HERE
%(1) ROI selection
%(2) show filename and no. of frames

% --- Executes on button press in load_image.
%read image file (img_file)
function load_image_Callback(hObject, eventdata, handles)
clear handles.image_data handles.seri handles.img_file
files = uipickfiles;
filename = files{1};
%[pathstr,name,ext] = fileparts(filename);

[handles.seri, lsminf] = lsm_read(filename);
handles.lsminf = lsminf;
handles.num_ch = lsminf.NUMBER_OF_CHANNELS;
%total number of frames
handles.DimensionTime = lsminf.DimensionTime;
%pixel size in um
handles.pixel_size = lsminf.VoxelSizeX*10^(6);
%frame time in s
handles.t = lsminf.TimeStamps.TimeStamps(2);

axes(handles.stics_final);
%imagesc to imshow
imagesc(handles.seri{1}(:,:,1))
%imshow(mat2gray(handles.seri{1}(:,:,1)))

%create video
save_mov = get(handles.save_mov,'value');
ch = 2;
if save_mov == 1
    writerObj = VideoWriter('data.avi');
    open(writerObj);
    for k = 1:100 
       imshow(mat2gray(handles.seri{ch}(:,:,k)))
       frame = getframe;
       writeVideo(writerObj,frame);
    end
    close(writerObj);
end

guidata(hObject, handles);


function pixel_size_Callback(hObject, eventdata, handles)
%HERE: conflict with data loading
if isnumeric(handles.pixel_size) == 0
    set(handles.pixel_size,'Value',str2double(get(hObject,'String')));
    display pixel_size
    get(handles.pixel_size,'Value');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pixel_size_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function t_Callback(hObject, eventdata, handles)
%HERE: conflict with data loading
if isnumeric(handles.t) == 0
    set(handles.t,'Value',str2double(get(hObject,'String')));
    display t
    get(handles.t,'Value');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function seg_size_Callback(hObject, eventdata, handles)
set(handles.seg_size,'Value',str2num(get(hObject,'String')));
get(handles.seg_size,'Value')
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function seg_size_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tauLimit_Callback(hObject, eventdata, handles)
set(handles.tauLimit,'Value',str2double(get(hObject,'String')));
display tauLimit
get(handles.tauLimit,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tauLimit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in immobile.
function immobile_Callback(hObject, eventdata, handles)
get(handles.immobile,'Value')
display immobile
guidata(hObject, handles);

% --- Executes on button press in whitenoise.
function whitenoise_Callback(hObject, eventdata, handles)
get(handles.whitenoise,'Value')
display whitenoise
guidata(hObject, handles);

function ch_Callback(hObject, eventdata, handles)
set(handles.ch,'Value',str2double(get(hObject,'String')));
display ch
get(handles.ch,'Value')
ch = get(handles.ch,'value');
handles.image_data = handles.seri{ch};
%immobile removal image
handles.imm_data = immfilter_new(handles.image_data);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ch_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stics_run.
function stics_run_Callback(hObject, eventdata, handles)
image_data = handles.image_data;
%HERE
%t = get(handles.t,'value');
t = handles.t;
pixel_size = handles.pixel_size;
%pixel_size = get(handles.pixel_size,'value');
seg_size = get(handles.seg_size,'value');
tauLimit = get(handles.tauLimit,'value');
immobile = get(handles.immobile,'value');
whitenoise = get(handles.whitenoise,'value');

if immobile == 0
    immobile = 'n';
else
    immobile = 'y';
end    
if whitenoise == 0 
    whitenoise = 'n';
else
    whitenoise = 'y';
end

warning('off');
[handles.Vx_total, handles.Vy_total, handles.xdim, handles.ydim, handles.half_size] = stics_seg(image_data,t,pixel_size,immobile,tauLimit,whitenoise,seg_size);

guidata(hObject, handles);

%display time series image
% --- Executes on slider movement.
function frame_slider_Callback(hObject, eventdata, handles)
display frame_slider
frame_slider = get(handles.frame_slider,'Value')
image_data = handles.image_data;
frames = size(image_data,3);

%frames = size(handles.seri,1);
if frame_slider <1
    fra = floor(frame_slider*frames)+1;
else
    fra = frames;
end
axes(handles.stics_final);

%HERE
%show immobile removal
imm_data = handles.imm_data;

%07132015: for showing raw, immobile removed, difference images, see
%lsm_imgshow.m

%ORIGINAL 07132015
%imagesc to imshow
imagesc(image_data(:,:,fra))
%imshow(mat2gray(image_data(:,:,fra)))
colormap(handles.stics_final,'gray')
axis image
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frame_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in stics_plot.
function stics_plot_Callback(hObject, eventdata, handles)
image_data = handles.image_data;
Vx_total = handles.Vx_total;
Vy_total = handles.Vy_total;
half_size = handles.half_size;
pixel_size = handles.pixel_size;

axes(handles.stics_final);

stics_plot(image_data, Vx_total, Vy_total,half_size,pixel_size)


% --- Executes on button press in simu.
function simu_Callback(hObject, eventdata, handles)

countingNoise = 0;
backgroundNoise = 0;

flowX1 = get(handles.flowX1,'value');
flowY1 = get(handles.flowY1,'value');
flowX2 = get(handles.flowX2,'value');
flowY2 = get(handles.flowY2,'value');
den1 = get(handles.den1,'value');
den2 = get(handles.den2,'value');
diff1 = get(handles.diff1,'value');
diff2 = get(handles.diff2,'value');

%get the pixel_size and t
pixel_size = get(handles.pixel_size,'Value');
t = get(handles.t,'Value');
%simul8tr(sizeXdesired,sizeYdesired,sizeT,density,bleachType,bleachDecay,qYield,pixelsize,timesize,PSFType,PSFSize,PSFZ,noBits,diffCoeff,flowX,flowY,flowZ,countingNoise,backgroundNoise);

simu_data = simul8tr(32,32,1000,[den1 den2],'none',[0 0],[1 1],pixel_size,t,'g',0.3,0,12,[diff1 diff2],[flowX1 flowX2],[flowY1 flowY2],[0 0],countingNoise,backgroundNoise);

%save into movie file
save_mov = get(handles.save_mov,'value');
if save_mov == 1
    writerObj = VideoWriter('simu.avi');
    open(writerObj);
    for k = 1:100 
       imagesc(simu_data(:,:,k));
       colormap(gray)
       frame = getframe;
       writeVideo(writerObj,frame);
    end
    close(writerObj);
end

handles.image_data = simu_data; 
%immobile removal image
handles.imm_data = immfilter_new(handles.image_data);

axes(handles.stics_final);
%imagesc to imshow
imagesc(handles.image_data(:,:,1));
%imshow(mat2gray(handles.image_data(:,:,1)));

guidata(hObject, handles);


function flowX1_Callback(hObject, eventdata, handles)
set(handles.flowX1,'Value',str2double(get(hObject,'String')));
display flowX1
get(handles.flowX1,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function flowX1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function flowY1_Callback(hObject, eventdata, handles)
set(handles.flowY1,'Value',str2double(get(hObject,'String')));
display flowY1
get(handles.flowY1,'Value')
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function flowY1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function diff1_Callback(hObject, eventdata, handles)
set(handles.diff1,'Value',str2double(get(hObject,'String')));
display diff1
get(handles.diff1,'Value')
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function diff1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function den1_Callback(hObject, eventdata, handles)
set(handles.den1,'Value',str2double(get(hObject,'String')));
display den1
get(handles.den1,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function den1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function flowX2_Callback(hObject, eventdata, handles)
set(handles.flowX2,'Value',str2double(get(hObject,'String')));
display flowX2
get(handles.flowX2,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function flowX2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function flowY2_Callback(hObject, eventdata, handles)
set(handles.flowY2,'Value',str2double(get(hObject,'String')));
display flowY2
get(handles.flowY2,'Value')
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function flowY2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function diff2_Callback(hObject, eventdata, handles)
set(handles.diff2,'Value',str2double(get(hObject,'String')));
display diff2
get(handles.diff2,'Value')
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function diff2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function den2_Callback(hObject, eventdata, handles)
set(handles.den2,'Value',str2double(get(hObject,'String')));
display den2
get(handles.den2,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function den2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in partial_img.
function partial_img_Callback(hObject, eventdata, handles)

image_data = handles.image_data;

cx = get(handles.cx,'value'); 
cy = get(handles.cy,'value');
start_t = get(handles.start_t,'value');
end_t = get(handles.end_t,'value');

seg_size = get(handles.seg_size,'value');
tauLimit = get(handles.tauLimit,'value');
immobile = get(handles.immobile,'value');

if immobile == 1
    image_data = handles.imm_data;
end
[ICS2DCorr] = partial_ICS(image_data,cx,cy,start_t,end_t,seg_size,tauLimit);
handles.ICS2DCorr = ICS2DCorr;

%HERE: save for testing
%ICS2DCorr = handles.ICS2DCorr;
%save('corr.mat','ICS2DCorr');
axes(handles.stics_corr);
surf(handles.ICS2DCorr(:,:,2),'EdgeColor','none');
%use the max at tau =1 for color upper limit 
caxismax = max(max(max(ICS2DCorr(:,:,2:end))));
caxismin = min(ICS2DCorr(:));
handles.caxismax = caxismax;
handles.caxismin = caxismin;
caxis(handles.stics_corr,[caxismin caxismax])
view(0,-90);
axis('equal')

%create video
save_mov = get(handles.save_mov,'value');
if save_mov == 1
    writerObj = VideoWriter('corr.avi');
    open(writerObj);
    kmax = min(20,tauLimit);
    for k = 2:kmax 
       surf(handles.ICS2DCorr(:,:,k),'EdgeColor','none'); 
       colormap gray
       caxismax = max(max(max(ICS2DCorr(:,:,2:end))));
       caxismin = min(ICS2DCorr(:));
       caxis(handles.stics_corr,[caxismin caxismax])
       view(0,-90);
       axis('equal')
       frame = getframe;
       writeVideo(writerObj,frame);
    end
    close(writerObj);
end

handles.v2 = axis;
guidata(hObject, handles);


function start_t_Callback(hObject, eventdata, handles)
set(handles.start_t,'Value',str2double(get(hObject,'String')));
display start_t
get(handles.start_t,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function start_t_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function end_t_Callback(hObject, eventdata, handles)
set(handles.end_t,'Value',str2double(get(hObject,'String')));
display end_t
get(handles.end_t,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function end_t_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cx_Callback(hObject, eventdata, handles)
set(handles.cx,'Value',str2double(get(hObject,'String')));
display cx
get(handles.cx,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cx_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cy_Callback(hObject, eventdata, handles)
set(handles.cy,'Value',str2double(get(hObject,'String')));
display cy
get(handles.cy,'Value')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cy_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function time_slider_Callback(hObject, eventdata, handles)
display time_slider
time_slider = get(handles.time_slider,'Value')
tauLimit = get(handles.tauLimit,'value');

%HERE
%frames = size(handles.seri,1);
if time_slider <1
    fra = floor(time_slider*tauLimit)+1;
else
    fra = tauLimit;
end

rotate3d on
axes(handles.stics_corr);

surf(handles.ICS2DCorr(:,:,fra),'EdgeColor','none');
%HERE log z scale
%set(gca,'zscale','log')
colormap(handles.stics_corr,'jet')
caxismax = handles.caxismax;
caxismin = handles.caxismin;
caxis(handles.stics_corr,[caxismin caxismax])
axis(handles.stics_corr,handles.v2)
view(0,-90);
axis('square')
%HERE
xlim([0 32])
ylim([0 32])


% --- Executes during object creation, after setting all properties.
function time_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in auto_corr.
function auto_corr_Callback(hObject, eventdata, handles)
image_data = handles.image_data;
cx = get(handles.cx,'value'); 
cy = get(handles.cy,'value');
pixel_t = squeeze(image_data(cx,cy,:));
[G] = single_corr(pixel_t,pixel_t)

axes(handles.stics_corr)
semilogx(squeeze(G));


% --- Executes on button press in pixel_time.
function pixel_time_Callback(hObject, eventdata, handles)
image_data = handles.image_data;
cx = get(handles.cx,'value'); 
cy = get(handles.cy,'value');
pixel_t = squeeze(image_data(cx,cy,:));

figure(1)
plot(pixel_t,'linewidth',2);


% --- Executes on button press in iMSD.
function iMSD_Callback(hObject, eventdata, handles)
scan = handles.ICS2DCorr;
if isnumeric(handles.t) == 0
    time = get(handles.t,'value');
else
    time = handles.t;
end

if isnumeric(handles.pixel_size) == 0
    p_size = get(handles.pixel_size,'value');
else
    p_size = handles.pixel_size;
end

cx = get(handles.cx,'value');
cy = get(handles.cy,'value');

fit_option = 2;
%diffusion only
%[MSD,x0,y0,diff,sig0] = iMSD_seg_diff(scan,time,p_size,cx,cy);
%diffusion + binding
%[MSD,x0,y0,diff,sig0] = iMSD_seg_diff_bind(scan,time,p_size,cx,cy);
%binding only
%[Nt,tauT,sigT] = iMSD_seg_bind(scan)
%with velocity
if fit_option == 1
    iMSD_seg_diff_v(scan,time,p_size,cx,cy);
end
if fit_option == 2
    iMSD_seg_rot_iso(scan,time,p_size,cx,cy);
end
guidata(hObject, handles);


% --- Executes on button press in iMSD_run.
%overall iMSD for the entire image
function iMSD_run_Callback(hObject, eventdata, handles)

image_data = handles.image_data;
[X,Y,T] = size(image_data)
start_t = get(handles.start_t,'value');
end_t = get(handles.end_t,'value');
seg_size = get(handles.seg_size,'value');
tauLimit = get(handles.tauLimit,'value');
immobile = get(handles.immobile,'value');
time = handles.t;
p_size = handles.pixel_size;
[xdim,ydim,zdim] = size(image_data);
mov_sizex = seg_size/2; %shifting step size
mov_sizey = seg_size/2; %shifting step size
imin = seg_size/2/mov_sizex;
jmin = seg_size/2/mov_sizey;
imax = (xdim-seg_size/2)/mov_sizex;
jmax = (ydim-seg_size/2)/mov_sizey;
cy_all = zeros(jmax,1);
sig0_all = zeros(imax,jmax);
diff_all = zeros(imax,jmax);
amp_all = zeros(imax,jmax);
conc_all = zeros(imax,jmax);
theta_all = zeros(imax,jmax);
amp1_all= zeros(imax,jmax);
amp2_all= zeros(imax,jmax);
sx_all= zeros(imax,jmax);
sy_all= zeros(imax,jmax);
s_all= zeros(imax,jmax);

if immobile == 1
    image_data = handles.imm_data;
end

for i = imin : imax
    for j = jmin : jmax
       cx = i*mov_sizex+1;
       cy = j*mov_sizey+1;
       [ICS2DCorr] = partial_ICS(image_data,cx,cy,start_t,end_t,seg_size,tauLimit);
       
       %diffusion
       %[MSD,x0,y0,diff,sig0] = iMSD_seg_diff(ICS2DCorr,time,p_size,cx,cy);
       fit_option = 2;
       %with velocity %used until 20150910
       if fit_option ==1
           [MSD,x0,y0,diff,amp,v,sig0] = iMSD_seg_diff_v(ICS2DCorr,time,p_size,cx,cy);
           diff_all(i,j) = diff;
           %number of particles in the observation volume (N)= gamma/(pi*amp)
           amp_all(i,j) = amp;
           %if amp is too small, cannot calculate concentration correctly
           if amp>0.1
            conc_all(i,j) = 0.35/(pi*amp);
           else
               conc_all(i,j) = 0;
           end
           v_all(i,j) = v;
           cy_all(j) = cy;
           sig0_all(i,j) = sig0;
       end
       %diffusion + binding
       %[MSD,x0,y0,diff,sig0] = iMSD_seg_diff_bind(ICS2DCorr,time,p_size,cx,cy);
       
       %binding only
       %[Nt,tauT,sigT] = iMSD_seg_bind(scan)
       
       %rot+iso 2D Gaussian
       if fit_option == 2
           [xnew] = iMSD_seg_rot_iso(ICS2DCorr,time,p_size,cx,cy);
           %xnew:
           %[Amp1,x0  ,sx  ,y0  ,sy  ,theta,  bg, Amp2,  x1,s    ,y1]
           %[x(1),x(2),x(3),x(4),x(5),x(6) ,x(7), x(8),x(9),x(10),x(11)]
           %HERE:
           theta_all(i,j) = median(xnew(6,:)).*180/pi;
           amp1_all(i,j) = median(xnew(1,:));
           amp2_all(i,j) = median(xnew(8,:));
           sx_all(i,j) = sqrt(median(xnew(3,:))./2)*2.35;
           sy_all(i,j) = sqrt(median(xnew(5,:))./2)*2.35;
           s_all(i,j) = sqrt(median(xnew(10,:))./2)*2.35;
           cy_all(j) = cy;
       end
       

    end
end

%use the max at tau =1 for color upper limit
caxismax = max(max(max(ICS2DCorr(:,:,2:end))));
caxismin = min(ICS2DCorr(:));
handles.caxismax = caxismax;
handles.caxismin = caxismin;

handles.diff_all = diff_all;
handles.amp_all = amp_all;
handles.conc_all = conc_all;

if fit_option == 1
    figure(1)
    subplot(4,1,1)
    plot(cy_all,diff_all,'linewidth',2)
    title('Diffusion')
    set(gca,'FontSize',16)

    subplot(4,1,2)
    plot(cy_all,conc_all,'linewidth',2)
    title('concentration')
    set(gca,'FontSize',16)

    subplot(4,1,3)
    plot(cy_all,v_all,'linewidth',2)
    title('velocity')
    set(gca,'FontSize',16)

    subplot(4,1,4)
    plot(cy_all,sig0_all,'linewidth',2)
    title('sig0')
    set(gca,'FontSize',16)
end

if fit_option == 2
    figure(1)
    subplot(3,1,1)
    plot(cy_all,theta_all,'linewidth',2)
    title('Theta')
    set(gca,'FontSize',16)
 
    subplot(3,1,2)
    hold on
    plot(cy_all,sx_all,'color',[0 0 1],'linewidth',2)
    plot(cy_all,sy_all,'color',[0 0 0.6],'linewidth',2)
    plot(cy_all,s_all,'color',[0 1 0],'linewidth',2)
    title('FWMH(pixel)')
    legend('sx','sy','s')
    set(gca,'FontSize',16)
    hold off
    
    subplot(3,1,3)
    hold on
    plot(cy_all,amp1_all,'r','linewidth',2)
    plot(cy_all,amp2_all,'b','linewidth',2)
    title('Amp')
    legend('Amp1','Amp2')
    set(gca,'FontSize',16)
    hold off

end
%save('diff.mat','diff_all');
%save('sig0.mat','sig0_all');
%save('v.mat','v_all');

guidata(hObject, handles);


% --- Executes on button press in save_mov.
function save_mov_Callback(hObject, eventdata, handles)
get(handles.save_mov,'Value')
display save_mov
guidata(hObject, handles);