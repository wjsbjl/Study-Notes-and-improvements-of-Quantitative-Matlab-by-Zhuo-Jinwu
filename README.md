# 《量化投资：数据挖掘技术与实践（MATLAB版）》 - Ch16 基于Wind数据的程序化交易 - 学习笔记

## 摘要
本书第十六章进行了MATLAB程序化投资的梳理，覆盖从数据下载到权重配置的全流程。在阅读过程中，笔者发现这本书中诸多问题，简要概述如下：

1. 下载数据时没有下载时间戳，导致并不知道数据时间；

2. 作者在计算时默认第一列为时间戳，但其实数据整体少了一列，导致操作都是错位的。比如作者排序用的是第一列开盘价降序排列；作者计算收益率用的是第五列成交量而不是第四列的收盘价，诸如此类；

3. 作者在训练神经网络时忽略日期维度和股票维度，将所有不同日期、股票的数据统一作为训练集、将最新一期数据作为测试集。即用第二行以下的所有数据来对第一行进行预测；

4. 作者在预测完成后，用测试集选出的股票代码回到训练集来选股和配权，相当于用训练集上得出的模型在训练集上选股。即使这样，选出的八支股票收益表现只有一只还不错；配置完权重后作者也并没有测试投资效果。

## 相关链接(点击进入对应代码资源)
[《量化投资：数据挖掘技术与实践（MATLAB版）》程序和数据](https://www.ilovematlab.cn/thread-334773-1-1.html)

[《量化投资：数据挖掘技术与实践（MATLAB版）》程序和数据-第二版](https://www.ilovematlab.cn/thread-486972-1-1.html)

<!-- ## 前言 -->
 <!-- 《量化投资：数据挖掘技术与实践(MATLAB版)》全书内容分三个部分。第一部分(基础篇)介绍一些基本概念和知识，包括数据挖掘与量化投资的关系，数据挖掘的概念、实现过程、主要内容、主要工具等内容。第二部分（技术篇）系统介绍了数据挖掘的相关技术及其这些技术在量化投资中的应用。首先介绍了数据挖掘前期的一些技术，包括数据的准备(收集数据、数据质量分析、数据预处理等)和数据的探索（衍生变量、数据可视化、样本选择、数据降维等）；然后重点介绍了数据挖掘的核心六大类方法，包括关联规则、回归、分类、聚类、预测和诊断，对于每类方法中的典型算法，则介绍了算法的基本思想、应用场景、算法步骤、MATLAB实现程序和应用案例，同时对每类方法，还介绍了一个在量化投资中的应用案例，以强化这些方法在量化投资中的实用性；随后补充了数据挖掘中特殊的实用技术，包括针对时序数据挖掘的时间序列技术和常用的智能优化方法(遗传算法和模拟退火算法)。第三部分（实践篇）主要介绍数据挖掘技术在量化投资中的综合应用实例，包括统计套利策略的挖掘、配对交易策略的挖掘、基于数据挖掘技术的股票程序化交易和基于数据挖掘技术的量化交易系统的构建。
 
本书的读者对象为：从事投资、数据挖掘、数据分析、数据管理工作的专业人士；金融、经济、管理、统计等专业的教师和学生；希望学习MATLAB的广大科研人员、学者和工程技术人员。 -->

## 第十六章研读-思路梳理

第十六章希望阐释基于Wind数据的Matlab程序化交易。从流程上看，分为以下几步：

**1. 基于Wind获取数据**

获取2013-01-02到2016-04-27期间的开盘价, 最高价, 最低价, 收盘价, 成交量, 换手率, 成交额, 成交笔数共八个特征。**注意这里没获取日期**...

**2. 计算出20个常用指标，分别关于涨幅、K线、乖离率（BIAS）、RSV、OBV等**

划分训练集和测试集。训练集是相比于三天前变化绝对值超过5\%的股票；测试集是最新一期数据。2452个股票中共有62只股票被选出，每只股票含46-173条数据。其他全是NA[^小声bb]。

**计算有很多问题**，比如这里涨跌幅是用成交量而不是收盘价算的;排序是用开盘价降序排列的。即作者忘记获取日期列，导致计算全部是错位的。


**3. 对指标进行标准化**

标准化，大于均值+两倍标准差的取为1，小于均值-两倍标准差的取为0，余下取为：
$$\tilde{X} = \frac{X-(\bar{X}-2std(X))}{4std(X)}$$

**4. 根据数据相关性进行变量筛选**

绘制相关系数热力图。选取和y的相关系数绝对值大于0.2的变量。

**5. 运用神经网络对未来结果进行预测**

使用MATLAB自带的神经网络工具箱中的feedforwardnet函数，创建一个有50个神经元的前向神经网络模型net。

**6. 选择股票排序中前8只股票进行投资，并用Markowitz组合进行优化**

限定股票数为8，投资天数为200。根据预测结果排序，从高到低选8只股票。计算累积回报，配置Markowitz组合（只求了权重）。

**7. 当股票不在前8或前50位就卖出**

## 改善空间

这里将基于作者思路，更新数据并用Python语言进行更为科学的全流程回测。这主要包括更为科学的数据清洗，更为细致的神经网络模型参数、Markowitz权重求解、投资回测等。

[^小声bb]:好奇怪啊，笔者本人不是很懂matlab代码，这里没看明白为啥只有62只股票而且股票数据这么多，h只取1到20啊...