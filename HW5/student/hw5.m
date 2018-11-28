%3.a
figure(31);
dct=dctmtx(8);
imshow(dct);
title("dct matrix");
%%
%3.c
img=imread('cameraman.tif');
img_mod=double(img)-128;
fun= @(block_struct) dct*block_struct.data*dct';
comp=blockproc(img_mod,[8 8],fun);
imagesc(comp);
colormap('gray');
axis image;
title('dct-transformed image');
%%
%4
q_levels=[10];
%q_levels=[10 100 200 300 1000];
Q=[1 1 1 2 2 2 4 4; 1 1 2 2 2 4 4 4;1 2 2 2 4 4 4 8; 2 2 2 4 4 4 8 8;2 2 4 4 4 8 8 8;2 4 4 4 8 8 8 16;4 4 4 8 8 8 16 16;4 4 8 8 8 16 16 16];

fig=1;
for q_level=q_levels  
    fun2= @(block_struct) round(block_struct.data./(q_level*Q));
    B=blockproc(comp,[8 8],fun2);
    h_g=imhist(comp);
    h_b=imhist(B);
    figure(fig);
    subplot(1,5,1);
    plot(h_g);
    title(sprintf('hist of G with q_level %d',q_level));
    subplot(1,5,2);
    plot(h_b);
    title(sprintf('hist of B with q_level %d',q_level));
    fun3= @(block_struct) block_struct.data.*(q_level*Q);
    G1=blockproc(B,[8 8],fun3);
    inverse_dct= @(block_struct) dct'*block_struct.data*dct;
    G=blockproc(G1,[8 8],inverse_dct);
    img_rec=uint8(G+128);
    subplot(1,5,3);
    imshow(img);
    title(sprintf('original image with q_level=%d',q_level));
    subplot(1,5,4);
    imshow(img_rec);
    title(sprintf('reconstructed image with q_level=%d',q_level));
    delta=abs(img-img_rec);
    subplot(1,5,5);
    imshow(delta);
    title('absolute difference');
    fig=fig+1;
end
%%
%5
ent=entropy(img_rec);
binarySig = de2bi(img_rec);
Img_rec_Len = numel(binarySig)
symbols = unique(img_rec(:));
counts = imhist(img_rec(:), 256);
p = double(counts) ./ sum(counts);
[dict,avglen] = huffmandict(symbols,p);
comp = huffmanenco(img_rec(:),dict);
bits_huffman=(comp);
binaryComp = de2bi(comp);
HuffmanLen = numel(binaryComp)
%%
%6.a
alpha=1;
[R,C]=size(img_rec);
f_prime=uint8(zeros([R,C]));
for r=1:R
    for c=2:C
        f_prime(r,c)=round(alpha*img_rec(r,c-1));             
    end
end
e=img_rec-f_prime;
figure(6);
subplot(1,2,1);
imshow(img_rec);
title('Before predictive coding');
subplot(1,2,2);
imshow(e);
title('After predictive coding');
%%
%6.b.
rec_hist=imhist(img_rec);
e_hist=imhist(e);
figure(62);
subplot(1,2,1);
plot(rec_hist);
title("plot of img_rec hist");
subplot (1,2,2);
plot(e_hist);
title("e_hist plot");
e_ent=entropy(e);
rec_ent=entropy(img_rec);

%6.c
[R,C]=size(e);
rec_pred=uint8(zeros([R,C]));
for r=1:R
    rec_pred(r,1)=e(r,1);
    for c=2:C
        rec_pred(r,c)=e(r,c)+f_prime(r,c);             
    end
end
figure(63);
subplot(1,2,1);
imshow(rec_pred);
title('reconstructed image');
diff=abs(rec_pred-img_rec);
subplot(1,2,2);
imshow(diff);
title('difference');