%% ��ȡ�������ݻ�������
% ������Ͷ�ʣ�MATLAB�����ھ�����ʵ�������׳��򣬵��ӹ�ҵ�����磬׿���䡢��Ӣ���� 
% �������ۣ� http://www.ilovematlab.cn/forum-243-1.html
% ���ɷ�ʽ�� 70263215@qq.com
clc, clear, close all % �崰��
%% ����Wind���ݽӿ�
w=windmatlab;
w.menu;
stime = '2013-01-02';
etime = '2016-04-27'; % ��ֹ����
%% ��ȡ��������
disp('���ڻ�ȡ��������'); 
n=0;
k1='00000';    k2='0000';    k3='000';    k4='00';
name_h='sz';
% Start a waitbar
hBar = waitbar(0,'���ڻ�ȡ��������'); % ������ʾ����
tic
for i=1:2790 % 1:2790 
   % �������������Ʊ���� 
    d=num2str(i);
    if i<10
        kk=[k1,d];
    elseif (10<=i)&&(i<100)
        kk=[k2,d];
    elseif (100<=i)&&(i<1000)
        kk=[k3,d];
    elseif (1000<=i)&&(i<10000)
        kk=[k4,d];
    end 
    tail='.sz';
    whole=[kk,tail];
   
  % ��ù�Ʊ��������
  [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(whole,'open,high,low,close,volume,turn,amt,dealnum', stime,etime);
  if  isa(wdata,'numeric')==1 &&  isequal(mat2str(wdata(2)), 'NaN')==0;
        n=n+1; 
        cdata=wdata;
        % ��������
        name_t=kk;
        table_name=strcat(name_h, name_t);        
        save(['Data\',table_name], 'cdata');
  else
        continue
  end
  clear kk whole wdata wcodes wfields wtimes werrorid wreqidd1 name_t table_name
   if mod(i , 10) == 0
        waitbar(i/2790,hBar,sprintf('Processed %d files out of %d' , i , 2790));
    end
  
end 
% Close the waitbar
delete(hBar); % �ص�������
clear k1 k2 k3 k4;
t1=toc;
disp(['��ȡ�������ݵ�ʱ��:' num2str(t1)]);

%% ��ȡ��������
% disp('���ڻ�ȡ��������');
n1=0; 
k1='60000';    k2='6000';    k3='600';    k4='60';
name_h='sh';
% Start a waitbar
hBar = waitbar(0,'���ڻ�ȡ��֤����');
tic
for i=0:3918 % ���й�Ʊ�����0--3918
   % �������������Ʊ���� 
    d=num2str(i);
    if i<10
        kk=[k1,d];
    elseif (10<=i)&&(i<100)
        kk=[k2,d];
    elseif (100<=i)&&(i<1000)
        kk=[k3,d];
    elseif (1000<=i)&&(i<10000)
        kk=[k4,d];
    end 
    tail='.SH';
    whole=[kk,tail];
     % ��ù�Ʊ��������
  [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(whole,'open,high,low,close,volume,turn,amt,dealnum', stime,etime);
  if  isa(wdata,'numeric')==1 &&  isequal(mat2str(wdata(2)), 'NaN')==0;
        n1=n1+1; 
        cdata=wdata;
        % ��������
        name_t=kk;
        table_name=strcat(name_h, name_t);        
        save(['Data\',table_name], 'cdata');
  else
        continue
  end
   if mod(i , 10) == 0
        waitbar(i/3918,hBar,sprintf('Processed %d files out of %d' , i , 3918));
    end
   clear kk whole wdata wcodes wfields wtimes werrorid wreqidd1 name_t table_name
end 
delete(hBar);
clear k1 k2 k3 k4;
t2=toc;
disp(['��ȡ��֤���ݵ�ʱ��:' num2str(t2)]);

%% ��ȡ��ҵ�������
% disp('���ڻ�ȡ��ҵ������');
n2=0; 
k1='30000';    k2='3000';    k3='300';    k4='30';
name_h='sz';
% Start a waitbar
hBar = waitbar(0,'���ڻ�ȡ��ҵ������');
tic
for i=1:468  % ������Ʊ����������1-468
   % �������������Ʊ���� 
   
    d=num2str(i);
    if i<10
        kk=[k1,d];
    elseif (10<=i)&&(i<100)
        kk=[k2,d];
    elseif (100<=i)&&(i<1000)
        kk=[k3,d];
    elseif (1000<=i)&&(i<10000)
        kk=[k4,d];
    end 
    tail='.SZ';
    whole=[kk,tail];
    % ��ù�Ʊ��������
  [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(whole,'open,high,low,close,volume,turn,amt,dealnum', stime,etime);
  if  isa(wdata,'numeric')==1 &&  isequal(mat2str(wdata(2)), 'NaN')==0;
        n2=n2+1; 
        cdata=wdata;
        % ��������
        name_t=kk;
        table_name=strcat(name_h, name_t);        
        save(['Data\',table_name], 'cdata');
  else
        continue
  end
   if mod(i , 10) == 0
        waitbar(i/468,hBar,sprintf('Processed %d files out of %d' , i , 468));
    end
  clear kk whole wdata wcodes wfields wtimes werrorid wreqidd1 name_t table_name
end 
delete(hBar);
clear k1 k2 k3 k4;
t3=toc;
disp(['��ȡ��ҵ�����ݵ�ʱ��:' num2str(t3)]);
