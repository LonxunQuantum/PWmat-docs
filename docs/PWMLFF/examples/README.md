---
sidebar_position: 7
title: PWMLFF Examples
---

在本章节，我们整理了使用PWMLFF做的一些测试工作，以及使用PWMLFF的已发表论文，为用户提供参考。

### [一、Comparison of Features ](./features.md)

本例中比较了 `PWMLFF 中的特征类型` 在描述物理系统能力方面的差异。这些特征类型包括`余弦特征`、`高斯特征`、`矩张量势(MTP)特征`、`光谱邻域分析势特征`、具有`切比雪夫多项式特征`和`高斯多项式特征`的简化光滑深势以及原子簇展开特征。文章使用`线性回归模型` 在`无定形硫体系`和`碳体系`下，评估了针对密度泛函理论结果的`原子群能量`、`总能量`和`力`的训练均方根误差(RMSE)。特征的详细介绍请参考[Feature Wiki](../Appendix-1.md)。

### [二、LKF vs ADAM](./LKF%20vs%20Adam.md)

PWMFF中实现了 `重组层扩展卡尔曼滤波（RLEKF）` 优化器，旨在加速训练神经网络力场。RLEKF是全局扩展卡尔曼滤波（GEKF）的改进版本，通过采用分割大层和聚集小层的策略来降低计算成本。该策略利用稀疏对角块矩阵逼近密集权重误差协方差矩阵，从而提高了计算效率。作者在`13`个常见体系上进行了数值实验，并与 ADAM 优化器进行了比较。
<!-- 实验结果表明，RLEKF 相对于 ADAM `收敛更快且精度稍高`。此外，作者还从理论上证明了权值的更新是收敛的，从而克服了梯度爆炸问题。总体而言，RLEKF对权值初始化不敏感，对神经网络力场的训练具有较好的效果。 -->

<!-- ### [四、Si](./Si.md)

### [五、Fe](./Fe.md)

### [六、ZWT](./wzt.md) -->

### [三、Active Learning](./Active%20Learning.md)
[PWact](../active%20learning/README.md) (Active learning based on PWMLFF) 是我们开发的一款开源的基于 PWMLFF 的一套自动化主动学习平台，用于高效的数据采样。在PWact中实现了常用的基于多模型委员会查询（Committee Query）的主动学习策略，以及我们基于卡尔曼滤波算法提出的不确定性度量算法（Kalman Prediction Uncertainty， KPU）。基于 KPU 的主动学习还在内测阶段，暂未开放给用户访问。在本例中，我们做了两种主动学习采样的对比。


### [四、其他](./GNN.md)

#### GNN

#### NEP



