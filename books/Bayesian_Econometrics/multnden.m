function lmndens = multnden(amean,avar,apoint)
%log of the multivariate normal density with mean amean
%and variance avar, evaluated at a point apoint

ndim=size(amean,1);


lmndens = -.5*ndim*log(2*pi) -.5*log(det(avar)) ...
    -.5*(apoint-amean)'*inv(avar)*(apoint-amean);



