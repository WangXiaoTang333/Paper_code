%% 用天牛须算法来优化BP的权值和阈值,数据样本为测试数据，非论文实际数据，样本60个，其中每个样本具有401个特征值；NIR为样本的光谱数据，octane为60*1的辛烷值数据
% 1.0版本
%% 清空环境变量
clear all
close all
clc
tic
%% 加载数据
load spectra_data.mat
% 随机产生训练集和测试集
temp=randperm(size(NIR,1));
%训练集——50个样本
P=NIR(temp(1:50),:)';
T=octane(temp(1:50),:)';
%测试集——10个样本
P_test=NIR(temp(51:end),:)';
T_test=octane(temp(51:end),:)';
N=size(P_test,2);
M=size(P,2);

%% 归一化
[P, ps_input] = mapminmax(P,0,1);%p_train归一化处理，范围为[0,1]，默认情况下为[-1,1]
P_test = mapminmax('apply',P_test,ps_input);%对P_test采用相同的映射
[T, ps_output] = mapminmax(T,0,1);
%% 
inputnum=size(P,1);
outputnum=size(T,1);
hiddennum=9;%初始隐含层神经元个数
%% 创建网络
net=newff(P,T,hiddennum);
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-3;
net.trainParam.lr = 0.01;
%% 天牛须算法初始化
eta=0.8;
c=5;%步长与初始距离之间的关系
step=30;%初始步长
n=100;%迭代次数
k=inputnum*hiddennum+outputnum*hiddennum+hiddennum+outputnum;
x=rands(k,1);
bestX=x;
bestY=fitness(bestX,inputnum,hiddennum,outputnum,net,P,T);
fbest_store=bestY;
x_store=[0;x;bestY];
display(['0:','xbest=[',num2str(bestX'),'],fbest=',num2str(bestY)])
%% 迭代部分
for i=1:n
d0=step/c;
    dir=rands(k,1);
    dir=dir/(eps+norm(dir));
    xleft=x+dir*d0/2;
    fleft=fitness(xleft,inputnum,hiddennum,outputnum,net,P,T);
    xright=x-dir*d0/2;
    fright=fitness(xright,inputnum,hiddennum,outputnum,net,P,T);
    x=x-step*dir*sign(fleft-fright);
    y=fitness(x,inputnum,hiddennum,outputnum,net,P,T);
    if y<bestY
        bestX=x;
        bestY=y;
    end
    if y<0.001
         bestX=x;
        bestY=y;
    end
    x_store=cat(2,x_store,[i;x;y]);
    fbest_store=[fbest_store;bestY];
    step=step*eta;
     display([num2str(i),':xbest=[',num2str(bestX'),'],fbest=',num2str(bestY)])
end

%% 可视化
figure(1)
%plot(x_store(1,:),x_store(end,:),'r-o')
hold on,
plot(x_store(1,:),fbest_store,'b-.')
xlabel('Iteration')
ylabel('BestFit')
toc