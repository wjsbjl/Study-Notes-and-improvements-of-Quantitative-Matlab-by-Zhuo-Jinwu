%% ���������ھ����ĳ���ѡ��step3:���ݱ�׼��
% ������Ͷ�ʣ�MATLAB�����ھ�����ʵ�������׳��򣬵��ӹ�ҵ�����磬׿���䡢��Ӣ���� 
% �������ۣ� http://www.ilovematlab.cn/forum-243-1.html
% ���ɷ�ʽ�� 70263215@qq.com
%% ��ȡ����
clc, clear, close all
PTSX0=xlsread('A_train.xlsx', 'Sheet1');
forecast_sample=xlsread('A_forecast.xlsx', 'Sheet1');
tic;
%%  ѵ��������һ��
[sxn1,sxm1]=size(PTSX0);
 SS_X=PTSX0;
 S_X_T(:,1)=PTSX0(:,1);
 S_X_T(:,22)=PTSX0(:,22);
  for k=2:sxm1-1
      %���ھ�ֵ����Ĵ�����Ⱥ�����������С��һ��
      for j=1:sxn1 
      xm2=mean(SS_X(:,k));
      std2=std(SS_X(:,k));
      if SS_X(j,k)>xm2+2*std2
            S_X_T(j,k)=1;
      elseif SS_X(j,k)<xm2-2*std2
            S_X_T(j,k)=0;
      else
            S_X_T(j,k)=(SS_X(j,k)-(xm2-2*std2))/(4*std2);
      end
      end
  end
xlswrite('B_train.xlsx', S_X_T, 'sheet1','A1');

%% Ԥ��������һ��
[sxn2,sxm2]=size(forecast_sample);
 SS_X=forecast_sample;
 S_X_F(:,1)=forecast_sample(:,1);
   for k=2:sxm2
      for j=1:sxn2 
      xm2=mean(SS_X(:,k));
      std2=std(SS_X(:,k));
      if SS_X(j,k)>xm2+2*std2
            S_X_F(j,k)=1;
      elseif SS_X(j,k)<xm2-2*std2
            S_X_F(j,k)=0;
      else
            S_X_F(j,k)=(SS_X(j,k)-(xm2-2*std2))/(4*std2);
      end
      end
   end
%�����һ��֮�������
xlswrite('B_forecast.xlsx', S_X_F, 'sheet1','A1');
s3t1=toc;
disp(['���ݹ�һ��ʱ��:' num2str(s3t1)]);
%% ˵�������������õĹ�һ������Ϊ��ֵ��׼�

