function varargout = two_axes(varargin)
% TWO_AXES Application M-file for two_axes.fig
%   TWO_AXES, by itself, creates a new TWO_AXES or raises the existing
%   singleton*.
%
%   H = TWO_AXES returns the handle to a new TWO_AXES or the handle to
%   the existing singleton*.
%
%   TWO_AXES('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in TWO_AXES.M with the given input arguments.
%
%   TWO_AXES('Property','Value',...) creates a new TWO_AXES or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before two_axes_OpeningFunction gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to two_axes_OpeningFcn via varargin.
%
%   *See GUI Options - GUI allows only one instance to run (singleton).
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help two_axes

% Copyright 2001-2006 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 10-Jun-2015 02:13:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',          mfilename, ...
                   'gui_Singleton',     gui_Singleton, ...
                   'gui_OpeningFcn',    @two_axes_OpeningFcn, ...
                   'gui_OutputFcn',     @two_axes_OutputFcn, ...
                   'gui_LayoutFcn',     [], ...
                   'gui_Callback',      []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before two_axes is made visible.
function two_axes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to two_axes (see VARARGIN)

% Choose default command line output for two_axes
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes two_axes wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = two_axes_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function plot_button_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatePlot(handles);


function f1_input_Callback(hObject, eventdata, handles)
% hObject    handle to f1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f1_input as text
%        str2double(get(hObject,'String')) returns contents of f1_input
%        as a double

% Validate that the text in the f1 field converts to a real number
f1 = str2double(get(hObject,'String'));
if isnan(f1) || ~isreal(f1)  
    % isdouble returns NaN for non-numbers and f1 cannot be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Cannot plot f1')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
    updatePlot(handles);
end


function f2_input_Callback(hObject, eventdata, handles)
% hObject    handle to f2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f1_input as text
%        str2double(get(hObject,'String')) returns contents of f1_input
%        as a double

% Validate that the text in the f2 field converts to a real number
f2 = str2double(get(hObject,'String'));
if isnan(f2) ...          % isdouble returns NaN for non-numbers
        || ~isreal(f2)    % f1 should not be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Cannot plot f2')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
    updatePlot(handles);
end

function I_input_Callback(hObject, eventdata, handles)
% hObject    handle to I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of I_input as text
%        str2double(get(hObject,'String')) returns contents of I_input as a double
% Validate that the text in the I field converts to a real number
modI = str2double(get(hObject,'String'));
if isnan(modI) ...          % isdouble returns NaN for non-numbers
        || ~isreal(modI)    % f1 should not be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Cannot plot f2')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
    updatePlot(handles);
end

function t_input_Callback(hObject, eventdata, handles)
% hObject    handle to t_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_input as text
%        str2double(get(hObject,'String')) returns contents of t_input
%        as a double

% Test that the time vector is not too large, is not scalar, 
% and increases monotonically. First fail if EVAL cannot parse it. 

% Disable the Plot button ... until proven innocent
set(handles.plot_button,'Enable','off') 
try
    t = eval(get(handles.t_input,'String'));
    if ~isnumeric(t)
        % t is not a number
        set(handles.plot_button,'String','t is not numeric')
    elseif length(t) < 2
        % t is not a vector
        set(handles.plot_button,'String','t must be vector')
    elseif length(t) > 10000
        % t is too long a vector to plot clearly
        set(handles.plot_button,'String','t is too long')
    elseif min(diff(t)) < 0
        % t is not monotonically increasing
        set(handles.plot_button,'String','t must increase')
    else
        % All OK; Enable the Plot button with its original name
        set(handles.plot_button,'String','Plot')
        set(handles.plot_button,'Enable','on')
        updatePlot(handles);
        return
    end
    % Found an input error other than a bad expression
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
 catch EM
    % Cannot evaluate expression user typed
    set(handles.plot_button,'String','Cannot plot t')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
end




% --- Executes during object creation, after setting all properties.
function I_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatePlot(handles);

fc = str2double(get(handles.f1_input,'String'));
fm = str2double(get(handles.f2_input,'String'));
I  = str2double(get(handles.I_input, 'String'));
t  = 0:1/44100:1;

% Calculate data
x = sin(2*pi*fc*t + I*sin(2*pi*fm*t));
sound(x, 44100);



function updatePlot(handles)
% Get user input from GUI
fc = str2double(get(handles.f1_input,'String'));
fm = str2double(get(handles.f2_input,'String'));
I  = str2double(get(handles.I_input, 'String'));
t = eval(get(handles.t_input,'String'));

% Calculate data
x = sin(2*pi*fc*t + I*sin(2*pi*fm*t));
y = fft(x,512);
m = y.*conj(y)/512;
f = 1000*(0:256)/512;

% Create frequency plot in proper axes
plot(handles.frequency_axes,f,m(1:257))
set(handles.frequency_axes,'XMinorTick','on')
grid on

% Create time plot in proper axes
plot(handles.time_axes,t,x)
set(handles.time_axes,'XMinorTick','on')
grid on

% Create carrier sinus plot
sinFC=sin(2*pi*fc*t);
plot(handles.sinFC_axes,t,sinFC)
set(handles.sinFC_axes,'XTick',[])
set(handles.sinFC_axes,'XMinorTick','on')
grid on

% Create modulation sinus plot
sinFM=sin(2*pi*fm*t);
plot(handles.sinFM_axes, t,sinFM)
set(handles.sinFM_axes,'XMinorTick','on')
grid on

