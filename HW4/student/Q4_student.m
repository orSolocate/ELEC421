%{
RAFEEF GARBI - ELEC 421 - DIGITAL SIGNAL PROCESSING - 2018
HW 4 - PROBLEM 4 - student file
%}
clear all; close all; clc;

%%
pltstp=100; % the distance between each moving point in the polar plot
%maxAngRange=0:10:720; %Total spin angle (and how much to rotate every spin)
maxAngRange=0:-10:-720;
%A=uint8(255*checkerboard(16));
A=imread('swirled.bmp');
subplot(131); imshow(A);

%%
%Mid point of the image
midr=ceil(size(A,1)/2); % rows increase downwards
midc=ceil(size(A,2)/2); % columns increase to the right

hold on
plot(midc,midr,'r.','markersize',20);
text(midc+3,midr+3,'origin','FontSize',20,'color',[1 0 0]);
nRows=size(A,1);
nCols=size(A,2);

%%
[r,c]=ndgrid(1:nRows,1:nCols);
x=c-midc;
y=midr-r;

%%
[th,rho]=cart2pol(x,y);

for maxAngDeg=maxAngRange,    
    maxRho=max(rho(:));
    maxAng=maxAngDeg*pi/180;
    
    th2=th+(rho/maxRho)*maxAng;        
    rho2=rho;
    
    subplot(132);hold off
    polar(th2(1:pltstp:end),rho2(1:pltstp:end),'go')
    
    [x2,y2]=pol2cart(th2,rho2);
    
    c2=x2+midc;
    r2=midr-y2;
    
    %
    B=uint8(zeros(size(A)));
    for r=1:nRows, %go through all the rows
        for c=1:nCols, %and columns... and then round the numbers  with values between [1<->nRows,1<->nCols]
            if r2(r,c)>=1 && r2(r,c)<=nRows && ...
                    c2(r,c)>=1 && c2(r,c)<=nCols,                
                
                
                B(r,c,:)=A(round(r2(r,c)),round(c2(r,c)),:);
            end
        end
    end   
    subplot(133)
    imshow(B);
    % set bacground of image to white
    set(gcf,'Color',[1 1 1]);
    
    pause(0.01)
end