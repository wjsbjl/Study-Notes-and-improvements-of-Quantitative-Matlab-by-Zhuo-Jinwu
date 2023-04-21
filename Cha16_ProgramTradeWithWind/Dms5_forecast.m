%% 基于数据挖掘技术的程序化选股step5: 训练神经网络并进行模型评估
% 《量化投资：MATLAB数据挖掘技术与实践》配套程序，电子工业出版社，卓金武、周英著。 
% 问题讨论： http://www.ilovematlab.cn/forum-243-1.html
% 答疑方式： 70263215@qq.com
%% % 读入数据
clc, clear, close all
stdata=xlsread('C_train.xlsx');
sfdata=xlsread('C_forecast.xlsx');
[rn, cn]=size(stdata);
P_X=stdata(:,2:(cn-1));
P_Y=stdata(:,cn);
P1_X=sfdata(:,2:(cn-1));
% 数据转置
p_net=P_X';
t_net=P_Y';
p1_net=P1_X';

%% 神经网络预测
%BP网络训练
net = feedforwardnet(50);
net=train(net,p_net,t_net);    %开始训练，其中p_net,t_net分别为输入输出样本

%股票增长概率预测
r_net = sim(net,p1_net);
r_net=r_net';
% [row_n1, column_m1]=size(r_net);
% 将数据保存到excel
% 将数据保存到excel
fr_data=[sfdata, r_net];
fr_cn = size(fr_data,2);
frs_data = sortrows(fr_data, -fr_cn);
xlswrite('forecast_result.xlsx', frs_data);
xlswrite('ForecastSummary.xlsx', frs_data(:,[1,end-1,end]));

%% 模型正确率的评估
r_nn = sim(net,p_net);
Y_nn = zeros(size(r_nn,2),1);
for i = 1:size(r_nn,2)
    if r_nn(i)>0
        Y_nn(i,1)=1;
    elseif   r_nn(i)<=0
        Y_nn(i,1)=-1;
    end
end
c_id=Y_nn==P_Y;
stn=size(t_net,2);
ctn=sum(c_id);
co_rate=ctn/stn;
disp(['全部训练的正确率为:' num2str(co_rate)]);
er_rate=1-co_rate;
mrate=[co_rate, er_rate];
figure
pie(mrate)
title('模型的正确率和错误率')
%% 保存模型
save('NNet', 'net');

%% 说明： 模型评估采用全集验证
