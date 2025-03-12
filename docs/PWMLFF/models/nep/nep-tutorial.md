---
sidebar_position: 2
---

# NEP 操作演示
这里，我们以 MatPL [[源码根目录/example/HfO2]](https://github.com/LonxunQuantum/PWMLFF/blob/master/example/HfO2) 为例（[HfO2 训练集来源](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)），详细介绍 NEP 模型的训练、测试、lammps模拟以及其他功能。

## train 训练
使用如下命令即可开始训练：
``` bash
PWMLFF train nep_train.json
# 该目录下提供了slurm脚本提交的例子，替换相应的环境变量即可
```

#### 输入文件
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
        "./pwdata/init_000_50/", "./pwdata/init_002_50/", "./pwdata/init_004_50/", 
        "./pwdata/init_006_50/", "./pwdata/init_008_50/", "./pwdata/init_010_50/", 
        "./pwdata/init_012_50/", "./pwdata/init_014_50/", "./pwdata/init_016_50/", 
        "./pwdata/init_018_50/", "./pwdata/init_020_20/", "./pwdata/init_022_20/", 
        "./pwdata/init_024_20/", "./pwdata/init_026_20/", "./pwdata/init_001_50/", 
        "./pwdata/init_003_50/", "./pwdata/init_005_50/", "./pwdata/init_007_50/", 
        "./pwdata/init_009_50/", "./pwdata/init_011_50/", "./pwdata/init_013_50/", 
        "./pwdata/init_015_30/", "./pwdata/init_017_50/", "./pwdata/init_019_50/", 
        "./pwdata/init_021_20/", "./pwdata/init_023_20/", "./pwdata/init_025_20/", 
        "./pwdata/init_027_20/"
    ],
    "valid_data":[
        "./pwdata/init_000_50/", "./pwdata/init_004_50/", "./pwdata/init_008_50/"       
    ]
}
```

#### 训练文件目录
训练结束后产生如下目录如下所示
``` txt
├── model_record
│   ├── epoch_train.dat
│   ├── epoch_valid.dat
│   ├── nep_model.ckpt
│   └── nep_to_lmps.txt
├── std_input.json
└── train.json
```

- `std_input.json` 为模型训练中使用的所有设置参数（用户自定义参数以及默认参数）

- `model_record/nep_model.ckpt` 为最近一个epoch训练结束后的力场文件，.ckpt 为pytorch可读的文件格式

- `model_record/nep_to_lmps.txt` 为 nep_model.ckpt 提取出的 txt 格式力场文件，用于 lammps 中做MD推理

- `model_record/epoch_train.dat` 为训练过程中"train_data"中，每个 epoch 的训练集的 loss 信息汇总，内容如下所示，从左到右分别为 epoch步、总loss、原子能量的rmse(ev)、原子的力rmse(ev/A)、维里rmse（不训练维里则该列为0）、学习率、epoch耗时（秒）
```txt
# epoch              loss   RMSE_Etot_per_atom            RMSE_F   RMSE_virial_per_atom           real_lr              time
    1  2.2590103327e+01     6.4849732595e-02  1.5027318054e-01       0.0000000000e+00  1.0000000000e-03           64.4217
    2  8.5290845778e+00     6.9152885903e-02  9.2303320115e-02       0.0000000000e+00  1.0000000000e-03           55.2256
    ......
```

- `model_record/epoch_valid.dat` 为训练过程中"valid_data"中，每个 epoch训练结束时验证集的 loss 信息汇总，如果不设置验证集则不输出改文件，文件内容如下所示。从左到右分别为 epoch步、总loss、原子能量的rmse(ev)、原子的力rmse(ev/A)、维里rmse（不训练维里则该列为0）
```txt
# epoch              loss   RMSE_Etot_per_atom            RMSE_F   RMSE_virial_per_atom
    1  2.1228458079e+01     4.7977097739e-02  8.6751656714e-02       0.0000000000e+00
    2  5.8206698379e+01     7.9463623094e-02  7.9268106160e-02       0.0000000000e+00
