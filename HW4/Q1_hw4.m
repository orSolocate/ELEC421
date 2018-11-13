%Q1
l=imread('lena512.bmp');
figure(1);
%subplot(1,2,1);
imshow(l);
title("Lena original image");

L=fftshift((fft2(l)));
rows=size(L,1);
cols=size(L,2);
filter=ones(rows,cols);

orig_power=sum(sum(abs(L).*abs(L)));
rad=1.8; %30 for 0.5%  9 for 2%  4.6 for 3.6%, 3 for 5.4%  1.8 for 8%
for i=1:rows
    for j=1:rows
        if (sqrt((i-rows/2)^2+(j-cols/2))>rad)
            filter(i,j)=0;
        end
    end
end

L=L.*filter;
power=sum(sum(abs(L).*abs(L)));
perc=power/orig_power*100;
restored=ifft2(ifftshift((L)));
%subplot(1,2,2);
imagesc(abs(restored));
title("filter 8%")
colormap 'gray'