function [correspondence]=centralcell_trackingn(phi1,phi2,edge_threshold1,edge_threshold2,neighbor_threshold,cellarea_threshold1,cellarea_threshold2)
%i,j are the correspondence central cell index in phi1 and phi2


eps=10e-9;

cord1=getcentroid(phi1,edge_threshold1,cellarea_threshold1);
[graph_matrix1,edge_matrix1,direction_matrix1]=graphmatrix(cord1,neighbor_threshold);
m11=size(graph_matrix1);

cord2=getcentroid(phi2,edge_threshold2,cellarea_threshold2);
[graph_matrix2,edge_matrix2,direction_matrix2]=graphmatrix(cord2,neighbor_threshold);
m22=size(graph_matrix2);


[n1,m1]=size(cord1);
[n2,m2]=size(cord2);


for i=1:m1
    for j=1:m2
    sorted1=fliplr(sort(direction_matrix1(i,:)));
    sorted1_m=sorted1(1:8)+eps;
    sorted2=fliplr(sort(direction_matrix2(j,:)));
    sorted2_m=sorted2(1:8)+eps;
    sorted3=fliplr(sort(edge_matrix1(i,:)));
    sorted3_m=sorted3(1:8)+eps;
    sorted4=fliplr(sort(edge_matrix2(j,:)));
    sorted4_m=sorted4(1:8)+eps;
    distance_diff=((cord1(i).Centroid(1)-cord2(j).Centroid(1))^2+(cord1(i).Centroid(2)-cord2(j).Centroid(2))^2)/2500;
    d1=sum(abs(sorted1_m-sorted2_m).^2./sorted1_m.^2);
    d2=sum(abs(sorted3_m-sorted4_m).^2./sorted3_m.^2);
    cord1(i).Area;
    N_difference_area=abs(cord1(i).Area-cord2(j).Area)/150;
   %diff(i,j)=0.7*d1+0.2*d2+distance_diff+0.2*N_difference_area;
    diff(i,j)=0.7*d1+0.2*d2+0.2*N_difference_area;
%     diff(i,j)=0.7*d1+0.2*d2;
%    diff(i,j)=d1;
      %diff(i,j)=d2;
     % diff(i,j)=distance_diff;
    end
end

correspondence=zeros(m11,m22);

minimum=min(diff);
sorted_minimum=sort(minimum);
sorted_5=sorted_minimum(1:1);

for i=1:1
    [p,q]=find(diff==sorted_5(i));
    correspondence(p,q)=1;
end


cord1=getcentroid(phi1,edge_threshold1,cellarea_threshold1);
%plot(cord1(i).Centroid(1),cord1(i).Centroid(2),'Color',[0,0,1],'Marker','.','MarkerSize',30);
cord2=getcentroid(phi2,edge_threshold2,cellarea_threshold2);
%plot(cord2(j).Centroid(1),cord2(j).Centroid(2),'Color',[0,0,1],'Marker','.','MarkerSize',30);
 
 
