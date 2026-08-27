---
sidebar_position: 4
title: MatPL
---

# Introduction to MatPL

`Materials Potential Library (MatPL, formerly PWMLFF; current version: MatPL-2026.3) is an open-source software package distributed under the GNU GPL 3.0 license.`

MatPL provides a comprehensive collection of software, tools, and data repositories for rapidly developing machine-learning force fields with accuracy comparable to ab initio molecular dynamics (AIMD). The ecosystem includes the `MatPL` model-training platform, a `LAMMPS` molecular-dynamics interface, the `pwact` active-learning data-generation platform, the `pwdata` format-conversion tool, and repositories for data and models. Use the links below to access their source code and documentation.

**[Download the MatPL User Manual from Gitee](https://gitee.com/pfsuo/PWmat-docs/blob/master/i18n/en/docusaurus-plugin-content-docs/current/MatPL/MatPL-2026.3-userdoc-EN.pdf) or [download it from GitHub](https://github.com/LonxunQuantum/PWmat-docs/blob/master/i18n/en/docusaurus-plugin-content-docs/current/MatPL/MatPL-2026.3-userdoc-EN.pdf)**

MatPL is also available as a free [`open-source machine-learning force-field application`](https://scnet.cn/ui/mall/detail/goods?type=software&shopId=1717790158329552898&common1=APP_SOFTWARE&id=2074441100162269185&resource=APP_SOFTWARE&keyword=MatPL) on the National Supercomputing Internet platform.

**[1. MatPL Machine-Learning Platform](./models/README.md)**

👉[Source repository](https://github.com/LonxunQuantum/MatPL)

MatPL rapidly trains machine-learning force fields with accuracy comparable to AIMD. NEP models support efficient large-batch training across multiple GPUs and compute nodes.

**[2. LAMMPS Interface](./install/README.md)**


👉[Source repository](https://github.com/LonxunQuantum/lammps-MatPL)

This high-performance molecular-dynamics interface integrates MatPL force-field models with GPU acceleration. The NEP interface uses LAMMPS KOKKOS acceleration, provides excellent multi-node parallel efficiency, and supports simulations with more than one hundred million atoms. A single RTX 4090 can handle systems containing more than six million atoms.

**[3. PWact Active-Learning Tool](./pwact/README.md)**


👉[Source repository](https://github.com/LonxunQuantum/PWact)

`PWact` is an open-source MatPL-based platform for automated active-learning data generation. It integrates `MatPL`, the `LAMMPS interface`, and widely used first-principles packages such as `PWmat`, `VASP`, and `CP2K`. PWact automates job dispatch, monitoring, fault recovery, and result collection, enabling users to generate training datasets that cover broad regions of phase space quickly and cost-effectively.

**[4. PWdata Structure-Conversion Tool](./pwdata/README.md)**

👉[Source repository](https://github.com/LonxunQuantum/pwdata)

`pwdata` is MatPL's data-preprocessing tool for extracting features and labels. It converts structure formats among `PWmat`, `VASP`, `CP2K`, and `LAMMPS`, and supports supercell construction, lattice scaling, and atomic-position perturbation.

<!-- ## [5. AIMD Dataset and Model Repository](https://github.com/LonxunQuantum/MatPL_library)

👉[Source repository](https://github.com/LonxunQuantum/MatPL_library)

This repository contains `AIMD datasets` for common systems and force-field models extensively trained with `MatPL`. Users can quickly reuse existing datasets and models, compare different models, and switch among them while reducing the cost of data preparation and model training. -->

**[5. MatPL Examples](./examples/README.md)**

Test results and application examples for MatPL.

**[MatPL Citation](https://chemrxiv.org/doi/full/10.26434/chemrxiv.15001665)**

https://chemrxiv.org/doi/full/10.26434/chemrxiv.15001665

<!-- **Support: support@pwmat.com** -->
