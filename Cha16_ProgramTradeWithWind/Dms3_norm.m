%% 基于数据挖掘技术的程序化选股step3:数据标准化
% 《量化投资：MATLAB数据挖掘技术与实践》配套程序，电子工业出版社，卓金武、周英著。 
% 问题讨论： http://www.ilovematlab.cn/forum-243-1.html
% 答疑方式： 70263215@qq.com
%% 读取数据
clc, clear, close all
PTSX0=xlsread('A_train.xlsx', 'Sheet1');
forecast_sample=xlsread('A_forecast.xlsx', 'Sheet1');
tic;
%%  训练样本归一化
[sxn1,sxm1]=size(PTSX0);
 SS_X=PTSX0;
 S_X_T(:,1)=PTSX0(:,1);
 S_X_T(:,22)=PTSX0(:,22);
  for k=2:sxm1-1
      %基于均值方差的处理离群点数据最大最小归一化
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

%% 预测样本归一化
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
%保存归一化之后的数据
xlswrite('B_forecast.xlsx', S_X_F, 'sheet1','A1');
s3t1=toc;
disp(['数据归一化时间:' num2str(s3t1)]);
%% 说明：程序中所用的归一化方法为均值标准差法

