---
sidebar_position: 4
title: MatPL 案例实操
slug: /Models
---
# MatPL 案例实操

👉[开源仓库地址](https://github.com/LonxunQuantum/MatPL)

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
        4. Neuroevolution Potential(NEP) (支持跨节点多卡训练以及大规模超快 lammps MD)
```
`2` 种高效的训练优化器
```
        1. Adaptive Moment Estimation (ADAM)
        2. Reorganized Layer Extended Kalman Filtering (LKF)
```