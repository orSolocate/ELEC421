%{
RAFEEF GARBI - ELEC 421 - DIGITAL SIGNAL PROCESSING - 2018
HW 4 - PROBLEM 5 - student file
%}
clear all; close all; clc;

%% create vid
f=imresize(im2double(rgb2gray(imread('paris.jpg'))),0.5);

T=.1;%threshold change detected
nz=0.05;
frms=20;

objfrms=[...  %start and end frames for each object
1 20
3 7
5 17
1 20
1 20
];

objsize=round([...  height and width for each object as a percent of image dim
    [10 5 3 20 10]/100*size(f,1) ; ...
    [20 4 10 12 30]/100*size(f,2)...
    ])';

objx=[...   start and end x for each object, as a fraction of image dim 1
    0.7 0.2
    0.7 0.1
    0.3 0.75
    0.7 0.7
    0.85 0.85]*size(f,1);

objy=[...   start and end y for each object, as a fraction of image dim 2
    0.6 0.7
    0.3 0.7
    0.6 0.75
    0.2 0.8
    0.1 0.6]*size(f,2);

%initialize video matrix: x,y,channels (1 for grayscale, 3 for RGB), #frames
vid=zeros(size(f,1),size(f,2),1,frms);

xmov=zeros(size(objfrms,1),frms);
ymov=zeros(size(objfrms,1),frms);
for b=1:size(objfrms,1)
    xmov(b,:)=round(linspace(objx(b,1),objx(b,2),frms));
    ymov(b,:)=round(linspace(objy(b,1),objy(b,2),frms));
end

for k=1:frms
    vid(:,:,:,k)=f+nz*rand(size(f));
    for b=1:size(objfrms,1)
        if k>=objfrms(b,1) & k<=objfrms(b,2) 
            vid(xmov(b,k):xmov(b,k)+objsize(b,1)-1,...
                ymov(b,k):ymov(b,k)+objsize(b,2)-1,1,k)=...
                rand(objsize(b,:));
        end
    end
end

%% play movie
implay(vid)

%% accumulate difference
longest_run=zeros(size(f)); %initialize the longest #frames without change (for each pixel)
current_run=zeros(size(f)); %initialize the current #frames without change (for each pixel)
frm_longest_run=ones(size(f)); %(index of) the frame to represent the longest run (for each pixel)
                               %idea: we will use the pixel value from frames
                               %that were stable (did not change) for the
                               %longest time.

for k=2:frms
    % did a pixel change between consecutive frames?
    changed = abs(vid(:,:,:,k)-vid(:,:,:,k-1)) > T ; 
   
    % if no change, increase run length by 1
    %   change detected ==> run = 0
    %   no change ==> run = run + 1
    current_run = (current_run+1).*double(~changed); 
    
    % new longer run detected?
    new_longer_run = current_run > longest_run;
    
    % note: y = a*x + b*(~x) where x={0,1}
    %       y = a if x is 1; 
    %       y = b if x=0
    longest_run = longest_run.*(~new_longer_run) + current_run.*new_longer_run;
    
    % frame of longest run is 
    %       either a new frame k (if a longer run detected)
    %       or/otherwise: the old frame index stored in frm_longest_run
    frm_longest_run = frm_longest_run.*(~new_longer_run)+ k.*new_longer_run;
end

%% reconstruct the background image
recon=nan*ones(size(f)); %init same size as one of the frames
for x=1:size(f,1) % for each pixel...
    for y=1:size(f,2) %...
        %set the intensity of recon image at pixel x,y
        %to be intensity of the same pixel location
        %but in the last frame of the longest run
        recon(x,y)=vid(x,y,1,frm_longest_run(x,y));
        rec_mean(x,y)=mean(vid(x,y,1,:)); %just use the average
        rec_med(x,y)=median(vid(x,y,1,:)); %and just use the median
    end
end
figure(51)
% subplot(1,3,1)
imagesc(recon)
title("Reconstructed-logest frame background image, ");
% 
% subplot(1,3,2)
% imagesc(rec_mean)
% title("Reconstructed-mean background image");
% 
% subplot(1,3,3)
% imagesc(rec_med)
% title("Reconstructed-median background image");
axis image
colormap gray

figure(52)
% subplot(1,3,1)
imagesc(abs(f-recon))
title('MAE longest_frame')
% subplot(1,3,2)
% imagesc(abs(f-rec_mean));
% title('MAE mean');
% subplot(1,3,3)
% imagesc(abs(f-rec_med));
 axis image
 colormap gray
% title('MAE median')