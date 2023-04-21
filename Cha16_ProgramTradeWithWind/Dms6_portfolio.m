%% 基于数据挖掘技术的程序化选股step6: 投资组合优化
% 《量化投资：MATLAB数据挖掘技术与实践》配套程序，电子工业出版社，卓金武、周英著。 
% 问题讨论： http://www.ilovematlab.cn/forum-243-1.html
% 答疑方式： 70263215@qq.com
%% 读取数据
clc, clear, close all
sdata = xlsread('forecast_result.xlsx');
isn = 8; %投资的股票数
dn=200;  %天数
isid= sdata(1:isn, 1);
dirname = 'Data';
tail='.mat';
for i =1:isn
       d=isid(i);
       if d<300000
        % 定义深圳主板股票代码 
        k1='00000';    k2='0000';    k3='000';    k4='00';
        name_h='sz';
        %这里其实需要的只是补全成六位数，这分类分个寂寞。
     
            if d<10
                kk=[k1,num2str(d)];
            elseif (10<=d)&&(d<100)
                kk=[k2,num2str(d)];
            elseif (100<=d)&&(d<1000)
                kk=[k3,num2str(d)];
            elseif (1000<=d)&&(d<10000)
                kk=[k4,num2str(d)];
            end 
   
        whole=[name_h,kk];
     % 定义上证股票代码 
     elseif (d>=600000) 
            name_h='sh';
            kk = num2str(d);
            whole=[name_h,kk];
     elseif (300000<=d) && (d<600000)
       % 定义创业板股票代码 
            name_h='sz';
            kk = num2str(d);
            whole=[name_h,kk];
    end
   % 获得股票交易数据
    fname=[whole, tail];
    filename = fullfile(dirname, fname);
    load(filename);  
    CP(:,i)=cdata(1:dn, 4);
     clear cdata
end
  

%% 计算选出来的8只股票的回报
Returns = tick2ret(CP);
figure;
plot(Returns);  title('股票回报趋势图');
set(get(gcf,'Children'),'YLim',[-0.5 0.5]); % 确保Y轴坐标尺度相同

%% 计算累计回报
CumSumReturns = cumsum(tick2ret(CP));
figure;
plot(CumSumReturns);  title('股票累计回报趋势图');
set(get(gcf,'Children'),'YLim',[-0.5 0.5]); % 确保Y轴坐标尺度相同

%% 股票编号
assetTickers = {'p1', 'p2', 'p3','p4', 'p5', 'p6', 'p7','p8'};
%% 设置投资组合风险限制
pmc = PortfolioCVaR;
pmc = pmc.setAssetList(assetTickers);
pmc = pmc.setScenarios(Returns);
pmc = pmc.setDefaultConstraints;
pmc = pmc.setProbabilityLevel(0.95);

% 绘制有效前沿曲线
figure; [pmcRisk, pmcReturns] = pmc.plotFrontier(10);
%% 设置投资组合收益限制
pmv = Portfolio;
pmv = pmv.setAssetList(assetTickers);
pmv = pmv.estimateAssetMoments(Returns);
pmv = pmv.setDefaultConstraints;
% 绘制收益有限前沿曲线
figure; pmv.plotFrontier(10);

%% 计算并显示权重与风险
pmcwgts = pmc.estimateFrontier(10);
pmcRiskStd = pmc.estimatePortStd(pmcwgts);
figure;
pmv.plotFrontier(10);
hold on
plot(pmcRiskStd,pmcReturns,'-r','LineWidth',2);
legend('Mean-Variance Efficient Frontier',...
       'CVaR Efficient Frontier',...
       'Location','SouthEast')
   
%% 比较投资权重
pmvwgts = pmv.estimateFrontier(10);
figure; 
subplot(1,2,1);
area(pmcwgts');
title('CVaR 投资组合权重');
subplot(1,2,2);
area(pmvwgts');
title('Mean-Variance 投资组合权重');
set(get(gcf,'Children'),'YLim',[0 1]);
legend(pmv.AssetList);

%% 根据投资偏好选择投资组合方案
mrisk = 0.02; % 定义风险阀值
% 寻找在不超过风险阀值情况下预期收益最大的一组投资组合
sid = pmcRiskStd <= mrisk;
nid = find(pmcRiskStd == max(pmcRiskStd(sid)))
disp(['最佳投资比例:' num2str(pmcwgts(:,nid)')]);
%% 说明：可以根据风险偏好选择投资组合


