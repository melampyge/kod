function lweight = ch5aw(parm,amean,acapvinv,adof,y,x,n,nparam)
%calculate log weights necessary to obtain MH acceptance probabilities
%for Independence Metropolis Hastings empirical illustration --- see chapter5a.m


lcanden=-.5*(adof+nparam)*log(adof+(parm-amean)'*acapvinv*(parm-amean));

%specify f(.) as CES form used in empirical illustration
%uses 2 input prices

fgamma=zeros(n,1);
for ii = 1:2
    fgamma = fgamma + parm(ii+1,1)*(x(:,ii+1).^parm(4,1)); 
end
fgamma = fgamma.^(1/parm(4,1));
fgamma = fgamma + parm(1,1)*ones(n,1);

lpost = -.5*n*log((y - fgamma)'*(y-fgamma));
lweight = lpost - lcanden;





