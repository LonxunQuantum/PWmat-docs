---
sidebar_position: 3
title: PWact for Active Learning
---

# 主动学习

机器学习力场（Machine learning force filed，MLFF）相比于传统方法，能够更快和精确地预测材料性质和反应机理，当前最先进的基于深度学习的分子动力学已经能够做到百亿原子体系的模拟。但是由于机器学习方法的插值特性，对于训练集之外的相空间，MLFF 很难做出准确预测。由于训练数据通常是使用昂贵的第一性原理计算生成的，现实中很难获取到大量的从头算数据集，生成具有足够代表性的训练数据但不依赖大量从头算数据，对于提升模型的外推能力至关重要。[PWact](https://github.com/LonxunQuantum/PWact) (Active learning based on PWmat Machine Learning Force Field) 是开源的基于 PWMLFF 的一套自动化主动学习平台，用于高效的数据采样。

# PWact

PWact 平台包含主任务和任务分发器两部分，如 [结构图](#Arch_design_slurm) 所示。

主任务包括 `预训练数据制备` 以及 `主动学习` 两个模块。负责预训练数据制备和主动学习过程中的计算任务生成、以及结果收集。任务分发器接收到任务调度请求之后，根据计算资源使用状态以及任务申请资源情况将任务调度到对应的计算节点上，待任务执行完毕之后，收集计算节点的执行结果返回给主任务程序。

![Arch_design_slurm](../models/dp/picture_wu/active_learning/Arch_design_slurm_zh.png)

### 预训练数据制备模块

包括驰豫 `(支持 PWmat、VASP、CP2k和DFTB)`、阔胞、缩放晶格、微扰以及运行 MD `(支持 PWmat、VASP、CP2k和DFTB)` 四个模块，并支持对这些模块的组合使用。

### 主动学习模块

![active_sampling](../models/dp/picture_wu/active_learning/active_arch_zh.png)

包括`训练`、`构型探索`以及`标注`模块。首先，训练模块做模型训练；之后将训练好的模型送入探索模块。探索模块调用力场模型做分子动力学模拟，模拟结束后把得到的分子运动轨迹送入查询器做不确定性度量；查询完成后，把待标注构型点送入标注模块；最后标注模块做自洽计算，得到能量和力，作为标签与对应构型一起送入已标注数据库中；重复上述步骤，直到收敛。

    1. 对于模型训练，我们这里支持 PWMLFF 中的 DP model、DP model with compress 以及 DP model with type embedding。

    2. 对于不确定性度量，提供了常用了基于多模型委员会查询的方法，并且也提供了我们最新设计的 单模型的基于卡尔曼滤波的不确定性度量方法 KPU (Kalman Prediction Uncertainty, KPU)。该方法能够在接近委员会查询精度的情况下，将模型训练的计算开销减少到 1/N, N为委员会查询模型数量，欢迎用户尝试。

    3. 对于标注，支持 PWmat、VASP、CP2k和DFTB。

# 依赖应用

1. PWact 作业调度采用 [SLURM](https://slurm.schedmd.com/documentation.html) 集群管理和作业调度系统，需要您的计算集群上已安装 SLURM。

2. PWact 的 DFT 计算支持 [PWmat](https://www.pwmat.com/gpu-download) 、[VASP](https://www.vasp.at/)、 [CP2K](https://www.cp2k.org/)和DFTB，需要您的计算机群已安装PWMAT、VASP或CP2K。对于DFTB, 我们已经在 PWMAT 中集成了 DFTB，您可以在[`PWMAT手册的DFTB_DETAIL章节`](http://www.pwmat.com/pwmat-resource/Manual_cn.pdf)查看详细使用说明([`集成了DFTB的PWmat版本下载地址`](https://www.pwmat.com/modulefiles/pwmat-resource/mstation-download/cuda-11.6-mstation-beta.zip))。

3. PWact 模型训练基于 [PWMLFF](https://github.com/LonxunQuantum/PWMLFF) , PWMLFF 安装方式参考 [PWMLFF 文档](http://doc.lonxun.com/PWMLFF/Installation)。

4. PWact Lammps 分子动力学模拟 基于 [Lammps_for_pwmlff](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/tree/libtorch)，安装方式参考 [Lammps_for_pwmlff 文档](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/blob/libtorch/README)。

# 安装流程

PWact 支持pip 命令安装与源码安装两种安装方式。

### 1.pip 命令安装
```bash
    pip install pwact
```

### 2. github源码安装
源码下载
```bash
git clone https://github.com/LonxunQuantum/PWact.git
```

源码下载后，您可以通过加载如下环境变量的方式使用 `pwact` 命令，这里`~/codespace/al_pwmlff` 为您的源码文件路径
```bash
export PATH=~/codespace/al_pwmlff/pwact/bin:$PATH
```

PWact 开发语言采用 Python ，支持 Python 3.9 以及以上的版本。建议用户直接使用 PWMLFF 的 [Python 运行环境](http://doc.lonxun.com/PWMLFF/Installation) 即可。

如果您需要为 PWact 单独创建虚拟环境，只需要安装以下依赖包即可（与您的 Python 版本相匹配， 支持Python 3.9 以及以上）。
```bash
    pip install numpy pandas tqdm pwdata
```


# 命令列表

PWact 包括如下命令，起始命令为`pwact`

### 1. 输出可用命令列表

```bash
pwact  [ -h / --help / help ]
```
您也可以用这条命令检查您的PWact是否安装成功
### 2. 输出 cmd_name 对应的参数列表

```bash
pwact cmd_name -h
```

### 3. 初始训练集制备

```bash
pwact init_bulk param.json resource.json
```

### 4. 主动学习

```bash
pwact run param.json resource.json
```

对于上述两个命令，json 文件名称可以用户修改，但是要求 [`param.json`](#paramjson) 和 [`resouce.json`](#resourcejson) 的输入顺序不能变。

### 5. 工具命令

MOVEMENT 或 OUTCAR 转换为 PWdata 数据格式

```bash
pwact to_pwdata
```

搜索主动学习目录下已标记的数据集

```bash
pwact gather_pwdata
```

## 输入文件

PWact 包括两个输入文件 `param.json` 和 `resource.json`，用于初始数据集制备或者主动学习。PWact 对于两个 JSON 文件中键的大小写输入不敏感。

### param.json

[初始训练集制备 init_param.josn](./init_param_zh#参数列表)

对构型（VASP、PWmat 格式）进行驰豫、扩胞、缩放、微扰和 AIMD（DFTB、PWMAT、VASP、DFTB）设置。

[主动学习 run_param.josn](./run_param_zh#参数列表)

主动学习流程中的训练设置（网络结构、优化器）、探索设置（lammps 设置、选点策略）以及标记设置（VASP/PWmat 自洽计算设置）。

### [resource.json](./resource_zh#resourcejson)

计算集群资源设置，包括对训练、分子动力学（MD）、DFT 计算（SCF、Relax、AIMD）使用的计算节点、CPU、GPU 资源设置，以及对应的运行软件（Lammps、VASP、PWMAT、PWMLFF）。

## 主动学习案例

### [硅的主动学习](./example_si_init_zh)
