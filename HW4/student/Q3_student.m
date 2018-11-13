%{
RAFEEF GARBI - ELEC 421 - DIGITAL SIGNAL PROCESSING - 2018
HW 4 - PROBLEM 3 - student file
Requires: dftuv.m, lpfilter.m, notch.m
%}
close all; clear all; clc;

%% Loading the image and computing the FFT
A = im2double(imread('halftone.png'));

figure; imshow(A);
title('Original Image');
F = fftshift(fft2(A));
mag = abs(F); %magnititude of Freq domain of the image

%%
ratio = 0.0103; % The ratio of data we want to notch-out
mask = mag > ratio*max(mag(:)); % we will keep any that satisfies [ratio< mag/MAX(mag)]
mask = bwmorph(mask,'dilate',2); % dilate the binary mask 2 times
mask = bwmorph(mask,'shrink',100); % shrink the image with n=100
mask(size(F,1)/2+1,size(F,2)/2+1) = 0; %0-out the middle value - THE VALUE WE WANT TO KEEP

%%
rad =20; % the radius we want to cutoff each frequency
[x,y] = find(double(mask)); % return the locations of the '1' values in mask
F2 = F;

for i=1:size(x,1)
    H = notch('btw',size(F,1),size(F,2),rad,y(i),x(i)); % cuts off frequancies in radious `rad` at position (x,y)
    F2 = F2.*H;
end

figure; imshow(log(abs(F)),[]);
title('');
figure; imshow(log(abs(F2)),[]);
title('');
figure; imshow(real(ifft2(ifftshift(F2))));
title('Resulting Image');