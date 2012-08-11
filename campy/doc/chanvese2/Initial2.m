function [phi]=Initial2(phi,K)
[ny,nx]=size(phi);
h=1/(nx-1);
rs=0.12;

for i=1:ny
    for j=1:nx
        cx=1/(K+1)*(nx+1);
        cy=1/(K+1)*(ny+1);
        x=(i-cx)*h;
        y=(j-cy)*h;
        r=sqrt(x^2+y^2);
        phi(i,j)=r-rs;
    end
end

for k1=1:K
    for k2=1:K
        for i=1:ny
            for j=1:nx
                cx=1/(K+1)*k2*(nx+1);
                cy=1/(K+1)*k1*(ny+1);
                x=(i-cx)*h;
                y=(j-cy)*h;
                r=sqrt(x^2+y^2);
                phit(i,j)=r-rs;
                phi(i,j)=min(phi(i,j),phit(i,j));
            end
        end
    end
end