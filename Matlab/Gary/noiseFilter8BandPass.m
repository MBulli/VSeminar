function Hd = noiseFilter8BandPass
%NOISEFILTER8BANDPASS Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.1 and the DSP System Toolbox 8.4.
% Generated on: 06-Jun-2015 19:14:35

% FIR least-squares Multiband filter designed using the FIRLS function.

% All frequency values are in Hz.
Fs = 44100;  % Sampling Frequency

N = 250;                                  % Order
W = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];  % Weight Vector

% Frequency Vector
% F = [0 650 700 900 950 1450 1500 1700 1750 2250 2300 2500 2550 3050 ...
%      3100 3300 3350 3850 3900 4100 4150 4650 4700 4900 4950 5450 5500 ...
%      5700 5750 6250 6300 6500 6550 7050 7100 7300 7350 7850 7900 8100 ...
%      8150 8650 8700 8900 8950 9450 9500 9700 9750  22050];


F = [0 770 780 820 830 1570 1580 1620 1630 2370 2380 2420 2430 3170 3180 ...
     3220 3230 3970 3980 4020 4030 4770 4780 4820 4830 5570 5580 5620 ...
     5630 6370 6380 6420 6430 7170 7180 7220 7230 7970 7980 8020 8030 ...
     8770 8780 8820 8830 9570 9580 9620 9630 22050];
 

% Amplitude Vector
A = [0 0 1 1 0 0 0.8 0.8 0 0 0.5 0.5 0 0 0.4 0.4 0 0 0.2 0.2 0 ... 
     0 0.18 0.18 0 0 0.15 0.15 0 0 0.13 0.13 0 0 0.1 0.1 0 0 0.08 0.08 0 ... 
     0 0.05 0.05 0 0 0.05 0.05 0 0];

% Calculate the coefficients using the FIRLS function.
b  = firls(N, F/(Fs/2), A, W);
Hd = dfilt.dffir(b);

% [EOF]
