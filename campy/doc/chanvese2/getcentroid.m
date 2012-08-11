function [cordnew]=getcentroid(phi,alpha,cellarea_threshold)

[ny,nx]=size(phi);

for i=1:ny
    for j=1:nx
        if phi(i,j)<0
            J(i,j)=0;
        else
            J(i,j)=255;
        end
    end
end
%colormap([1 0 0])
%imshow(J);

BW = edge(J,'canny',[],alpha,'nothinning'); %Edge Transformation

%figure,imshow(BW);


cord=regionprops(bwlabeln(BW),'pixellist','PixelIdxList', 'BoundingBox','area','ConvexArea','EulerNumber','ConvexHull','Extrema','centroid','Solidity','Extent','EquivDiamete','Perimeter','MajorAxisLength', 'MinorAxisLength','Orientation','FilledArea');

m=length(cord);
j=1;


for ii=1:m
    for jj=1:m
        graph_matrix(ii,jj)=sqrt((cord(ii).Centroid(1)-cord(jj).Centroid(1))^2+(cord(ii).Centroid(2)-cord(jj).Centroid(2))^2);
    end
end

for iii=1:m
   temp=sort(graph_matrix(iii,:));
   lengthsum(iii)=temp(1)+temp(2)+temp(3)+temp(4)+temp(5)+temp(6);
end
   
    
for i=1:m
    if (cord(i).BoundingBox(3)>cellarea_threshold)&&(cord(i).BoundingBox(4)>cellarea_threshold)&&(cord(i).BoundingBox(3)<70)&&(cord(i).BoundingBox(4)<70)&&(lengthsum(i)<220)&&(cord(i).MinorAxisLength>10)
        cordnew(j)=cord(i);
        j=j+1;
    else
        j=j;
    end
end

m_new=length(cordnew);
for i=1:m_new
    x(i)=cordnew(i).Centroid(1);
    y(i)=cordnew(i).Centroid(2);
end

peripheral=convhull(x,y,{'Qt','Pp'});

j=1;
for i=1:m_new
    aa=find(peripheral==i);
    if isempty(aa)==1
        cordnew2(j)=cordnew(i);
        j=j+1;
    else
        j=j;
    end
end


