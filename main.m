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

N = 30; % grid number -> grid: 1 , N ĭ�� �ٿ���� -> ������ 2 ~ N-1 ���� ��
% boundary -> �𼭸� : horizon ���� v = 0 , vertical ���� u =0 , x = �� �պ��� ��
%          -> ������ : �ֺ� 2�� �� ���

% diff = Ȯ���
b = 0;
x0 = 0*ones(N,N);
x0(10:20,10:20) = 1;
x=x0;
diff = 0.5;
visc = 0.5;


u0 = zeros(N);
u0(10:20,:) = 5;
v0 = zeros(N);
v0(:,10:20) = 5;

u0 = bnd(N,1,u0);
v0 = bnd(N,2,v0);
u=u0;
v=v0;

interval = 500;
step=interval;
idx=1;
for i = 1: 4000
% velocity
[u,u0] = swap(u,u0); [v,v0] = swap(v,v0);
u = diffuse(N,1,u,u0,visc,0.01); v = diffuse(N,2,v,v0,visc,0.01);
[u,v]=div_clear(N,u,v);
[u,u0] = swap(u,u0); [v,v0] = swap(v,v0);
u = advect(N,1,u,u0,u0,v0,0.01); v = advect(N,2,v,v0,u0,v0,0.01);
[u,v]=div_clear(N,u,v);
% density
[x,x0] = swap(x,x0); x = diffuse(N,0,x,x0,diff,0.01);
[x,x0] = swap(x,x0); x = advect(N,0,x,x0,u,v,0.01);
if step == interval
    X(:,:,idx) = x;
    U(:,:,idx) = u;
    V(:,:,idx) = v;
    step=0;
    idx = idx+1;
end
step=step+1;
end

for  step = 1 : length(X(1,1,:))
figure(1)
plot(0,0)
hold on;
for  i = 1: N
    for j = 1: N
        plot(i,j,'o','color',[exp(1-X(j,i,step))/exp(1) exp(1-X(j,i,step))/exp(1) exp(1-X(j,i,step))/exp(1)])
        plot([i i+u(j,i)],[j j+v(j,i)],'r-')
    end
end

hold off;
text(N/2,N/2,num2str(step))
axis([0 N+1 0 N+1])
end
