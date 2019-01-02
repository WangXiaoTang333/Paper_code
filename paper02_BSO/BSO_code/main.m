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

% You can simply define your cost in a seperate file and load its handle to fobj 
% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables
% Max_iter = maximum number of generations
% N = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define lb and ub as two single number numbers

%__________________________________________

%% Clear variables
clc 
clear all
close all
%%
N=300;  % Number of search agents
Max_iter=1000; %maximum number of generations
TargetFitness=zeros(23,30);
for j=1:30;
for i=1:16;
    tic
    [lb(i),ub(i),dim(i),fobj] = Get_Functions_details(['F' num2str(i)]); 
     [TargetFitness(i,j)]=BSO_fun(N, Max_iter,lb(i),ub(i),dim(i),fobj);
      time(i,j)=toc;
end
tic
[lb_17,ub_17,dim_17,fobj] = Get_Functions_details(['F17']);
     [TargetFitness(17,j)]=BSO_fun17(N, Max_iter,lb_17,ub_17,dim_17,fobj);
     time(17,j)=toc;
for i=18:23;
    tic
    [lb(i),ub(i),dim(i),fobj] = Get_Functions_details(['F' num2str(i)]);
     [TargetFitness(i,j)]=BSO_fun(N, Max_iter,lb(i),ub(i),dim(i),fobj);
     time(i,j)=toc;
end
end