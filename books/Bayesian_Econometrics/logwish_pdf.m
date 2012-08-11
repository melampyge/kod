function pdf = logwish_pdf(Z, A, omega)
% PURPOSE: log of pdf of the Wishart(A,a) distribution evaluated at Z
%defined as in Poirier (1995) page 136
%--------------------------------------------------------------
M=size(Z,1); 
lintcon = .5*omega*M*log(2) + .25*M*(M-1)*log(pi);
for i = 1:M
    lintcon = lintcon + gammaln(.5*(omega+1-i));
end
pdf = -lintcon + .5*(omega-M-1)*log(det(Z)) - .5*omega*log(det(A)) - ...
    .5*trace(inv(A)*Z);


