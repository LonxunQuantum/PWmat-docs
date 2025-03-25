---
sidebar_position: 7
title: 案例
---

在本章节，我们整理了使用 MatPL 做的一些测试工作，以及使用 MatPL 的已发表论文，为用户提供参考。

### [一、Comparison of Features ](./features.md)

本例中比较了 `MatPL 中的特征类型` 在描述物理系统能力方面的差异。这些特征类型包括`余弦特征`、`高斯特征`、`矩张量势(MTP)特征`、`光谱邻域分析势特征`、具有`切比雪夫多项式特征`和`高斯多项式特征`的简化光滑深势以及原子簇展开特征。文章使用`线性回归模型` 在`无定形硫体系`和`碳体系`下，评估了针对密度泛函理论结果的`原子群能量`、`总能量`和`力`的训练均方根误差(RMSE)。特征的详细介绍请参考[Feature Wiki](../models/nn/README.md)。

更多的测试细节也可以参考 [龙讯公众号文章](https://mp.weixin.qq.com/s/JjkivADrvUdOE_C9qCuA9g) 以及 [[文献 Accuracy evaluation of different machine learning force field features ]](https://iopscience.iop.org/article/10.1088/1367-2630/acf2bb)

### [二、LKF And ADAM](./LKF%20vs%20Adam.md)

PWMFF中实现了 [[重组层扩展卡尔曼滤波（LKF）优化器]](https://arxiv.org/abs/2212.06989)，旨在加速训练神经网络力场。LKF是全局扩展卡尔曼滤波（GKF）的改进版本，通过采用分割大层和聚集小层的策略来降低计算成本。该策略利用稀疏对角块矩阵逼近密集权重误差协方差矩阵，从而提高了计算效率。作者在`13`个常见体系上进行了数值实验，并与 ADAM 优化器进行了比较。
<!-- 实验结果表明，LKF 相对于 ADAM `收敛更快且精度稍高`。此外，作者还从理论上证明了权值的更新是收敛的，从而克服了梯度爆炸问题。总体而言，LKF对权值初始化不敏感，对神经网络力场的训练具有较好的效果。 -->

### [三、Active Learning](./Active%20Learning.md)
[PWact](../pwact/README.md) (Active learning based on MatPL) 是我们开发的一款开源的基于 MatPL 的一套自动化主动学习平台，用于高效的数据采样。在PWact中实现了常用的基于多模型委员会查询（Committee Query）的主动学习策略，以及我们基于卡尔曼滤波算法提出的不确定性度量算法（Kalman Prediction Uncertainty， KPU）。基于 KPU 的主动学习还在内测阶段，暂未开放给用户访问。在本例中，我们做了两种主动学习采样的对比。


### [四、通用模型（大模型）](./GNN.md)
基于 GNN 的各类通用模型正在快速涌现，这类通用模型可以“开箱即用”，也可以做作为“基础模型”，通过微调、蒸馏、主动学习等手段，快速应用到各个专业领域内，极大降低力场构建代价。我们对最近开源的 [[MACE (文献链接)]](https://arxiv.org/abs/2401.00096) 做了一些微调测试。


### [五、使用机器学习力场模拟液态硅到晶体硅的生长过程（案例）](./Si.md)
 [[文献 Liquid to crystal Si growth simulation using machine learning force field]](https://pubs.aip.org/aip/jcp/article/153/7/074501/1064762/Liquid-to-crystal-Si-growth-simulation-using)

本案例 使用PMLFF模拟了远离平衡态的硅熔体生长过程，发现基于第一性原理分解的原子能量 (`PWmat 特性`) 构建的 MLFF 可以准确再现第一性原理模拟的生长过程。
提出了一种校正ML-FF训练中存在的系统偏差的方法，这对于准确模拟相变温度等关键结果非常重要。
结果表明，ML-FF可以准确模拟硅熔体生长过程，为使用ML-FF进行远离平衡态模拟提供了证据。


<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/si.gif").default} alt="cu_ffc_333" width="300" />
  </div>
</div>

### [六、基于机器学习的铁-氢系统力场及其对α-Fe裂纹传播中氢的作用研究（案例）](./Fe.md)
[[文献 Machine learning force field for Fe-H system and investigation on role of hydrogen on the crack propagation in α-Fe ]](https://www.osti.gov/pages/biblio/1882447-machine-learning-force-field-fe-system-investigation-role-hydrogen-crack-propagation-fe)

案例主要介绍了使用机器学习力场来研究氢对α-铁裂纹传播影响的研究。具体内容包括： 1. 基于密度泛函理论计算结果，构建了铁-氢体系的机器学习力场，该力场采用了神经网络模型，并训练了原子能量。该力场表现出了良好的统计和动力学性质。 2. 通过分子动力学模拟，研究氢浓度对含裂纹的α-铁模型试样裂纹传播的影响。研究发现氢浓度在裂纹尖端处越高，裂纹传播速度越快，这表明氢对裂纹的传播具有促进作用。 3. 在含有晶界的试样中，观察到裂纹尖端处形成了微孔洞，这有助于释放裂纹尖端的拉伸应力，从而促进裂纹的传播。但微孔洞的形成似乎与氢的存在关系不大。 4. 研究还发现，在x方向周期性较短的结构中，裂纹传播速度较快，这可能是由于x方向的协同效应导致的。 5. 与嵌入原子力场的结果相比，机器学习力场显示出了氢对裂纹传播的显著影响，这表明准确描述氢-金属相互作用的力场的重要性。 6. 研究结果表明，氢在裂纹尖端聚集对氢脆性裂纹的传播起着关键作用，需要进一步深入研究不同条件下氢脆性的行为。

<!-- 案例细节可以参考 [龙讯公众号文章](https://mp.weixin.qq.com/s/WdxQCJ0fMVAL7cjw-g5x-g) 以及 [文献 Revealing Morphology Evolution of Lithium Dendrites by Large-Scale Simulation Based on Machine Learning Force Field](https://onlinelibrary.wiley.com/doi/abs/10.1002/aenm.202202892) -->

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/fe1.gif").default} alt="cu_ffc_333" width="251" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/fe2.gif").default} alt="si_diamond_222" width="251" />
  </div>
</div>

### [七、基于机器学习力场的分子动力学模拟揭示锂枝晶的形态演化（案例）](./Li.md)

案例细节可以参考 [[龙讯公众号文章]](https://mp.weixin.qq.com/s/kapzIrPvL2AcGTUzdHgglg) 以及 [[文献 Revealing Morphology Evolution of Lithium Dendrites by Large-Scale Simulation Based on Machine Learning Force Field ]](https://iopscience.iop.org/article/10.1088/1367-2630/acf2bb)

案例利用机器学习力场结合自洽连续溶剂模型，对锂枝晶在工作电解质环境中的形态演化进行了模拟。结果表明，枝晶形态演化可分为两个阶段。第一阶段由表面原子能量的降低驱动，导致原本单晶的枝晶发生局部取向重排，形成多个晶域。第二阶段由内部原子能量的降低驱动，促使晶域沿晶界滑移，并降低晶界能量。此外，文章还讨论了不同暴露表面取向对枝晶形态变化的影响。总的来说，降低表面能和晶界能驱动了枝晶形态的演化。


<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/li.gif").default} alt="cu_ffc_333" width="400" />
  </div>
</div>

<!-- #### GNN


#### NEP -->




