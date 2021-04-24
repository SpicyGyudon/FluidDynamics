% Ȯ��
% d(x,y) = �е�
% s(x,y) = �е����
% k
% dn = dc + k(sc-dc)
% dc = dn - k(sn-dn) -> dn = (dc + k*sn)/(1+k)
% sn = sum(dn)/4
% -> gauss seidal method -> dc�� dn ��� (�밢 ����� �ٸ� �����պ��� Ŀ�ߵ�)
% -> x,y�ӵ� , �µ����� ��Į�� ���� ��밡����
% 
% advection (��ũ���)
% �������ϴ� ���̵��?
% � �׸����� ��ũ��ǿ� ���� ���� �е��� �˰� ���� ��
% f = (x,y) - v(x,y)dt -> �ش� ���ܿ��� ��ü�� �������ܿ��� ��� �־�����
% i = floor(f), f�� ����Ű�� ������ �����κ�
% j = fract(f), f�� ����Ű�� ������ �Ҽ��κ� -> ��� ��������
% �Ʒ��� x������ �������� -> z1 
% ���� x���� �������� -> z2
% z1�� z2�� jy�� �������� -> ���ο�е� -> �� �е��� �̷��ӵ��� ���� ���罺���� x,y�� ������Ʈ
% ���� ���� �Լ� : lerp(a,b,k) = a+ k(b-a)
% clearing divergence
% curl -> �ҿ뵹��
% divergence -> �߻�� ����
% helmholtz theorem -> � ������ ���̾��� ������� �߻��� ���� �������� ��ø���� ����� �ִ�
%                   -> div free = origin flow - culr free
%                 
% �����ġ�� �׶���Ʈ��� 
% del dot v = [vx(x+1,y)-vx(x-1,y)]/2+[vy(x,y+1)-vy(x,y-1)]/2
% ���κ��� ������ ��Į���Լ� p ����
% del dot v = [p(x-1)-p]/1+[p(x+1)-p]/1+[p(y-1)-p]/1+[p(y+1)-p]/1
% -> p = [[p+p+p+p]-del dot v]/4  -> gauss seidal �� ��� �κ��� p��� -> p ������ �� �κ��� �߻�����
% -> x�ӵ� -= [p(x+1)-p(x-1)]/2
% -> y�ӵ� -= [p(y+1)-p(y-1)]/2 ->���� �ӵ����� �߻�ӵ� ����
% 
% ��ü ����  every step
% 1. �ӵ� : Ȯ���� -> �߻����� -> �̷���� -> �߻�����
% 2. �е� : Ȯ���� -> �̷����    
%---------------------------------------------------------------------------
clear; clc;

N = 300; 
length = 1;
h = length/N;
% grid number -> grid: 1 , N ĭ�� �ٿ���� -> ������ 2 ~ N-1 ���� ��
% boundary -> �𼭸� : horizon ���� v = 0 , vertical ���� u =0 , x = �� �պ��� ��
%          -> ������ : �ֺ� 2�� �� ���

% diff = Ȯ���
% x0 = 0.1*ones(N,'gpuArray');
x0 = 0.1*ones(N);
% x0(60:90,60:80) = 0.7;
% x0(180:260,70:150) = 0.5;
x0(2*N/5:3*N/5,2*N/5:3*N/5) = 1;

% x0(180:260,160:250) = 0.5;
% x0(100:190,150:180) = 1;
% x0(50:90,150:190) = 1;


x=x0;
diff = 0.0008/N;
visc = 0.005/N;
dt = 0.001;

u0 = 0*N*3/N*ones(N); v0 = 0*N*3/N*ones(N);
% u0 = 2/N*ones(N,'gpuArray'); v0 = 1/N*ones(N,'gpuArray');
u0(2*N/5:3*N/5,2*N/5:3*N/5) = N*3/N;
v0(2*N/5:3*N/5,2*N/5:3*N/5) = 0*N*2.9/N;

u0 = bnd(N,1,u0);
v0 = bnd(N,2,v0);
u=u0;
v=v0;
xgrid = linspace(0,1,N);
ygrid = linspace(1,0,N);
interval = 1;
step=interval;
idx=1;

for i = 1: 1000
% velocity
v=gravity(N,2,v,x,dt,h);
[u,v]=div_clear(N,u,v,h,x,x0,dt);
[u,u0] = swap(u,u0); [v,v0] = swap(v,v0);
u = diffuse(N,1,u,u0,visc,dt); v = diffuse(N,2,v,v0,visc,dt);
[u,v]=div_clear(N,u,v,h,x,x0,dt);
[u,u0] = swap(u,u0); [v,v0] = swap(v,v0);
u = advect(N,1,u,u0,u0,v0,dt,h); v = advect(N,2,v,v0,u0,v0,dt,h);
[u,v]=div_clear(N,u,v,h,x,x0,dt);
% ctime = timeit(@()div_clear(N,u,v,h,x,x0,dt))
% density
[x,x0] = swap(x,x0); x = diffuse(N,0,x,x0,diff,dt);
[u,v]=div_clear(N,u,v,h,x,x0,dt);
[x,x0] = swap(x,x0); x = advect(N,0,x,x0,u,v,dt,h);
[u,v]=div_clear(N,u,v,h,x,x0,dt);


if step == interval
    figure(1)
%     X(:,:,idx) = x;
%     U(:,:,idx) = u;
%     V(:,:,idx) = v;
%     idx = idx+1;
    imagesc(xgrid,ygrid,x)
    title(num2str(i*dt))

    step=0;
end
step=step+1;
end

% 
% for  step = 1 : length(X(1,1,:))
% figure(1)
% plot(0,0)
% hold on;
% for  i = 1: N
%     for j = 1: N
%         plot(i,j,'o','color',[exp(1-X(j,i,step))/exp(1) exp(1-X(j,i,step))/exp(1) exp(1-X(j,i,step))/exp(1)])
%         plot([i i+u(j,i)],[j j+v(j,i)],'r-')
%     end
% end
% 
% hold off;
% text(N/2,N/2,num2str(step))
% axis([0 N+1 0 N+1])
% end
