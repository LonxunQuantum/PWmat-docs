---
sidebar_position: 4
---

# 分子动力学组件

- 支持 NVE、NVT、NPT 系综：NVE 系综使用*Verlet*方法，此时恒定原子数 N、体积 V 和总能 E；NVT 系综可以使用的方法有三个（_Berendsen_、*Langevin*和*Nose-Hoover*）,此时恒定原子数 N、体积 V 和温度 T；NPT 可以使用的方法有三个（_Berendsen_、*Langevin*和*Nose-Hoover*），此时恒定原子数 N、压强 P 和温度 T。除 NVE 外，体系的温度将随时间从初态温度调整到末态温度。对于 NVE，末态温度不起作用。
  - <img src={require("../../unit/14.png").default} width='30%' /><img src={require("../../unit/15.png").default} width='30%' /><img src={require("../../unit/16.png").default} width='30%' />
- 支持 Nose-Hoover、Langevin、Berendsen 热浴：用于 NVT 和 NPT，如上。
- 支持自旋极化体系: 主要针对磁性材料，默认为关闭
  - <img src={require("../../unit/1.png").default} width='12%' />
- 支持强关联体系 DFT+U: 为指定元素的原子轨道添加 U 值，可以从一些文章中获取
  - <img src={require("../../unit/2.png").default} width='40%' />
- 支持带电体系：体系增减电荷
  - <img src={require("../../unit/3.png").default} width='30%' />
- 支持弱相互作用修正 DFT-D2、DFT-D3: 针对低维材料，需要考虑范德华(vdW)相互作用
  - <img src={require("../../unit/4.png").default} width='30%' />
- 支持打开或关闭时间反演对称性
- 径向分布函数计算
  - <img src={require("../../unit/17.png").default} width='20%' />
- 均方位移计算
  - <img src={require("../../unit/18.png").default} width='18%' />
- 支持分子动力学轨迹动画