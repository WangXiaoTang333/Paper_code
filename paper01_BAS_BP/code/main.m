%% 使用优化后的权值和阈值测试结果
%% 使用优化后的权值和阈值
inputnum=size(P,1);%输入层神经元个数
outputnum=size(T,1);%输出层神经元个数
N=size(P_test,2);
M=size(P,2);
%% 新建BP
net=newff(P,T,9);
%% 设置网络参数：训练次数1000，训练目标0.001，学习速率00.1
net.trainParam.epochs =3000;
net.trainParam.goal = 1e-6;
net.trainParam.lr = 0.01;
%% BP初始权值和阈值
w1num=inputnum*hiddennum;%输入层到隐含层的权值个数
w2num=outputnum*hiddennum;%隐含层到输入层的权值个数
w1=bestX(1:w1num);%初始输入层到隐含层的权值
B1=bestX(w1num+1:w1num+hiddennum);
w2=bestX(w1num+hiddennum+1:w1num+hiddennum+w2num);%初始隐含层到输出层的权值
B2=bestX(w1num+hiddennum+w2num+1:w1num+hiddennum+w2num+outputnum);%输出层阈值
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=reshape(B2,outputnum,1);
%% 训练网络
net=train(net,P,T);
%% 测试网络
t_sim_P= sim(net,P);
t_sim_P_test= sim(net,P_test);
%% 反归一化
T=mapminmax('reverse',T,ps_output);

T_sim_P= mapminmax('reverse',t_sim_P,ps_output);
T_sim_P_test = mapminmax('reverse',t_sim_P_test,ps_output);
%% 相对误差
error_P=abs(T_sim_P-T)./T;
error_P_test=abs(T_sim_P_test-T_test)./T_test;
%% 相关系数
R2_P= (M * sum(T_sim_P .* T) - sum(T_sim_P) * sum(T))^2 / ((M * sum((T_sim_P).^2) - (sum(T_sim_P))^2) * (M * sum((T).^2) - (sum(T))^2)); 
R2_P_test = (N * sum(T_sim_P_test .* T_test) - sum(T_sim_P_test) * sum(T_test))^2 / ((N * sum((T_sim_P_test).^2) - (sum(T_sim_P_test))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 
%% 结果对比
result = [T_test' T_sim_P_test' abs(T_test-T_sim_P_test)']
result=[T' T_sim_P' abs(T-T_sim_P)']