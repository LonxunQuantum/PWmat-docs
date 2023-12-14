# 含时密度泛函计算组件

- 支持 NVE 系综：NVE 系综使用*Verlet*方法，此时恒定原子数 N、体积 V 和总能 E
- 支持绝热窗口自动/手动设置：常用设置是 m1 设置为 1 或其他较深能级，mstate 设置为最高占据态（也可大于电子数/2），m2 设置为电子有可能激发到的最高态（可略小于总能带数，以保证计算能够较好的收敛）。关于含时密度泛函计算更多的细节请参考[Manual-TDDFT_DETAIL 部分](http://www.pwmat.com/pwmat-resource/Manual.pdf)
  - <img src={require("./unit/28.png").default} width='50%'/>
- 支持外场
  - <img src={require("./unit/27.png").default} width='56%'/>
- 支持自旋极化体系: 主要针对磁性材料，默认为关闭
  - <img src={require("./unit/1.png").default} width='13%'/>
- 支持弱相互作用修正 DFT-D2、DFT-D3: 针对低维材料，需要考虑范德华(vdW)相互作用
  - <img src={require("./unit/4.png").default} width='30%'/>
- 支持强关联体系 DFT+U: 为指定元素的原子轨道添加 U 值，可以从一些文章中获取
  - <img src={require("./unit/2.png").default} width='40%'/>
- 支持带电体系：体系增减电荷
  - <img src={require("./unit/3.png").default} width='30%'/>