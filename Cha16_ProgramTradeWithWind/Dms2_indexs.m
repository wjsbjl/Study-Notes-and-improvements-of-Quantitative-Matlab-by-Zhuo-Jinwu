%%  ���������ھ����ĳ���ѡ��step2:��Ʊָ�����
% ������Ͷ�ʣ�MATLAB�����ھ�����ʵ�������׳��򣬵��ӹ�ҵ�����磬׿���䡢��Ӣ���� 
% �������ۣ� http://www.ilovematlab.cn/forum-243-1.html
% ���ɷ�ʽ�� 70263215@qq.com
%% ����׼������������
clc, clear, close all
% ��������
stn=0; % ��Ʊ�ܸ���
train_num=0; % ѵ��������¼����
forecast_num=0; % Ԥ��������¼����
good_s_n=0; % �ù�Ʊ��¼����
bad_s_n=0; % ����Ʊ��¼����
common_s_n=0; % һ���Ʊ�ĸ���
%% ͳ�������ļ�����(��Ʊ����)
dirname = './Data/';
files = dir(fullfile('./Data/*.mat'));
SN = length(files);
disp(['��Ʊ����:' num2str(SN)]);


tsn = 0;
tic;


%% ���һ��,����ǰ��տ��̼۵�������
i = 1
filename = fullfile(dirname, files(i).name);
load(filename);  % �ļ�����cdata��
P0 = cdata; % �����浽cdata��
P= sortrows(P0, -1); % ��������
P(:,1)

%%

% Start a waitbar
hBar = waitbar(0,'���ڼ���ָ��');

for i=1:SN % ����ÿ����Ʊ
   % ��ȡ�����ļ���
   filename = fullfile(dirname, files(i).name);
  load(filename);  % �ļ�����cdata��
  P0 = cdata; % �����浽cdata��
  P= sortrows(P0, -1); % ��������
   %���ɽ���Ϊ0����ɾ��
    [m,n]=size(P); % �� ��
     ii=1;
     for iii=1:m
        if P(ii,6)==0 || isequal(mat2str(P(ii,6)), 'NaN')==1 % ������Ϊ0
           P(ii,:)=[];
        else
           ii = ii+1;
        end
     end
  % ������Ч�����ٵĹ�Ʊɾ��
 [m_r0,n1_c0]=size(P); 
 if m_r0<120 % �������120�������
     continue;
 end
  % ��¼��Ч��Ʊ������
  stn=stn+1;

  %% ָ�����
   for h=1:20
       [m_r1,n1_c1]=size(P);
       if h==2||h==3||(m_r1-h)<=100
           continue % ������������
       end
       
      % s_x1: �����Ƿ�
      s_x1=100*(P(h,5)-P(h+1,5))/P(h+1,5);

      % s_x2: 2���Ƿ�
      s_x2=100*(P(h,5)-P(h+2,5))/P(h+2,5);

      % s_x3: 5���Ƿ�
      s_x3=100*(P(h,5)-P(h+5,5))/P(h+5,5);

      % s_x4: 10���Ƿ�
      s_x4=100*(P(h,5)-P(h+10,5))/P(h+10,5);

      % s_x5: 30���Ƿ�
      s_x5=100*(P(1,5)-P(h+30,5))/P(h+30,5);

      % s_x6: 10���ǵ�����ADR
      % s_x7: 10�����ǿ��ָ��RSI
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
          
          % s_x8: ����K��ֵ;   
          % s_x9: 3��K�߾�ֵ
          % s_x10: 6��K�߾�ֵ
          s_kvalue=zeros(1,6);
    for j=1:6
     s_kvalue(j)=(P(h+j-1,5)-P(h+j-1,2))/...
         ((P(h+j-1,3)-P(h+j-1,4))+0.01);
    end
          s_x8=s_kvalue(1);
          s_x9=sum(s_kvalue(1,1:3))/3;
          s_x10=sum(s_kvalue(1,1:6))/6;

          % s_x11: 6�չ�����(BIAS)
          % s_x12: 10�չ�����(BIAS)
          s_x11=(P(h,5)-sum(P(h:h+5,5))/6)/(sum(P(1:h+5,5))/6);
          s_x12=(P(h,5)-sum(P(h:h+9,5))/10)/(sum(P(1:h+9,5))/10);

          % s_x13: 9��RSV
          % s_x14: 30��RSV
          % s_x15: 90��RSV
  s_x13=(P(h,5)-min(P(h:h+8,5)))/(max(P(h:h+8,5))-min(P(h:h+8,5)));
  s_x14=(P(h,5)-min(P(h:h+29,5)))/(max(P(h:h+29,5))-min(P(h:h+29,5)));
  s_x15=(P(h,5)-min(P(h:h+89,5)))/(max(P(h:h+89,5))-min(P(h:h+89,5)));

          % s_x16: OBV����
          % s_x17: 5��OBV����
          % s_x18: 10��OBV���� 
          % s_x19: 30��OBV���� 
          % s_x20: 60��OBV���� 
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
       
  %�ռ�Ԥ������
  if h==1
      forecast_num=forecast_num+1;
      forecast_sample(forecast_num,:)=[str2double(files(i).name(3:8)),s_x1,...
          s_x2, s_x3, s_x4, s_x5, s_x6, s_x7, s_x8, s_x9, s_x10, s_x11, ...
          s_x12, s_x13, s_x14, s_x15, s_x16, s_x17, s_x18, s_x19, s_x20];
      continue;
  end
  % �жϺû���Ʊ
  s_y=0;
  rise_1=100*(P(h-1,5)-P(h,5))/P(h,5);
  rise_2=100*(P(h-3,5)-P(h,5))/P(h,5);
  
    if rise_2>=5 % �Ƿ�����5%�Ǻù�Ʊ
      s_y=1;
      good_s_n=good_s_n+1;
    elseif rise_2<=-5
      s_y=-1;
      bad_s_n=bad_s_n+1;
    else
      common_s_n=common_s_n+1; % ��������ͨ��Ʊ
    end
       
  % �ռ�ѵ������
  train_num=train_num+1; % ���3:8���ǰѹ�Ʊ������ȡ������
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
disp(['����ָ��ʱ��:' num2str(s2t1)]);
%% ��ѡ����
disp('��ʼ��ѡ����...')
clc
part_num = min([good_s_n, bad_s_n, common_s_n]);
[m_rt1, n_rt1]=size(train_s1); % m���У�n����
good_p_n=0; bad_p_n=0; common_p_n=0;
g_sample=[]; c_sample=[]; b_sample=[];
for i=1:m_rt1
    if train_s1(i,22)==1 % 1���ţ�-1�ǵ�
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
PTSX0=[g_sample; b_sample]; % ƴ��һ��������g_sample,������b_sample����һ��

if size(PTSX0)==0
    disp('û�з�����������������')
else
%����ѵ��������Ԥ������
xlswrite('A_train.xlsx', PTSX0, 'sheet1',['A1:X' num2str(3*part_num)]);
% ����ÿ��train��һ����...
xlswrite('A_forecast.xlsx', forecast_sample, 'sheet1',['A1:W' num2str(forecast_num)]);
end
