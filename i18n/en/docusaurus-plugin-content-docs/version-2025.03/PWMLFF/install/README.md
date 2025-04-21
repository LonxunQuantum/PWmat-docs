---
sidebar_position: 1
title: 安装手册
---

MatPL 提供了 [离线安装](./Installation-offline.md) 和 [在线安装](./Installation-online.md) 两种方式。

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已经做了预装，只需要加载即可使用，加载方式如下所示。

``` bash
# 加载 MatPL
source /share/app/MATPL/MatPL-2025.3/env.sh

# 或者采用以下方式分步加载
# step1. 加载 python 运行环境
source /share/app/anaconda3/etc/profile.d/conda.sh
module load conda/3-2020.07
conda deactivate
conda activate matpl-2025.3
# step2. 加载MatPL
module load matpl/2025.3
```

```bash
# 加载 lammps
module load lammps4matpl/2025.3
# 对于 Linear 和 NN 模型的lammps 接口，我们提供了 cpu 版本的接口，使用fortran 实现，请加载
module load lammps4matpl/fortran
```
lammps 接口已经预装了下列功能 

 - KSPACE
 - MANYBODY
 - REAXFF
 - MOLECULE
 - QEQ
 - REPLICA
 - RIGID
 - MEAM
 - MC
 - MatPL

<!-- :::tip
`离线安装包`中集成了 MatPL 和 lammps 接口，包括` GPU 版本`和 `CPU 版本`两种；

`在线安装`方法提供了` GPU 版本`和` CPU 版本`两种安装方式。
::: -->