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

function Target=BSO_fun(N, Max_iter,lb,ub,dim,fobj)
%% I .Argument Initialization

%Set the speed boundary value
Vmax=ub*0.5; %maximum speed,you can adjust to the actual problem
Vmin=lb*0.5;%minimum speed
%The parameters involved in the step size update
 step0=0.9;
 step1=0.2;
 eta=0.95;
 c=2;
 %Maximum and minimum values of inertia weight
 wmax=0.9;
 wmin=0.4; 
 k=0.4;
 %Initialization step
 step=(ub-lb)*2;
%% II. initialize
for i = 1:N;
    % Randomly generate a swarm of beetles
    pop(i,:) = (rands(1,dim) ) *(ub-lb)+lb ;   %Initial population (ensure initial population does not exceed boundary 1-2)
    V(i,:) = 10 * rands(1,dim);  
    % Calculating the fitness function value
    fitness(i) =fobj(pop(i,:)) ; 
end

%% III. Calculate individual extremum and population extremum
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   
gbest = pop;    
fitnessgbest = fitness;   % individual extremum
fitnesszbest = bestfitness;   %population extremum
%% IV. Iteration process
for i = 1:Max_iter
    %Adjustment of learning factors c1, c2
    c1=1.3+1.2*(cos(i*pi)/Max_iter);
    c2=2-1.2*(cos(i*pi)/Max_iter);
    d0=step/c;% distance between  two antennaes
    w= wmax- (wmax-wmin)*(i/Max_iter);%inertia weight
    for j = 1:N;
        
        xleft=pop(j,:)+V(j,:)*d0/2;
        fleft=fobj(xleft);
        xright=pop(j,:)-V(j,:)*d0/2;
        fright=fobj(xright);
        Y(j,:)=step.*V(j,:).*sign(fleft-fright);
        % Update Speed
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax)) = Vmax;
        V(j,find(V(j,:)<Vmin)) = Vmin;
        
        % Update the Position of search agents 
        pop(j,:) = pop(j,:) + k*V(j,:)+(1-k)*Y(j,:);
        pop(j,find(pop(j,:)>ub)) = ub;
        pop(j,find(pop(j,:)<lb)) = lb;
        
        % update fitness value 
        fitness(j) = fobj(pop(j,:)); 
    end
    
    fitnesstable(i,:)=fitness;
    for j = 1:N;   
        % Update individual optimal value
        if fitness(j) <fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        % Update group optimal value
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

