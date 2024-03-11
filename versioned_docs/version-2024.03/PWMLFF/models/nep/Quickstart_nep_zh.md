---
sidebar_position: 0
---

# GPUMD

GPUMD 是完全基于 GPU 的高效通用分子动力学软件包，能够训练和使用神经进化网络力场 (neuroevolution potentials，NEP)。

访问 GPUMD 源仓库获取更多[GPUMD](https://github.com/brucefan1983/GPUMD)细节。

我们在 PWMLFF 中集成的 GPUMD 版本号为 **(commit hash 6c9e75b on Nov 9)**.

## NEP 模型训练

### 输入文件设置

训练 NEP 模型的输入文件与 Linear\NN\DP 模型输入类似。
需要准备一个输入控制 json 文件，最简单的输入设置如下所示，指定模型类型为**NEP**，原子类型顺序以及用于训练的 MOVEMENT 文件列表。所有其他参数均采用默认值，并在训练前输出到一个 std_input.json 文件中，方便用户检查，用户也可以在 `std_input.json` 文件中重新设置想要的参数，然后作为输入文件用于训练。

注意这里 **nep_in_file** 是可选设置，**`nep.in`** 文件是源生的 GPUMD 训练 NEP 模型所需的输入控制文件，用户可以在这里指定该文件的路径。用户也可以像在 **std_input.json** 中展示的一样，在 **model** 中设置 NEP 输入参数。

```json
{
  "model_type": "NEP",
  "atom_type": [28, 44, 45, 46, 77],
  "nep_in_file": "nep.in",
  "train_movement_file": [
    "./mvm_data/init_mvm_19_300",
    "./mvm_data/init_mvm_21_300",
    "./mvm_data/init_mvm_23_300",
    "./mvm_data/init_mvm_7_300"
  ]
}
```

标准的 **std_input.json** 文件如下：

```json
{
  "model_type": "NEP",
  "atom_type": [28, 44, 45, 46, 77],
  "max_neigh_num": 100,
  "seed": 2023,
  "model_num": 1,
  "train_valid_ratio": 0.8,
  "recover_train": true,
  "model": {
    "version": 4,
    "type": "5 Ni Ru Rh Pd Ir",
    "model_type": 0,
    "prediction": 0,
    "cutoff": [8, 4],
    "n_max": [4, 4],
    "basis_size": [8, 8],
    "l_max": [4, 2, 0],
    "neuron": 30,
    "lambda_1": -1,
    "lambda_2": -1,
    "lambda_e": 1.0,
    "lambda_f": 1.0,
    "lambda_v": 0.1,
    "batch": 1000,
    "population": 50,
    "generation": 100000
  },
  "work_dir": "work_dir",
  "reserve_work_dir": false,
  "train_movement_file": [
    "./mvm_data/init_mvm_19_300",
    "./mvm_data/init_mvm_21_300",
    "./mvm_data/init_mvm_23_300",
    "./mvm_data/init_mvm_7_300"
  ]
}
```

标准的 **`nep.in`** 文件输入如下，详细的 nep.in 文件设置方式，可以参考[GPUMD 手册](https://gpumd.org/nep/index.html)。

```bash
    version 4
    type 5 Ni Ru Rh Pd Ir
    model_type 0
    prediction 0
    cutoff 8 4
    n_max 4 4
    basis_size 12 12
    l_max 4 2 0
    neuron 100
    generation 100000
```

### 训练

训练 NEP 模型，用户只需要在当前 `nep.json` 所在目录执行如下命令即可

```bash
PWMLFF train nep.json
```

### 训练的输出文件

训练完成后，会在当前目录下生一个 **model_record** 目录，包含如下 10 个文件：
**`nep.txt`**，**`energy_train.out`**，**`force_train.out`**，**`virial_train.out`**，**`energy_test.out`**，**`force_test.out`**，**`virial_test.out`**，**`loss.out`**，**`nep.restart`**，**`nep.in`**

**`nep.txt`** 为训练完成后的 NEP 力场文件

**`energy_train.out`**, **`force_train.out`**, **`virial_train.out`** 是完成训练后的模型对训练集的能量、力和和维里做推理的结果

**`energy_test.out`**, **`force_test.out`**, **`virial_test.out`** 分别是完成训练后的模型对测试集的能量、力和维里做推理的结果

**`loss.out`** 为训练过程中的误差统计

**`nep.restart`** 用于中断训练后重新恢复训练

**`nep.in`** 文件用于启动 NEP 训练，为系统自动生成文件

## NEP for Lammps

### 输入文件设置

### running

## GPUMD

做 GPUMD 的 NEP 分子动力学，输入文件与 Linear\NN\DP 模型输入类似。
需要准备一个输入控制 json 文件，最简单的输入设置如下所示，1. 指定 NEP 力场文件路径 **potential_file**；2. 执行 GPUMD 分子动力学控制文件 **`run.in`** 文件；3. 初始构型文件，可以是 PWMAT 的 atom.config 文件、VASP 的 POSCAR 文件、Lammps 的 config.lmp 文件或者 GPUMD 的扩展 xyz 格式文件，4. 指定采用模型类型为 NEP。

详细的 **`run.in`** 文件设置，请参考[GPUMD 手册](https://gpumd.org/gpumd/index.html)

```bash
    {
        "potential_file" : "./model_record/nep.txt",
        "run_in_file": "run.in",
        "md_init_config": "atom.config",
        "model_type":"NEP"
    }
```

### 运行

准备好上述文件之后，在该 json 文件所在目录下，执行命令

```bash
PWMLFF gpumd gpumd_lisi.json
```

运行完毕之后，会在 json 文件所在目录下生成 gpumd_work_dir 目录，包含本次分子动力学执行结果，包含 6 个文件。

### 分子动力学输出

**`dos.out`**, **`gpumd.log`**, **`model.xyz`**, **`mvac.out`**, **`nep.txt`**, **`run.in`**
