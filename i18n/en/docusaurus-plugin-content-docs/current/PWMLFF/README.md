---
sidebar_position: 4
title: PWMLFF
---
# Machine Learning Force Field

PWmat Machine Learning Force Field (PWMLFF) is an open-source software package under the GNU license. We provide a comprehensive set of software, tools, and data repositories for rapidly generating machine learning force fields that rival ab initio molecular dynamics (AIMD). This includes a model training platform, Lammps molecular dynamics interface, active learning platform, data format conversion tools, and data and model repositories. You can access their source code and user manuals through the following links.

## [1. PWMLFF Machine Learning Platform](./Installation.md)

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
        1. Linear
        2. Neural Netowrk (NN)
        3. DP se_e2_a(Pytorch)
        4. Neuroevolution Potential(NEP)
```
`2` efficient training optimizers:
```
        1. Adaptive Moment Estimation (ADAM)
        2. Reorganized Layer Extended Kalman Filtering (LKF)
```

## [2. Lammps Interface](./Installation.md#lammps-for-pwmlff-compilation-and-installation)

👉[Open source repository](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/tree/libtorch)

An efficient molecular dynamics simulation software that seamlessly integrates PWMLFF's DP and NEP models (including type embedding and model compress). It supports simulation on both `CPU` and `GPU (multi-GPUs)`. For `Linear` and `NN`, a `Fortran`-based CPU version of the Lammps interface is provided.

## [3. Active Learning Platform](./active%20learning/README.md)


👉[Open source repository](https://github.com/LonxunQuantum/PWact)

`PWact` is an open-source automated active learning platform based on PWMLFF. It integrates PWMLFF, Lammps interface, and commonly used first-principles software such as `PWMAT`, `VASP`, `CP2K`, and `DFTB (integrated with PWMAT)`. It automates tasks such as job distribution, monitoring, fault recovery, and result collection. By using PWact, users can prepare training datasets that cover a wide phase space at a low cost and quickly.

## [4. Structure Transformation Tool pwdata](./Appendix-2.md)

👉[Open source repository](https://github.com/LonxunQuantum/pwdata)

`pwdata` is the data preprocessing tool for PWMLFF, used for feature and label extraction. It also provides structure format conversion between `PWmat`, `VASP`, `CP2K`, and `Lammps`, as well as operations such as supercell, lattice scaling, and atomic position perturbation.

## [5. AIMD Dataset and Model Repository](https://github.com/LonxunQuantum/PWMLFF_library)

👉[Open source repository](https://github.com/LonxunQuantum/PWMLFF_library)

This data repository contains `AIMD datasets` for common systems, pre-trained `PWMLFF models`, and information about training accuracy. It allows users to quickly reuse existing datasets and models, compare them across different models, and `save data preparation and model training costs`.

## [6. PWMLFF Examples](./examples/README.md)

Some test work done using PWMLFF, as well as published papers using PWMLFF.


##

<div>
<div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/pmat_support.png").default} alt="user_chat" width="250" />
    <p style={{ textAlign: 'center' }}>PWMAT 客服微信(support@pwmat.com)</p>
</div>
</div>
