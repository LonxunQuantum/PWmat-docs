# 结构优化组件

优化算法：共轭梯度法 CG、预处理共轭梯度法 PCG、BFGS 拟牛顿法、Limited-memory BFGS、最速下降法 Steepest decent、FIRE。对于大多数问题，我们建议直接使用 CG。

- 支持自旋极化体系: 主要针对磁性材料，默认为关闭
  - <img src={require('./unit/1.png').default} width='12%' />
- 支持强关联体系(DFT+U): 为指定元素的原子轨道添加 U 值，可以从一些文章中获取
  - <img src={require('./unit/2.png').default} width='40%' />
- 支持带电体系：体系增减电荷
  - <img src={require('./unit/3.png').default} width='35%' />
- 支持弱相互作用修正 DFT-D2、DFT-D3: 针对低维材料，需要考虑范德华(vdW)相互作用
  - <img src={require('./unit/4.png').default} width='35%' />
- 支持隐式溶剂模型和固定电势计算：当计算液体溶剂中溶质分子的能量时，例如在电化学研究中，隐式溶剂模型以连续介质表示溶剂的影响，主要包括其对* 静电极化的影响。与显式溶剂分子和分子动力学相比，隐式溶剂模型要快得多。需要设置溶剂的介电常数、溶质腔及离子浓度等，默认为关闭。详细细节请* 查看 [Manual](http://www.pwmat.com/pwmat-resource/Manual_cn.pdf) 的**IN.SOLVENT**部分
  - <img src={require('./unit/5.png').default} width='15%' />
- 支持打开或关闭空间对称性、时间反演对称性
