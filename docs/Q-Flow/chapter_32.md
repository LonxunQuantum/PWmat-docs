# 自洽计算组件

电子结构计算：获取体系基态时各种电学性质
总电荷密度、部分电荷密度计算及可视化：计算完成后直接点击组件`查看结果`获取
<img src={require("./unit/6.png").default} width='20%' /><img src={require("./unit/7.png").default} width='20%' />

- 支持自旋极化体系: 主要针对磁性材料，默认为关闭
  - <img src={require("./unit/1.png").default} width='12%' />
- 支持强关联体系 DFT+U: 为指定元素的原子轨道添加 U 值，可以从一些文章中获取
  - <img src={require("./unit/2.png").default} width='40%' />
- 支持带电体系：体系增减电荷
  - <img src={require("./unit/3.png").default} width='30%' />
- 支持弱相互作用修正 DFT-D2、DFT-D3: 针对低维材料，需要考虑范德华(vdW)相互作用
  - <img src={require("./unit/4.png").default} width='30%' />
- 支持隐式溶剂模型和固定电势计算：当计算液体溶剂中溶质分子的能量时，例如在电化学研究中，隐式溶剂模型以连续介质表示溶剂的影响，主要包括其对静电极化的影响。与显式溶剂分子和分子动力学相比，隐式溶剂模型要快得多。需要设置溶剂的介电常数、溶质腔及离子浓度等，默认为关闭。详细细节请查看 [Manual](http://www.pwmat.com/pwmat-resource/Manual_cn.pdf) 的**IN.SOLVENT**部分
  - <img src={require("./unit/5.png").default} width='15%' />
- 支持打开或关闭空间对称性、时间反演对称性
