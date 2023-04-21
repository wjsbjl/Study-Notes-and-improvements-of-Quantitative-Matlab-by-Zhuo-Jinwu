%% ���������ھ����ĳ���ѡ��step4: ����ɸѡ
% ������Ͷ�ʣ�MATLAB�����ھ�����ʵ�������׳��򣬵��ӹ�ҵ�����磬׿���䡢��Ӣ���� 
% �������ۣ� http://www.ilovematlab.cn/forum-243-1.html
% ���ɷ�ʽ�� 70263215@qq.com
%% ��ȡ������Ϣ
clc, clear, close all
tdata=xlsread('B_train.xlsx');
fdata=xlsread('B_forecast.xlsx');
[rn, cn]=size(tdata);
A=tdata(:, 2:cn);

%% ���㲢��ʾ���ϵ������
covmat = corrcoef(A);
varargin = {'x1','x2','x3','x4','x5','x6','x7','x8','x9','x10',...
    'x11','x12','x13','x14','x15','x16','x17','x18','x19','x20', 'y'};
figure;
x = size(covmat, 2);
imagesc(covmat);
set(gca,'XTick',1:x);
set(gca,'YTick',1:x);
% if nargin > 1
    set(gca,'XTickLabel',varargin);
    set(gca,'YTickLabel',varargin);
% end
axis([0 x+1 0 x+1]);
grid;
colorbar;
%% ѡ������Խ�ǿ�ı���
covth = 0.2;
c1 = covmat(cn-1, 1:(cn-2));
vid = abs(c1)>covth;
idc=1:cn;
A1=A(:,1:(cn-2));
A2=A1(:,vid);
stdata = [ tdata(:,1),A2, tdata(:,cn)];
B = fdata(:,2:(cn-1));
B1= B(:,vid);
sfdata = [fdata(:,1), B1];
xlswrite('C_train.xlsx', stdata);
xlswrite('C_forecast.xlsx', sfdata);
%% ˵��������ɸѡ����Ϊ���������
