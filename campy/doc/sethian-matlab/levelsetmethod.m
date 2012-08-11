H = 4;
K = 5;
EPS = 1e-1;
h = 2^-H;
k = 2^-K;
M = -3:h:3;
Ml = length(M);
[xm,ym] = meshgrid(M);
meshsize = size(xm,1);
phi = zeros(size(xm));

% Contour
s = [0:h:(1-h), 1:h/3:(2-h/3), 2:h:(3-h), 3:h/3:(4-h/3)]';
x = zeros(size(s));
y = zeros(size(s));
x(s >= 0 & s < 1) = s(s >= 0 & s < 1);
y(s >= 0 & s < 1) = cos(s(s >= 0 & s < 1)*2*pi);
x(s >= 1 & s < 2) = 1;
y(s >= 1 & s < 2) = 1-3*(s(s >= 1 & s < 2)-1);
x(s >= 2 & s < 3) = 3 - s(s >= 2 & s < 3);
y(s >= 2 & s < 3) = -2;
x(s >= 3 & s < 4) = 0;
y(s >= 3 & s < 4) = -2+3*(s(s >= 3 & s < 4)-3);
%

% Find the contour lines
for i = 1:meshsize
    for j = 1:meshsize
        if (xm(i,j) == 0 || xm(i,j) == 1) && (ym(i,j) <= 1 && ym(i,j) >= -2)
            phi(i,j) = 0;
        else
            d = min(((x-xm(i,j)).^2+(y-ym(i,j)).^2).^(1/2));
            phi(i,j) = d;
        end
    end
end
%

% Find the interior of the contour
interior = ~(xm >= 1 | xm <= 0 | ym <= -2 | ym >= 1);
interior(M <= 1 & M > -2, M < 1 & M >= 0) = ~(ym(M <= 1 & M > -2, M < 1 & M >= 0) > ones(length(M(M <= 1 & M > -2)),1)*y(s >= 0 & s < 1)');
phi(interior) = -phi(interior);
%

I = speye(Ml);
Af = sparse(diag(ones(Ml-1,1),1) - diag(ones(Ml,1),0));
Af([1,end],:) = 0;
Ab = sparse(diag(ones(Ml,1),0) - diag(ones(Ml-1,1),-1));
Ab([1,end],:) = 0;
Ac = sparse(.5*diag(ones(Ml-1,1),1) - .5*diag(ones(Ml-1,1),-1));
Ac([1,end],:) = 0;
Acc = sparse(diag(ones(Ml-1,1),1) + diag(ones(Ml-1,1),-1) - 2*diag(ones(Ml,1),0));
Acc([1,end],:) = 0;

phi_yy = kron(I,Acc);
phi_xx = kron(Acc,I);
phi_y = kron(I,Ac);
phi_x = kron(Ac,I);
phi_xy = kron(Ac,Ac);
Dmy = kron(I,Ab);
Dpy = kron(I,Af);
Dmx = kron(Ab,I);
Dpx = kron(Af,I);
phiv = reshape(phi,[],1);
Zs = zeros(length(phiv),1);

contourf(xm,ym,phi)

while 1
    A = - ( max([Dmx*phiv, Zs],[],2).^2 + min([Dpx*phiv,Zs],[],2).^2 + max([Dmy*phiv,Zs],[],2).^2 + min([Dpy*phiv,Zs],[],2).^2 ).^(1/2);
    D = ((phi_x*phiv).^2 + (phi_y*phiv).^2).^(1/2);
    K = ((phi_xx*phiv).*(phi_y*phiv).^2 - 2*(phi_x*phiv).*(phi_y*phiv).*(phi_xy*phiv) + (phi_yy*phiv).*(phi_x*phiv).^2)./(D.^3 + .0000001).*D;
    phiv = phiv + k/h*A + EPS*K;
    contourf(xm,ym,reshape(phiv,Ml,Ml),[0 0])
    drawnow
    pause(.1)
end