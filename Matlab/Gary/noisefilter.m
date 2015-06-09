function Hd = noisefilter
%NOISEFILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.1 and the DSP System Toolbox 8.4.
% Generated on: 03-Jun-2015 15:40:17

% Butterworth Lowpass filter designed using FDESIGN.LOWPASS.

% All frequency values are in Hz.
Fs = 44100;  % Sampling Frequency

N  = 2;     % Order
Fc = 5000;  % Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter');

% [EOF]