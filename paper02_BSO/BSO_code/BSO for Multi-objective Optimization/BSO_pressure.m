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
%% II. 
maxgen =1000;   
sizepop =50;   
%
Vmax=5;
Vmin=-5;
%
popmax =[0.0625*99,0.0625*99,200,200];
popmin =[0.0625,0.0625,10,10];
%
step=20;
step0=0.9;
step1=0.4;
c=2;
 %
 wmax=0.9;
 wmin=0.4; 
 k=0.4;
 vd=4;
%% III. 
for i = 1:sizepop
    % 
    pop(i,1:2)=0.0625*[randperm(99,1),randperm(99,1)];
    pop(i,3:4) = rand(1,2)*190+10;    
    V(i,:) =1* rands(1,vd);  
    
    fitness(i) =pressure(pop(i,:));   
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
%% IV. 
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   
gbest = pop;    
fitnessgbest = fitness;   
fitnesszbest = bestfitness;  

%% V. 
for i = 1:maxgen
    %
    c1=1.3+1.2*(cos(i*pi)/maxgen);
    c2=2-1.2*(cos(i*pi)/maxgen);
    d0=step/c;
    w= wmax- (wmax-wmin)*(i/maxgen);
    for j = 1:sizepop
       
        xleft(1:2)=0.0625*floor((pop(j,1:2)+V(j,1:2)*d0/2)/0.0625);
        xleft(3:4)=pop(j,3:4)+V(j,3:4)*d0/2;
        fleft=pressure(xleft);
        xright(1:2)=0.0625*floor((pop(j,1:2)-V(j,1:2)*d0/2)/0.0625);
        xright(3:4)=pop(j,3:4)-V(j,3:4)*d0/2;
        fright=pressure(xright);
        Y(j,:)=step*V(j,:)*sign(fleft-fright);
        
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax)) = Vmax;
        V(j,find(V(j,:)<Vmin)) = Vmin;
        
       
        pop(j,:) = pop(j,:) + k*V(j,:)+(1-k)*Y(j,:);
        pop(j,1:2)=0.0625*floor(pop(j,1:2)/0.0625);
         pop(j,:)=(pop(j,:)>popmax).*popmax+(pop(j,:)<popmax).*pop(j,:);
         pop(j,:)=(pop(j,:)<popmin).*popmin+(pop(j,:)>popmin).*pop(j,:);
       
        
        
        fitness(j) =pressure(pop(j,:)); 
    end
   
    fitnesstable(i,:)=fitness;
    for j = 1:sizepop    
        
        if fitness(j) < fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
       
        if fitness(j) < fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end 
     yy(i) = fitnesszbest;        
    eta= step1 * (step0/step1)^(1/(1+10*i/maxgen));
    step=eta*step;
end

%% VI.
%% 
figure(maxgen+2)
plot(xulie2,yy);
grid;
legend('solution of the behavior');
xlabel('iterations','fontname','Microsoft YaHei');
ylabel('fitness','fontname','Microsoft YaHei');


%% 
disp('The minimum value  is£º')
min(yy)

