%Calculate posterior mode and Hessian at mode for 
%chapter 5 empirical illustrations
%These are later used as input for Metropolis-Hastings

%feed in a data set
load ch5data.out;
output = ch5data(:,1);
lab=ch5data(:,2);
cap=ch5data(:,3);
n=size(output,1);
x = [ones(n,1) lab cap];
y=output;
k=3;

%OLS estimates
bols = inv(x'*x)*x'*y;
s2 = (y-x*bols)'*(y-x*bols)/(n-k);
sse=(n-k)*s2;
bolscov = s2*inv(x'*x);
bolssd=zeros(k,1);
for i = 1:k
bolssd(i,1)=sqrt(bolscov(i,i));
end


%Now do optimization using LeSage's frpr_min 
%see LeSage's Toolbox for more details
nparam=k+1;
parm = ones(nparam,1);
parm(1:k,1)=bols;
info.pflag = 1; % turn on intermediate printing options
info.maxit=1000;
info.tol=1.0e-5;
result = pow_min('ch5post',parm,info,y,x,n);
disp('time taken by pow_min routine');
mprint(result.time);

fprintf(1,'parameter values \n');
mprint(result.b);

fprintf(1,'hessian matrix \n');
mprint(result.hess);

fprintf(1,'# of iterations taken \n');
mprint(result.iter);

fprintf(1,'function value at optimum \n');
mprint(result.f);
'comparable linear OLS function value'
-.5*n*log(sse)
bmode=result.b;
hess=result.hess;
imatrix = inv(hess);
bsd=zeros(nparam,1);
for i = 1:nparam
bsd(i,1)=sqrt(imatrix(i,i));
end
'Posterior Mode and St dev estimate'
[bmode bsd]


'OLS estimate and standard error for linear model'
[bols bolssd]

%Print out posterior mode and variance estimate for
%later use in Metropolis hastings programs

save postmode.out bmode -ASCII;
save postvar.out imatrix -ASCII;
