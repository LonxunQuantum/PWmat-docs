---
sidebar_position: 3
---

# 截断能

- 包含该参数的组件：结构优化，自洽计算，过渡态计算，分子动力学，含时密度泛函计算，声子模式计算，弹性常数计算，密度泛函微扰计算
- 默认值：
  - 结构优化组件：70
  - 其他组件：50
- 单位：Rydberg（Ryd）
- 相关PWmat参数：ECUT

平面波的截止动能。涉及晶格变化的计算（如结构优化中开启优化晶格时），建议增加截断能到70 Ryd。