function  error = fitness(x,inputnum,hiddennum,outputnum,net,P,T)
%该函数用来计算适应度值
%% 输入
%x                     个体
%inputnum        输入层节点数
%hiddennum     隐含层节点数
%outputnum     输出层节点数
%net                 网络
%P                    训练输入数据
%T                     训练输出数据
%% 输出
%error       个体适应度值
%% 提取
M=size(P,2);
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);
%% 网络权值赋值
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=reshape(B2,outputnum,1);
%% 训练网络
net=train(net,P,T);
%% 测试
Y=sim(net,P);
error=sum(abs(Y-T).^2)./M;
end

