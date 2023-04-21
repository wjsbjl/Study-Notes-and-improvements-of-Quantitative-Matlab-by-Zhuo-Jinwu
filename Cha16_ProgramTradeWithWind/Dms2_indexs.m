%%  基于数据挖掘技术的程序化选股step2:股票指标计算
% 《量化投资：MATLAB数据挖掘技术与实践》配套程序，电子工业出版社，卓金武、周英著。 
% 问题讨论： http://www.ilovematlab.cn/forum-243-1.html
% 答疑方式： 70263215@qq.com
%% 环境准备及变量定义
clc, clear, close all
% 参数定义
stn=0; % 股票总个数
train_num=0; % 训练样本记录条数
forecast_num=0; % 预测样本记录条数
good_s_n=0; % 好股票记录个数
bad_s_n=0; % 坏股票记录个数
common_s_n=0; % 一般股票的个数
%% 统计数据文件个数(股票个数)
dirname = './Data/';
files = dir(fullfile('./Data/*.mat'));
SN = length(files);
disp(['股票个数:' num2str(SN)]);


tsn = 0;
tic;


%% 检查一下,真的是按照开盘价倒序，离谱
i = 1
filename = fullfile(dirname, files(i).name);
load(filename);  % 文件读到cdata里
P0 = cdata; % 排序后存到cdata里
P= sortrows(P0, -1); % 降序排列
P(:,1)

%%

% Start a waitbar
hBar = waitbar(0,'正在计算指标');

for i=1:SN % 对于每个股票
   % 读取数据文件名
   filename = fullfile(dirname, files(i).name);
  load(filename);  % 文件读到cdata里
  P0 = cdata; % 排序后存到cdata里
  P= sortrows(P0, -1); % 降序排列
   %将成交量为0的行删除
    [m,n]=size(P); % 行 列
     ii=1;
     for iii=1:m
        if P(ii,6)==0 || isequal(mat2str(P(ii,6)), 'NaN')==1 % 第六行为0
           P(ii,:)=[];
        else
           ii = ii+1;
        end
     end
  % 开盘有效天数少的股票删除
 [m_r0,n1_c0]=size(P); 
 if m_r0<120 % 如果少于120天就跳过
     continue;
 end
  % 记录有效股票的数量
  stn=stn+1;

  %% 指标计算
   for h=1:20
       [m_r1,n1_c1]=size(P);
       if h==2||h==3||(m_r1-h)<=100
           continue % 若符合则跳过
       end
       
      % s_x1: 当日涨幅
      s_x1=100*(P(h,5)-P(h+1,5))/P(h+1,5);

      % s_x2: 2日涨幅
      s_x2=100*(P(h,5)-P(h+2,5))/P(h+2,5);

      % s_x3: 5日涨幅
      s_x3=100*(P(h,5)-P(h+5,5))/P(h+5,5);

      % s_x4: 10日涨幅
      s_x4=100*(P(h,5)-P(h+10,5))/P(h+10,5);

      % s_x5: 30日涨幅
      s_x5=100*(P(1,5)-P(h+30,5))/P(h+30,5);

      % s_x6: 10日涨跌比率ADR
      % s_x7: 10日相对强弱指标RSI
      rise_num=0; dec_num=0;

     for j=1:10
       rise_rate=100*(P(h+j-1,5)-P(h+j,5))/P(j+h,5);
              if rise_rate>=0
                  rise_num=rise_num+1;
              else
                  dec_num=dec_num+1;
              end
     end
          s_x6=rise_num/(dec_num+0.01);
          s_x7=rise_num/10;
          
          % s_x8: 当日K线值;   
          % s_x9: 3日K线均值
          % s_x10: 6日K线均值
          s_kvalue=zeros(1,6);
    for j=1:6
     s_kvalue(j)=(P(h+j-1,5)-P(h+j-1,2))/...
         ((P(h+j-1,3)-P(h+j-1,4))+0.01);
    end
          s_x8=s_kvalue(1);
          s_x9=sum(s_kvalue(1,1:3))/3;
          s_x10=sum(s_kvalue(1,1:6))/6;

          % s_x11: 6日乖离率(BIAS)
          % s_x12: 10日乖离率(BIAS)
          s_x11=(P(h,5)-sum(P(h:h+5,5))/6)/(sum(P(1:h+5,5))/6);
          s_x12=(P(h,5)-sum(P(h:h+9,5))/10)/(sum(P(1:h+9,5))/10);

          % s_x13: 9日RSV
          % s_x14: 30日RSV
          % s_x15: 90日RSV
  s_x13=(P(h,5)-min(P(h:h+8,5)))/(max(P(h:h+8,5))-min(P(h:h+8,5)));
  s_x14=(P(h,5)-min(P(h:h+29,5)))/(max(P(h:h+29,5))-min(P(h:h+29,5)));
  s_x15=(P(h,5)-min(P(h:h+89,5)))/(max(P(h:h+89,5))-min(P(h:h+89,5)));

          % s_x16: OBV量比
          % s_x17: 5日OBV量比
          % s_x18: 10日OBV量比 
          % s_x19: 30日OBV量比 
          % s_x20: 60日OBV量比 
          s_x16=sign(P(h,5)-P(h+1,5))*P(h,6)/(sum(P(h:h+4,6))/5);

          OBV_5=0;  OBV_10=0; OBV_30=0; OBV_60=0; 

          for j=1:5
              OBV_5=sign(P(h+j-1,5)-P(h+j,5))*P(h+j-1,6)+ OBV_5;
          end
          s_x17=OBV_5/(sum(P(h:h+4,6))/5);

          for j=1:10
              OBV_10=sign(P(h+j-1,5)-P(h+j,5))*P(h+j-1,6)+ OBV_10;
          end
          s_x18=OBV_10/(sum(P(h:h+9,6))/10);

          for j=1:30
              OBV_30=sign(P(h+j-1,5)-P(h+j,5))*P(h+j-1,6)+ OBV_30;
          end
          s_x19=OBV_30/(sum(P(h:h+29,6))/30);

          for j=1:60
              OBV_60=sign(P(h+j-1,5)-P(h+j,5))*P(h+j-1,6)+ OBV_60;
          end
          s_x20=OBV_60/(sum(P(h:h+59,6))/60);
       
  %收集预测数据
  if h==1
      forecast_num=forecast_num+1;
      forecast_sample(forecast_num,:)=[str2double(files(i).name(3:8)),s_x1,...
          s_x2, s_x3, s_x4, s_x5, s_x6, s_x7, s_x8, s_x9, s_x10, s_x11, ...
          s_x12, s_x13, s_x14, s_x15, s_x16, s_x17, s_x18, s_x19, s_x20];
      continue;
  end
  % 判断好坏股票
  s_y=0;
  rise_1=100*(P(h-1,5)-P(h,5))/P(h,5);
  rise_2=100*(P(h-3,5)-P(h,5))/P(h,5);
  
    if rise_2>=5 % 涨幅大于5%是好股票
      s_y=1;
      good_s_n=good_s_n+1;
    elseif rise_2<=-5
      s_y=-1;
      bad_s_n=bad_s_n+1;
    else
      common_s_n=common_s_n+1; % 其他是普通股票
    end
       
  % 收集训练样本
  train_num=train_num+1; % 这个3:8就是把股票代码提取出来了
  train_s1(train_num,:)=[str2double(files(i).name(3:8)),s_x1, s_x2,...
      s_x3, s_x4, s_x5, s_x6, s_x7, s_x8, s_x9, s_x10, s_x11, s_x12,...
      s_x13, s_x14, s_x15, s_x16, s_x17, s_x18, s_x19, s_x20, s_y];
    
   end  % for h
   if mod(i , 10) == 0
        waitbar(i/SN,hBar,sprintf('Processed %d files out of %d' , i , SN));
    end
   
  clear  P0 cdata P
  
