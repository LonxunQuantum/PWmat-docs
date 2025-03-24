---
sidebar_position: 1
title: compress model
---

# compress model

The number of Embedding net networks in the DP model is $N^2$ times the number of atom types $N$. As the number of atom types increases, the number of Embedding net networks will rapidly increase, leading to a larger computational graph for backpropagation, which becomes one of the bottlenecks for inference in the DP model. The time statistics for the inference process of a quinary alloy system in the DP model show that the time spent on Embedding net computation and gradient calculation accounts for over 90% of the total time, indicating significant optimization potential.

The input to the Embedding net is a single value of $S_{ij}$, and the output is a set of $m$ values (where $m$ is the number of neurons in the last layer of the Embedding net). Therefore, the Embedding net can be replaced by $m$ single-value functions. Here, we implement the [fifth-order polynomial](#5order_cmp) compression method described in the paper [DP Compress](https://pubs.acs.org/doi/10.1021/acs.jctc.2c00102?fig=fig3&ref=pdf), and we also provide the option of using the [third-order polynomial](#3order_cmp) compression method based on Hermite interpolation. In our tests, when the grid size $dx=0.001$, both the third-order and fifth-order polynomial compression methods achieve the same accuracy. Detailed test data can be found in the [performance test](#cmp_time).

![proportion_time](./picture_wu/proportion_time_inference.png)

## Usage

To compress a trained DP model, the complete model compression command is as follows：

```json
PWMLFF compress dp_model.ckpt -d 0.01 -o 3 -s cmp_dp_model
```

- "compress" is the command for compression.
- "dp_model.ckpt" is the name of the model file to be compressed and is a required parameter.
- -d specifies the grid partition size for $S_{ij}$. The default value is 0.01.
- -o determines the order of model compression. Use 3 for third-order model compression and 5 for fifth-order model compression. The default value is 3.
- -s sets the name of the compressed model. The default name is "cmp_dp_model".

After compressing the model, you can use it in molecular dynamics simulations in LAMMPS using the same approach as the standard [DP model](./examples/Cu.md).

## performance test{#cmp_time}

<!--
 type embedding的模型压缩还没有加入到lammps中，所以先不写
 -->

### Model Compression Accuracy

We performed model compression on the DP model for both bulk copper and a quinary alloy system, and conducted tests on a valid set. The results are shown in the following figure. For the copper system, we included a comparison of accuracy using second-order interpolation, and it was found that the accuracy of the second-order method did not meet the required standards when compared to the third-order and fifth-order methods.

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/compress/cu_compress_dp_valid_abs_error.png").default} alt="cu_compress_dp_valid_abs_error" width="500" />
      <p>Fig 1. Comparison of 2-order, 3-order, and 5-order polynomial compression in the DP model of Bulk copper system</p>
    </td>
    <td>
      <img src={require("./picture_wu/compress/alloy_compress_dp_valid_abs_error.png").default} alt="alloy_compress_dp_valid_abs_error" width="400" />
      <p>Fig 2. Comparison of 3-order and 5-order polynomial compression in the DP model of a five element alloy system</p>
    </td>
  </tr>
</table>

<!-- #### 不同的 dx 计算时间开销统计？ -->

### speed

<!-- #### embedding net 和 grad 速度提升？ -->

We conducted a statistical analysis of the inference time for the DP model with 3-order polynomial compression and the uncompressed model on the entire valid set of the quinary alloy system. After applying polynomial compression, there was a noticeable reduction in the time required for backpropagation (autograd). This is because the polynomial method significantly reduces the size of the computational graph for the Embedding net during automatic differentiation in PyTorch.


<table>
  <tr>
    <td>
      <img src={require("./picture_wu/compress/alloy_compress_forward_time.png").default}  alt="alloy_compress_forward_time" width="400" />
      <p>Fig 1. Comparison between with 3-order polynomial compression (dx=0.01) and uncompressed DP model for the quinary alloy system</p>
    </td>
  </tr>
</table>

<!-- #### 在 Lammps 中的速度提升 -->

## The compression process of 3-order polynomial{#3order_cmp}

### Grid partitioning of $S_{ij}$

We scan the entire training set to obtain the maximum value of $s_{ij}$. Since $s_{ij}$ is a function of the 3-dimensional coordinate distance $r_{ij}$ between atom $i$ and $j$, we take the minimum value when $r_{ij} = r_{cut}$. Based on the range of $s_{ij}$, we divide it into $L$ equal parts with a spacing of $dx$, resulting in a total of $l+1$ interpolation points denoted as $x_1, x_2, \ldots, x_{l+1}$. In practical usage, due to the incompleteness of the training set, there may be some $s_{ij}$ values that exceed the range of the training set. In this case, we extend the grid beyond the aforementioned range and add $s_{ij}$ values up to $10\times s_{ij}$, with a grid size of $10 \times dx$.

### 3-order polynomial

For each interval $[x_l, x_{l+1})$, the Embedding net is replaced by the following third-order polynomial

$$
g^l_m(x)=a^l_mx^3 + b^l_mx^2 + c^l_mx + d^l_m
$$

Here, $m$ represents the number of neurons in the last layer of the Embedding net, which is the number of output values of the Embedding net. The $x = s_{ij}-x_l, s_{ij} \in [x_l, x+{l+1})$. At each grid point, the following 2 conditions need to be satisfied.
The polynomial values are consistent with the output values of the Embedding net.
$$
y_l = G_m(x_l)
$$
The first derivative of the polynomial is consistent with the first derivative of the Embedding net with respect to $S_{ij}$.
$$
y'_l = G'_m(x_l)
$$
The corresponding coefficients are determined as a result.
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
Where $h=y_{l+1}-y_l$ and $\Delta t=x_{l+1}-x_l$.

### 5-order polynomial{#5order_cmp}

We have also implemented the 5-order polynomial compression method described in [DP Compress](https://pubs.acs.org/doi/10.1021/acs.jctc.2c00102?fig=fig3&ref=pdf).

For the 5-order polynomial, the partitioning method for $S_{ij}$ is the same as the 5-order method, and the following polynomial is used to replace the Embedding net
$$g^l_m(x)=a^l_mx^5+b^l_mx^4+c^l_mx^3+d^l_mx^2+e^l_mx+f^l_m$$

Here, $m$ represents the number of neurons in the last layer of the Embedding net, which is the number of output values of the Embedding net. The $x = s_{ij}-x_l, s_{ij} \in [x_l, x+{l+1})$. At each grid point, the following 3 conditions need to be satisfied.

The value of the polynomial should be consistent with the output of the Embedding net.

$$y_l=\mathcal{G}_m(x_l)$$

The first derivative of the polynomial is consistent with the first derivative of the Embedding net with respect to $S_{ij}$.

$$y'_l=\mathcal{G}'_m(x_l)$$

The second derivative of the polynomial should match the second derivative of the Embedding net with respect to $S_{ij}$.

$$y''_l=\mathcal{G}''_m(x_l)$$

Consequently, we obtain 6 coefficient values, which are as follows.

$$a^l_m=\frac{1}{2\Delta t^5}[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]$$

$$b^l_m=\frac{1}{2\Delta t^4}[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]$$

$$c^l_m=\frac{1}{2\Delta t^3}[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]$$

$$d^l_m=\frac{1}{2}y''_l$$

$$e^l_m=y'_l$$

$$f^l_m=y_l$$

Where $h=y_{l+1}-y_l$ and $\Delta t=x_{l+1}-x_l$