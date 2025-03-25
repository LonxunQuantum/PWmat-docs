---
sidebar_position: 2
---

# NEP 操作演示
这里，我们以 MatPL [`源码根目录/example/HfO2/nep_demo`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo) 为例（[HfO2 训练集来源](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)），演示 NEP 模型的训练、测试、lammps模拟以及其他功能。案例目录结构如下所示。
``` txt
HfO2/
├── atom.config
├── pwdata/
└── nep_demo/
    ├── nep_test.json
    ├── nep_train.json
    ├── train.job
    └── nep_lmps/
        ├── in.lammps
        ├── lmp.config
        ├── nep_to_lmps.txt
        ├── runcpu.job
        └── rungpu.job
```
- pwdata 目录为训练数据目录
- nep_train.json 是训练 NEP 力场输入参数文件
- nep_test.json 是测试 NEP 力场输入参数文件
- train.job 是slurm 提交训练任务例子
- nep_lmps 目录下 为 NEP 力场的 lammps md例子
  - 力场文件 nep_to_lmps.txt
  - 初始结构 lmp.config 
  - 控制文件 in.lammps
  - runcpu.job 和 rungpu.job 是 slurm 脚本例子

## train 训练

在 nep_demo 目录下使用如下命令即可开始训练：
``` bash
MatPL train nep_train.json
# 或修改环境变量之后通过slurm 提交训练任务 sbatch train.job
```

