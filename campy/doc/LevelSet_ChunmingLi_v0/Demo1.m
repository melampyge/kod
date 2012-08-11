% This Matlab file demomstrates the level set method in Li et al's paper
%    "Level Set Evolution Without Re-initialization: A New Variational Formulation"
%    in Proceedings of CVPR'05, vol. 1, pp. 430-436.
% Author: Chunming Li, all rights reserved.
% E-mail: li_chunming@hotmail.com
% URL:  http://www.engr.uconn.edu/~cmli/

clear all;
close all;
Img = imread('twocells.bmp');  % The same cell image in the paper is used here
Img=double(Img(:,:,1));
sigma=1.5;    % scale parameter in Gaussian kernel for smoothing.
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(Img,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.

epsilon=1.5; % the papramater in the definition of smoothed Dirac function

timestep=5;  % time step
mu=0.2/timestep;  % coefficient of the internal (penalizing) energy term P(\phi)
          % Note: the product timestep*mu must be less than 0.25 for stability!

lambda=5; % coefficient of the weighted length term Lg(\phi)
alf=1.5;  % coefficient of the weighted area term Ag(\phi);
          % Note: Choose a positive(negative) alf if the initial contour is outside(inside) the object.


% define initial level set function (LSF) as -c0, 0, c0 at points outside, on
% the boundary, and inside of a region R, respectively.
[nrow, ncol]=size(Img);  
c0=4;   
initialLSF=c0*ones(nrow,ncol);
w=8;
initialLSF(w+1:end-w, w+1:end-w)=0;  % zero level set is on the boundary of R. 
                                     % Note: this can be commented out. The intial LSF does NOT necessarily need a zero level set.
                                     
initialLSF(w+2:end-w-1, w+2: end-w-1)=-c0; % negative constant -c0 inside of R, postive constant c0 outside of R.
u=initialLSF;
figure;imagesc(Img);colormap(gray);hold on;
[c,h] = contour(u,[0 0],'r');                          
title('Initial contour');

% start level set evolution
for n=1:300
    u=EVOLUTION(u, g ,lambda, mu, alf, epsilon, timestep, 1);     
    if mod(n,20)==0
        pause(0.001);
        imagesc(Img);colormap(gray);hold on;
        [c,h] = contour(u,[0 0],'r'); 
        iterNum=[num2str(n), ' iterations'];        
        title(iterNum);
        hold off;
    end
end
imagesc(Img);colormap(gray);hold on;
[c,h] = contour(u,[0 0],'r'); 
totalIterNum=[num2str(n), ' iterations'];  
title(['Final contour, ', totalIterNum]);
