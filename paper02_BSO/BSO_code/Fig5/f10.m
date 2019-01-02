function z =f10( x,y )
z=-20*exp(-0.2*sqrt(0.5*(x.^2+y.^2)))-exp(0.5*(cos(2*pi*x)+cos(2*pi*y)))+20+2.71828183;
z=-z;
end

