function varargout = mccv_gui(varargin)
%      MCCV_GUI M-file for mccv_gui.fig
%      GUI for pricing Arithmetic average Asian Call option
%      This example tells how to use Monte carlo method for pricing Arithmetic Average 
%      Asian Fixed strike Call option and how to improve the confidence interval 
%      by using control variate .In the case of pricing the arithmetic Asian option
%      which does not have an analytical formula, I use as a control variate the 
%      Geometric Asian option which has an analytical formula.
%      MCCV_GUI, by itself, creates a new MCCV_GUI or raises the existing
%      singleton*.
%
%      H = MCCV_GUI returns the handle to a new MCCV_GUI or the handle to
%      the existing singleton*.
%
%      MCCV_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCCV_GUI.M with the given input arguments.
%
%      MCCV_GUI('Property','Value',...) creates a new MCCV_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mccv_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mccv_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help mccv_gui

% Last Modified by GUIDE v2.5 01-Jun-2008 21:31:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mccv_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @mccv_gui_OutputFcn, ...
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


% --- Executes just before mccv_gui is made visible.
function mccv_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mccv_gui (see VARARGIN)

%Create the data to plot
%handles.r_edit = 1000

% Choose default command line output for mccv_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mccv_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = mccv_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Run_pushbutton.
function Run_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Run_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%r_edit_str = get(edit,'style',edit,'r_edit,'string') ;
%set(handles.Strike_edit,'String',1000)
S0 = str2double(get(handles.so_edit,'String'));
K = str2double(get(handles.Strike_edit,'String'));
r = str2double(get(handles.r_edit,'String'));
T = str2double(get(handles.Time_edit,'String'));
vol = str2double(get(handles.vol_edit,'String'));
Simu = str2double(get(handles.Simu_edit,'String'));
[Price_AM,CI_AM,Price,CI] = asiancall_mc_cv(S0,K,r,T,vol,Simu);

set(handles.pam_edit,'String',Price_AM)
set(handles.ciam_edit,'String',CI_AM)
set(handles.pgm_edit,'String',Price)
set(handles.cigm_edit,'String',CI)
% Choose default command line output for mccv_gui

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);





% --- Executes on button press in price_pushbutton.
function price_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to price_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


S0 = str2double(get(handles.so_edit,'String'));
K = str2double(get(handles.Strike_edit,'String'));
r = str2double(get(handles.r_edit,'String'));
T = str2double(get(handles.Time_edit,'String'));
vol = str2double(get(handles.vol_edit,'String'));
Simu = str2double(get(handles.Simu_edit,'String'));
mult = str2double(get(handles.endsim_edit,'String'));

cia = zeros(6,2);
cig = zeros(6,2);

for n = 1:mult
    simulation(n) = 1000*n;
    Simu= simulation(n);
    t = cputime;
    [Price_AM,CI_AM,Price,CI] = asiancall_mc_cv(S0,K,r,T,vol,Simu);
    pa(n) = Price_AM;
    cia(n,1) = CI_AM(1,1);
    cia(n,2) = CI_AM(1,2);
    pg(n)= Price;
    cig(n,1) = CI(1,1);
    cig(n,2) = CI(1,2);
    localtime(n)= cputime -t;
end

title('Monte Carlo control variate')
plot3(handles.Price_axes,simulation,pa,localtime,simulation,pg,localtime);
legend('AM','GM')
xlabel('simu')
ylabel('price')
zlabel('time')
grid on

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);





