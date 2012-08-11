function b = tdensity(amean,acapv,adof,alower,aupper,inc)
%for univariate t with arguments amean, acapv and adof 
%create a grid with points inc apart between upper and lower bounds
%then evaluate the t density at the grid
%output matrix b which contains grid in first column
%and normal density in second

grid=(alower:inc:aupper)';

lintcon=.5*log(acapv)-.5*adof*log(adof)+.5*log(pi)+gammaln(.5*adof)...
    -gammaln(.5*(adof+1));
dens = -.5*(adof+1)*log(adof+((grid-amean).^2)./acapv)-lintcon;
dens=exp(dens);
b = [grid dens];



