---
sidebar_position: 2
---

# run_iter param.json

# run_param.json

训练设置（网络结构、优化器）、探索设置（lammps 设置、选点策略）以及标记设置（VASP/PWmat 自洽计算设置）。参数列表如下所示

## reserve_work

是否保留临时工作目录，默认值为 `false`，每轮次主动学习执行结束之后，自动删除临时工作目录。

## reserve_md_traj

是否保留 md 运行轨迹，默认值为 `false`，每轮次主动学习执行结束之后，自动删除 md 运行轨迹文件。

## reserve_scf_files

是否保留自洽计算的所有结果文件，默认值为 `false`，设置为 `false` 之后，每轮次主动学习结束之后，对于 PWMAT 自洽计算，只保留 `REPORT`, `etot.input`,`OUT.MLMD`, `atom.config` 四个文件，对于 VASP 只保留 `OUTCAR`, `POSCAR`, `INCAR` 三个文件。


## data_format
用于设置主动学习中初始训练集、采集到的数据集格式，默认为扩展的xyz格式 `extxyz`。

## init_data

初始训练集所在目录，为 list 格式。可以是绝对路径或者相对路径（当前目录）。

## valid_data

验证集所在目录，为 list 格式，可以是绝对路径或者相对路径（当前目录）。如不设置，则在主动学习训练模型过程中不输出验证集结果。

## init_model_list
用于设置初始探索模型，如果已有MatPL训练的 DP 或者 NEP 力场，并且希望从这些力场开始探索工作，则将力场文件路径写入 init_model_list 即可。

