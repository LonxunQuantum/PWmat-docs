---
sidebar_position: 2
---

# k点并行

- 包含该参数的组件：结构优化，自洽计算，过渡态计算，分子动力学，含时密度泛函计算，声子模式计算，弹性常数计算，非共振拉曼光谱，密度泛函微扰计算，晶格热导率
- 默认值：否
- 相关PWmat参数：NODE1，NODE2

是否开启k点并行。对于大体系少k点的计算建议关闭；小体系同时k点远大于加速卡数量的计算建议开启。当打开此选项时，若k点数量并非远大于加速卡数量且无法被加速卡数量整除，则会自动关闭k点并行。
