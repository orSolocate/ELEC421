%{
RAFEEF GARBI - ELEC 421 - DIGITAL SIGNAL PROCESSING - 2018
HW 3 - PROBLEM 5 - Student File
%}
clear all; close all; clc;

%% Load and display the image
Img = imread('in_the_tunnel.png');

figure;
imagesc(Img); title('Original Image - RGB'); axis image;

Img = rgb2gray(im2double(Img));

figure;
imagesc(Img); title('Original Image - Greyscale'); 
axis image; colormap gray;

%% frequency domain approach (homomorphic filtering)
% Western Australia function
% https://www.peterkovesi.com/matlabfns/index.html
newim = homomorphic(Img, 2, .25, 2, 0, 5);
figure;
imagesc(newim); 
title('Resulting Image: Homomorphic filtering'); 
axis image; colormap gray;
%%
%5.b
newim = homomorphic(Img, -2, .25, 2, 2, 10);
figure(52);
imagesc(newim); 
title('Homomorphic filtering (low frequency extraction)'); 
axis image; colormap gray;