注意，这里要求力场数量要与 [strategy/model_num](#model_num) 中一致，模型类型要与 `train/model_type` 中的模型类型一致。并且模型的训练参数将会自动从力场文件中提取，在 `train_input_file` 或者 `train` 字典中设置的模型网络和描述符参数将失效。

## use_pre_model
在当前步的探索中，使用上一步训练得到的力场，默认值为 true。

## train

模型训练参数，用于指定模型网络结构、优化器。详细的参数设置参考 [`MatPL 训练参数`](../Parameter%20details.md) 。您可以像如下例子中所示，设置训练的全部参数，也可以使用单独的 json 文件，只需要在参数 `train_input_file` 中指定训练的 json 文件所在路径即可。

### train_input_file

可选参数，如果您有单独的 MatPL 输入文件，您可以使用该参数指定文件所在路径。否则您需要设置如下例中所示参数。参数的详细解释您在可以在 [MatPL 参数列表](../Parameter%20details.md)中查看。

```json
    "train": {
        "model_type": "DP",
        "atom_type": [
            14
        ],
        "seed": 2023,
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
            "train_virial": false,
            "pre_fac_force": 2.0,
            "pre_fac_etot": 1.0,
            "pre_fac_virial": 1.0
        }
    }
```

由于 MatPL 中设置的默认参数已经能够支持大部分的训练需求，因此，您可以简写为如下形式，将采用标准的 `DP` 模型 使用 `LKF 优化器`训练。
```json
  "train": {
        "model_type": "DP",
        "atom_type": [14]
  }   
```

PWact 同时支持 MatPL 的 DP 和 NEP 力场。

## strategy

用于设置主动学习的不确定性度量方法，以及是否采用模型压缩做加速。

### uncertainty

用于设置不确定性度量策略，当前支持多模型委员会查询方法 (`committee`) 。

<!-- `KPU`方法我们在做探索，后续将面向用户开放。 -->
<!-- 
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

该参数需要配合 [`"uncertainty":"kpu"`](#uncertainty) 使用，用于设置 KPU 的上界，如果 KPU 值大于该上界，则该构型本身不符合物理意义，不需要标注，默认值为 `10`。 -->
### lmps_tolerance

当lammps 部分轨迹由于各种原因（如力场不准确导致丢失了原子、原子距离太近等）造成 MD 过程为正常执行结束时，是否终止主动学习过程。默认值为 true，即不终止。

### lower_model_deiv_f

该参数用于设置偏差的下界，如果偏差值小于该下界，则认为模型对构型的预测准确，不需要标注，默认值为 `0.05`。

### upper_model_deiv_f

该参数用于设置偏差的上界，如果偏差值大于该上界，则该构型本身不符合物理意义，不需要标注，默认值为 `0.15`。

这里使用的最大偏差值，计算公式如下所示：

$\varepsilon_{t}  = max_i(\sqrt{\frac{\sum_{1}^{w} \left \| F_{w,i}(R_t) -\hat{F_{i}} \right \| ^2 }{W}} )$,  $\hat{F_{i}} = \frac{ {\textstyle \sum_{1}^{W}F_{w,i}} }{W} $

这里 $W$ 为模型数量，$i$为原子下标。

### model_num

该参数用于设置使用 `committee` 方法作为不确定性度量时使用的模型数量，默认值为`4`，该值的设置应该 `>=3`。

### max_select

该参数用于设置一轮次主动学习中，对于未设置 [`select_sys`](#select_sys) 参数的`每个初始探索结构`对应最大选取构型用于标注的数量。当待标注结构数目超过该值时，将随机从待标注结构中选择 `max_select` 个结构做标注。默认不设置，即不做限制。

例如对于如下 md 探索设置，由于未设置 [`select_sys`](#select_sys)，如果设置了 `max_select`，则对于 [`sys_idx`](#sys_idx) 中指定的这两个结构，分别最多采集 `max_select`个结构，因此这里对于该 md 探索设置，最多采集 $2 \times max\_select $ 个结构用于标记。

### direct
该参数用于设置是否开启direct采样，用于对多模型偏差选出的结构进一步过滤，去除相似的结构。默认值为 False。

### direct_script
该参数用于设置 direct 方法使用的处理脚本，direct 为 True时，必须指定处理脚本。

对 direct 方法的接口设置，请参考[例子 si_direct_bigmodel](./example_si_direct_bigmodel.md#接入-direct-采样)。

<!--
#### md_type
该参数用于设置 lammps 调用力场（机器学习模型）做分子动力学模拟时使用的立场代码。我们这里提供了 fortran 和 libtorch c++ 两种方式，默认值为 `"md_type":1`，即 libtorch 方式，该方式支持 CPU 和 GPU 两种计算资源下的模拟，比 `"md_type":2` （fortran，只支持 CPU计算）方式模拟速度更快。 -->

### compress

该参数用于设置是否对模型做压缩，经过压缩后的模型精度会略有下降，但是模拟速度会有翻倍提升。默认值为 `false`, 即不使用模型压缩。

### compress_order

该参数用于设置模型压缩的方式，默认值为 `"compress_order":3` , 即使用三阶多项式压缩。也可以设置为 `"compress_order":5` ， 即使用五阶多项式压缩，相比于三阶多项式精度会更高，但是速度比三阶稍慢。

### Compress_dx

该参数用于设置模型压缩是的网格大小，默认值为 `"Compress_dx":0.01`。


### 例子

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

<!-- 对于KPU 方式选点策略
```json
    "strategy": {
        "uncertainty":"KPU",
        "max_select": 50,
        "kpu_lower":0.5,
        "kpu_upper":1.5
    }
``` -->
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

### sys_configs

设置待探索的结构文件路径，如果设置了 [`sys_config_prefix`](#sys_config_prefix) 则进行路径拼接，否则使用 sys_configs 中设置的路径作为 config 路径。

该参数为 list 格式，对于 PWMAT 格式结构文件，直接写出文件路径即可，对于 VASP 格式结构文件，需要设置 `format` 格式，如下例中所示。
```json
        "sys_config_prefix": "../../structures",
        "sys_configs": [
                        {"config":"POSCAR", "format":"vasp/poscar"},
                        "49.config",
                        "45.config",
                        "41.config",
                        "37.config",
                        "33.config",
                        "29.config",
                        "25.config",
                        "21.config",
                        "17.config",
                        "1.config"
            ]
```
例如对于 `49.config`文件，它的文件路径为`../../structures/49.config`。

### lmps_prefix

可选参数，用于设置 lammps 探索的输入控制文件路径前缀，`可选参数`，与 [`lmps_in`](#lmps_in) 配合使用。可以是绝对路径或者相对路径，相对路径为当前目录。

例子：`"lmps_prefix":"/data/in_lmps_files"`, `"lmps_in":"in0.lmps"`, 则 `in0.lmps` 的实际路径是 `/data/in_lmps_files/in0.lmps`。

### lmps_in

可选参数，设置设置 lammps 探索的输入控制文件路径，如果设置了 [`lmps_prefix`](#lmps_prefix) 则进行路径拼接，否则使用 lmps_in 中设置的路径作为 lammps 控制文件的路径。

该参数为 list 格式，如下例中所示。

```json
        "lmps_prefix": "../../in_lmps_files",
        "lmps_in": [
                        "in0.lmps",
                        "in1.lmps",
                        "in2.lmps",
                        "in3.lmps",
                        "in4.lmps",
                        "in5.lmps"
            ]
```

### md_jobs

设置每个轮次的主动学习分子动力学参数。为 list 格式，第 `i` 个元组代表第 `i` 个轮次主动学习对应设置。每个元组内部可以为 dict 格式，或者 dict 格式的 list 数组。注意：以下 md 设置中，对于时间的单位都使用 `units metal`。

对于lammps的输入控制，pwact 提供了两种方式。第一种是在 param.json 中提供的关键字设置，控制探索需要的步数、以及lammps温度、压强、系综，可参考[例子](#例子)。第二种是通过`用户提供的lammps.in文件`控制，参数为 [`lmps_prefix`](#lmps_prefix) 和 [`lmps_in`](#lmps_in)。可参考 [金银合金主动学习操作案例](./example_auag_init_zh.md)。

:::tip
第二种设置方式在 `pwact-0.4` 版本中开始支持。
:::

对于第二种，如果用户提供了lammps.in文件，pwact在运行时，会自动维护 lammps.in 文件中的以下字段。

- "dump_freq"，该参数通过 [trj_freq](#trj_freq) 设置，用于设置每隔多少步采样一次
- "units"、 "boundary"、 "atom_style"，由于 MatPL 力场只支持周期性的体系模拟，因此这三个关键字是固定格式，内容为
  ```txt
    units           metal
    boundary        p p p
    atom_style      atomic
  ```
- "restart"，pwact 中自动设置每个1万步保存一次运行状态
- "read_data"，该参数用设置初始结构所在路径，在 pwact 在探索时该值会自动设置为所需路径
- "mass"、 "pair_style"、 "pair_coeff"，该三个参数用于设置机器学习的力场，以对硅元素体系的探索为例，在 pwact 在探索时该值会自动设置为：
  ```txt
    mass    1    28.086
    pair_style   matpl  0_torch_script_module.pt 1_torch_script_module.pt 2_torch_script_module.pt 3_torch_script_module.pt  out_freq ${DUMP_FREQ}  out_file model_devi.out 
    pair_coeff   * * 14
  ```
- "dump"，该值用于设置轨迹的保存格式，在pwact中该值会自动设置为如下内容，并插入到lammps.in文件中的第一个 run 命令所在行前面，这里 DUMP_FREQ 值为[trj_freq](#trj_freq)参数中所设值：
  ```txt
    dump 1 all custom ${DUMP_FREQ} traj/*.lammpstrj id type x y z fx fy fz
  ```

这里以如下设置为例，该lmp.in 文件为硅的lammps模拟输入文件：
```txt
variable        NSTEPS          equal 400
variable        THERMO_FREQ     equal 5
variable        DUMP_FREQ       equal 5
variable        restart         equal 0
variable        TEMP            equal 500.000000
variable        PRESS           equal 100.000000
variable        TAU_T           equal 0.100000
variable        TAU_P           equal 0.500000

units           metal
boundary        p p p
atom_style      atomic

neighbor        1.0 bin
neigh_modify    delay 10

box              tilt large
if "${restart} > 0" then "read_restart lmps.restart.*" else "read_data lmp.config"
change_box       all triclinic

thermo_style    custom step temp pe ke etotal press vol lx ly lz xy xz yz
thermo          ${THERMO_FREQ}
restart         10000 lmps.restart

if "${restart} == 0" then "velocity        all create ${TEMP} 76752"
fix             1 all npt temp ${TEMP} ${TEMP} ${TAU_T} iso ${PRESS} ${PRESS} ${TAU_P}

timestep        0.001000
run             ${NSTEPS} upto

```
运行时，lmp.in会替换为如下内容：
```txt
variable        DUMP_FREQ       equal 5
variable        restart         equal 0
units           metal
boundary        p p p
atom_style      atomic

if "${restart} > 0" then "read_restart lmps.restart.*" else "read_data lmp.config"

mass   1    28.086
pair_style   matpl  0_torch_script_module.pt 1_torch_script_module.pt 2_torch_script_module.pt 3_torch_script_module.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
pair_coeff       * * 14

variable        NSTEPS          equal 400
variable        THERMO_FREQ     equal 5
variable        TEMP            equal 500.000000
variable        PRESS           equal 100.000000
variable        TAU_T           equal 0.100000
variable        TAU_P           equal 0.500000

neighbor        1.0 bin
neigh_modify    delay 10

box              tilt large
change_box       all triclinic


thermo_style    custom step temp pe ke etotal press vol lx ly lz xy xz yz
thermo          ${THERMO_FREQ}

fix             1 all npt temp ${TEMP} ${TEMP} ${TAU_T} iso ${PRESS} ${PRESS} ${TAU_P}

timestep        0.001000
dump            1 all custom ${DUMP_FREQ} traj/*.lammpstrj id type x y z fx fy fz
restart         10000 lmps.restart

if "${restart} == 0" then "velocity        all create ${TEMP} 75740"
run             ${NSTEPS} upto
```

#### sys_idx
用于设置 md 的初始结构，为 list 格式，值为 [`sys_configs`](#sys_configs)中的结构下标，这里可以指定多个结构。

#### select_sys
与 [`sys_idx`](#sys_idx) 配合使用，用于限制 `sys_idx` 中每个初始探索结构的最多用于标注的构型数量，默认不设置，采用 [`max_select`](#max_select)中的设置。如果参数 `max_select` 也未设置，将采用默认值 `100`。例如对于如下设置：
```json
  "sys_idx": [0, 1],
  "select_sys":[20, 30],
```
sys_idx指定了`0`号结构 POSCAR 和 `1`号结构 49.config，在`0`号结构对应的轨迹中最多选取`20`个结构用于标注，在`1`号结构对应的轨迹中最多最多选取`30`个结构用于标注。如果不设置 select_sys，则对0和1号结构分别最多选取[`max_select`](#max_select)个结构做标记。

您也可以设置为`"select_sys":20`，等效于`"select_sys":[20, 20]`。

#### trj_freq
用于设置轨迹采样频率（ `thermo` ），默认值为`10`，即间隔 10 步采样一次。

#### lmps_in_idx
用于第二种lammps输入控制方式。设置对[`sys_idx`](#sys_idx)中对应的初始结构做分子动力学探索的lammps.in文件所在路径。使用如下例子中所示：
```json
        "md_jobs": [
            [{
                "sys_idx": [ 1,3,4],
                "select_sys":[10,15,20],
                "lmps_in_idx":[0, 1, 2],
                "trj_freq": 5
            },{
                "sys_idx": [0, 1],
                "lmps_in_idx":3
            }
            ]]
```
在该例中，对于"sys_idx": [ 1,3,4] 指定了需要探索的结构，即[上例](#sys_configs)中的49.config、41.config、37.config。分别设置lammps控制文件为in0.lmps、 in1.lmps、in2.lmps。设置每隔5步，采样一次。

对于"sys_idx": [0, 1] 指定的结构49.config、41.config，设置lammps输入控制文件in3.lmps。采样间隔用默认值，每个10步采样一次。

存在 lmps_in_idx 设置时，[`ensemble`](#ensemble)、[`nsteps`](#nsteps)、[`md_dt`](#md_dt)、[`press`](#press)、[`taup`](#taup)、[`temps`](#temps)、[`taut`](#taut) 参数将自动失效。

#### ensemble

用于第一种lammps输入控制方式。设置 系综，默认值 `"nve"`,支持如下设置：

`npt`、`npt-i`或`npt-iso` 对应 lammps 设置
```txt
fix  1 all npt temp ${TEMP} ${TEMP} ${TAU_T} iso ${PRESS} ${PRESS} ${TAU_P}
```

`npt-a` 或 `npt-aniso` 对应 lammps 设置
```txt
fix  1 all npt temp ${TEMP} ${TEMP} ${TAU_T} aniso ${PRESS} ${PRESS} ${TAU_P}
```

`npt-t`、`npt-tri` 对应 lammps 设置
```txt
fix  1 all npt temp ${TEMP} ${TEMP} ${TAU_T} tri ${PRESS} ${PRESS} ${TAU_P}
```

`nvt` 对应 lammps 设置
```txt
fix  1 all nvt temp ${TEMP} ${TEMP} ${TAU_T}
```

`nve` 对应 lammps 设置
```txt
fix  1 all nve
```

#### nsteps

用于第一种lammps输入控制方式。设置 md 总的步数，为必选参数，需要用户提供。
#### md_dt

用于第一种lammps输入控制方式。用于设置 `timestep` ，默认值为 `0.001`，即 `1飞秒`。

#### press

用于第一种lammps输入控制方式。用于设置 md 探索的压强，为 list 格式。

#### taup

用于第一种lammps输入控制方式。稳压器的耦合时间（ps）, 默认值 `0.5`。

#### temps

用于第一种lammps输入控制方式。用于设置 md 探索的温度，为 list 格式。

#### taut

用于第一种lammps输入控制方式。恒温器的耦合时间（ps），默认值 `0.1`。

#### boundary

用于第一种lammps输入控制方式。设置模拟系统的边界条件，由于MatPL力场只支持对周期性体系的模拟，因此该值为 `true`，即采用 `p p p`。不需要用户设置。

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
            "boundary":true
        }]
    ]
}
```

在上例中，配置了一个轮次的主动学习，执行 `"md_jobs"`中两个 `dict` 中配置的lammps 模拟。

对于第一个 dict, 使用 `npt` 系综，在 `sys_idx` 配置了两个构型，对应0.`95_scale.poscar`和 `0_pertub.poscar`。温度和压强的列表分别为 `[500, 800]` 和 `[100,200]`，意思是对这两个结构分别在温度、压强组合为 `[500, 100]`、`[500, 800]`、`[800, 100]`、`[800, 200]` 下执行`lammps`模拟，模拟 `1000` 步，输出频率 `10` 步，单步时间长度 `2` 飞秒。模拟结束后，会获得 `8` 条轨迹。

对于第二个dict，使用 `nvt` 系综，在`sys_idx` 配置了`1`个构型，对应 `0_pertub.poscar`，温度为 `400`，即在 温度`400K` 下做`lammps`模拟。模拟结束后获得`1`条轨迹。

下面是"ensemble": "npt", "nsteps": 1000, "md_dt": 0.002, "trj_freq": 10, "sys_idx": 0, "temps": 500, "taut":0.1, "press" :100, "taup": 0.5, "boundary":true 设置下，自动生成的lammps.in输入控制文件内容：
```txt
variable        NSTEPS          equal 400
variable        THERMO_FREQ     equal 5
variable        DUMP_FREQ       equal 5
variable        restart         equal 0
variable        TEMP            equal 500.000000
variable        PRESS           equal 100.000000
variable        TAU_T           equal 0.100000
variable        TAU_P           equal 0.500000

units           metal
boundary        p p p
atom_style      atomic

neighbor        1.0 bin
neigh_modify    delay 10

box              tilt large
if "${restart} > 0" then "read_restart lmps.restart.*" else "read_data lmp.config"
change_box       all triclinic

mass   1    28.086
pair_style   matpl  0_torch_script_module.pt 1_torch_script_module.pt 2_torch_script_module.pt 3_torch_script_module.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
pair_coeff       * * 14

thermo_style    custom step temp pe ke etotal press vol lx ly lz xy xz yz
thermo          ${THERMO_FREQ}
dump            1 all custom ${DUMP_FREQ} traj/*.lammpstrj id type x y z fx fy fz
restart         10000 lmps.restart

if "${restart} == 0" then "velocity        all create ${TEMP} 76752"
fix             1 all npt temp ${TEMP} ${TEMP} ${TAU_T} iso ${PRESS} ${PRESS} ${TAU_P}

timestep        0.001000
run             ${NSTEPS} upto
```
文件中velocity 中的`76752`为随机生成值。
## DFT

设置自洽计算，为 dict 格式。

### dft_style

设置标注（自洽计算）使用哪种 DFT 计算软件，默认值为 `pwmat`, 也支持 VASP 格式，如果是 VASP 格式，则设置为 `vasp`。如果设置为 `bigmodel`，则必须在 [`bigmodel_script`](#bigmodel_script) 中设置处理脚本。

### bigmodel_script
用于设置 大模型做标记（推理能量和受力）时的处理脚本。

对大模型标记的接口设置，请参考[例子 si_direct_bigmodel](./example_si_direct_bigmodel.md#接入-大模型-标记)。

### input

设置输入控制文件的路径，可以为绝对路径或相对路径（相对于当前路径）。

### kspacing

该参数为 PWMAT 的输入参数，用于设置 K 点，可选参数。如果在 etot.input 文件中未设置 `MP_N123` 参数，则使用该参数设置 K 点。不能同时设置 `MP_N123` 与 `kspacing`。

如果 `etot.input` 文件中未设置 `MP_N123`，且 `kspacing` 未设置，则采用默认设置 `kspacing` 值为 `0.5`。

### flag_symm

该参数为 PWMAT 的输入参数，用于设置 K 点，可选参数。对于 Relax 或者 SCF 计算，默认值为 `0`, 对于 AIMD 计算，默认值为 `3`。

### pseudo 
设置 `PWMAT` 或 `VASP` 赝势文件所在路径，为list格式，赝势文件路径可以为绝对路径或相对路径（相对于当前路径）。

<!-- ### in_skf
设置 `DFTB`(PWMAT封装) 的赝势文件上一级目录所在路径，为string 格式，绝对路径或相对路径（相对于当前路径）。 -->

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
<!-- 
如果您使用了集成在PWMAT中的DFTB，则设置为：
```json
"DFT": {
      "dft_style": "pwmat",
      "input": "scf_etot.input",
      "in_skf": "./lisi_dftb_pseudo"
    }
``` -->

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

如下例子，为一个标准的主动学习流程，两个轮次的主动学习，采用多模型委员会查询策略。更多使用案例，请参考源码根目录的 [`example`](https://github.com/LonxunQuantum/PWact/tree/main/examples)。

```json
{
  "reserve_work": false,
  "reserve_md_traj": false,
  "reserve_scf_files": false,

  "init_data": ["/path/init_data"],

  "train": {
    "_train_input_file": "std_si.json",

    "model_type": "DP",
    "atom_type": [14],
    "seed": 2023,
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
      "train_virial": false,
      "pre_fac_force": 2.0,
      "pre_fac_etot": 1.0,
      "pre_fac_virial": 1.0
    }
  },

  "strategy": {
    "uncertainty": "committee",
    "lower_model_deiv_f": 0.05,
    "upper_model_deiv_f": 0.15,
    "model_num": 4,
    "max_select": 10
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
          "boundary": true
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
