function x = bnd(N,b,x)
for i = 2 : N-1 
    if b == 1 % u
        if x(i,2) < 0
            x(i,1) = 0;
        else
            x(i,1) = x(i,2);
        end
        
        if x(i,N-1) > 0
            x(i,N) = 0;
        else
            x(i,N) = x(i,N-1);
        end
        
        x(1,i) = x(2,i);
        x(N,i) = x(N-1,i);
    elseif b== 2 % v
   
        if x(2,i) < 0
            x(1,i) = 0;
        else
            x(1,i) = x(2,i);
        end
        
        if x(N-1,i) > 0
            x(N,i) = 0;
        else
            x(N,i) = x(N-1,i);
        end
        
        x(i,1) = x(i,2);
        x(i,N) = x(i,N-1);
    else % ¹Ðµµ
        x(1,i) = x(2,i);
        x(N,i) = x(N-1,i);
        x(i,1) = x(i,2);
        x(i,N) = x(i,N-1);
    end
end
x(1,1) = 0.5 * (x(2,1)+x(1,2));
x(1,N) = 0.5 * (x(2,N)+x(1,N-1));
x(N,1) = 0.5 * (x(N,2)+x(N-1,1));
x(N,N) = 0.5 * (x(N-1,N)+x(N,N-1));
end