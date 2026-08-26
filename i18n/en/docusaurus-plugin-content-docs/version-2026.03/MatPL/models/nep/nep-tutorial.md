---
sidebar_position: 2
title: NEP 操作演示
---

## NEP 操作演示
这里，我们以 MatPL [`源码根目录/example/HfO2/nep_demo`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo) 为例（[HfO2 训练集来源](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)），演示 NEP 模型的训练、测试、lammps 模拟以及其他功能。当前案例目录结构如下所示：

``` txt
nep_demo/
├── nep_kokkos_lmps/
│   ├── kkin.lmp
│   ├── lmp.config
│   ├── nep_to_lmps.txt
│   ├── rungpu_mcloud.job
│   └── rungpu_station.job
├── nep_lmps/
│   ├── in.lmp-cpu-25
│   ├── in.lmp-kk
│   ├── lmp.config
│   ├── nep_to_lmps.txt
│   ├── runcpu_mcloud.job
│   ├── runcpu_station.job
│   ├── rungpu_mcloud.job
│   └── rungpu_station.job
├── nep_lmps_deviation/
│   ├── in.lmp-kk
│   ├── lmp.config
│   ├── nep0.txt
│   ├── nep1.txt
│   ├── nep2.txt
│   ├── nep3.txt
│   ├── rungpu_mcloud.job
│   └── rungpu_station.job
├── nep_test.json
├── nep_train.json
├── train_mcloud.job
└── train_station.job
```

- `nep_train.json` 和 `nep_test.json` 分别是 NEP 模型的训练和测试参数文件，其中的 `../pwdata/` 指向 `HfO2/pwdata` 训练数据目录。
- `train_mcloud.job` 和 `train_station.job` 分别是 mcloud 和自建集群的 Slurm 训练任务示例。
- `nep_lmps` 同时提供 CPU 和 NEP KOKKOS GPU 模拟的输入文件与作业脚本。
- `nep_kokkos_lmps` 提供 NEP KOKKOS GPU 模拟示例。
- `nep_lmps_deviation` 提供四模型偏差计算示例，用于主动学习流程。
- 各 lammps 案例目录中，`lmp.config` 为初始结构，`nep_to_lmps.txt` 或 `nep*.txt` 为 NEP 力场文件，`*.lmp*` 为 lammps 输入文件，`*.job` 为 Slurm 作业脚本。


### train 训练

在 nep_demo 目录下使用如下命令即可开始训练：
``` bash
MatPL train nep_train.json
# 或根据运行环境修改 Slurm 脚本后提交训练任务
sbatch train_mcloud.job
# 自建集群使用 sbatch train_station.job
```

**输入文件解释**

