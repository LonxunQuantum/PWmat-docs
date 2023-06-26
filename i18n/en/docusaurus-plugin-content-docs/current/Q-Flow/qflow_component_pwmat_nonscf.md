# 非自洽计算组件

- 支持自动生成高对称 k 点路径
  - <img src={require("./unit/8.png").default} width='30%' />
- 能带结构计算：必须输入势函数，通常来自之前的 SCF 计算，即连接在自洽计算组件后面，此时仅计算非自洽波函数的本征值，不计算总能。结果处理设置中默认为打开
  - <img src={require("./unit/9.png").default} width='15%' />
- 载流子有效质量计算：选取特定 K 点坐标及特定能带进行计算，结果处理设置中默认为关闭
  - <img src={require("./unit/10.png").default} width='50%' />