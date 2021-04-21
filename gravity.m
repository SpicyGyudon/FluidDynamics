function v=gravity(N,b,v,x,dt)
g=9.81;
Fg = x * -g;

v=bnd(N,b,v+Fg*dt);
end