nep_train.json 中的内容如下所示，关于 NEP 的参数解释，请参考 [NEP 参数手册](../../parameterdetail.md#nep-模型超参数)：
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

### 多节点多卡训练
多节点多卡训练的目录结构与上面相同，案例请参考
MatPL [`源码根目录/example/parallelnep`](https://github.com/LonxunQuantum/MatPL/tree/main/example/parallelnep) 为例（[HfO2 训练集来源](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)）。

该目录下提供了单节点单卡 `1node-1g-run.job` 、单节点多卡 `1node-4g-run.job` 、多节点多卡 `2node-8g-run.job` 三种启动脚本供参考，该脚本适用于 mcloud 用户。
对于在线安装用户，MatPL-2026.3 的环境加载请参考文件`env.sh`。

多节点多卡训练启动时要求提供`主机节点的地址`以及`可用端口`，建议通过如下shell 命令自动获取
```bash
MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
# 动态分配空闲端口
function get_free_port() {
    python -c 'import socket; s = socket.socket(socket.AF_INET, socket.SOCK_STREAM); s.bind(("", 0)); print(s.getsockname()[1]); s.close()'
}
MASTER_PORT=$(get_free_port)

export MASTER_ADDR=$MASTER_ADDR
export MASTER_PORT=$MASTER_PORT

echo "addrs: $MASTER_ADDR"
echo "port:  $MASTER_PORT"
echo "tasks: $SLURM_NTASKS"

srun MATPL train train.json 
```

:::caution
注意，NEP 多卡训练只支持使用 ADAM 优化器，不支持 LKF 或 GKF 优化器。
:::

### test 测试

test 命令支持来自  MatPL `nep_model.ckpt` 力场文件，以及在 lammps 或 GPUMD 中使用的 `nep5.txt`、`nep4.txt` 格式文件。

``` bash
MatPL test nep_test.json
```
test.json 中的内容如下所示，参数解释请参考 [参数手册](../../parameterdetail.md)
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

### infer 推理单结构

infer 命令支持来自MatPL `nep_model.ckpt` 力场文件、`GPUMD 的 nep4.txt `文件、 lammps 和 GPUMD 中通用的`nep5.txt` 格式文件。

``` bash
MatPL infer nep_model.ckpt atom.config pwmat/config
MatPL infer gpumd_nep.txt 0.lammpstrj lammps/dump Hf O
# Hf O 为 lammps/dump格式的结构中的元素名称，Hf为结构中1号元素类型，O为元素中2号元素类型
```
推理成功后，将在窗口输出推理的总能、每原子能量、每原子受力和维里

### totxt 转ckpt训练文件为nep5.txt

用于把 `MatPL` 训练的 `nep_model.ckpt` 文件转换为 txt 格式的`nep5.txt` 文件，该文件可用于 GPUMD 或 lammps-MatPL 中做分子动力学模拟。

``` bash
MatPL totxt nep_model.ckpt
```
执行成功将在执行该命令的所在目录生成名称为`nep5.txt`文件

### lammps MD

HfO2 案例分别提供了单模型、NEP KOKKOS 和多模型偏差计算目录。下面按“准备力场—选择案例—修改输入—启动模拟”的顺序说明。

#### 1. 准备力场文件

正常训练结束后，`model_record` 目录中会生成 `nep5.txt`，可直接用于 lammps。如果只有 `nep_model.ckpt`，可使用前文介绍的 `totxt` 命令转换：

```bash
MatPL totxt nep_model.ckpt
```

将生成的 `nep5.txt` 复制到相应案例目录，并按输入脚本中的文件名设置为 `nep_to_lmps.txt`。lammps-MatPL 同样支持 GPUMD 的 NEP4 和 NEP5 力场文件。

#### 2. 选择 lammps 案例

| 案例目录 | 用途 | 主要输入文件 |
| --- | --- | --- |
| [`nep_lmps`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo/nep_lmps) | CPU 和 NEP KOKKOS GPU 模拟 | `in.lmp-cpu-25`、`in.lmp-kk` |
| [`nep_kokkos_lmps`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo/nep_kokkos_lmps) | NEP KOKKOS GPU 模拟 | `kkin.lmp` |
| [`nep_lmps_deviation`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo/nep_lmps_deviation) | 四模型偏差计算 | `in.lmp-kk`、`nep0.txt`—`nep3.txt` |

每个目录都分别提供了 `*_mcloud.job` 和 `*_station.job`，请根据运行环境选择并修改模块名称、软件路径、分区和 GPU 资源参数。

#### 3. 设置 lammps 输入文件

NEP KOKKOS GPU 接口使用 half 近邻表并开启 Newton 通信。HfO2 单模型案例的核心设置如下：

```lammps
package kokkos neigh half comm device
newton on

pair_style   matpl/nep/kk nep_to_lmps.txt
pair_coeff   * * 72 8
```

`pair_coeff * *` 后的元素按 data 文件中的原子类型顺序排列。可使用元素名称，也可使用原子序数；本案例中 `1` 号类型为 Hf（`72`），`2` 号类型为 O（`8`）。

多模型案例使用第一个模型进行 MD，其他模型参与偏差计算：

```lammps
pair_style   matpl/nep/kk nep0.txt nep1.txt nep2.txt nep3.txt \
             out_freq ${DUMP_FREQ} out_file model_devi.out
pair_coeff   * * 72 8
```

`out_freq` 用于设置偏差输出频率，`out_file` 用于设置输出文件名。完整 NPT 控制参数请直接参考案例中的 `in.lmp-kk`、`in.lmp-cpu-25` 或 `kkin.lmp`，无需重复复制输入脚本。

#### 4. 启动 lammps 模拟

在案例目录中，可直接提交与运行环境对应的 Slurm 脚本，例如：

```bash
sbatch rungpu_mcloud.job
# 或
sbatch rungpu_station.job
```

也可在加载 lammps 环境后直接运行：

```bash
# 单 GPU，nep_kokkos_lmps/kkin.lmp
mpirun -np 1 --bind-to numa lmp -k on g 1 -sf kk -pk kokkos -in kkin.lmp

# 单节点 4 GPU，nep_lmps/in.lmp-kk
mpirun -np 4 --bind-to numa lmp -k on g 4 -sf kk -pk kokkos -in in.lmp-kk

# 2 节点，每节点 4 GPU
mpirun -np 8 --bind-to numa --map-by ppr:4:node \
    lmp -k on g 4 -sf kk -pk kokkos -in in.lmp-kk
```

如果使用 MatPL Pro 闭源版本，运行前还需要设置 `NEP_GPU_LIB_PATH` 和 `NEP_LICENSE_PATH`。多节点运行时，所有节点必须能访问共享库、License、输入文件和力场文件。

#### MatPL 热流计算

> **接口区别**：开放源码版本使用 `matpl/heatflux`；MatPL Pro 闭源版本使用 KOKKOS GPU 热流接口 `matpl/heatflux/kk`。请根据已安装的 lammps-MatPL 接口版本选择对应命令。

开放源码版本的热流 compute 设置为：

```lammps
compute      flux all matpl/heatflux
```

MatPL Pro 闭源版本的 `matpl/heatflux/kk` 直接在 GPU 上计算 MatPL 热流，无需使用传统的 `ke/atom + pe/atom + centroid/stress/atom + heat/flux` 后处理链：

```lammps
package kokkos neigh half comm device
newton on

pair_style   matpl/nep/kk nep.txt
pair_coeff   * * C

compute      flux all matpl/heatflux/kk
fix          fluxout all matpl/heatflux/ave/kk 10 100 1000 flux file compute_HeatFlux.out
```

`compute matpl/heatflux/kk` 输出包含 6 个分量的全局向量，依次为：

1. `Jx`：x 方向总热流。
2. `Jy`：y 方向总热流。
3. `Jz`：z 方向总热流。
4. `Jconv,x`：x 方向对流热流。
5. `Jconv,y`：y 方向对流热流。
6. `Jconv,z`：z 方向对流热流。

因此，virial 热流贡献可由总热流减去对流热流得到，即 `(1-4, 2-5, 3-6)`。`fix matpl/heatflux/ave/kk` 用于对热流向量进行时间平均，并将结果写入 `compute_HeatFlux.out`。

#### 热流案例

- [开放源码版本 Heat_flux 案例](https://github.com/LonxunQuantum/lammps-MatPL/tree/main/examples/Heat_flux)
- [MatPL Pro 闭源版本 Heat_flux 案例](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/Heat_flux)


### ASE 接口
NEP 模型提供了 ase 接口，使用方式如下脚本例子所示[gitee](https://gitee.com/pfsuo/MatPL/tree/main/example/ase_calculator/test_nep) 或 [github](https://github.com/LonxunQuantum/MatPL/tree/main/example/ase_calculator/test_nep)。 

```python
from src.ase.calculate import MatPL_calculator
calc = MatPL(model_file='nep_model.ckpt or nep.txt')
atoms = ..... # create ase.atoms.Atoms
atoms.calc = calc # or atoms.set_calculator(calc)
energy = atoms.get_potential_energy()
forces = atoms.get_forces()
stress = atoms.get_stress()
```
注意，在使用本ase接口时确保已经导入了[MatPL的环境变量](../../install/README.md)。

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
###  MATPL 中NEP模型与深度势能模型的精度对比

深度势能（deep potential, DP）模型是目前广泛使用的一种神经网络模型， MATPL 中实现了Pytorch版本的DP模型，该DP模型也可以使用LKF优化器。我们在多个体系下，使用LKF优化器对NEP模型和DP（ MATPL ）模型训练做了对比，结果如下图4中所示。在Al、HfO2、LiGePS（包含1万个结构）、[Ru、Rh、Ir、Pd、Ni]五元合金体系（包含9486个结构）下， MATPL 中的NEP模型比DP模型收敛都更快，精度也更高。特别的，对于五元合金，我们采用type embedding DP以减少元素种类对训练速度的影响（在之前的测试中，我们发现，对五种以上的元素的情况，在 MATPL 的DP训练中引入type embedding可以获得比普通DP更高的精度）。

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
测试数据与模型已经上传, 您可以访问我们的 [百度云网盘下载 https://pan.baidu.com/s/1beFMBU1IehmNEpIQ9B8ybg?pwd=pwmt ](https://pan.baidu.com/s/1beFMBU1IehmNEpIQ9B8ybg?pwd=pwmt)， 或者我们的[开源数据集仓库](https://github.com/LonxunQuantum/MatPL_library/tree/main/PWMLFF_NEP_test_examples)。 -->

<!-- 
## 关于lammps 接口的测试结果
下图展示了 NEP 模型的 lammps CPU 和 GPU 接口在 `3090*4` 机器上做 NPT 系综 MD 模拟的速度。对于CPU 接口，速度正比与原子规模和CPU核数；对于GPU 接口, 速度正比与原子规模和GPU数量。

根据测试结果，我们建议如果您需要模拟的体系规模在 $10^3$ 量级以下，建议您使用 CPU 接口即可。另外使用 GPU 接口时，建议您使用的 CPU 核数与 GPU 卡数相同。

<div style={{ display: 'inline-block', marginRight: '10px' }}>
  <img src={require("./pictures/lmps_speed.png").default} alt="nep_net" width="500" />
</div> -->
