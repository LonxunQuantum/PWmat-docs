---
sidebar_position: 16
---

# 电极能带计算及连接组件

该组件为PWmat Transport工作流类型第二个组件，必须连接在电势计算及拼接组件之后。

该组件计算左、右元电极的能带结构，进行波函数插值，并将不同 K 点的能带连接起来，最后计算 evanescent state。

如果特殊 K 点选取方式为撒点，则在倒空间ky,kz平面内撒点，在每个生成 K 点上沿输运方向生成K点路径，并分别计算左、右元电极的能带结构。如果特殊 K 点选取方式为单点，则只根据单点沿输运方向生成K点路径，并分别计算左、右元电极的能带结构。

该组件生成各K点能带结构及所有可能的evanescent state。
