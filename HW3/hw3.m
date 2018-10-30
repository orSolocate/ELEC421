%1.a
a=0.8;
w=0:0.01:2*pi;
X=(1-a^2)./(1-2*a.*cos(w)+a^2);
plot (w,X);
xlabel("w");
ylabel("X(w)");

%%
%1.b+c
N=20;
w=0:2*pi/N:2*pi;
X2=(1-a^2)./(1-2*a.*cos(w)+a^2);
subplot (1,2,1);
plot(w,X2);
xlabel('frequancy');
ylabel('X2(w)');
title("X(w) when: N=20");

subplot (1,2,2);
N=100;
w=0:2*pi/N:2*pi;
X3=(1-a^2)./(1-2*a.*cos(w)+a^2);
plot(w,X3);
xlabel('frequancy');
ylabel('X3(w)');
title("X(w) when:N=100");
%%
%1.e.
origin=abs(ifft(X));
n20=abs(ifft(X2));
figure(15);
subplot(1,2,1);
plot(origin);
title('original x(n)');
xlabel('n - time');
ylabel("X(n)");
xlim([0 20]);
subplot(1,2,2);
plot (n20);
xlim([0 20]);
title('reconstructed from DFT when N=20, x(n)');
xlabel('n - time');
ylabel("X(n)");
%%
%2.a
f1=1/18;
f2=5/128;
fc=50/128;
n=0:1:255;
xn=cos(2*pi*f1*n)+cos(2*pi*f2*n);
xc=cos(2*pi*fc*n);
xam=xn.*xc;
figure(2);
subplot (1,3,1);
plot(xn);
xlabel("n");
ylabel("x(n)");
title("plot of x(n)");
subplot (1,3,2);
plot(xc);
xlabel("n");
ylabel("xc(n)");
title("plot of xc");
subplot (1,3,3);
plot(xam);
xlabel("n");
ylabel("xam(n)");
title("plot of xam");
%%
%2.b+c+d
figure(21);
subplot(1,3,1);
Xam=fft(xam,128);
plot(fftshift(abs(Xam)));
title("N=128");
subplot(1,3,2);
n=0:1:99;
xn=cos(2*pi*f1*n)+cos(2*pi*f2*n);
xc=cos(2*pi*fc*n);
xam=xn.*xc;
Xam=fft(xam,128);
plot(fftshift(abs(Xam)));
title("N=128 when only 100 indices");
subplot(1,3,3);
n=0:1:179;
xn=cos(2*pi*f1*n)+cos(2*pi*f2*n);
xc=cos(2*pi*fc*n);
xam=xn.*xc;
Xam=fft(xam,256);
plot(fftshift(abs(Xam)));
title("N=256 when only 180 indices");
%%
%3
figure(3);
img=imread('peppers.png');
subplot (1,3,1);
converted_img=rgb2ycbcr(img);
imshow(img);
title("origin");
title("converted");
d_sam=imresize(converted_img,0.25,'bilinear');
mod_Y=imresize(d_sam(:,:,1),4,'bilinear');
mse = immse(mod_Y,converted_img(:,:,1));
mse; %report mse
mod_img=cat(3,imresize(d_sam(:,:,1),4,'bilinear'),converted_img(:,:,2),converted_img(:,:,3));
mod_rgb=ycbcr2rgb(mod_img);
subplot(1,3,2);
imshow(mod_rgb);
title('Luma resample');

mod_cb=imresize(d_sam(:,:,2),4,'bilinear');
mod_cr=imresize(d_sam(:,:,3),4,'bilinear');
mse_cb = immse(mod_cb,converted_img(:,:,2));
mse_cr= immse(mod_cr,converted_img(:,:,3));
mse_cb;mse_cr; %reporting!
mod_img=cat(3,converted_img(:,:,1),mod_cb,mod_cr);
mod_rgb=ycbcr2rgb(mod_img);
subplot(1,3,3);
imshow(mod_rgb);
title('Cb+Cr resample');

%3.c whene compressing, we should compress the Cb and Cr channels as they
%dont really effect the image. the Y chaneel downsampling effects the
%sharpness of the image and we rather keep it as it is.

%4.a - the larger the window is the more resolution we have in frequancy
%and the less we have in time and vice versa).
% and q is the distance between windows.

%%
%5.b
im=imread('in_the_tunnel.png');
im= rgb2gray(im2double(im));
[rows,cols] = size(im); 
im = normalise(im);                  
FFTlogIm = fft2(log(im+.01));
h = highboostfilter([rows cols], 0.2, 2,0.5);
FFTlogIm=reshape(FFTlogIm,[rows,cols]);
him = exp(real(ifft2(FFTlogIm.*h)));
