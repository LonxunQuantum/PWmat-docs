---
sidebar_position: 4
title: MatPL
---

# MatPL 简介

`Materials Potential Library (MatPL，原名 PWMLFF，当前版本MatPL-2026.3 )，是一套在 GNU GPL3.0 许可下的开源软件包。` 

MatPL 提供了一套完备的软件、工具以及数据仓库，用于快速生成生成媲美从头算分子动力学（AIMD）的机器学习力场。包括模型训练平台 `MatPL`、`Lammps` 分子动力学接口、主动学习数据生成平台 `pwact`、数据格式转换工具 `pwdata`、数据和模型仓库。您可以通过下列链接访问它们的源码以及使用手册

**[MatPL用户手册下载-MatPL-2026.3 用户手册下载.pdf](./MatPL-2026.3-userdoc.pdf)**

[<kbd>📥 MatPL用户手册下载-MatPL-2026.3用户手册下载.pdf</kbd>](./MatPL-2026.3-userdoc.pdf)

**[1. MatPL机器学习平台](./models/README.md)**

👉[开源仓库地址](https://github.com/LonxunQuantum/MatPL)

MatPL 用于快速训练机器学习力场，这些力场的精度可以与从头算分子动力学（AIMD）相媲美。对于 NEP 力场，支持跨节点多卡大 batchsize 高效训练。

**[2. lammps 接口](./install/README.md)**


👉[开源仓库地址](https://github.com/LonxunQuantum/lammps-MatPL)

高效的分子动力学仿真软件，无缝集成了 MatPL 的 力场模型，并支持GPU加速。尤其是对于 NEP 力场，我们采用了 lammps KOKKOS GPU加速，有非常高的跨节点并行效率，支持超亿级原子的高速模拟（4090单卡模拟规模能到600万原子以上）。

**[3. 主动学习工具 pwact](./pwact/README.md)**


👉[开源仓库地址](https://github.com/LonxunQuantum/PWact)

`PWact` 是开源的基于 MatPL 的一套自动化主动学习数据生成工具。它集成了 `MatPL`、`Lammps接口`以及常用的`PWMAT`、`VASP`、`CP2K`第一性原理软件，能够自动进行计算任务分发、监控、故障恢复、结果收集。通过使用PWact，用户能够低成本、快速地制备覆盖广泛相空间的训练数据集

**[4. 结构转换工具 pwdata](./pwdata/README.md)**

👉[开源仓库地址](https://github.com/LonxunQuantum/pwdata)

`pwdata` 是 MatPL 的数据预处理工具，可用于提取特征和标签。同时提供`PWmat`、`VASP`、`CP2K`、`Lammps` 间的结构格式转换以及相应的扩胞、晶格缩放、原子位置微扰操作

<!-- ## [5. AIMD数据集以及模型仓库](https://github.com/LonxunQuantum/MatPL_library)

👉[开源仓库地址](https://github.com/LonxunQuantum/MatPL_library)

该数据仓库包含了常见体系的 `AIMD 数据集`、一些经过 `MatPL` 充分训练的力场模型，便于用户快速复用已有数据集和模型，以及在不同模型之间的横向比较和切换，节省数据制备和模型训练成本。 -->

**[5. MatPL Examples](./examples/README.md)**

MatPL 的测试结果以及使用 MatPL 的相关案例

<!-- **客服邮箱 support@pwmat.com** -->