---
sidebar_position: 4
title: MatPL 案例实操
slug: /Models
---
# MATPL
👉[开源仓库地址](https://github.com/LonxunQuantum/PWMLFF)

包括 `8` 种具有平移、旋转和置换不变性的特征类型
```
        1. 2-body(2b)
        2. 3-body(3b)
        3. 2-body Gaussian(2b gauss)
        4. 3-body Cosine(3b cos)
        5. Moment Tensor Potential(MTP)
        6. Spectral Neighbor Analysis Potential(SNAP)
        7. DP-Chebyshev(dp1)
        8. DP-Gaussian(dp2)
```

`4` 种训练模型
```
        1. Linear
        2. Neural Network(NN)
        3. DP se_e2_a(Pytorch)
        4. Neuroevolution Potential(NEP)
```
`2` 种高效的训练优化器
```
        1. Adaptive Moment Estimation (ADAM)
        2. Reorganized Layer Extended Kalman Filtering (LKF)
```
<!-- 
:::tip

Linear model 中需指定 feature type 生成 descriptor，针对实际训练选择需要在 optimizer 中写不同训练组分的 weight；

NN model 与 linear model 相似，需要指定 feature type 生成 descriptor，区别在于增加了 fitting net 与具体的 optimizer(如 Adam, LKF)；

DP model 的 fitting net, optimizer 与 NN model 一致，区别在于 descriptor 通过 embedding net 处理，不需要指定 feature type。

**除此之外，dp model 产生目前有两种力场导出方式，一种是通过`PWMLFF extract_ff`命令导出(程序默认导出, `*.ff`)，另一种是通过`PWMLFF script`命令导出（手动导出，根据使用 gpu/cpu 版本 lammps，`*.pt`）。前者为旧版力场文件，对应需要编译不同的 lammps 版本，该版本与 Linear/NN model 一致。后者为 libtorch 版本，目前仅适用于 DP model。**

::: -->
