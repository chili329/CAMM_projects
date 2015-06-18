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

% Last Modified by GUIDE v2.5 17-Jun-2015 16:38:34

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
[handles.seri, lsminf] = lsm_read(filename);
handles.lsminf = lsminf;
handles.num_ch = handles.lsminf.NUMBER_OF_CHANNELS;

%pixel size in um
handles.pixel_size = lsminf.VoxelSizeX*10^(6);
%line time in s
handles.t = lsminf.TimeStamps.TimeStamps(2);

axes(handles.stics_final);
imagesc(handles.seri{1}(:,:,1))
guidata(hObject, handles);


function pixel_size_Callback(hObject, eventdata, handles)
%read from metadata

% set(handles.pixel_size,'Value',str2double(get(hObject,'String')));
% display pixel_size
% get(handles.pixel_size,'Value')
% guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pixel_size_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function t_Callback(hObject, eventdata, handles)
%read from metadata

% set(handles.t,'Value',str2double(get(hObject,'String')));
% display t
% get(handles.t,'Value')
% guidata(hObject, handles);


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
whitenoise = get(handles.immobile,'value');

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
%need to get rid of autoscale
imagesc(image_data(:,:,fra))
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
density = [5 5];
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

%simul8tr(sizeXdesired,sizeYdesired,sizeT,density,bleachType,bleachDecay,qYield,pixelsize,timesize,PSFType,PSFSize,PSFZ,noBits,diffCoeff,flowX,flowY,flowZ,countingNoise,backgroundNoise);

simu_data = simul8tr(64,64,1000,[den1 den2],'none',[0 0],[1 1],0.1,0.1,'g',0.3,0,12,[diff1 diff2],[flowX1 flowX2],[flowY1 flowY2],[0 0],countingNoise,backgroundNoise);

handles.image_data = simu_data; 

axes(handles.stics_final);
imagesc(handles.image_data(:,:,1));
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

%t = get(handles.t,'value');
%pixel_size = get(handles.pixel_size,'value');
t = handles.t;
pixel_size = handles.pixel_size;
seg_size = get(handles.seg_size,'value');
tauLimit = get(handles.tauLimit,'value');
immobile = get(handles.immobile,'value');
whitenoise = get(handles.immobile,'value');

cx1 = cx-seg_size/2;
cx2 = cx+seg_size/2-1;
cy1 = cy-seg_size/2;
cy2 = cy+seg_size/2-1;

%partial_data = zeros(seg_size,seg_size,(end_t-start_t+1));

if immobile == 1
    image_filtered = immfilter_new(image_data);
    %HERE: temporarily used to show subtract average images
    % handles.image_filtered = image_filtered;
    axes(handles.stics_final);
    imagesc(image_filtered(:,:,1))
    partial_data = image_filtered(cx1:cx2,cy1:cy2,start_t:end_t);
elseif immobile == 0
    partial_data = image_data(cx1:cx2,cy1:cy2,start_t:end_t);
end

size(partial_data)

if whitenoise == 0 
    whitenoise = 'n';
else
    whitenoise = 'y';
end

warning('off');
%[handles.Vx_total, handles.Vy_total, handles.xdim, handles.ydim, handles.half_size] = stics_seg(partial_data,t,pixel_size,'n',tauLimit,whitenoise,seg_size);

%plot correlation function
ICS2DCorr = stics(partial_data,tauLimit);
handles.ICS2DCorr = autocrop(ICS2DCorr,20);
%HERE: save for testing
%ICS2DCorr = handles.ICS2DCorr;
%save('corr.mat','ICS2DCorr');
axes(handles.stics_corr);
surf(handles.ICS2DCorr(:,:,2),'EdgeColor','none');
view(0,90);
handles.v = caxis;
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
handles.v
rotate3d on
axes(handles.stics_corr);

surf(handles.ICS2DCorr(:,:,fra),'EdgeColor','none');
caxis(handles.stics_corr, handles.v)
axis(handles.stics_corr,handles.v2)
view(0,90);


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
t = max(size(scan,3),10);
MSDx = zeros(t,1);
MSDy = zeros(t,1);
x0 = zeros(t,1);
y0 = zeros(t,1);
theta = zeros(t,1);

for i = 1:t
    [x, residual] = D2GaussFitRot(scan(:,:,i));
    MSDx(i) = x(3);
    MSDy(i) = x(5);
    x0(i) = x(2);
    y0(i) = x(4);
    theta(i) = x(6).*57.3;
end
handles.MSDx = MSDx;
handles.MSDy = MSDy;
figure(5)
plot(MSDx,'r','linewidth',2)
hold on
plot(MSDy,'k','linewidth',2)
plot(x0,'g','linewidth',2)
plot(y0,'b','linewidth',2)
plot(theta,'m','linewidth',2)
legend('MSDx','MSDy','x0','y0','theta','FontSize',30)
guidata(hObject, handles);