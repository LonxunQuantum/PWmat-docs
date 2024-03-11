---
sidebar_position: 2
---

# Exploration parameter input

# run_param.json

训练设置（网络结构、优化器）、探索设置（lammps 设置、选点策略）以及标记设置（VASP/PWmat 自洽计算设置）。

#

# 参数列表

### record_file

设置记录主动学习轮次的记录文件名称，默认设置为 `"al.record"`。

### reserve_work

是否保留临时工作目录，默认值为 `false`，每轮次主动学习执行结束之后，自动删除临时工作目录。

### reserve_md_traj

是否保留 md 运行轨迹，默认值为 `false`，每轮次主动学习执行结束之后，自动删除 md 运行轨迹文件。

### reserve_scf_files

是否保留自洽计算的所有结果文件，默认值为 `false`，设置为 `false` 之后，每轮次主动学习结束之后，对于 PWMAT 自洽计算，只保留 `REPORT`, `etot.input`,`OUT.MLMD`, `atom.config` 四个文件，对于 VASP 只保留 `OUTCAR`, `POSCAR`, `INCAR` 三个文件。

### init_data

初始训练集所在目录，为 list 格式。可以是绝对路径或者相对路径（当前目录）。

#

### train

模型训练参数，用于指定模型网络结构、优化器。详细的参数设置参考 [`PWMLFF文档`](http://doc.lonxun.com/PWMLFF/) 。您可以如例子中所示设置训练的全部参数，也可以使用单独的 json 文件，只需要在参数 `train_input_file` 中指定训练的 json 文件所在路径即可。

#### train_input_file

可选参数，如果您有单独的 PWMLFF 输入文件，您可以使用该参数指定文件所在路径。否则您需要设置如下例中所示参数。参数的详细解释您在可以在 [PWMLFF 参数列表](../Parameter%20details.md)中查看。

```json
    "train": {
        "model_type": "DP",
        "atom_type": [
            14
        ],
        "max_neigh_num": 100,
        "seed": 2023,
        "data_shuffle":true,
        "train_valid_ratio": 0.8,
        "recover_train": true,
        "model": {
            "descriptor": {
                "Rmax": 6.0,
                "Rmin": 0.5,
                "M2": 16,
                "network_size": [25, 25, 25]
            },
            "fitting_net": {
                "network_size": [50, 50, 50, 1]
            }
        },
        "optimizer": {
            "optimizer": "LKF",
            "epochs": 30,
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
        }
    }
```

由于 PWMLFF 中设置的默认参数已经能够支持大部分的训练需求，因此，您可以简写为如下形式，将采用标准的 `DP` 模型 使用 `LKF 优化器`训练。
```json
  "train": {
        "model_type": "DP",
        "atom_type": [14],
        "max_neigh_num": 100
  }   
```

### strategy

用于设置主动学习的不确定性度量方法，以及是否采用模型压缩做加速。

#### uncertainty

用于设置不确定性度量策略

默认值为 `committee`，即采用多模型查询的方式计算模型预测偏差。该值 需要配合 [`model_num`](#model_num) 、[`lower_model_deiv_f`](#lower_model_deiv_f) 和 [`upper_model_deiv_f`](#upper_model_deiv_f) 参数使用，将模型预测偏差值介于 `lower_model_deiv_f` 和 `upper_model_deiv_f` 之间结构作为候选结构，之后使用 DFT 做标注，`model_num` 用于设置模型的数量，如果使用 `committee` 方法，默认值为 `4`。

如果设置为 `kpu`，则采用单模型的基于卡尔曼滤波的不确定性度量。该值 需要配合 [`kpu_lower`](#kpu_lower) 和 [`kpu_upper`](#kpu_upper) 使用，其中 `kpu_lower` 用于设置不确定性下界，`kpu_upper` 用于设置不确定性上界。

#### lower_model_deiv_f

该参数需要配合 [`"uncertainty":"committee"`](#uncertainty) 使用，用于设置偏差的下界，如果偏差值小于该下界，则认为模型对构型的预测准确，不需要标注，默认值为 `0.05`。

#### upper_model_deiv_f

该参数需要配合 [`"uncertainty":"committee"`](#uncertainty) 使用，用于设置偏差的上界，如果偏差值大于该上界，则该构型本身不符合物理意义，不需要标注，默认值为 `0.15`。

#### model_num

该参数用于设置使用 `committee` 方法作为不确定性度量时使用的模型数量，默认值为`4`，该值的设置应该 `>=3`。

#### kpu_lower

该参数需要配合 [`"uncertainty":"kpu"`](#uncertainty) 使用，用于设置 KPU 的下界，如果 KPU 值小于该下界，则认为模型对构型的预测准确，不需要标注，默认值为 `5`。

#### kpu_upper

该参数需要配合 [`"uncertainty":"kpu"`](#uncertainty) 使用，用于设置 KPU 的上界，如果 KPU 值大于该上界，则该构型本身不符合物理意义，不需要标注，默认值为 `10`。

#### max_select

该参数用于设置一轮次主动学习中标注结构的最大数目。当待标注结构数目超过该值时，将随机从待标注结构中选择 `max_select` 个结构做标注。默认值为 `200`。

<!--
#### md_type
该参数用于设置 lammps 调用力场（机器学习模型）做分子动力学模拟时使用的立场代码。我们这里提供了 fortran 和 libtorch c++ 两种方式，默认值为 `"md_type":1`，即 libtorch 方式，该方式支持 CPU 和 GPU 两种计算资源下的模拟，比 `"md_type":2` （fortran，只支持 CPU计算）方式模拟速度更快。 -->

#### compress

该参数用于设置是否对模型做压缩，经过压缩后的模型精度会略有下降，但是模拟速度会有翻倍提升。默认值为 `false`, 即不使用模型压缩。

#### compress_order

该参数用于设置模型压缩的方式，默认值为 `"compress_order":3` , 即使用三阶多项式压缩。也可以设置为 `"compress_order":5` ， 即使用五阶多项式压缩，相比于三阶多项式精度会更高，但是速度比三阶稍慢。

#### Compress_dx

该参数用于设置模型压缩是的网格大小，默认值为 `"Compress_dx":0.01`。


#### 例子

对于committee方式的选点策略
```json
    "strategy": {
        "uncertainty":"committee",
        "lower_model_deiv_f": 0.1,
        "upper_model_deiv_f": 0.2,
        "model_num": 4,
        "max_select": 50,
        "compress": false
    }

```

对于KPU 方式选点策略
```json
    "strategy": {
        "uncertainty":"KPU",
        "max_select": 50,
        "kpu_lower":0.5,
        "kpu_upper":1.5
    }
```
如果您需要开启模型压缩，则
```json
    "strategy": {
        "uncertainty":"committee",
        "lower_model_deiv_f": 0.1,
        "upper_model_deiv_f": 0.2,
        "model_num": 4,
        "max_select": 50,
        "compress": true,
        "compress_order":3,
        "Compress_dx":0.01
    }
```

#

## explore

用于设置主动学习每个轮次探索过程的分子动力学设置

### sys_config_prefix

用于设置待探索的结构文件路径前缀，`可选参数`，与 [`sys_configs`](#sys_configs) 配合使用。可以是绝对路径或者相对路径，相对路径为当前目录。

例子：`"sys_config_prefix":"/data/structure"`, `"sys_configs":"atom.config"`, 则 `atom.config` 的实际路径是 `/data/structure/atom.config`。

### sys_configs

设置待探索的结构文件路径，如果设置了 [`sys_config_prefix`](#sys_config_prefix) 则进行路径拼接，否则使用 sys_configs 中设置的路径作为 config 路径。

该参数为 list 格式，对于 PWMAT 格式结构文件，直接写出文件路径即可，对于 VASP 格式结构文件，需要设置 `format` 格式，如下例中所示。

```json
    "sys_configs": [
        {"config":"POSCAR", "format":"vasp/poscar"},
        "atom1.config",
        "atom2.config"
    ]
```

### md_jobs

设置每个轮次的主动学习分子动力学参数。为 list 格式，第 `i` 个元组代表第 `i` 个轮次主动学习对应设置。每个元组内部可以为 dict 格式，或者 dict 格式的 list 数组。

注意：以下 md 设置中，对于时间的单位都使用 `units metal`。

#### ensemble

设置 系综，默认值 `"npt"`, 也支持 `"nvt"` 系综。

#### nsteps

设置 md 总的步数，为必选参数，需要用户提供。

#### md_dt

用于设置 `timestep` ，默认值为 `0.001`，即 `1飞秒`。

#### trj_freq

用于设置轨迹采样频率（ `thermo` ），默认值为`10`，即间隔 10 步采样一次。

#### sys_idx

用于设置 md 的初始结构，为 list 格式，值为 [`sys_configs`](#sys_configs)中的结构下标，这里可以指定多个结构。在探索中，会对每个构型分别按照 [`"press"`](#press) 和 [`"temps"`](#temps) 中指定的压强和温度做探索。

例如 `"sys_idx":[0, 1]`、 `"press":[100, 200]`、 `"temps":[300, 400]`，将对下标为 0 和 1 的结构，分别在 压强、温度为[100, 300]、[100, 400]、[200, 300]、[200, 400]下做 md，将产生 `8条` 轨迹。

#### press

用于设置 md 探索的压强，为 list 格式。

#### taup

稳压器的耦合时间（ps）, 默认值 `0.5`。

#### temps

用于设置 md 探索的温度，为 list 格式。

#### taut

恒温器的耦合时间（ps），默认值 `0.1`。

#### boundary

设置模拟系统的边界条件，默认值为 `true`，即采用 `p p p`， 设置为 `false` 则使用 `f f f`。

#### 例子

```json
"explore": {
    "sys_config_prefix": "./init_bulk/collection/init_config_0",
    "sys_configs": [
        {"config":"0.95_scale.poscar", "format":"vasp/poscar"},
        {"config":"0_pertub.poscar", "format":"vasp/poscar"},
        {"config":"0_pertub.poscar", "format":"vasp/poscar"}
    ],
    "md_jobs": [
        [{  
            "ensemble": "npt",
            "nsteps": 1000,
            "md_dt": 0.002,
            "trj_freq": 10,
            "sys_idx": [0, 1],
            "temps": [500, 800],
            "taut":0.1,
            "press" :[ 100,200],
            "taup": 0.5,
            "boundary":true
            },{
            "ensemble": "nvt",
            "nsteps": 1000,
            "md_dt": 0.002,
            "trj_freq": 10,
            "sys_idx": [2],
            "temps": [400],
            "taut":0.1,
            "taup": 0.5,
            "boundary":true
        }]
    ]
}
```

在上例中，配置了一个轮次的主动学习，执行 `"md_jobs"`中两个 `dict` 中配置的lammps 模拟。

对于第一个 dict, 使用 `npt` 系综，在 `sys_idx` 配置了两个构型，对应0.`95_scale.poscar`和 `0_pertub.poscar`。温度和压强的列表分别为 `[500, 800]` 和 `[100,200]`，意思是对这两个结构分别在温度、压强组合为 `[500, 100]`、`[500, 800]`、`[800, 100]`、`[800, 200]` 下执行`lammps`模拟，模拟 `1000` 步，输出频率 `10` 步，单步时间长度 `2` 飞秒。模拟结束后，会获得 `8` 条轨迹。

对于第二个dict，使用 `nvt` 系综，在`sys_idx` 配置了`1`个构型，对应 `0_pertub.poscar`，温度为 `400`，即在 温度`400K` 下做`lammps`模拟。模拟结束后获得`1`条轨迹。


## DFT

设置自洽计算，为 dict 格式。

### dft_style

设置标注（自洽计算）使用哪种 DFT 计算软件，默认值为 `pwmat`, 也支持 VASP 格式，如果是 VASP 格式，则设置为 `vasp`。

### input

设置输入控制文件的路径，可以为绝对路径或相对路径（相对于当前路径）。

### kspacing

该参数为 PWMAT 的输入参数，用于设置 K 点，可选参数。如果在 etot.input 文件中未设置 `MP_N123` 参数，则使用该参数设置 K 点。不能同时设置 `MP_N123` 与 `kspacing`。

如果 `etot.input` 文件中未设置 `MP_N123`，且 `kspacing` 未设置，则采用默认设置 `kspacing` 值为 `0.5`。

### flag_symm

该参数为 PWMAT 的输入参数，用于设置 K 点，可选参数。对于 Relax 或者 SCF 计算，默认值为 `0`, 对于 AIMD 计算，默认值为 `3`。

### pseudo 
设置 `PWMAT` 或 `VASP` 赝势文件所在路径，为list格式，赝势文件路径可以为绝对路径或相对路径（相对于当前路径）。

### in_skf
设置 `DFTB`(PWMAT封装) 的赝势文件上一级目录所在路径，为string 格式，绝对路径或相对路径（相对于当前路径）。

### basis_set_file
参考 [potential_file](#potential_file)。

### potential_file
设置 `CP2K` 赝势文件 `BASIS_MOLOPT` 和 `POTENTIAL` 文件所在路径。例如
```josn
    "basis_set_file":"~/datas/systems/cp2k/data/BASIS_MOLOPT",
    "potential_file":"~/datas/systems/cp2k/data/POTENTIAL"
```

### 例子
由于自洽计算任务使用的输入控制相同，因此只需要单文件的设置，对于不同的DFT软件，分别设置如下。

对于PWMAT，设置与 [INIT_BULK](./init_param_zh.md) 中相似，如果您未在scf_etot.input中指定 "MP_N123" 参数，则您需要设置 kspacing 和 flag_symm 参数。
```json
    "DFT": {
            "dft_style": "pwmat",
            "input": "scf_etot.input",
            "kspacing":0.3,
            "flag_symm":0
    }
```

您也可以不设置，将使用默认参数 kspacing=0.5， flag_symm = 0，此时设置如下
```json
"DFT": {
      "dft_style": "pwmat",
      "input": "scf_etot.input",
      "pseudo":["~/NCPP-SG15-PBE/Si.SG15.PBE.UPF"]
    }
```

如果您使用了集成在PWMAT中的DFTB，则设置为：
```json
"DFT": {
      "dft_style": "pwmat",
      "input": "scf_etot.input",
      "in_skf": "./lisi_dftb_pseudo"
    }
```

对于 VASP，设置如下：
```json
"DFT": {
      "dft_style": "vasp",
      "input": "scf_INCAR",
      "pseudo":["~/Si/POTCAR"]
    }
```

对于 CP2K，设置如下：
```json
"DFT": {
    "dft_style": "cp2k",
    "input": "scf_cp2k.inp",
    "basis_set_file":"~/datas/systems/cp2k/data/BASIS_MOLOPT",
    "potential_file":"~/datas/systems/cp2k/data/POTENTIAL"
    }
```

### 例子

如下例子，为一个标准的主动学习流程，两个轮次的主动学习，采用多模型委员会查询策略。更多使用案例，请参考源码根目录的 [`example`](https://github.com/LonxunQuantum/PWMLFF_AL/tree/main/example)。

```json
{
  "record_file": "si.al",

  "reserve_work": false,
  "reserve_md_traj": false,
  "reserve_scf_files": false,

  "init_data": ["/path/init_data"],

  "train": {
    "_train_input_file": "std_si.json",

    "model_type": "DP",
    "atom_type": [14],
    "max_neigh_num": 100,
    "seed": 2023,
    "model_num": 1,
    "data_shuffle": true,
    "train_valid_ratio": 0.8,
    "recover_train": true,
    "model": {
      "descriptor": {
        "Rmax": 6.0,
        "Rmin": 0.5,
        "M2": 16,
        "network_size": [25, 25, 25]
      },
      "fitting_net": {
        "network_size": [50, 50, 50, 1]
      }
    },
    "optimizer": {
      "optimizer": "LKF",
      "epochs": 10,
      "batch_size": 16,
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
    }
  },

  "strategy": {
    "uncertainty": "committee",
    "lower_model_deiv_f": 0.05,
    "upper_model_deiv_f": 0.15,
    "model_num": 4,

    "kpu_lower": 5,
    "kpu_upper": 10,

    "max_select": 10,
    "md_type": 2,
    "compress": false,
    "compress_order": 3,
    "Compress_dx": 0.01
  },

  "explore": {
    "sys_config_prefix": "/path/structures",
    "sys_configs": [
      { "config": "POSCAR", "format": "vasp/poscar" },
      "atom1.config",
      "atom2.config",
      "atom3.config",
      "atom4.config"
    ],
    "md_jobs": [
      [
        {
          "ensemble": "nvt",
          "nsteps": 1000,
          "md_dt": 0.002,
          "trj_freq": 10,
          "taup": 0.5,
          "sys_idx": [0, 1],
          "temps": [500, 700],
          "taut": 0.1,
          "boundary": true
        },
        {
          "ensemble": "npt",
          "nsteps": 1000,
          "md_dt": 0.002,
          "trj_freq": 10,
          "press": [100.0, 200.0],
          "taup": 0.5,
          "sys_idx": [0, 3],
          "temps": [500, 700],
          "taut": 0.1,
          "boundary": true,
          "_neigh_modify": 10,
          "_mass": "list or string",
          "merge_traj": false
        }
      ],
      {
        "ensemble": "nvt",
        "nsteps": 4000,
        "md_dt": 0.002,
        "trj_freq": 10,
        "press": [100.0, 200.0],
        "taup": 0.5,
        "sys_idx": [0, 1],
        "temps": [500, 700],
        "taut": 0.1,
        "boundary": true
      }
    ]
  },
  "DFT": {
    "dft_style": "pwmat",
    "input": "scf_etot.input",
    "kspacing": 0.5,
    "flag_symm": 0,
    "pseudo": ["path/Si.SG15.PBE.UPF"]
  }
}
```
