---
sidebar_position: 1
title: compress model
---

# 模型压缩

DP 模型的 Embedding net 网络数目是原子类型数目$N$的$N^2$倍，随着原子类型增多，Embedding net 数目会快速增加，导致用于反向传播求导的计算图的规模会增加，成为 DP 模型做推理的瓶颈之一。如下我们对于一个五元合金系统在 DP 模型的推理过程的时间统计所示，对于 Embedding net 计算以及梯度计算的时间占比超过 90%，这存在大量的优化空间。Embedding net 的输入为一个$S_{ij}$的单值，输出为$m$个值（$m$为 Embedding net 最后一层神经元数目）。因此，可以将 Embedding net 通过$m$个单值函数代替。我们在这里实现论文[DP Compress](https://pubs.acs.org/doi/10.1021/acs.jctc.2c00102?fig=fig3&ref=pdf)中使用的[五阶多项式](#5order_cmp)压缩方法，同时我们也提供了基于 Hermite 插值方法的[三阶多项式](#3order_cmp)压缩方法供用户自由选择。在我们的测试中，当网格大小 $dx=0.001$ 时，三阶多项式与五阶多项式能够达到相同的精度，详细测试数据见[性能测试](#cmp_time)。

![proportion_time](./picture_wu/proportion_time_inference.png)

## 使用方法

对于一个训练后 DP 模型做模型压缩，完整的模型压缩指令如下：

```json
PWMLFF compress dp_model.ckpt -d 0.01 -o 3 -s cmp_dp_model
```
* compress 是压缩命令
* dp_model.ckpt为待压缩模型文件名称，为必须要提供的参数
* -d 为S_ij 的网格划分大小，默认值为0.01
* -o 为模型压缩阶数，3为三阶模型压缩，5为五阶模型压缩，默认值为3
* -s 为压缩后的模型名称，默认名称为“cmp_dp_model”

模型压缩之后，在 lammps 中做分子动力学模拟使用方式与标准的[DP 模型](../dp/examples/Cu)相同。

## 性能测试{#cmp_time}

<!--
 type embedding的模型压缩还没有加入到lammps中，所以先不写
 -->

### 模型压缩精度

我们在 Bulk 铜和五元合金体系上对 DP 模型做了模型压缩，并在测试集上分别做了测试。结果如下图中所示，对于铜体系，我们加入了对二阶插值方法的精度对比，相比于三阶和五阶方法，二阶方法的精度达不到要求。

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/compress/cu_compress_dp_valid_abs_error.png").default} alt="cu_compress_dp_valid_abs_error" width="500" />
      <p>图1: Bulk铜体系DP模型二阶、三阶与五阶多项式压缩对比</p>
    </td>
    <td>
      <img src={require("./picture_wu/compress/alloy_compress_dp_valid_abs_error.png").default} alt="alloy_compress_dp_valid_abs_error" width="400" />
      <p>图2: 五元合金体系DP模型三阶与五阶多项式压缩对比</p>
    </td>
  </tr>
</table>

<!-- #### 不同的 dx 计算时间开销统计？ -->

### 推理速度

<!-- #### embedding net 和 grad 速度提升？ -->

我们统计了五元合金体系下 DP 模型三阶多项式压缩以及未压缩时，在整个测试集上的推理时间。经过多项式压缩后明显减少了反向求导（autograd）时间，这是因为多项式方法能够显著减少 Embedding net 在 pytorch 自动求导时的计算图大小。

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/compress/alloy_compress_forward_time.png").default}  alt="alloy_compress_forward_time" width="400" />
      <p>图1: 五元合金体系三阶多项式压缩（dx=0.01）与未压缩对比</p>
    </td>
  </tr>
</table>

<!-- #### 在 Lammps 中的速度提升 -->

## 三阶多项式模型压缩过程{#3order_cmp}

### 网格划分

我们扫描全部训练集，得到$s_{ij}$的最大值，由于$s_{ij}$是原子$i$和$j$的三维坐标距离$r_{ij}$函数，当$r_{ij}$ = $r_cut$时取最小值。根据$s_{ij}$取值范围按照$dx$值等分为$L$份，则共有$l+1$个插值点，分别记为$x_1,x_2,\cdots,x_l+1$。在实际的使用中，由于训练集的不完备，可能存在一些$s_{ij}$值超出训练集之外，这里我们在上述网格之外，继续增加了$s_{ij}$到$ 10\times s\_{ij}$的网格，网格大小设置为$ 10 \times dx$。

### 三阶多项式

对于每个$[x_l,x_{l+1})$区间，采用如下的三阶多项式替代 Embedding net:

$$
g^l_m(x)=a^l_mx^3 + b^l_mx^2 + c^l_mx + d^l_m
$$

这里$m$为 Embedding net 最后一层神经元数量，即 Embedding net 输出值数目，多项式的自变量$x$值应为$s_{ij}-x_l$。在每个网格点上，都需要满足如下两个限定条件。
在每个网格点上限制如下条件。
多项式值与 Embedding net 输出值一致：

$$
y_l = G_m(x_l)
$$

多项式一阶导数与 Embedding net 对$S_{ij}$的一阶导一致：

$$
y'_l = G'_m(x_l)
$$

解得对应系数为

$$
    a^l_m=\frac{1}{\Delta t^3}[(y'_{l+1} + y'_l)\Delta t - 2h]
$$

$$
    b^l_m=\frac{1}{\Delta t^2}[-(y'_{l+1} + 2y'_l)\Delta t + 3h]
$$

$$
    c^l_m=y'_l
$$

$$
    d^l_m=y_l
$$

### 五阶多项式{#5order_cmp}

我们也实现了[DP Compress](https://pubs.acs.org/doi/10.1021/acs.jctc.2c00102?fig=fig3&ref=pdf)中的五阶多项式压缩方法。

对于五阶多项式，对$S_{ij}$的划分方法与五阶方法相同，采用如下的多项式代替 Embedding net：
$$g^l_m(x)=a^l_mx^5+b^l_mx^4+c^l_mx^3+d^l_mx^2+e^l_mx+f^l_m$$

注意：此时多项式的自变量$x$值应为$s_{ij}-x_l$。在每个网格点上，都需要满足如下三个限定条件。

多项式值与 Embedding net 输出值一致：
$$y_l=\mathcal{G}_m(x_l)$$

多项式一阶导数与 Embedding net 对$S_{ij}$的一阶导一致：
$$y'_l=\mathcal{G}'_m(x_l)$$

多项式二阶导数与 Embedding net 对$S_{ij}$的二阶导一致：
$$y''_l=\mathcal{G}''_m(x_l)$$

由此可得六个系数值分别为：

$$a^l_m=\frac{1}{2\Delta t^5}[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]$$

$$b^l_m=\frac{1}{2\Delta t^4}[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]$$

$$c^l_m=\frac{1}{2\Delta t^3}[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]$$

$$d^l_m=\frac{1}{2}y''_l$$

$$e^l_m=y'_l$$

$$f^l_m=y_l$$

其中 $h=y_{l+1}-y_l$，$\Delta t=x_{l+1}-x_l$
