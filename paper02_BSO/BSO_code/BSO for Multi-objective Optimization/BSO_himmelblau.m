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

%% I. 
clc
close all
clear 


%% II. Initialization parameters
maxgen =100;   
sizepop =50;  
%
Vmax=3;
Vmin=-3;
%
popmax =[102 45 45 45 45];
popmin =[78 33 27 27 27];
%
step=20;
step0=0.9;
step1=0.4;
c=2;
 %
 wmax=0.9;
 wmin=0.4; 
 k=0.4;
 vd=5;
%% III 
for i = 1:sizepop
    % 
    pop(i,:) = rand(1,vd).*(popmax-popmin)+popmin;    %
    V(i,:) = 2 * rands(1,vd);  %
    % 
    fitness(i) =Himmelblau(pop(i,:));   
end
%% 
xulie1=zeros(sizepop,1);
for i=1:sizepop;
    xulie1(i,1)=i;
end
xulie2=zeros(maxgen,1);
for i=1:maxgen;
    xulie2(i,1)=i;
end
%% 
figure(maxgen+1)
plot(xulie1,fitness,'ro',xulie1,fitness);
 xlabel('Individual serial number','fontname','Microsoft YaHei');
 ylabel('Value distribution','fontname','Microsoft YaHei');
 title('Initial population','fontname','Microsoft YaHei UI');
%% IV. 
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   
gbest = pop;   
fitnessgbest = fitness;   
fitnesszbest = bestfitness;   

%% V. 
for i = 1:maxgen
   
    c1=1.3+1.2*(cos(i*pi)/maxgen);
    c2=2-1.2*(cos(i*pi)/maxgen);
    d0=step/c;
    w= wmax- (wmax-wmin)*(i/maxgen);
    for j = 1:sizepop
        %
        xleft=pop(j,:)+V(j,:)*d0/2;
        fleft=Himmelblau(xleft);
        xright=pop(j,:)-V(j,:)*d0/2;
        fright=Himmelblau(xright);
        Y(j,:)=step*V(j,:)*sign(fleft-fright);
        % 
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax)) = Vmax;
        V(j,find(V(j,:)<Vmin)) = Vmin;
        
        % 
        pop(j,:) = pop(j,:) + k*V(j,:)+(1-k)*Y(j,:);
        pop(j,:)=(pop(j,:)>popmax).*popmax+(pop(j,:)<popmax).*pop(j,:);
         pop(j,:)=(pop(j,:)<popmin).*popmin+(pop(j,:)>popmin).*pop(j,:);
        
        % 
        fitness(j) =Himmelblau(pop(j,:)); 
    end
    %
    fitnesstable(i,:)=fitness;
    X(i,:,:)=pop;
    for j = 1:sizepop    
        % 
        if fitness(j) < fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        % 
        if fitness(j) < fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end 
     yy(i) = fitnesszbest;        
    eta= step1 * (step0/step1)^(1/(1+10*i/maxgen));
    step=eta*step;
end

%% VII. 
%% 
figure(1)
plot(xulie2,yy);
grid;
legend('solution of the behavior');
xlabel('iterations','fontname','Microsoft YaHei');
ylabel('fitness','fontname','Microsoft YaHei');

%% 
%% 
disp('The minimum value  is£º')
min(yy)

