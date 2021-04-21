function x = advect(N,b,x,x0,u,v,dt,h)

for i = 2: N-1
    for j = 2 : N-1
        x_grid = i - dt*u(j,i)/h;
        y_grid = j - dt*v(j,i)/h;
        if x_grid < 1.5
            x_grid = 1.5;
        elseif x_grid > N-0.5
            x_grid = N-0.5;
        end
        if y_grid < 1.5
            y_grid = 1.5;
        elseif y_grid > N-0.5
            y_grid = N-0.5;
        end
        i0 = floor(x_grid); i1 = i0+1;
        j0 = floor(y_grid); j1 = j0+1;
        s1 = x_grid - i0; s0 = 1-s1;
        t1 = y_grid - j0; t0 = 1-t1;
        
        x(j,i) = s0*( t0 * x0(j0,i0) + t1 * x0(j1,i0) ) + s1*(t0 * x0(j0,i1) + t1 * x0(j1,i1) );
        
    end
end
x = bnd(N,b,x);
end