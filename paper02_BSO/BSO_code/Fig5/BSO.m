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
%%
%This part is the code of Figure 5 in the paper.You can adjust each parameter as needed.
%The function part can be replaced with any function you want to verify.

%% I.Clear variables
clc
close all
clear 

%% II. Drawing the objective function image
[x,y]=meshgrid(-5.12:0.1:5.12);
figure(1)
mesh(x,y,f5(x,y));
%% III. Initialization parameters
maxgen =500;   % the maximum number of iterations
sizepop =5;   %population size
%Set the speed boundary value
Vmax=5.12;
Vmin=-5.12;
%
popmax =50;
popmin =-50;
%Initialization step
step=10;
step0=0.9;
step1=0.4;
c=2;
 %Maximum and minimum values of inertia weight
 wmax=0.9;
 wmin=0.4; 
 k=0.4;
 vd=2;
%% IV. Initialize
for i = 1:sizepop
    % Randomly generate a swarm of beetles
    pop(i,:) = (rands(1,vd) + 1) / 2 + 1;    
    V(i,:) = 0.5 * rands(1,vd);  
    % Calculating the fitness function value
    fitness(i) =f5(pop(i,1),pop(i,2));   
end
%%Save initialized data
xulie1=zeros(sizepop,1);%Serial number of each individual
for i=1:sizepop;
    xulie1(i,1)=i;
end
xulie2=zeros(maxgen,1);
for i=1:maxgen;
    xulie2(i,1)=i;
end
%%Draw an image of the initial population fitness function value
figure(maxgen+1)
plot(xulie1,fitness,'ro',xulie1,fitness);
 xlabel('Individual serial number','fontname','Microsoft YaHei');
 ylabel('Value distribution','fontname','Microsoft YaHei');
 title('Initial population','fontname','Microsoft YaHei UI');
%% V. Individual extremum and group extremum
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   
gbest = pop;    
fitnessgbest = fitness;  
fitnesszbest = bestfitness;  

%% VI. Iterative optimization process
for i = 1:maxgen
    %%
    c1=1.3+1.2*(cos(i*pi)/maxgen);
    c2=2-1.2*(cos(i*pi)/maxgen);
    d0=step/c;
    w= wmax- (wmax-wmin)*(i/maxgen);
    for j = 1:sizepop
        %
        xleft=pop(j,:)+V(j,:)*d0/2;
        fleft=f5(xleft(1),xleft(2));
        xright=pop(j,:)-V(j,:)*d0/2;
        fright=f5(xright(1),xright(2));
        Y(j,:)=step*V(j,:)*sign(fleft-fright);
        % 
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax)) = Vmax;
        V(j,find(V(j,:)<Vmin)) = Vmin;
        
        % 
        pop(j,:) = pop(j,:) + k*V(j,:)+(1-k)*Y(j,:);
        pop(j,find(pop(j,:)>popmax)) = popmax;
        pop(j,find(pop(j,:)<popmin)) = popmin;
        
        % 
        fitness(j) =f5(pop(j,1),pop(j,2)); 
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

%% VII. Output results and plot
%% 
figure(maxgen+2)
plot(xulie2,yy,'LineWidth',1.5);
grid;
legend('solution of the behavior');
xlabel('iterations','fontname','Microsoft YaHei');
ylabel('fitness','fontname','Microsoft YaHei');
set(gca,'FontSize',20,'Fontname', 'Times New Roman');
%%
disp('The minimum value  is£º')
min(fitness)
%%
figure(maxgen+3)
rgb=hsv(sizepop);%Create an initial RGB color matrix
[u,v]=meshgrid(-50:0.05:50);
    contour(u,v,f1(u,v),300); hold on; 
colorbar
    xlabel('x','fontname','Microsoft YaHei');
   ylabel('y','fontname','Microsoft YaHei');
   
for i=2:maxgen; 
   for j=1:sizepop;
   plot([X(i-1,j,1),X(i,j,1)],[X(i-1,j,2),X(i,j,2)],'*-','color',rgb(j,:));
   %axis([-50 50 -50 50 0 500]);
   set(gca,'FontSize',20,'Fontname', 'Times New Roman');
   end
end
plot([-0.0898,0.0898],[0.7126,-0.7126],'kp','MarkerSize',20)
set(gca,'FontSize',20,'Fontname', 'Times New Roman');
   title(['the path of beetles']);
hold off
figure(maxgen+4)
rgb=hsv(sizepop);%Create an initial RGB color matrix
   surf(u,v,f5(u,v)); hold on; alpha(0.4)
colorbar;shading interp
     xlabel('x','fontname','Microsoft YaHei');
   ylabel('y','fontname','Microsoft YaHei');
    zlabel('z','fontname','Microsoft YaHei')
for i=2:maxgen; 
   for j=1:sizepop;
   plot3([X(i-1,j,1),X(i,j,1)],[X(i-1,j,2),X(i,j,2)],[fitnesstable(i-1,j),fitnesstable(i,j)],'*-','color',rgb(j,:));
 %  axis([-50 50 -50 50 0 500]);
   set(gca,'FontSize',20,'Fontname', 'Times New Roman');
   end
end
plot3([-0.0898,0.0898],[0.7126,-0.7126],[-1.031628,-1.031628],'kp','MarkerSize',20)
set(gca,'FontSize',20,'Fontname', 'Times New Roman');
% axis([-50 50 -50 50 0 500]);
  title(['the path of beetles']);
hold off