# 过渡态计算组件

- 优化算法：共轭梯度法 CG、预处理共轭梯度法 PCG、BFGS 拟牛顿法、Limited-memory BFGS、最速下降法 Steepest decent、FIRE：NEB 计算时推荐使用*LBFGS*和*FIRE*，首选*LBFGS*
- 弹性带类型：首先可以直接尝试使用 original 或 regular 方法。如果收敛不好，那么可以尝试使用 conventional 方法，弹性系数设置为 1 进行计算。conventional 方法容易收敛，但是算出的势垒误差较大(弹性系数越大, 误差越大)，因此还需要再使用小的弹性系数(或者用 original 或 regular 方法) 进行续算。
  - NEB 计算，包括 original、conventional 和 regular 方法。
  - CI-NEB 计算，包括 original、conventional 和 regular 方法。不要在一开始就使用 CI-NEB 方法, 将会非常难收敛。建议先进行 NEB 计算并保证收敛, 然后在续算时选择 CI-NEB 方法。
- 弹性系数：推荐设置在 0.1 到 1 之间。弹性系数越大, 收敛越容易，但是误差也越大(特别是对于 conventional 方法的情况)。
  - <img src={require("./unit/24.png").default} width='35%'/>
- 支持过渡态续算
- 支持自旋极化体系: 主要针对磁性材料，默认为关闭
  - <img src={require("./unit/1.png").default} width='12%'/>
- 支持弱相互作用修正 DFT-D2、DFT-D3: 针对低维材料，需要考虑范德华(vdW)相互作用
  - <img src={require("./unit/4.png").default} width='30%'/>
- 支持打开或关闭时间反演对称性
  - <img src={require("./unit/25.png").default} width='20%'/>
- 支持过渡态路径展示、过渡态迁移轨迹动画：计算完成后从过渡态计算组件中`查看结果`获取
  - <img src={require("./unit/26.png").default} width='23%'/>