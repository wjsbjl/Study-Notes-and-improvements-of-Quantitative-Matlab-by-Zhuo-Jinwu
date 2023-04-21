%% ���������ھ����ĳ���ѡ��step5: ѵ�������粢����ģ������
% ������Ͷ�ʣ�MATLAB�����ھ�����ʵ�������׳��򣬵��ӹ�ҵ�����磬׿���䡢��Ӣ���� 
% �������ۣ� http://www.ilovematlab.cn/forum-243-1.html
% ���ɷ�ʽ�� 70263215@qq.com
%% % ��������
clc, clear, close all
stdata=xlsread('C_train.xlsx');
sfdata=xlsread('C_forecast.xlsx');
[rn, cn]=size(stdata);
P_X=stdata(:,2:(cn-1));
P_Y=stdata(:,cn);
P1_X=sfdata(:,2:(cn-1));
% ����ת��
p_net=P_X';
t_net=P_Y';
p1_net=P1_X';

%% ������Ԥ��
%BP����ѵ��
net = feedforwardnet(50);
net=train(net,p_net,t_net);    %��ʼѵ��������p_net,t_net�ֱ�Ϊ�����������

%��Ʊ��������Ԥ��
r_net = sim(net,p1_net);
r_net=r_net';
% [row_n1, column_m1]=size(r_net);
% �����ݱ��浽excel
% �����ݱ��浽excel
fr_data=[sfdata, r_net];
fr_cn = size(fr_data,2);
frs_data = sortrows(fr_data, -fr_cn);
xlswrite('forecast_result.xlsx', frs_data);
xlswrite('ForecastSummary.xlsx', frs_data(:,[1,end-1,end]));

%% ģ����ȷ�ʵ�����
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
disp(['ȫ��ѵ������ȷ��Ϊ:' num2str(co_rate)]);
er_rate=1-co_rate;
mrate=[co_rate, er_rate];
figure
pie(mrate)
title('ģ�͵���ȷ�ʺʹ�����')
%% ����ģ��
save('NNet', 'net');

%% ˵���� ģ����������ȫ����֤
