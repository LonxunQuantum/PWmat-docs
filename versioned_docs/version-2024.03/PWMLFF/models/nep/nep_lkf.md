---
sidebar_position: 1
---

# NEP Model (dev)

我们在 PWMLFF 中实现了Pytorch版本的 [NEP 模型](https://doi.org/10.1063/5.0106617)，能够使用 PWMLFF 的`LKF`、`ADAM` 等需要计算梯度的优化器进行训练，基于LKF优化器的 NEP 模型精度相比 `GPUMD 的演化算法`或者` ADAM 算法`，有明显提升。

目前已经实现 NEP 模型以及基于 libtorch 的 lammps 接口，还未正式 release。需要体验的用户，可以访问 [git 仓库 dev_nn_nep 分支](https://github.com/LonxunQuantum/PWMLFF/tree/dev_nn_nep) 以及 [git lammps 仓库 libtorch 分支](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/tree/libtorch)。对于 MD 模拟，用户也可以使用 GPUMD，我们在训练 NEP 模型结束后也会输出适配PGUMD的力场文件 `nep.txt` 和 `nep.in`。

## 从源码安装
### step1 源码下载：
``` bash
git clone -b dev_nn_nep git@github.com:LonxunQuantum/Lammps_for_PWMLFF.git PWMLFF_nep

您也可以使用 git clone -b dev_nn_nep https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git PWMLFF_nep，相比于https方式，第一种下载速度更快
```

### step2 编译：
这里默认您已经安装和激活您的 PWMLFF conda 虚拟环境，虚拟环境的安装参考[mcloud 加载](../../Installation.md#mcloud-直接加载) 或 [在线安装](../../Installation.md#在线安装)

```
如果您是mcloud用户，使用如下命令编译，其他用户需要手动加载您的编译器：
module load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable

cd PWMLFF_nep/src
sh build.sh
```
### step3 加载环境变量：
```
export PATH=/the/path/PWMLFF_nep/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF_nep/src/:$PYTHONPATH

替换 '/the/path/PWMLFF_nep'为您自己的代码目录
```

<!-- GPUMD 是完全基于 GPU 的高效通用分子动力学软件包，访问 GPUMD 源仓库获取更多[GPUMD](https://github.com/brucefan1983/GPUMD)细节。 -->

<!-- 我们在 PWMLFF 中集成的 GPUMD `(tag v3.9.1)`. -->

## NEP 模型训练

我们这里以一个HfO2的数据集为例，例子位于 [[PWMLFF_nep/example/NEP]](https://github.com/LonxunQuantum/PWMLFF/tree/dev_nn_nep/example/NEP).
### 输入文件设置

训练 NEP 模型的输入文件与 Linear\NN\DP 模型输入类似。
需要准备一个输入控制 json 文件，最简单的输入设置如下所示，指定模型类型为`NEP`，原子类型顺序以及用于训练的 MOVEMENT 文件列表或者 pwdata 数据格式。将采用 LKF 优化器训练。

```json 
{
  "model_type": "NEP",
  "atom_type": [72,8],
  "raw_files": [
    "./mvm_data/init_mvm_19_300",
    "./mvm_data/init_mvm_21_300",
    "./mvm_data/init_mvm_23_300",
    "./mvm_data/init_mvm_7_300"
  ]
}
```
如果您已经使用pwdata将结构转为npy格式，那么请使用如下输入设置：
``` json
{
  "model_type": "NEP",
  "atom_type": [72,8],
  "datasets_path": [
    "./pwdata/init_mvm_19_300",
    "./pwdata/init_mvm_21_300",
    "./pwdata/init_mvm_23_300",
    "./pwdata/init_mvm_7_300"
  ]
}
```
标准的 `std_input.json` 文件如下：

```json
{
    "model_type": "NEP",
    "atom_type": [
        72,8
    ],
    "max_neigh_num": 100,
    "seed": 2023,
    "model_num": 1,
    "recover_train": true,
    "model": {
        "descriptor": {
            "cutoff": [
                6.0, 6.0
            ],
            "n_max": [
                4, 4
            ],
            "basis_size": [
                12, 12
            ],
            "l_max": [
                4, 2, 1
            ]
        },
        "fitting_net": {
            "network_size": [
                100,
                1
            ]
        }
    },
    "optimizer": {
        "optimizer": "LKF",
        "epochs": 40,
        "batch_size": 4,
        "print_freq": 10,
        "block_size": 5120,
        "kalman_lambda": 0.98,
        "kalman_nue": 0.9987,
        "train_energy": true,
        "train_force": true,
        "train_ei": false,
        "train_virial": false,
        "train_egroup": false,
        "pre_fac_force": 2.0,
        "pre_fac_etot": 1.0,
        "pre_fac_ei": 1.0,
        "pre_fac_virial": 1.0,
        "pre_fac_egroup": 0.1
    },
    "datasets_path": [
        "/.../HfO2_liutheory/mvms/init_000_50"
    ]
}
```

### 参数详解

#### model_type
该参数用于指定`NEP`训练的类型。

#### cutoff
该参数用于设置 `radial` 和 `angular` 的截断能，在PWMLFF的实现中，我们只使用了 radial 的截断能，角度的截断能与 raidial 一致。

#### n_max
该参数用于设置 `radial` 和 `angular`的距离和角度分别对应的 feature 数量，默认值为 4 和 4。

#### basis_size
该参数用于设置 `radial` 和 `angular`的距离和角度分别对应的基组数量，默认值为 8 和 8。

#### l_max
该参数用于设置 angular 的展开阶，默认值为 `[4, 2, 0]`，分别是三体 feature、四体 feature 以及五体 feature 对应的阶，这里 `0`表示不使用五体 feature，此外要求$l_3 \geqslant l_4 \geqslant l_5$。

#### network_size
该参数用于设置 `NEP` 模型中隐藏层神经元个数，在 NEP 模型中只有一层隐藏层，默认值为 100。建议您使用默认值即可，更多网络层数对模型拟合精度的提升有限。

### 训练

训练 NEP 模型，用户只需要在当前 `nep.json` 所在目录执行如下命令即可

``` bash
PWMLFF train nep.json
```

### 训练的输出文件

训练完成后，会在当前目录下生一个 `model_record` 目录，包含如下 10 个文件：
`nep.txt`、`nep.in`、`nep_model.ckpt`、`epoch_valid.dat`、`epoch_train.dat`

`nep_model.ckpt`为训练结束后的力场文件，`nep.txt` 为改力场文件的 GPUMD 版本，可以与`nep.in`一起在PGUMD中使用.

`epoch_valid.dat`、`epoch_train.dat` 为训练过程中的loss记录文件。

## Python inference
本部分介绍如何使用训练好的 NEP 模型对新的原子结构进行性质预测。训练好的模型可以用来预测新的原子结构的性质，如系统的能量、力和应力等。

操作类似 DP、Linear 或者 NN 模型，用户需要准备如下内容的 json 文件，之后使用如下命令做推理：
```bash
PWMLFF test jsonfile
```

```json
{
    "model_type": "NEP",
    "model_load_file":"/.../nep_model.ckpt",
    "format": "pwmat/movement",
    "raw_files":[
        "movement_0",
        "movement_1"
    ],
    "datasets_path":[
        "PWdata/mvm_files_11",
        "PWdata/mvm_files_12/train"
    ]
}

```
`model_load_file` 为 训练好的 `nep_model.ckpt` 文件所在路径;

`format` 为 `raw_files` 中的结构文件格式;

用户也可以直接在 `datasets_path` 中使用 `pwmlff/npy` 格式的文件所在目录。

例如对于如下的`pwmlff/npy`文件结构，如果用户设置 "datasets_path":['pathA']，那么`train`和`valid`所在目录下的所有结构都会用于推理；如果用户设置 "datasets_path":['pathA/valid']，那么只使用p`athA/valid`下的结构做推理。

您也可以混合使用 `raw_files`、`datasets_path`。
```txt
pathA
    ├──train
    │   └──ei.npy,forces.npy,...
    └──valid
        └──ei.npy,forces.npy,...
```

## NEP for Lammps
我们也提供了 NEP 的 Lammps 接口，支持 GPU 下的模拟。
### 输入文件设置

将训练完成后生成的`nep_model.ckpt`力场文件用于 lammps 模拟，您需要：
### step1 转换力场文件为libtorch格式，您只需要输入如下命令
```
PWMLFF script nep_model.ckpt

```
转换成功之后，您将得到一个力场文件`jit_nep_module.pt`

注：请在GPU节点执行该命令，我们尚未适配CPU NEP 模型推理的版本，如果使用 CPU 做lammps 模拟，请参考[ cpu_nep for lammps](./Quickstart_nep_zh.md#nep-for-lammps)

### step2 lammps 输入文件设置
为了使用 PWMLFF 生成的力场文件，lammps 的输入文件示例如下：
```bash
pair_style   pwmlff   1 jit_nep_module.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
pair_coeff       * * 72 8

```
### step3 启动lammps模拟
您可以使用如下命令执行，命令中 2 表示使用 2 个 GPU 核心，您可以根据实际的资源情况做修改
```bash
mpirun -np 2 lmp_mpi_gpu -in in.lammps
```

### 关于lammps环境变量
为了运行lammps，您需要导入如下环境变量，包括您的PWMLFF 路径以及lammps 路径

``` bash
source /the/path/anaconda3/etc/profile.d/conda.sh
conda activate torch2_feat

export PATH=/the/path/codespace/PWMLFF_nep/src/bin:$PATH
export PYTHONPATH=/the/path/codespace/PWMLFF_nep/src/:$PYTHONPATH

export PATH=/the/path/codespace/lammps_nep/src:$PATH

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib

module load cuda/11.8 intel/2020
```

## 关于NEP 模型的测试结果

### 


<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/al1.png").default} alt="al1" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/hfo2.png").default} alt="hfo2" width="300" />
  </div>
  <p></p>
  <div style={{ display: 'inline-block' }}>
    <img src={require("./pictures/MgAlCu.png").default} alt="MgAlCu" width="300" />
  </div>
  <div style={{ display: 'inline-block' }}>
  <img src={require("./pictures/LiGePS.png").default} alt="LiGePS" width="300" />
  </div>
</div>
基于LKF 优化器的 NEP 模型（单隐藏层100个神经元）比 DP 模型收敛的精度更高，所需的epochs 也更少

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/optim_e.png").default} alt="optim_e" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/optim_f.png").default} alt="hfo2" width="300" />
  </div>
</div>

NEP 模型在 LKF 优化器下收敛精度相比于 ADAM 和 SNES(GPUMD 训练) 更高