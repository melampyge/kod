function [central_candidate]=getcentralcell(phi,edge_threshold,neighbor_threshold,cellarea_threshold,N)
%get the most i central cells
cord=getcentroid(phi,edge_threshold,cellarea_threshold);

m=length(cord);
[graph_matrix,binary_matrix,direction_matrix]=graphmatrix(cord,neighbor_threshold);
s=sum(graph_matrix);
sort_s=sort(s);

thresh=sort_s(N);

central_candidate=find(s<=thresh);


% for i=1:N
%     plot(cord(central_candidate(i)).Centroid(1),cord(central_candidate(i)).Centroid(2),'Color',[0,1,0],'Marker','.','MarkerSize',5);
% end
