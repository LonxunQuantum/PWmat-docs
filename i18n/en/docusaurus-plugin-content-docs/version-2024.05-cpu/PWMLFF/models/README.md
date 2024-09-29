---
sidebar_position: 2
title: Models
slug: /Models
---
👉[Open source repository](https://github.com/LonxunQuantum/PWMLFF)

It includes `8` feature types with translational, rotational, and permutation invariance:
```
        1. 2-body(2b)
        2. 3-body(3b)
        3. 2-body Gaussian(2bgauss)
        4. 3-body Cosine(3bcos)
        5. Moment Tensor Potential(MTP)
        6. Spectral Neighbor Analysis Potential(SNAP)
        7. DP-Chebyshev(dp1)
        8. DP-Gaussian(dp2)
```

`4` training models:
```
        1. Linear Model
        2. Deep Neural Netowrk (NN)
        3. DP-torch Network (DP) with model compress and type embedding
        4. Neuro evolution potentail(NEP)
```
`2` efficient training optimizers:
```
        1. Adaptive Moment Estimation (ADAM)
        2. Reorganized Layer Extended Kalman Filtering (LKF)
```