end
% Close the waitbar
delete(hBar);

s2t1=toc;
disp(['计算指标时间:' num2str(s2t1)]);
%% 挑选样本
disp('开始挑选样本...')
clc
part_num = min([good_s_n, bad_s_n, common_s_n]);
[m_rt1, n_rt1]=size(train_s1); % m是行，n是列
good_p_n=0; bad_p_n=0; common_p_n=0;
g_sample=[]; c_sample=[]; b_sample=[];
for i=1:m_rt1
    if train_s1(i,22)==1 % 1是张，-1是跌
        if good_p_n>=part_num
            continue;
        end
        good_p_n=good_p_n+1;
        g_sample(good_p_n,:)=train_s1(i,:);
       
    elseif train_s1(i,22)==0
        if common_p_n>=part_num
            continue;
        end
        common_p_n=common_p_n+1;
        c_sample(common_p_n,:)=train_s1(i,:);
        
     elseif train_s1(i,22)==-1
        if bad_p_n>=part_num
            continue;
        end
        bad_p_n=bad_p_n+1;
        b_sample(bad_p_n,:)=train_s1(i,:);
     end
     
end

% PTSX0=[g_sample; c_sample; b_sample];
PTSX0=[g_sample; b_sample]; % 拼在一起，上面是g_sample,下面是b_sample，列一样

if size(PTSX0)==0
    disp('没有符合条件的数据样本')
else
%保存训练样本和预测样本
xlswrite('A_train.xlsx', PTSX0, 'sheet1',['A1:X' num2str(3*part_num)]);
% 这里每个train不一样长...
xlswrite('A_forecast.xlsx', forecast_sample, 'sheet1',['A1:W' num2str(forecast_num)]);
end
