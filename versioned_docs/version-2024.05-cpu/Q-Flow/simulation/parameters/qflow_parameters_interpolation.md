---
sidebar_position: 22
---

# k点插值
- 包含该参数的组件：原子轨道投影，非共振拉曼光谱

非共振拉曼光谱打开k点插值时，使用二阶插值方法

## 是否插值
- 可选项：否，普通插值，二阶插值
- 默认值：否
- 相关PWmat参数：DOS_DETAIL

输出不同k点实空间波函数的重叠积分（overlap），用于后续如电子态密度、光吸收性质的k点插值计算。k点插值可用于在有限的DFT计算量基础上模拟多k点计算结果。
普通插值方法要求k点网格中的k1，k2，k3至少有一个方向大于1；二阶插值方法要求k点网格中的k1，k2均大于等于4，k3等于1或大于等于4。若不满足以上要求则k点插值计算没有意义。

## 插值点数
- 默认值：4 * 4 * 4

每个k点周围的插值网格点数