function [phi]=ReInitializeOrd1Damped(phi,iter)
[ny,nx]=size(phi);
hx=1/(nx-1);hy=1/(ny-1);
h=hx;
dt=0.4*h;

for k=1:iter

    for i=1:ny % second order
        for j=1:nx
            imin=min(i+1,ny);
            jmin=min(j+1,nx);
            imax=max(i-1,1);
            jmax=max(j-1,1);
            DDphix_1(i,j)=(phi(i,jmin)-phi(i,j))/hx;
            DDphix_2(i,j)=(phi(i,j)-phi(i,jmax))/hx;
            DDphiy_1(i,j)=(phi(imin,j)-phi(i,j))/hy;
            DDphiy_2(i,j)=(phi(i,j)-phi(imax,j))/hy;
        end
    end

    for i=1:nx
        for j=1:nx
            if (phi(i,j)>0)
                phi(i,j)=phi(i,j)-dt*(sqrt(max((max(DDphiy_2(i,j),0))^2,(min(DDphiy_1(i,j),0))^2)+...
                    max((max(DDphix_2(i,j),0))^2,(min(DDphix_1(i,j),0))^2))-1)*phi(i,j)/sqrt((phi(i,j))^2+...
                    (sqrt(max((max(DDphiy_2(i,j),0))^2,(min(DDphiy_1(i,j),0))^2)+max((max(DDphix_2(i,j),0))^2,...
                    (min(DDphix_1(i,j),0))^2)))^2*h^2);
            elseif (phi(i,j)<0)
                phi(i,j)=phi(i,j)-dt*(sqrt(max((min(DDphiy_2(i,j),0))^2,(max(DDphiy_1(i,j),0))^2)+...
                    max((min(DDphix_2(i,j),0))^2,(max(DDphix_1(i,j),0))^2))-1)*phi(i,j)/sqrt((phi(i,j))^2+...
                    (sqrt(max((min(DDphiy_2(i,j),0))^2,(max(DDphiy_1(i,j),0))^2)+max((min(DDphix_2(i,j),0))^2,...
                    (max(DDphix_1(i,j),0))^2)))^2*h^2);
            else
                phi(i,j)=0;
            end
        end
    end
end