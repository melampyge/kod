function fastmarching(H,OBS,PLOT)
h = 2^-H;
mesh = 0:h:1;
ml = length(mesh);
[xm,ym] = meshgrid(mesh,mesh);

% Speed function f
f = 3*xm + 5*ym;
%

% Obstacle mesh grid
Obstacle = xm == inf & ym == inf;
if OBS ~= 0
    Obstacle = Obstacle | xm > 1/3 & xm < .8 & ym > 2/3;
    Obstacle = Obstacle | (xm > .2 & xm < .6 & ym > .2 & ym < .5);
    Obstacle = Obstacle | (xm > .7 & xm < .9 & ym > .55);
    Obstacle = Obstacle | (xm > .1 & xm < .25 & ym > .3 & ym < .7);
    Obstacle = Obstacle | (xm > .7 & xm < .8 & ym > .25 & ym < .5);
end
%

F = ones(size(xm))./f;
POI = xm == 1 & ym == 1;
Known = xm == 0 & ym == 0;
Trial = (xm == 0 & ym == h) | (xm == h & ym == 0);
T = zeros(size(xm));
T(1,1) = 1;
T(1,2) = F(1,2)*h + T(1,2-1);
T(2,1) = F(2,1)*h + T(2-1,1);

while ~Known(POI)
    [x,y] = find(T == min(T(Trial)));
    Known(x,y) = 1;
    Trial(x,y) = 0;
    
    if y < ml
        Trial(x,y+1) = ~Known(x,y+1) & ~Obstacle(x,y+1);
    end
    if y > 1
        Trial(x,y-1) = ~Known(x,y-1) & ~Obstacle(x,y-1);
    end
    if x > 1
        Trial(x-1,y) = ~Known(x-1,y) & ~Obstacle(x-1,y);
    end
    if x < ml
        Trial(x+1,y) = ~Known(x+1,y) & ~Obstacle(x+1,y);
    end
    
    [a,b] = find(Trial);
    Region = (a - x).^2 + (b-y).^2 < 9;
    a = a(Region);
    b = b(Region);
    
    for k = 1:length(a);
        INPUT = [];
        if a(k) > 1
            if Known(a(k)-1,b(k)) && ~Obstacle(a(k)-1,b(k))
                INPUT = [INPUT, T(a(k)-1,b(k))];
            end
        end
        if a(k) < ml
            if Known(a(k)+1,b(k)) && ~Obstacle(a(k)+1,b(k))
                INPUT = [INPUT, T(a(k)+1,b(k))];
            end
        end
        if b(k) > 1
            if Known(a(k),b(k)-1) && ~Obstacle(a(k),b(k)-1)
                INPUT = [INPUT, T(a(k),b(k)-1)];
            end
        end
        if b(k) < ml
            if Known(a(k),b(k)+1) && ~Obstacle(a(k),b(k)+1)
                INPUT = [INPUT, T(a(k),b(k)+1)];
            end
        end
        T(a(k),b(k)) = solvequad(INPUT,F(a(k),b(k)),h);
    end
    
    if nargin > 2
        Temp = T;
        Temp(~Known) = NaN;
        contourf(xm,ym,Temp);
        colorbar
        drawnow
    end
end

T(~Known) = NaN;
contourf(xm,ym,T,50);
colorbar
T(~Known) = max(T(:));
[FX,FY] = gradient(T);
streamline(stream2(xm,ym,-FX,-FY,1,1));
end

function y = solvequad(INPUT,F,h)
if isempty(INPUT)
    error('WHOOPS');
elseif length(INPUT) == 1
    y = F*h+INPUT;
else
    A = length(INPUT);
    B = -2*sum(INPUT);
    C = sum(INPUT.^2)-h^2*F^2;
    y = (-B + sqrt(B^2-4*A*C))/(2*A);
end
end