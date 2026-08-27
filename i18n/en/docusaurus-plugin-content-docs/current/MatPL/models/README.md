---
sidebar_position: 4
title: MatPL Tutorials
slug: /Models
---
# MatPL Tutorials

👉[Source repository](https://github.com/LonxunQuantum/MatPL)

MatPL includes `8` descriptor types with translational, rotational, and permutational invariance:
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

`4` trainable model types:
```
        1. Linear
        2. Neural Network(NN)
        3. DP se_e2_a(Pytorch)
        4. Neuroevolution Potential (NEP) (supports multi-GPU, multi-node training and ultra-fast large-scale LAMMPS MD)
```
`2` efficient training optimizers:
```
        1. Adaptive Moment Estimation (ADAM)
        2. Reorganized Layer Extended Kalman Filtering (LKF)
```