```


## test 测试 
test 命令支持来自 `GPUMD 的 nep.txt `文件、 PWMLFF `nep_model.ckpt` 力场文件，以及在 lammps 中使用的 `nep_to_lmps.txt` 格式文件。

``` bash
PWMLFF test test.json
```
#### 输入文件
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
#### 测试文件目录
```
test_result/
│   ├──image_atom_nums.txt
│   ├── dft_total_energy.txt
│   ├── dft_force.txt
│   ├── dft_virial.txt
│   ├── dft_atomic_energy.txt
│   ├── inference_total_energy.txt
│   ├── inference_force.txt
│   ├── inference_virial.txt
│   ├── inference_atomic_energy.txt
│   ├── inference_summary.txt
│   ├── Energy.png
│   └── Force.png
└── std_input.json
```
- `test_result/image_atom_nums.txt` 存储测试集中结构对应的原子数

- `test_result/dft_total_energy.txt` 存储每个结构的能量标签

- `test_result/dft_force.txt` 存储每个结构中，每个原子的力标签，每行存储该原子的x、y、z三个方向分力

- `test_result/dft_virial.txt` 存储每个结构的维里标签，每个结构存储为一行，如果该结构不存在维里信息，则该行用 9个`-e6`值占位

- `test_result/dft_atomic_energy.txt` 存储每个结构中，每个原子的能量标签（该标签为PWmat 独有），每个结构存储为一行

- `test_result/inference_total_energy.txt` 存储每个结构的能量推理结果，与 dft_total_energy.txt 中的行对应

- `test_result/inference_virial.txt` 存储每个结构的维里推理结果，每个结构存储为一行，与 dft_virial.txt 中的行对应

- `test_result/inference_atomic_energy.txt` 存储每个结构中，每个原子的能量推理结果，每个结构存储为一行，与 dft_atomic_energy.txt 中的行对应

- `test_result/inference_summary.txt` 存储本次测试的汇总信息，如下例子中所示。
```txt
For 1140 images: 
Average RMSE of Etot per atom: 0.029401988821789057 
Average RMSE of Force: 0.045971754863441294 
Average RMSE of Virial per atom: None 

More details can be found under the file directory:
/the/path/test/test_result
```

## infer 推理单结构
infer 命令支持来自 `GPUMD 的 nep.txt `文件、 PWMLFF `nep_model.ckpt` 力场文件，以及在 lammps 中使用的 `nep_to_lmps.txt` 格式文件。

``` bash
PWMLFF infer nep_model.ckpt atom.config pwmat/config
PWMLFF infer gpumd_nep.txt 0.lammpstrj lammps/dump Hf O
# Hf O 为 lammps/dump格式的结构中的元素名称，Hf为结构中1号元素类型，O为元素中2号元素类型
```
推理成功后，将在窗口输出推理的总能、每原子能量、每原子受力和维里

## 其他命令

### toneplmps
用于把 `PWMLFF` 训练的 `nep_model.ckpt` 文件转换为 `nep_to_lmps.txt`文件，用于 `lammps` 模拟。
``` bash
PWMLFF toneplmps nep_model.ckpt
```
执行成功将在执行该命令的所在目录生成名称为`nep_to_lmps.txt`文件

### togpumd
用于把`PWMLFF` 训练的`nep_model.ckpt` 文件转换为 `nep_to_gpumd.txt` 文件，可用于 `GPUMD` 模拟。

`nep_to_lmps.txt` 相比于 GPUMD 的 `nep_to_gpumd.txt` 区别是额外存储了不同元素各自的 last bias，因此，因此多了 $N_{type} - 1$ 行值，$N_{type}$ 为元素类型，如果只有单元素，那它们完全相同。

由于GPUMD 不同元素的网络共享最后一个 bias， 因此需要根据模拟体系做转换。我们这里的转换思路如下公式所示。

$b_{com} = \frac{\sum_{t=1}^{N} b_t * N_t}{\sum_{t=1}^{N} N_t }$

这里 $N$ 为元素类型数量, $b_t$ 为力场中元素类型 $r$ 对应的 bias , $N_t$ 为待模拟体系中类型为 $t$ 的元素对应的原子数量。

``` bash
#HfO2体系为例，假设您要模拟一个Hf原子数目为N, O 原子数目为 M 的体系
#命令执行后您将得到一个nep_to_gpumd.txt 力场文件，可以用于GPUMD中模拟
#注意，这种方式只适用于体系中不同类型原子的数量不改变的 MD 模拟
#如模拟的原子数量变化，此时总能将不在正确
PWMLFF togpumd -m nep_model.ckpt -t Hf O -n N M
```
执行成功将在执行该命令的所在目录生成名称为`nep_to_gpumd.txt`文件

## lammps MD

我们提供了 NEP 的 Lammps 接口，支持 CPU（单核或多核）、GPU（单卡或多卡）下的模拟。您可以参考 [lammps 目录](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/tree/libtorch_nep/examples/nep_lmps/)下的 `examples/nep_lmps/hfo2_lmps_96atoms` 案例。此外，我们的 Lammps 接口也支持从 GPUMD 训练的 NEP4 模型，设置与 MatPL 相同。

### step1. 准备力场文件
将训练完成后生成的`nep_model.ckpt`力场文件用于 lammps 模拟，您需要
提取力场文件，您只需要输入如下命令
```
MatPL toneplmps nep_model.ckpt

