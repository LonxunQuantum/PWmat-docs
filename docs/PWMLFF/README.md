---
sidebar_position: 4
title: PWMLFF
---

# Machine Learning Force Field

PWmat Machine Learning Force Field (PWMLFF) 是一套在 GNU 许可下的开源软件包。我们提供了一套完备的软件、工具以及数据仓库，用于快速生成生成媲美从头算分子动力学（AIMD）的机器学习力场。包括模型训练平台、Lammps分子动力学接口、主动学习平台、数据格式转换工具、数据和模型仓库。您可以通过下列链接访问它们的源码以及使用手册。

## [1. PWMLFF机器学习平台](./Installation.md#pwmlff)

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
        1. Linear Model
        2. Neural Network(NN)
        3. DP se_e2_a(Pytorch)
        4. Neuroevolution Potential(NEP)
```
`2` 种高效的训练优化器
```
        1. Adaptive Moment Estimation (ADAM)
        2. Reorganized Layer Extended Kalman Filtering (LKF)
```

## [2. lammps 接口](./Installation.md#lammps-recompiled-version-for-pwmlff)


👉[开源仓库地址](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/tree/libtorch)

高效的分子动力学仿真软件，无缝集成了PWMLFF的 `DP` 模型（包括type embedding 以及 model compress）和 `NEP` 模型，模拟支持 `CPU(多核)` 以及 `GPU(多卡)` 。对于 `Linear` 和 `NN` 提供了基于 `fortran` 的 CPU 版本 Lammps 接口。

## [3. 主动学习平台](./active%20learning/README.md)


👉[开源仓库地址](https://github.com/LonxunQuantum/PWact)

`PWact` 是开源的基于 PWMLFF 的一套自动化主动学习数据生成平台。它集成了 `PWMLFF`、`Lammps接口`以及常用的`PWMAT`、`VASP`、`CP2K`、`DFTB(PWMAT 集成)`第一性原理软件，能够自动进行计算任务分发、监控、故障恢复、结果收集。通过使用PWact，用户能够低成本、快速地制备覆盖广泛相空间的训练数据集。

## [4. 结构转换工具pwdata](./Appendix-2.md)

👉[开源仓库地址](https://github.com/LonxunQuantum/pwdata)

`pwdata` 是 PWMLFF 的数据预处理工具，可用于提取特征和标签。同时提供`PWmat`、`VASP`、`CP2K`、`Lammps` 间的结构格式转换以及相应的扩胞、晶格缩放、原子位置微扰操作。

## [5. AIMD数据集以及模型仓库](https://github.com/LonxunQuantum/PWMLFF_library)

👉[开源仓库地址](https://github.com/LonxunQuantum/PWMLFF_library)

该数据仓库包含了常见体系的 `AIMD 数据集`、一些已经过充分训练的 `PWMLFF 模型`，便于用户快速复用已有数据集和模型，以及在不同模型之间的横向比较，节省数据制备和模型训练成本。

## [6. PWMLFF Examples](./examples/README.md)

PWMLFF的测试结果以及使用PWMLFF的相关案例


##

<div>
<div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/pmat_support.png").default} alt="user_chat" width="250" />
    <p style={{ textAlign: 'center' }}>PWMAT 客服微信(support@pwmat.com)</p>
</div>
</div>
