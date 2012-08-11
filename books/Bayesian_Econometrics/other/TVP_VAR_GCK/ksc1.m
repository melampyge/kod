function [vdraw,sdraw] = ksc1(y2,t,capRt,Q,sdraw,h0draw)
% This modifies the univariate ksc subroutine to allow for p-variate model
% measurement error covariance matrix assumed to be diagonal as in
% Primiceri (2005)
% Drawing log volatilities using method of Kim, Shephard and Chib with 7
% Normals in mixture
% y2 is y minus the conditional mean all squared
% capRt is from DK notation which will be used for dynamic mixture. For now
% simply set to ones
% Q is covariance matrix for error in state equation

nh = size(y2,2);
prw = zeros(7,1);
prw1 = zeros(7,1);
mi = zeros(7,1);
vi = zeros(7,1);
%Set the values for the mixing distribution from KSC page 371@
vi(1,1) = 5.79596; vi(2,1) = 2.61369; vi(3,1) = 5.17950; vi(4,1) = 0.16735; vi(5,1) = 0.64009; vi(6,1) = 0.34023; vi(7,1) = 1.26261; 
mi(1,1) = -10.12999; mi(2,1) = -3.97281; mi(3,1) = -8.56686; mi(4,1) = 2.77786; mi(5,1) = 0.61942; mi(6,1) = 1.79518; mi(7,1) = -1.08819; 
prw(1,1) = 0.00730; prw(2,1) = 0.10566; prw(3,1) = 0.00002; prw(4,1) = 0.04395; prw(5,1) = 0.34001; prw(6,1) = 0.24566; prw(7,1) = 0.25750; 

yss = zeros(t,nh);
for i = 1:nh
    yss(:,i) = log(y2(:,i) + 0.001) - h0draw(i,1);
end
%First draw volatilities conditional on sdraw
Ht = zeros(t*nh,nh);
yss1 = zeros(t,nh);

for i = 1:t
    for j = 1:nh
        imix = sdraw(i,j);
        Ht((i-1)*nh+j,j) = vi(imix,1);
        yss1(i,j) = yss(i,j) - mi(imix,1) + 1.2704;  
    end
end
Qc = chol(Q);
Ztemp = [];
for i = 1:t
    Ztemp = [Ztemp ; eye(nh)];
end

[vdraw,llikt] = dk(yss1',nh,nh,t,Qc,Ht,Q,Ztemp,capRt);
vdraw = vdraw';
%disp(meanc(yss1)-meanc(vdraw(1:t,:)))

% Next draw sdraw conditional on vdraw
for jj = 1:nh
    for i = 1:t
        for j = 1:7
            temp1= (1/sqrt(2*pi*vi(j,1)))*exp(-.5*(((yss(i,jj) - vdraw(i,jj) - mi(j,1) + 1.2704)^2)/vi(j,1)));
            prw1(j,1) = prw(j,1)*temp1;
        end
        prw1 = prw1./sum(prw1);
        cprw = cumsum(prw1);
        trand = rand(1,1);
        if trand < cprw(1,1)
            imix=1; 
        elseif trand < cprw(2,1)
            imix=2; 
        elseif trand < cprw(3,1)
            imix=3; 
        elseif trand < cprw(4,1)
            imix=4; 
        elseif trand < cprw(5,1)
            imix=5; 
        elseif trand < cprw(6,1)
            imix=6; 
        else
            imix=7; 
        end
        sdraw(i,jj)=imix;
    end
end