function lpost = ch5post(parm,y,x,n);
%Evaluate the log of the marginal posterior for parmma at a point
%for empirical illustration in Chapter 5

%specify f(.) as CES form used in empirical illustration
%uses 2 input prices

fgamma=zeros(n,1);
for ii = 1:2
    fgamma = fgamma + parm(ii+1,1)*(x(:,ii+1).^parm(4,1)); 
end
fgamma = fgamma.^(1/parm(4,1));
fgamma = fgamma + parm(1,1)*ones(n,1);

%Ignoring non-essential constants, evaluate negative of log-posterior

lpost = .5*n*log((y - fgamma)'*(y-fgamma));