```
转换成功之后，您将得到一个力场文件`nep_to_lmps.txt`。

如果您的模型正常训练结束，在`model_record`目录下会存在一个`nep_to_lmps.txt` 文件，您可以直接使用。

### step2. 准备输入控制文件
您需要在lammps的输入控制文件中设置如下力场，这里以HfO2为例
``` bash
pair_style   matpl   1 nep_to_lmps.txt 
pair_coeff   * *     8 72
```
- pair_style 设置力场文件路径，这里 `matpl` 未固定格式，代表使用MatPL中力场，`1` 为力场数量，`nep_to_lmps.txt`为力场文件路径

  这里也支持多模型的偏差值输出，该功能一般用于主动学习采用中。您可以指定多个模型，在模拟中将使用第1个模型做MD，其他模型参与偏差值计算，例如例子中所示，此时pair_style设置为如下:
  ```txt
  pair_style   matpl   4 0_nep_to_lmps.txt 1_nep_to_lmps.txt 2_nep_to_lmps.txt 3_nep_to_lmps.txt  out_freq ${DUMP_FREQ} out_file model_devi.out 
  pair_coeff   * *     8 72
  ```
- pair_coeff 指定待模拟结构中的原子类型对应的原子序号。例如，如果您的结构中 `1` 为 `O` 元素，`2` 为 `Hf` 元素，设置 `pair_coeff * * 8 72`即可。

您也可以将 `nep_to_lmps.txt` 文件替换为您的 GPUMD 训练得到的 NEP4 力场文件。


### step3 启动lammps模拟

如果您需要使用 CPU 设备做lammps 模拟，请输入如下指令，这里 64 为您需要使用的 CPU 核数，请根据自己的设备设置。
``` bash
mpirun -np 64 lmp_mpi -in in.lammps
```

我们也提供了GPU 版本的 lammps接口，请输入如下指令。
``` bash
mpirun -np 4 lmp_mpi_gpu -in in.lammps
```
这里 `4` 为需要使用的 `CPU 核数`（线程数）。我们会根据可使用的 GPU卡 数量（例如 `4` 个），将 线程平均分配到这 4 个 GPU 上做计算。我们建议您使用的 CPU 核数与您设置的 GPU 数量相同，多个线程在单个 GPU 上会由于资源竞争导致运行速度降低。

此外，lammps 接口允许跨节点以及跨节点GPU卡并行，只需要指定节点数、GPU卡数即可。

## NEP 模型的训练测试

替换为最新的结果、是否把测试这部分结果单独提取出来作为NEP的README(介绍NEP的原理)

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
### PWMLFF中NEP模型与深度势能模型的精度对比

深度势能（deep potential, DP）模型是目前广泛使用的一种神经网络模型，PWMLFF中实现了Pytorch版本的DP模型，该DP模型也可以使用LKF优化器。我们在多个体系下，使用LKF优化器对NEP模型和DP（PWMLFF）模型训练做了对比，结果如下图4中所示。在Al、HfO2、LiGePS（包含1万个结构）、[Ru、Rh、Ir、Pd、Ni]五元合金体系（包含9486个结构）下，PWMLFF中的NEP模型比DP模型收敛都更快，精度也更高。特别的，对于五元合金，我们采用type embedding DP以减少元素种类对训练速度的影响（在之前的测试中，我们发现，对五种以上的元素的情况，在PWMLFF的DP训练中引入type embedding可以获得比普通DP更高的精度）。

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


## 关于lammps 接口的测试结果
下图展示了 NEP 模型的 lammps CPU 和 GPU 接口在 `3090*4` 机器上做 NPT 系综 MD 模拟的速度。对于CPU 接口，速度正比与原子规模和CPU核数；对于GPU 接口, 速度正比与原子规模和GPU数量。

根据测试结果，我们建议如果您需要模拟的体系规模在 $10^3$ 量级以下，建议您使用 CPU 接口即可。另外使用 GPU 接口时，建议您使用的 CPU 核数与 GPU 卡数相同。

<div style={{ display: 'inline-block', marginRight: '10px' }}>
  <img src={require("./pictures/lmps_speed.png").default} alt="nep_net" width="500" />
</div>
