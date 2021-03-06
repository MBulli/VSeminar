function Hd = noisefilterHigh
%NOISEFILTERHIGH Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.1 and the DSP System Toolbox 8.4.
% Generated on: 03-Jun-2015 15:58:50

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 44100;  % Sampling Frequency

N   =4;      % Order
Fc1 = 11200;  % First Cutoff Frequency
Fc2 = 12200;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

% [EOF]
