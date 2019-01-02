%_________________________________________________________________________%
%  Beetle Swarm Optimization (BSO)Algorithm source codes demo V1.0        
%                                                                         
%  Developed in MATLAB R2016a                                             
%                                                                         
%  Author and programmer: Long Yang and Tiantian Wang    
%                                                                         
%         e-Mail: yanglongren@163.com                 
%                 18366135507@163.com                   
%                                                                                           
%  Main paper: Tiantian Wang ,  Long Yang , Qiang Liu                        
%             Beetle Swarm Optimization Algorithm:Theory and Application
%                 
%_________________________________________________________________________%
function Target=BSO_fun17(N, Max_iter,lb,ub,dim,fobj)
%% III. 参数初始化

%速度的边界
Vmax=5.12;
Vmin=-5.12;
%种群范围
 step0=0.9;
 step1=0.2;
eta=0.95;
c=2;
 %惯性权重最大值与最小值
 wmax=0.9;
 wmin=0.4; 
 k=0.4;
 %初始步长
 step=10;
 Y=zeros(1,2);
%% IV. 产生初始粒子和速度
for i = 1:N;
    % 随机产生一个天牛群
    pop(i,:) = (rands(1,dim) ) *(ub-lb)+lb ;   %初始种群(保证初始种群不会超出边界1-2）
    V(i,:) = 0.5 * rands(1,dim);  %初始化速度
    % 计算适应度
    fitness(i) =fobj(pop(i,:));  
end
%% 绘制初始种群适应度函数值图像
%% V. 个体极值和群体极值
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   %全局最佳
gbest = pop;    %个体最佳
fitnessgbest = fitness;   %个体最佳适应度值
fitnesszbest = bestfitness;   %全局最佳适应度值
%% VI. 迭代寻优
for i = 1:Max_iter
    %学习因子c1,c2的调整
    c1=1.3+1.2*(cos(i*pi)/Max_iter);
    c2=2-1.2*(cos(i*pi)/Max_iter);
    d0=step/c;%两须之间的距离
    w= wmax- (wmax-wmin)*(i/Max_iter);%权重系数设置
    for j = 1:N;
        %bas方法部分位置移动
        xleft=pop(j,:)+V(j,:)*d0/2;
        fleft=fobj(xleft);
        xright=pop(j,:)-V(j,:)*d0/2;
        fright=fobj(xright);
     
        Y(j,:)=step.*V(j,:).*sign(fleft-fright);
        % 速度更新
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax)) = Vmax;
        V(j,find(V(j,:)<Vmin)) = Vmin;
        
        % 种群位置更新
        pop(j,:) = pop(j,:) + k*V(j,:)+(1-k)*Y(j,:);
         pop(j,:)=(pop(j,:)>ub').*ub'+(pop(j,:)<ub').*pop(j,:);
         pop(j,:)=(pop(j,:)<lb').*lb'+(pop(j,:)>lb').*pop(j,:);
       
        
        % 适应度值更新
        fitness(j) = fobj(pop(j,:)); 
    end
    %每代的适应度函数值
    fitnesstable(i,:)=fitness;
    for j = 1:N;   
        % 个体最优更新
        if fitness(j) <fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        % 群体最优更新
        if fitness(j) < fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end 
     yy(i) = fitnesszbest;        
   eta= step1 * (step0/step1)^(1/(1+10*i/Max_iter));
    step=eta*step;
end
Target=min(yy);