#### 输入文件解释
nep_train.json 中的内容如下所示，关于 NEP 的参数解释，请参考 [NEP 参数手册](../../Parameter%20details.md#nep-model)：
``` json
{
    "model_type": "NEP",
    "atom_type": [
        8, 72
    ],
    "optimizer": {
        "optimizer": "ADAM",
        "epochs": 30, 
        "batch_size": 1,
        "print_freq": 10,
        "train_energy": true,
        "train_force": true,
        "train_virial": true
    },

    "format": "pwmlff/npy",
    "train_data": [
        "../pwdata/init_000_50/", "../pwdata/init_002_50/", 
        "../pwdata/init_004_50/", "../pwdata/init_006_50/", 
        "../pwdata/init_008_50/", "../pwdata/init_010_50/", 
        "../pwdata/init_012_50/", "../pwdata/init_014_50/", 
        "../pwdata/init_016_50/", "../pwdata/init_018_50/", 
        "../pwdata/init_020_20/", "../pwdata/init_022_20/", 
        "../pwdata/init_024_20/", "../pwdata/init_026_20/", 
        "../pwdata/init_001_50/", "../pwdata/init_003_50/", 
        "../pwdata/init_005_50/", "../pwdata/init_007_50/", 
        "../pwdata/init_009_50/", "../pwdata/init_011_50/", 
        "../pwdata/init_013_50/", "../pwdata/init_015_30/", 
        "../pwdata/init_017_50/", "../pwdata/init_019_50/", 
        "../pwdata/init_021_20/", "../pwdata/init_023_20/", 
        "../pwdata/init_025_20/", "../pwdata/init_027_20/"
    ],
    "valid_data":[
        "../pwdata/init_000_50/", "../pwdata/init_004_50/", 
        "../pwdata/init_008_50/"       
    ]
}
```

训练结束后的力场文件目录请参考 [model_record 详解](../../matpl-cmd.md#train-文件目录)

## test 测试 
test 命令支持来自  MatPL `nep_model.ckpt` 力场文件，以及在 lammps 或 GPUMD 中使用的 `nep5.txt` 格式文件。

``` bash
MatPL test nep_test.json
```
test.json 中的内容如下所示，参数解释请参考 [参数手册](../../Parameter%20details.md)
```json
{
    "model_type": "NEP",
    "format": "pwmlff/npy",
    "model_load_file": "./model_record/nep_model.ckpt",
    "test_data": [
        "../init_000_50", "../init_004_50", "../init_008_50", 
        "../init_012_50", "../init_016_50", "../init_020_20", 
        "../init_024_20", "../init_001_50", "../init_005_50", 
        "../init_009_50", "../init_013_50", "../init_017_50", 
        "../init_021_20", "../init_025_20", "../init_002_50", 
        "../init_006_50", "../init_010_50", "../init_014_50", 
        "../init_018_50", "../init_022_20", "../init_026_20", 
        "../init_003_50", "../init_007_50", "../init_011_50", 
        "../init_015_30", "../init_019_50", "../init_023_20", 
        "../init_027_20"
    ]
}
```
测试结束后的力场文件目录请参考 [test_result 详解](../../matpl-cmd.md#test-文件目录)

## infer 推理单结构
infer 命令支持来自MatPL `nep_model.ckpt` 力场文件、`GPUMD 的 nep4.txt `文件、 lammps 和 GPUMD 中通用的`nep5.txt` 格式文件。

``` bash
MatPL infer nep_model.ckpt atom.config pwmat/config
MatPL infer gpumd_nep.txt 0.lammpstrj lammps/dump Hf O
# Hf O 为 lammps/dump格式的结构中的元素名称，Hf为结构中1号元素类型，O为元素中2号元素类型
```
推理成功后，将在窗口输出推理的总能、每原子能量、每原子受力和维里

## 其他命令

### totxt
用于把 `MatPL` 训练的 `nep_model.ckpt` 文件转换为 txt 格式的`nep5.txt` 文件，该文件可用于 GPUMD 或 lammps-MatPL 中做分子动力学模拟。

``` bash
MatPL totxt nep_model.ckpt
```
执行成功将在执行该命令的所在目录生成名称为`nep5.txt`文件

## lammps MD

### step1. 准备力场文件
将训练完成后生成的`nep_model.ckpt`力场文件用于 lammps 模拟，您需要
提取力场文件，您只需要输入如下命令
```
MatPL totxt nep_model.ckpt
```
转换成功之后，您将得到一个力场文件`nep5.txt`。

如果您的模型正常训练结束，在`model_record`目录下会存在一个`nep5.txt` 文件，您可以直接使用。

此外，也`支持 GPUMD 的 NEP4、NEP5 力场文件`。

### step2. 准备输入控制文件
您需要在lammps的输入控制文件中设置如下力场，这里以HfO2为例（[`HfO2/nep_demo/nep_lmps`](https://github.com/LonxunQuantum/MatPL/blob/master/example/HfO2/nep_demo/nep_lmps)

``` bash
pair_style   matpl   nep_to_lmps.txt 
pair_coeff   * *     8 72
```
- pair_style 设置力场文件路径，这里 `matpl` 为固定格式，代表使用MatPL中力场，`nep_to_lmps.txt`为力场文件路径

  这里也支持多模型的偏差值输出，该功能一般用于主动学习采用中。您可以指定多个模型，在模拟中将使用第1个模型做MD，其他模型参与偏差值计算，例如例子中所示，此时pair_style设置为如下:
  ```txt
  pair_style   matpl   0_nep_to_lmps.txt 1_nep_to_lmps.txt 2_nep_to_lmps.txt 3_nep_to_lmps.txt  out_freq ${DUMP_FREQ} out_file model_devi.out 
  pair_coeff   * *     8 72
  ```
- pair_coeff 指定待模拟结构中的原子类型对应的原子序号。例如，如果您的结构中 `1` 为 `O` 元素，`2` 为 `Hf` 元素，设置 `pair_coeff * * 8 72`即可。

这里也可以将 `nep_to_lmps.txt` 文件替换为您的 GPUMD 的 NEP4、NEP5 力场文件。

### step3 启动lammps模拟
``` bash
# 加载 lammps 环境变量env.sh 文件，正确安装后，该文件位于 lammps 源码根目录下
source /the/path/of/lammps/env.sh
# 执行lammps命令
mpirun -np N lmp_mpi -in in.lammps
```
这里 N 为md中的使用的 CPU 核数，如果您的设备中存在可用的GPU资源（例如 M 张GPU卡）,则在运行中，N个lammps线程将平均分配到这M张卡上。我们建议您使用的 CPU 核数与您设置的 GPU 数量相同，多个线程在单个 GPU 上会由于资源竞争导致运行速度降低。

此外，lammps 接口允许跨节点以及跨节点GPU卡并行，只需要指定节点数、GPU卡数即可。

<!-- ## NEP 模型的训练测试

替换为最新的结果、是否把测试这部分结果单独提取出来作为NEP的README(介绍NEP的原理) -->

<!-- 我们对多种体系进行了测试，所有测试中将数据集的80%作为训练集，20%作为验证集。我们在公开的HfO2训练集（包含𝑃21/c、Pbca、𝑃ca21和𝑃42/nmc相的2200个结构）上对NEP模型分别在LKF和演化算法（SNES, GPUMD）训练，它们在验证集上的误差下降如下图2中所示。随着训练epoch增加，基于LKF的NEP模型相比于SNES，可以更快收敛到更低误差（误差越低精度越高）。在铝的体系下（包括3984个结构）也有相似结果（图3）。此外，我们在LiGePS体系以及五元合金体系中也有类似结果，更详细数据请参考已上传的训练和测试数据。

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/hfo2_lkf_snes_energy.png").default} alt="hfo2_lkf_snes_energy" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/hfo2_lkf_snes_force.png").default} alt="hfo2_lkf_snes_force" width="300" />
  </div>
  <p>HfO2体系（2200个结构）下，NEP模型在LKF和SNES优化器下的能量（左图）和力（右图）收敛情况。图中虚线为SNES算法训练能够达到的最低loss水平。</p>

  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/al_lkf_snes_energy.png").default} alt="al_lkf_snes_energy" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/al_lkf_snes_force.png").default} alt="al_lkf_snes_force" width="300" />
  </div>
  <p>Al体系（3984个结构）下，NEP模型在LKF和SNES优化器下的能量（左图）和力（右图）收敛情况。图中虚线为SNES算法训练能够达到的最低loss水平。</p>
