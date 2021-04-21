function x = diffuse(N,b,x,x0,diff,dt)
a = dt*diff;

for k = 1 : 20 %Gauss-Seidal loop
    for i = 2 : N-1
        for j = 2 : N-1
            x(i,j) = ( x0(i,j) + a *( x(i-1,j)+x(i+1,j)+x(i,j-1)+x(i,j+1) )/4 ) / (1+a);
        end
    end
    x = bnd(N,b,x);
end

end