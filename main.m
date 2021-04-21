% 확산
% d(x,y) = 밀도
% s(x,y) = 밀도평균
% k
% dn = dc + k(sc-dc)
% dc = dn - k(sn-dn) -> dn = (dc + k*sn)/(1+k)
% sn = sum(dn)/4
% -> gauss seidal method -> dc로 dn 계산 (대각 계수가 다른 행계수합보다 커야됨)
% -> x,y속도 , 온도같은 스칼라 값에 사용가능함
% 
% advection (벌크모션)
% 역추적하는 아이디어?
% 어떤 그리드의 벌크모션에 의한 다음 밀도를 알고 싶을 때
% f = (x,y) - v(x,y)dt -> 해당 스텝에서 유체가 이전스텝에서 어디에 있었는지
% i = floor(f), f가 가르키는 벡터의 정수부분
% j = fract(f), f가 가르키는 벡터의 소수부분 -> 얘로 선형보간
% 아랫변 x끼리의 선형보간 -> z1 
% 윗변 x끼리 선형보간 -> z2
% z1과 z2를 jy로 선형보간 -> 새로운밀도 -> 이 밀도가 이류속도를 따라 현재스텝의 x,y로 업데이트
% 선형 보간 함수 : lerp(a,b,k) = a+ k(b-a)
% clearing divergence
% curl -> 소용돌이
% divergence -> 발산과 수렴
% helmholtz theorem -> 어떤 유동은 컬이없는 유동장과 발산이 없는 유동장의 중첩으로 만들수 있다
%                   -> div free = origin flow - culr free
%                 
% 모든위치의 그라디언트계산 
% del dot v = [vx(x+1,y)-vx(x-1,y)]/2+[vy(x,y+1)-vy(x,y-1)]/2
% 각부분의 포지션 스칼라함수 p 정의
% del dot v = [p(x-1)-p]/1+[p(x+1)-p]/1+[p(y-1)-p]/1+[p(y+1)-p]/1
% -> p = [[p+p+p+p]-del dot v]/4  -> gauss seidal 로 모든 부분의 p계산 -> p 성분은 각 부분의 발산정도
% -> x속도 -= [p(x+1)-p(x-1)]/2
% -> y속도 -= [p(y+1)-p(y-1)]/2 ->원래 속도에서 발산속도 제거
% 
% 전체 과정  every step
% 1. 속도 : 확산계산 -> 발산제거 -> 이류계산 -> 발산제거
% 2. 밀도 : 확산계산 -> 이류계산    
%---------------------------------------------------------------------------
clear; clc;

N = 30; % grid number -> grid: 1 , N 칸은 바운더리 -> 루프는 2 ~ N-1 까지 돎
% boundary -> 모서리 : horizon 에선 v = 0 , vertical 에선 u =0 , x = 그 앞벽의 값
%          -> 꼭지점 : 주변 2값 의 평균

% diff = 확산률
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
