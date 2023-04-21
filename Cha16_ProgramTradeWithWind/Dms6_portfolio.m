%% ���������ھ����ĳ���ѡ��step6: Ͷ������Ż�
% ������Ͷ�ʣ�MATLAB�����ھ�����ʵ�������׳��򣬵��ӹ�ҵ�����磬׿���䡢��Ӣ���� 
% �������ۣ� http://www.ilovematlab.cn/forum-243-1.html
% ���ɷ�ʽ�� 70263215@qq.com
%% ��ȡ����
clc, clear, close all
sdata = xlsread('forecast_result.xlsx');
isn = 8; %Ͷ�ʵĹ�Ʊ��
dn=200;  %����
isid= sdata(1:isn, 1);
dirname = 'Data';
tail='.mat';
for i =1:isn
       d=isid(i);
       if d<300000
        % �������������Ʊ���� 
        k1='00000';    k2='0000';    k3='000';    k4='00';
        name_h='sz';
        %������ʵ��Ҫ��ֻ�ǲ�ȫ����λ���������ָ���į��
     
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
     % ������֤��Ʊ���� 
     elseif (d>=600000) 
            name_h='sh';
            kk = num2str(d);
            whole=[name_h,kk];
     elseif (300000<=d) && (d<600000)
       % ���崴ҵ���Ʊ���� 
            name_h='sz';
            kk = num2str(d);
            whole=[name_h,kk];
    end
   % ��ù�Ʊ��������
    fname=[whole, tail];
    filename = fullfile(dirname, fname);
    load(filename);  
    CP(:,i)=cdata(1:dn, 4);
     clear cdata
end
  

%% ����ѡ������8ֻ��Ʊ�Ļر�
Returns = tick2ret(CP);
figure;
plot(Returns);  title('��Ʊ�ر�����ͼ');
set(get(gcf,'Children'),'YLim',[-0.5 0.5]); % ȷ��Y������߶���ͬ

%% �����ۼƻر�
CumSumReturns = cumsum(tick2ret(CP));
figure;
plot(CumSumReturns);  title('��Ʊ�ۼƻر�����ͼ');
set(get(gcf,'Children'),'YLim',[-0.5 0.5]); % ȷ��Y������߶���ͬ

%% ��Ʊ���
assetTickers = {'p1', 'p2', 'p3','p4', 'p5', 'p6', 'p7','p8'};
%% ����Ͷ����Ϸ�������
pmc = PortfolioCVaR;
pmc = pmc.setAssetList(assetTickers);
pmc = pmc.setScenarios(Returns);
pmc = pmc.setDefaultConstraints;
pmc = pmc.setProbabilityLevel(0.95);

% ������Чǰ������
figure; [pmcRisk, pmcReturns] = pmc.plotFrontier(10);
%% ����Ͷ�������������
pmv = Portfolio;
pmv = pmv.setAssetList(assetTickers);
pmv = pmv.estimateAssetMoments(Returns);
pmv = pmv.setDefaultConstraints;
% ������������ǰ������
figure; pmv.plotFrontier(10);

%% ���㲢��ʾȨ�������
pmcwgts = pmc.estimateFrontier(10);
pmcRiskStd = pmc.estimatePortStd(pmcwgts);
figure;
pmv.plotFrontier(10);
hold on
plot(pmcRiskStd,pmcReturns,'-r','LineWidth',2);
legend('Mean-Variance Efficient Frontier',...
       'CVaR Efficient Frontier',...
       'Location','SouthEast')
   
%% �Ƚ�Ͷ��Ȩ��
pmvwgts = pmv.estimateFrontier(10);
figure; 
subplot(1,2,1);
area(pmcwgts');
title('CVaR Ͷ�����Ȩ��');
subplot(1,2,2);
area(pmvwgts');
title('Mean-Variance Ͷ�����Ȩ��');
set(get(gcf,'Children'),'YLim',[0 1]);
legend(pmv.AssetList);

%% ����Ͷ��ƫ��ѡ��Ͷ����Ϸ���
mrisk = 0.02; % ������շ�ֵ
% Ѱ���ڲ��������շ�ֵ�����Ԥ����������һ��Ͷ�����
sid = pmcRiskStd <= mrisk;
nid = find(pmcRiskStd == max(pmcRiskStd(sid)))
disp(['���Ͷ�ʱ���:' num2str(pmcwgts(:,nid)')]);
%% ˵�������Ը��ݷ���ƫ��ѡ��Ͷ�����


