function [phi]=levelsetsegmentation(input_image);

sigma=20;
img=imread(input_image);
tic

I=img(:,:,1);
% figure,imshow(I);
II=medfilt2(I,[3,3]);
%figure,imshow(II);
III=imfilter(II,fspecial('gaussian'));

IIII=imfilter(III,fspecial('unsharp',1));
%figure,imshow(IIII);
%II=histeq(imfilter(medfilt2(I,[3,3]),fspecial('average',3)));

[ c, s] =wavedec2 (III, 2, 'sym4'); 
len = length ( c) ; 
for I = 1: len 
if ( c ( I ) > 200) % default 350
c ( I ) = 23 *c ( I ) ; 
else 
c ( I ) = 0.53* c ( I ) ; 
end 
end 
nx =waverec2 ( c, s, 'sym4') ; 

g=double(nx);
figure,imshow(g,[]);hold on

[ny,nx]=size(g);
hx=1/nx;hy=1/ny;h=hx;

phi=zeros(nx,ny);
[phi]=Initial2(phi,3);
%contour(phi, [0 0], 'b'); hold on

for i=1:10
    [phi]=ChanVeseImp(phi,g);
    [phi]=ReInitializeOrd1Damped(phi,2);
end

contour(phi,[0 0],'r'); hold on

toc