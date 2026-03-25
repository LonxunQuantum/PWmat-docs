---
sidebar_position: 1
title: 安装手册
---
# 安装手册

## 离线和在线安装

MatPL-2026.3 提供了 [离线安装](./Installation-offline.md) 和 [在线安装](./Installation-online.md) 两种方式。相比于在线安装，离线安装将 Python 运行环境做了整体打包，用户不必要花费长时间去安装 python 运行环境。

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户、`龙讯一体机用户`，我们已经做了预装，只需要加载即可使用，加载方式如下所示。

:::tip
MatPL-2026.3 相比于MatPL-2025.3 核心区别是对 NEP 做了极致优化。在训练上，针对单卡，我们优化了梯度算子，单卡相比 MatPL2025.3版本 训练速度`提升3倍以上`。并且，引入了多节点多卡的大batch训练，并缓解了大batch训练时的精度下降问题，让大规模的训练集训练效率得到`巨幅提升`。

因此对纯CPU训练或者模拟没有收益，这里不提供 MatPL-2026.3 CPU 版本的在线或者离线安装包支持。纯CPU用户请使用 [MatPL-2025.3-cpu](http://doc.lonxun.com/2025.03/MatPL/install/) 即可。
:::

### 龙讯超算云(Mcloud)用户

``` bash
#加载 MatPL
source /share/app/MATPL/MatPL-2026.3/env.sh

#或者采用以下方式分步加载
#step1. 加载 python 运行环境
# 加载conda
module load conda/3-2020.07
eval "$(conda shell.bash hook)"
# 激活python环境
conda activate matpl-2026.3
#step2. 加载MatPL
module load matpl/2026.3
```

```bash
#加载 lammps
module load lammps4matpl/2026.3
#对于 Linear 和 NN 模型的lammps 接口，我们提供了 cpu 版本的接口，使用fortran 实现，请加载
module load lammps4matpl/fortran
```

### 龙讯一体机(GPU)用户

``` bash
#加载 MatPL 和 lammps
module load intel/2020 cuda/11.8
source /share/app/MATPL/MatPL-2026.3/matpl-env.sh
```

```bash
#对于 Linear 和 NN 模型的lammps 接口，我们提供了 cpu 版本的接口，使用fortran 实现，请加载
module load intel/2020
source /share/app/MATPL/MatPL-2026.3/matpl-fortran-env.sh
```

### 龙讯一体机(CPU)用户

本次版本升级对纯 CPU 训练或者模拟没有收益，所以不提供 MatPL-2026.3 CPU 版本的在线或者离线安装包支持。纯CPU用户请使用 [MatPL-2025.3](http://doc.lonxun.com/2025.03/MatPL/install/)。


:::tip
`mcloud 超算平台 lammps4matpl/2026.3` 还预装了 cmake/presets/most.cmake 中指定的所有包

`AMOEBA`   `ASPHERE`   `BOCS`   `BODY`   `BPM`   `BROWNIAN`   `CG-DNA`   `CG-SPICA`   `CLASS2`   `COLLOID`   `COLVARS`   `COMPRESS`   `CORESHELL`   `DIELECTRIC`   `DIFFRACTION`   `DIPOLE`   `DPD-BASIC`   `DPD-MESO`   `DPD-REACT`   `DPD-SMOOTH`   `DRUDE`   `ELECTRODE`   `EFF`   `EXTRA-COMPUTE`   `EXTRA-DUMP`   `EXTRA-FIX`   `EXTRA-MOLECULE`   `EXTRA-PAIR`   `FEP`   `GRANULAR`   `INTERLAYER`   `KSPACE`   `LEPTON`   `MACHDYN`   `MANYBODY`   `MC`   `MEAM`   `MESONT`   `MISC`   `ML-IAP`   `ML-POD`   `ML-SNAP`   `MOFFF`   `MOLECULE`   `OPENMP`   `OPT`   `ORIENT`   `PERI`   `PHONON`   `PLUGIN`   `POEMS`   `QEQ`   `REACTION`   `REAXFF`   `REPLICA`   `RIGID`   `SHOCK`   `SPH`   `SPIN`   `SRD`   `TALLY`   `UEF`   `VORONOI`   `YAFF`

您可以通过`lmp -h` 输出所有编译通过的pairstyle.

离线包默认安装了 basic.cmake 中的包（如需要其他功能，请在安装完毕MatPL-2026.3 离线包后进入离线包的 MatPL-2026.3/lammps-2026.3 目录下自行构建安装）.
:::