</div> -->

<!-- 
### MatPL 中NEP模型与深度势能模型的精度对比

深度势能（deep potential, DP）模型是目前广泛使用的一种神经网络模型，MatPL中实现了Pytorch版本的DP模型，该DP模型也可以使用LKF优化器。我们在多个体系下，使用LKF优化器对NEP模型和DP（MatPL）模型训练做了对比，结果如下图4中所示。在Al、HfO2、LiGePS（包含1万个结构）、[Ru、Rh、Ir、Pd、Ni]五元合金体系（包含9486个结构）下，MatPL中的NEP模型比DP模型收敛都更快，精度也更高。特别的，对于五元合金，我们采用type embedding DP以减少元素种类对训练速度的影响（在之前的测试中，我们发现，对五种以上的元素的情况，在MatPL的DP训练中引入type embedding可以获得比普通DP更高的精度）。

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/NEP_Al.png").default} alt="al1" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/NEP_HfO2.png").default} alt="hfo2" width="300" />
  </div>
  <p></p>
  <div style={{ display: 'inline-block' }}>
    <img src={require("./pictures/NEP_Alloy.png").default} alt="Alloy" width="300" />
  </div>
  <div style={{ display: 'inline-block' }}>
  <img src={require("./pictures/NEP_LiGePS.png").default} alt="LiGePS" width="300" />
  </div>
</div>
NEP和DP模型在LKF优化器下训练误差收敛情况 -->


<!-- ### 测试数据
测试数据与模型已经上传, 您可以访问我们的 [百度云网盘下载 https://pan.baidu.com/s/1beFMBU1IehmNEpIQ9B8ybg?pwd=pwmt ](https://pan.baidu.com/s/1beFMBU1IehmNEpIQ9B8ybg?pwd=pwmt)， 或者我们的[开源数据集仓库](https://github.com/LonxunQuantum/PWMLFF_library/tree/main/PWMLFF_NEP_test_examples)。 -->

<!-- 
## 关于lammps 接口的测试结果
下图展示了 NEP 模型的 lammps CPU 和 GPU 接口在 `3090*4` 机器上做 NPT 系综 MD 模拟的速度。对于CPU 接口，速度正比与原子规模和CPU核数；对于GPU 接口, 速度正比与原子规模和GPU数量。

根据测试结果，我们建议如果您需要模拟的体系规模在 $10^3$ 量级以下，建议您使用 CPU 接口即可。另外使用 GPU 接口时，建议您使用的 CPU 核数与 GPU 卡数相同。

<div style={{ display: 'inline-block', marginRight: '10px' }}>
  <img src={require("./pictures/lmps_speed.png").default} alt="nep_net" width="500" />
</div> -->
