---
sidebar_position: 0
---

# GPUMD

GPUMD 是完全基于 GPU 的高效通用分子动力学软件包，能够训练和使用神经进化网络力场 (neuroevolution potentials，NEP)。

访问 GPUMD 源仓库获取更多[GPUMD](https://github.com/brucefan1983/GPUMD)细节。

我们在 PWMLFF 中集成的 GPUMD `(tag v3.9.1)`.

## NEP 模型训练

### 输入文件设置

训练 NEP 模型的输入文件与 Linear\NN\DP 模型输入类似。
需要准备一个输入控制 json 文件，最简单的输入设置如下所示，指定模型类型为`NEP`，原子类型顺序以及用于训练的 MOVEMENT 文件列表。所有其他参数均采用默认值，并在训练前输出到一个 std_input.json 文件中，方便用户检查，用户也可以在 `std_input.json` 文件中重新设置想要的参数，然后作为输入文件用于训练。

注意这里 `nep_in_file` 是可选设置，`nep.in` 文件是源生的 GPUMD 训练 NEP 模型所需的输入控制文件，用户可以在这里指定该文件的路径。用户也可以参照在 `std_input.json` 中展示的一样，在 `model` 中设置 NEP 输入参数。

```json
{
  "model_type": "NEP",
  "atom_type": [28, 44, 45, 46, 77],
  "nep_in_file": "nep.in",
  "raw_files": [
    "./mvm_data/init_mvm_19_300",
    "./mvm_data/init_mvm_21_300",
    "./mvm_data/init_mvm_23_300",
    "./mvm_data/init_mvm_7_300"
  ]
}
```
标准的 `std_input.json` 文件如下：

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
  "raw_files": [
    "./mvm_data/init_mvm_19_300",
    "./mvm_data/init_mvm_21_300",
    "./mvm_data/init_mvm_23_300",
    "./mvm_data/init_mvm_7_300"
  ]
}
```

标准的 `nep.in` 文件输入如下，详细的 nep.in 文件设置方式，可以参考 [NEP 参数设置](../../Parameter%20details.md) 或者 [GPUMD 官方手册](https://gpumd.org/nep/index.html)。

```txt
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

训练完成后，会在当前目录下生一个 `model_record` 目录，包含如下 10 个文件：
`nep.txt`，`energy_train.out`，`force_train.out`，`virial_train.out`，`energy_test.out`，`force_test.out`，`virial_test.out`，`loss.out`，`nep.restart`，`nep.in`

`nep.txt` 为训练完成后的 NEP 力场文件

`energy_train.out`, `force_train.out`, `virial_train.out` 是完成训练后的模型对训练集的能量、力和和维里做推理的结果

`energy_test.out`, `force_test.out`, `virial_test.out` 分别是完成训练后的模型对测试集的能量、力和维里做推理的结果

`loss.out` 为训练过程中的误差统计

`nep.restart` 用于中断训练后重新恢复训练

`nep.in` 文件用于启动 NEP 训练，为系统自动生成文件

## GPUMD

做 GPUMD 的 NEP 分子动力学，输入文件与 Linear\NN\DP 模型输入类似。
需要准备一个输入控制 json 文件，完整的输入参数如下所示
```json
    {
        "potential_file" : "./model_record/nep.txt",
        "run_in_file": "run.in",
        "md_init_config": "atom.config",
        "format":"pwmat/config",
        "basis_in_file":"basis.in",
        "kpoints_in_file":"kpoints.in"
    }
```
### potential_file
该参数为 NEP 力场文件路径

### run_in_file
该参数为GPUMD 分子动力学控制文件 `run.in` 文件所在路径，`run.in`文件的参数请参考 [GPUMD 手册 run.in](https://gpumd.org/dev/gpumd/input_files/run_in.html)

### md_init_config
该参数为初始 MD 结构文件路径

### format
该参数为初始结构文件类型，这里支持下列各式：
```
atom.config文件，format="pwmat/config"
poscar 文件，foramt="vasp/poscar"
config.lmp lammps输入结构文件，format="lammps/lmp"
extend xyz格式文件，format="xyz"
```

### basis_in_file
该文件用于定义声子计算的晶胞。文件格式如下所示
```txt
N_basis
id(0) mass(0)
id(1) mass(1)
...
id(N_basis-1) mass(N_basis-1)
map(0)
map(1)
...
map(N-1)
```
这里,`N_basis`是单位胞中原子的数量。例如,如果使用原胞作为单位胞,对于 diamond silicon 它可以是2。接下来的`N_basis`行包含基原子的原子序号(使用模拟模型文件中的顺序，从0开始)和质量。

剩余的N行将模拟模型中的N个原子映射到基原子。如果模拟模型文件中的第n个原子(在平移下)等同于单位胞中第m个基原子,我们就有map(n)=m。

### kpoints_in_file
该文件用于设置声子谱计算时的K点。文件格式如下所示
```txt
N_kpoints
kx(0) ky(0) kz(0)
kx(1) ky(1) kz(1)
...
kx(N_kpoints-1) ky(N_kpoints-1) kz(N_kpoints-1)
```
第一行 N_kpoints是k点的数量。
接下来每行给出k向量(单位为1/Å)。用户必须确保k向量是相对于所选的单位胞在倒易空间中定义的。

详细的 `run.in` 文件设置，请参考[GPUMD 手册](https://gpumd.org/gpumd/index.html)

### 运行

准备好上述文件之后，在该 json 文件所在目录下，执行命令

```bash
PWMLFF gpumd gpumd_lisi.json
```

运行完毕之后，会在 json 文件所在目录下生成 gpumd_work_dir 目录，包含本次分子动力学执行结果，包含 6 个文件。

### 分子动力学输出

`dos.out`, `gpumd.log`, `model.xyz`, `mvac.out`, `nep.txt`, `run.in`

## NEP for Lammps
我们也提供了 NEP 的 Lammps 接口，支持 CPU 下的模拟。
### 输入文件设置

将训练完成后生成的`nep.txt`力场文件用于 lammps 模拟。

为了使用 PWMLFF 生成的力场文件，lammps 的输入文件示例如下：

```bash
pair_style nep nep.txt
pair_coeff * * 
```
### running
您可以使用如下命令执行，命令中 24 表示使用 24 个 CPU 核心，您可以根据实际的资源情况做修改
```bash
mpirun -np 24 lmp_mpi -in in.lammps
```
