function f=f14(u,v)
[m,n]=size(u);
f=zeros(m);

    for j=1:n
f(:,j)=fangjian_z(u(:,j),v(:,j));
    end
end


function o = fangjian_z(x,y)
aS=[-32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32;...
-32 -32 -32 -32 -32 -16 -16 -16 -16 -16 0 0 0 0 0 16 16 16 16 16 32 32 32 32 32];
for i=1:length(x);
for j=1:25
    bS(i,j)=sum(([x(i);y(i)]-aS(:,j)).^6);
end

o(i)=(1/500+sum(1./([1:25]+bS(i,:)))).^(-1);
end
end
