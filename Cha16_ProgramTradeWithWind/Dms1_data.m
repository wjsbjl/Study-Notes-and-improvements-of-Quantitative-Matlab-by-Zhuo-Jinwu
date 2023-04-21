%% 获取交易数据基本数据
% 《量化投资：MATLAB数据挖掘技术与实践》配套程序，电子工业出版社，卓金武、周英著。 
% 问题讨论： http://www.ilovematlab.cn/forum-243-1.html
% 答疑方式： 70263215@qq.com
clc, clear, close all % 清窗口
%% 启动Wind数据接口
w=windmatlab;
w.menu;
stime = '2013-01-02';
etime = '2016-04-27'; % 起止日期
%% 获取深市数据
disp('正在获取深市数据'); 
n=0;
k1='00000';    k2='0000';    k3='000';    k4='00';
name_h='sz';
% Start a waitbar
hBar = waitbar(0,'正在获取深市数据'); % 用来显示进度
tic
for i=1:2790 % 1:2790 
   % 定义深圳主板股票代码 
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
   
  % 获得股票交易数据
  [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(whole,'open,high,low,close,volume,turn,amt,dealnum', stime,etime);
  if  isa(wdata,'numeric')==1 &&  isequal(mat2str(wdata(2)), 'NaN')==0;
        n=n+1; 
        cdata=wdata;
        % 保存数据
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
delete(hBar); % 关掉进度条
clear k1 k2 k3 k4;
t1=toc;
disp(['获取深市数据的时间:' num2str(t1)]);

%% 获取沪市数据
% disp('正在获取沪市数据');
n1=0; 
k1='60000';    k2='6000';    k3='600';    k4='60';
name_h='sh';
% Start a waitbar
hBar = waitbar(0,'正在获取上证数据');
tic
for i=0:3918 % 上市股票代码段0--3918
   % 定义深圳主板股票代码 
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
     % 获得股票交易数据
  [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(whole,'open,high,low,close,volume,turn,amt,dealnum', stime,etime);
  if  isa(wdata,'numeric')==1 &&  isequal(mat2str(wdata(2)), 'NaN')==0;
        n1=n1+1; 
        cdata=wdata;
        % 保存数据
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
disp(['获取上证数据的时间:' num2str(t2)]);

%% 获取创业板的数据
% disp('正在获取创业板数据');
n2=0; 
k1='30000';    k2='3000';    k3='300';    k4='30';
name_h='sz';
% Start a waitbar
hBar = waitbar(0,'正在获取创业板数据');
tic
for i=1:468  % 其他股票数据量较少1-468
   % 定义深圳主板股票代码 
   
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
    % 获得股票交易数据
  [wdata,wcodes,wfields,wtimes,werrorid,wreqid] = w.wsd(whole,'open,high,low,close,volume,turn,amt,dealnum', stime,etime);
  if  isa(wdata,'numeric')==1 &&  isequal(mat2str(wdata(2)), 'NaN')==0;
        n2=n2+1; 
        cdata=wdata;
        % 保存数据
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
disp(['获取创业板数据的时间:' num2str(t3)]);
