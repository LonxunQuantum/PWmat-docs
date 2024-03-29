---
sidebar_position: 3
---

# 原子轨道投影、振子强度计算组件

- k 点插值，支持普通插值、二阶插值方法：自洽计算组件中不能设置 k 点并行，并在原子轨道投影组件中设置是否插值
  - <img src={require("../../unit/11.png").default} width='40%'/>
- 态密度计算，包含总态密度、分波态密度、局域态密度、部分原子态密度：使用 k 点插值时，可以得到平滑的态密度曲线，此时原子轨道投影组件中设置为普通插值
- 高频介电函数、反射率、吸收系数、折射率、消光系数计算：计算光学性质，原子轨道投影组件使用普通插值；或者结合振子强度计算组件设置二阶插值，对介电函数进行修正
  - <img src={require("../../unit/12.png").default} width='40%'/>
- 贝里相位计算：一种计算离子钳位极化的方法，需要原子轨道投影组件结合振子强度计算组件，并在原子轨道投影组件中设置打开
  - <img src={require("../../unit/13.png").default} width='20%'/>