%1

% xn = [1, zeros(1,98)];
% t1 = [1 1/2 1/4 1/8 1/16 1/32];
% t2 = [1 1 1 1 1];
% t3 = [1/4 1/2 1/4];
% 
% v3 = filter(t3,1,xn);
% v2 = filter(conv(t1,t2),1,xn);
% vn = v3 +v2;
% 
% t4nom = [1,1];
% t4dom = [1 -0.9, +0.81];
% v4 = filter(t4nom,t4dom,vn);
% 
% plot(1:99,v4) %just the values 1-99
% xlabel("n");
% ylabel("y(n)");
% title("Impluse response");

v1=zeros([1 99])
v1(1:5)=[1,1/2,1/8,1/16,1/32];
v2 = conv([1,1,1,1,1],v1);
t3=zeros([1 103]);
t3(1:3)=[1/4,1/2,1/4];
vn=t3+v2;
yn=filter([1 1],[1 -0.9 0.81],vn);
yn=yn(1:99);
figure(1);
plot(yn);
xlabel("n");
ylabel("y(n)");
title("Impluse response");

%%
%2.b+2.c.
load officetemp;
 % convert from 'F' to 'C'
celsius=5*(temp-32)/9;
c=celsius-mean(celsius);
t=0:1/48:5583/48;
figure(2);
subplot(2,1,1);
plot (t,c);
xlabel('DAYS');
ylabel('Temp (C)');
title("Office Temperature");
subplot(2,1,2);
[autocor,lags] = xcorr(c,60*48,'coeff');
plot(lags/48,autocor)
xlabel('Lag (days)')
ylabel('Autocorrelation')
%%
%3.a
h1=[0 0 0;1 2 1;0 0 0];
h2=[0 1 0;0 0 0;0 -1 0];
h3 = conv2(h1,h2);
%3.c.
imread('mri.tif');
figure(3);
subplot (3,1,1);
imshow(ans);
title("mri.tif");
subplot(3,1,2);
imshow(conv2(ans,h3));
title("x axis difference filter");
%3.d
h12=[0 1 0;0 2 0;0 1 0];
h13 = conv2(h1,h12);
subplot(3,1,3);
imshow(conv2(ans,h13));
title("with the 3.d filter");
%%
%4.a.
im1=imread('TheCourtesan.bmp');
im2=imread('TheHagueSchool.bmp');
hist1=colorhist(im1,256,256,256);
hist2=colorhist(im2,256,256,256);
figure(4);
subplot(2,1,1);
plot(hist1);
title("Histogram of TheCourtesan");
subplot(2,1,2);
plot(hist2);
title("Histogram of TheHagueSchool");
%%
%4.b
im1=imread('evolution.jpg');
im2=imgaussfilt(im1,[4 1]);
[dy,dx]=gradient(double(im2));
M=sqrt(dx.^2+dy.^2);
figure(45);
subplot(1,3,1);
imshow(M);
quiver(dy,dx);
title("Gradient Verctors");
subplot(1,3,2);
imshow(M);
title("Original image");
subplot(1,3,3);
M(M>=5.1)=50;
M(M<5.1)=0;
imshow(M);
title("Threshold");
%%
%5.a+5.b.
img=zeros([100 100]);
img(21:80,41:60)= (255*ones([60,20]));
figure(51);
subplot (1,2,1);
imshow(img);
title('box original position');
f_img=abs(fft2(img));
f_img=fftshift(f_img);
subplot(1,2,2);
imagesc(f_img);
title("Fourier transform of the box");
figure(52);
subplot(1,2,1);
img_rot=imrotate(img,45,'bilinear','crop');
imshow(img_rot);
title('box rotated');
subplot(1,2,2);
f_img_rot=fftshift(abs(fft2(img_rot)));
imagesc(f_img_rot);
title("Fourier transform rotated box");
figure(53);
subplot(1,2,1);
img_tran = imtranslate(img,[30 30]);
imshow(img_tran);
title('box translated');
subplot(1,2,2);
f_img_tran=fftshift(abs(fft2(img_tran)));
imagesc(f_img_tran);
title("Fourier transform translated box");
figure(54);
subplot(1,2,1);
img2=zeros([60 20]);
img2(28:32,6:15)= (255*ones([5,10]));
imshow(img2);
title('box made tinner');
subplot(1,2,2);
f_img2=fftshift(abs(fft2(img2)));
imagesc(f_img2);
title("Fourier transform tinner box");
%%
%5.c
lena=imread('lena512.bmp');
lena_fft = fft2(lena);
figure (55);
subplot(1,2,1);
imagesc(ifft2((abs(lena_fft))));
title('magnititude');
subplot(1,2,2);
imagesc(abs(ifft2(exp(1i*angle((lena_fft))))));
title('phase');
%%
%6
figure(6);
moon=imread("blurry_moon.tif");
lap_moon=del2(double(moon));
f_lap_moon=fftshift(abs(fft2(lap_moon)));
subplot(2,2,1);
imshow(lap_moon);
title("del2 of moon");
subplot(2,2,2);
imagesc(f_lap_moon);
title("del2 of original moon freq domain");
h=[0 1 0;1 -4 1; 0 1 0];
fil_moon=conv2(h,moon);
fil_lap_moon=del2(double(fil_moon));
fil_f_lap_moon=fftshift(abs(fft2(fil_lap_moon)));
subplot(2,2,3);
imshow(fil_lap_moon);
title("del2 of filtered moon");
subplot(2,2,4);
imagesc(fil_f_lap_moon);
title("del2 of filtered moon freq domain");