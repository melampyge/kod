function lpost = ch5bw(parm,y,x,n,nparam)
%calculate log weights necessary to obtain MH acceptance probabilities
%for Independence Metropolis Hastings empirical illustration --- see chapter5a.m

fgamma=zeros(n,1);
for ii = 1:2
    fgamma = fgamma + parm(ii+1,1)*(x(:,ii+1).^parm(4,1)); 
end
fgamma = fgamma.^(1/parm(4,1));
fgamma = fgamma + parm(1,1)*ones(n,1);

lpost = -.5*n*log((y - fgamma)'*(y-fgamma));






