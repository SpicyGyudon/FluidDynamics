function [u,v]=div_clear(N,u,v,h,x,x0,dt)
% p = zeros(N,'gpuArray');delV = zeros(N,'gpuArray');
p = zeros(N); delV = zeros(N);

for i = 2 : N-1
    for j = 2 : N-1
        delV(j,i) = (x(j,i+1)*u(j,i+1)-x(j,i-1)*u(j,i-1)+v(j+1,i)*x(j+1,i)-v(j-1,i)*x(j-1,i))/(2*h)...
            -(x(j,i)-x0(j,i))/dt;
    end
end
delV = bnd(N,0,delV);
for k = 1:20
    for i = 2 : N-1
        for j = 2: N-1
            p(j,i) = (p(j+1,i)+p(j-1,i)+p(j,i+1)+p(j,i-1) - h * delV(j,i))/4 ;
        end
    end
    p = bnd(N,0,p);
end

for i = 2 : N-1
    for j = 2: N-1
        u(j,i) = u(j,i) - 0.5 * (p(j,i+1)-p(j,i-1))/x(j,i);
        v(j,i) = v(j,i) - 0.5 * (p(j+1,i)-p(j-1,i))/x(j,i);
    end
end
u = bnd(N,1,u); v = bnd(N,2,v);

end
