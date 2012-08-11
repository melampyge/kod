function [phi]=ChanVeseImp(phi,uinitial)
[ny,nx]=size(phi);
hx=1/(nx-1);
hy=1/(ny-1);
h=hx;
delta=10e-9;
dt=0.1*h;
speado=0;


u=10e-9;v=-100;lambda1=1;lambda2=1;eps=h;

for i=1:ny
    for j=1:nx
        imin=min(i+1,ny);
        jmin=min(j+1,nx);
        imax=max(i-1,1);
        jmax=max(j-1,1);
        dx1(i,j)=(phi(i,jmin)-phi(i,j))/hx;
        dx2(i,j)=(phi(i,j)-phi(i,jmax))/hx;
        dy1(i,j)=(phi(imin,j)-phi(i,j))/hy;
        dy2(i,j)=(phi(i,j)-phi(imax,j))/hy;
    end
end

L=h^2*sum(sum(Delta(phi,eps).*sqrt(0.5*(dx1.^2+dx2.^2)+0.5*(dy1.^2+dy2.^2))));
c1=sum(sum(uinitial.*Heaviside(phi,eps)))/sum(sum(Heaviside(phi,eps)));
c2=sum(sum(uinitial.*(1-Heaviside(phi,eps))))/sum(sum(1-Heaviside(phi,eps)));


for i=1:ny
    for j=1:nx
        imin=min(i+1,ny);
        jmin=min(j+1,nx);
        imax=max(i-1,1);
        jmax=max(j-1,1);
        %             C1(i,j)=1/pi*eps/(eps^2+phi(i,j)^2)*u*(p*L)^(p-1)/...
        %                 (sqrt((dx1(i,j))^2+0.5*((dy1(i,j))^2+(dy2(i,j))^2))+delta)/h^2;
        co=Delta(phi(i,j),eps)*u*L/h^2;
        C1(i,j)=co/(sqrt((dx1(i,j))^2+0.25*(dy1(i,j)+dy2(i,j))^2)+delta);
        %             C2(i,j)=1/pi*eps/(eps^2+phi(i,j)^2)*u*(p*L)^(p-1)/...
        %                 (sqrt((dx1(i,jmax))^2+0.5*((dy1(i,jmax))^2+(dy2(i,jmax))^2))+delta)/h^2;
        C2(i,j)=co/(sqrt((dx1(i,jmax))^2+0.25*(dy1(i,jmax)+dy2(i,jmax))^2)+delta);
        %             C3(i,j)=1/pi*eps/(eps^2+phi(i,j)^2)*u*(p*L)^(p-1)/...
        %                 (sqrt((dy1(i,j))^2+0.5*((dx1(i,j))^2+(dx2(i,j))^2))+delta)/h^2;
        C3(i,j)=co/(sqrt((dy1(i,j))^2+0.25*(dx1(i,j)+dx2(i,j))^2)+delta);
        %             C4(i,j)=1/pi*eps/(eps^2+phi(i,j)^2)*u*(p*L)^(p-1)/...
        %                 (sqrt((dy1(imax,j))^2+0.5*((dx1(imax,j))^2+(dx2(imax,j))^2))+delta)/h^2;
        C4(i,j)=co/(sqrt((dy1(imax,j))^2+0.25*(dx1(imax,j)+dx2(imax,j))^2)+delta);

        phi(i,j)=1/(1+C1(i,j)+C2(i,j)+C3(i,j)+C4(i,j))*(phi(i,j)+dt*(C1(i,j)*phi(i,jmin)+C2(i,j)*phi(i,jmax)...
            +C3(i,j)*phi(imin,j)+C4(i,j)*phi(imax,j)+1/pi*eps/(eps^2+phi(i,j)^2)*(-v-lambda1*(uinitial(i,j)-c1)^2 ...
            +lambda2*(uinitial(i,j)-c2)^2)));
    end
end

