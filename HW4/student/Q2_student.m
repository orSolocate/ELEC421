%{
RAFEEF GARBI - ELEC 421 - DIGITAL SIGNAL PROCESSING - 2018
HW 4 - PROBLEM 2 - student file
%}
close all; clear all; clc;

%% Mathematical Model of the Motion Blur
mn=0; st=0.1;  %0 0.1 0.001

USE_PSUEDO=0; % use psuedo filter
    
%parameter T (observation time) and motion rate
T=1; a=90;ax=30; ay=40;

%reading data
%I=im2double(imread('blur.bmp'));
I=im2double(imread('cameraman.tif'));

%generating frequencies for the blurring model
u=linspace(-0.5,0.5,size(I,2));
v=linspace(-0.5,0.5,size(I,1));

[U,V]=meshgrid(u,v);
H=(T./(pi*U*ax)).*sin(pi*U*ax).*exp(-1i*pi*U*ax);
%H=(T./(pi*(U*ax+V*ay))).*sin(pi*(U*ax+V*ay)).*exp(-1i*pi*(U*ax+V*ay));
%surf(abs(H),'EdgeColor','none');

%% Applying Motion Blur
% filtering in f domain
I_f=fft2(I);
I_motion_f=fftshift(I_f).*H;

%if you want to add noise to degradation
N=mn+st*randn(size(I));
N_f=fft2(N);
I_motion_fn=I_motion_f+N_f;

figure;
subplot(1,3,1), imagesc(I), colormap(gray)
title('original image')

%back to spatial domain
I_motion_n=ifft2(ifftshift(I_motion_fn));
subplot(1,3,2); imagesc(abs(I_motion_n))
title('image after degradation')

%% Reconstruction
%InvFilt = 1./H; %for 2: a-d
InvFilt= (1./H).*(abs(H).*abs(H))./((abs(H).*abs(H))+st);
if USE_PSUEDO
    threshold = 0.01;
    InvFilt(abs(H)<threshold)=0;
end

%my addition
%I_f=fft2(I);
%I_motion_fn=fftshift(I_f);
%
I_recon_fn=I_motion_fn.*InvFilt;

I_recon=ifft2(ifftshift(I_recon_fn));
subplot(1,3,3),
imagesc(abs(I_recon))
colormap gray;
title('reconstruction wiener filter of blur.bmp')