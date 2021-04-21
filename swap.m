function [x,x0] = swap(x,x0)
temp=x0; x0 = x;  x = temp;
end