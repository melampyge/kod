function b = norden(amean,avar,alower,aupper,inc)
%for univariate normal with mean=amean and var=avar
%create a grid with points inc apart between upper and lower bounds
%then evaluate the Normal density at the grid
%output matrix b which contains grid in first column
%and normal density in second

grid=(alower:inc:aupper)';

dens = (1/sqrt(2*pi*avar))*exp(-((grid-amean).^2)/(2*avar));
b = [grid dens];



