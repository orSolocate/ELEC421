%{
RAFEEF GARBI - ELEC 421 - DIGITAL SIGNAL PROCESSING - 2018
HW 3 - PROBLEM 4 - Student File
%}
close all; clear all; clc; 

%% Load sound
[x, fs] = audioread('bird.wav');
sound(x,fs);
%% Adding noise
sigma = .2;
xn = x + randn(size(x))*sigma;

%% STFT
w = 512;%4.a - the larger the window is the more resolution we have in frequancy
%and the less we have in time and vice versa).
% and q is the distance between windows.
q = w/2;
options.n = length(x);
st = perform_stft(x,w,q,options);
figure; imagesc(log(abs(st)));
stn = perform_stft(xn,w,q,options);
figure; imagesc(log(abs(stn)));

%% Denoise
stnt = perform_thresholding(stn, 2*sigma, 'hard');
figure; imagesc(log(abs(stnt)));

%my code
stnt_time=perform_stft(stnt,w,q,options);
sound(stnt_time,fs);
%4.b - We can hear less background noises
%%
%4.c
options.block_size=1;
stnt = perform_thresholding(stn, 2*sigma, 'block',options);
stnt_time=perform_stft(stnt,w,q,options);
figure; imagesc(log(abs(stnt)));
sound(stnt_time,fs);