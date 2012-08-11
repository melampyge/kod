function [correspondence]=cell_tracking2(phi1,phi2,correspondence1,edge_threshold1,edge_threshold2,neighbor_threshold,cellarea_threshold1,cellarea_threshold2)

[ind_1,ind_2]=find(correspondence1==1);
l=length(ind_1);
count1=0;
count2=0;

cord1=getcentroid(phi1,edge_threshold1,cellarea_threshold1);
[graph_matrix1,binary_matrix1,direction_matrix1]=graphmatrix(cord1,neighbor_threshold);
m1=size(graph_matrix1);

cord2=getcentroid(phi2,edge_threshold2,cellarea_threshold2);
[graph_matrix2,binary_matrix2,direction_matrix2]=graphmatrix(cord2,neighbor_threshold);
m2=size(graph_matrix2);


correspondence=correspondence1;

%%

for k=1:l

    index1=ind_1(k);
    index2=ind_2(k);

    adjacent_distance1=direction_matrix1(index1,:);%adjacent cells
    adjacent_direction1=binary_matrix1(index1,:);

    adjacent_distance2=direction_matrix2(index2,:);%adjacent cells
    adjacent_direction2=binary_matrix2(index2,:);

    index_1=find(adjacent_distance1>0);
    [m11,n1]=size(index_1);
    sorted_direction1=fliplr(sort(adjacent_direction1));

    index_2=find(adjacent_distance2>0);
    [m22,n2]=size(index_2);
    sorted_direction2=fliplr(sort(adjacent_direction2));

    for i=1:n1
        for j=1:n2
            a=find(adjacent_direction1==sorted_direction1(i));%index1
            b=find(adjacent_direction2==sorted_direction2(j));%index2
            if correspondence(:,b)==0
                if correspondence(a,:)==0
                    if (abs(adjacent_distance1(a)-adjacent_distance2(b))/adjacent_distance1(a)<0.1)&&(abs(adjacent_direction1(a)-adjacent_direction2(b))<10)

                        if (abs(adjacent_distance1(a)-adjacent_distance2(b))/adjacent_distance1(a)<0.05)&&(abs(adjacent_direction1(a)-adjacent_direction2(b))<5)&&(abs(cord1(a).Area-cord2(b).Area)<=30)
                            correspondence(a,b)=1;
                        elseif abs(cord1(a).Area-cord2(b).Area)>14
                            shift1=cord2(index2).Centroid(1)-cord1(index1).Centroid(1);
                            shift2=cord2(index2).Centroid(2)-cord1(index1).Centroid(2);
                            newposition1=cord1(a).Centroid(1)+shift1;
                            newposition2=cord1(a).Centroid(2)+shift2;
                            [k1,k2]=find(direction_matrix2(b,:)>0);
                            len=length(k1);
                            diff=zeros(1,len);

                            for iii=1:len
                                diff(iii)=sqrt((cord2(k2(iii)).Centroid(1)-newposition1)^2+(cord2(k2(iii)).Centroid(2)-newposition2)^2);
                            end

                            min_diff=min(diff);

                            if (min_diff>10)&&(min_diff<25) %%%%%
                                [k3,k4]=find(diff==min_diff);
                                c=k2(k4);%% new cell candidate
                                centralposition1=(cord2(b).Centroid(1)+cord2(c).Centroid(1))/2;
                                centralposition2=(cord2(b).Centroid(2)+cord2(c).Centroid(2))/2;
                                distance=sqrt((centralposition1-newposition1)^2+(centralposition2-newposition2)^2);

                                if correspondence(:,c)==0
                                    if (abs(cord2(b).Area+cord2(c).Area-cord1(a).Area)<30)&&(sqrt((cord2(b).Centroid(1)-cord2(c).Centroid(1))^2+(cord2(b).Centroid(2)-cord2(c).Centroid(2))^2)<30)&&(distance<5);
                                        correspondence(a,c)=2;
                                        correspondence(a,b)=2;
                                    else
                                    end
                                else
                                end
                            else
                            end
                        else
                        end
                    else
                    end
                else
                end
            else
            end
        end
    end
end