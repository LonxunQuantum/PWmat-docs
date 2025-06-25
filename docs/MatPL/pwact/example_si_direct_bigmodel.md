---
sidebar_position: 4
---

# Example for Si active learning (Bigmodel and Direct)

本案例为硅体系的主动学习过程，采用了大模型（eqv2）和direct采样。在 [`PWact/examples/`](https://github.com/LonxunQuantum/PWact/tree/main/pwact/example) 下准备了多种组合设置，每种组合的信息请参考[`PWact/examples/README.md`](https://github.com/LonxunQuantum/PWact/blob/main/examples/README.md)。对于 Mcloud用户，请访问路径`/share/public/PWMLFF_test_data/pwact_examples/25-pwact-demo`即可。这里以[`PWact/examples/si_pwmatgaussion_bigmodel_direct`] 为例介绍 大模型和 direct 方法的参数设置、脚本设置。
对于 `INIT_BULK` 构造初始训练集，以[`examples/si_pwmatgaussion_bigmodel_direct/init_bulk_bigmodel`](https://github.com/LonxunQuantum/PWact/tree/main/examples/si_pwmatgaussion_bigmodel_direct/init_bulk_bigmodel)为例：

 - step1. 用 PWmat (gaussion 基组) 做relax；
 - step2. 对结构调用大模型（seventnet）做分子动力学；
 - step3. 对分子动力学得到的轨迹做 direct 采样，去掉轨迹中相似的结构，筛选出的结构用于后续主动学习

请注意，本目录中使用的是 gaussian 基组的 PWmat，仅用于快速测试，例子生成的数据不具有可靠性。

# INIT_BULK

## 启动命令

进入 `examples/si_pwmatgaussion_bigmodel_direct/init_bulk_bigmodel` 目录 ，这里提供了在 mcloud 上的执行脚本，也可以通过如下命令执行。
```JSON
pwact init_bulk init_param.json resource.json
```

## INIT_BULK 目录结构

INIT_BULK 目录与 [si_pwmat 案例](./example_si_init_zh.md#init_bulk) 相似，只是多了一项 `bigmodel` 目录，如下所示。
```
.
├── datapath.txt
├── init_config_0/
├── init_config_1/
└── bigmodel/
    ├── 0-bigmodel.job
    ├── 0-tag.bigmodel.success
    ├── 1-bigmodel.job
    ├── 1-tag.bigmodel.success
    ├── ...
    ├── direct/
    │   ├── 0-direct.job
    │   ├── 0-tag.direct.success
    │   ├── candidate.json
    │   ├── candidate.xyz
    │   ├── Cov_score.png
    │   ├── direct.py
    │   ├── PCA_direct.png
    │   ├── PCA_variance.png
    │   ├── PWdata
    │   ├── select_idx.dat
    │   ├── select.xyz
    │   └── tag.direct.success
    ├── init_config_0/
    │   ├── 0.95_scale/
    │   │   ├── 3_bigmodel/
    │   │   │   ├── npt.log
    │   │   │   ├── POSCAR
    │   │   │   ├── sevennet_md.py
    │   │   │   ├── tag.bigmodel.success
    │   │   │   ├── tmp.traj
    │   │   │   └── traj.xyz
    │   │   ├── 4_bigmodel/
    │   │   └── 5_bigmodel/
    │   ├── 0.9_scale/
    │   └── 1.0_scale/
    └── init_config_*/
```

- `*-bigmodel.job` 和 `*-tag.bigmodel.success` 为 大模型运行 MD 的slurm脚本和执行成功的 tag 标记文件
- `init_config_0`、`init_config_1`、... 目录为执行大模型 MD 的工作目录
- `direct` 目录为执行 `direct` 方法筛选结构的工作目录

## 接入 大模型 MD
对于大模型 MD，提供了用户自定义接口，要求用户配置大模型的运行环境，可参考例子中使用的[sevennet_md.py](https://github.com/LonxunQuantum/PWact/blob/main/examples/si_pwmatgaussion_bigmodel_direct/sevennet_md.py)。

如目录 `bigmodel/init_config_0/0.95_scale/3_bigmodel/` 所示，在 init_bulk 运行过程中，pwact 检查到存在 [bigmodel](./init_param_zh.md#bigmodel) 设置时，会把对应结构按照类似`bigmodel/init_config_0/0.95_scale/3_bigmodel/`目录所示生成，包括一个 VASP/POSCAR 格式的POSCAR文件，拷贝用户提供的运行 MD 脚本的接口文件到该目录，如sevennet_md.py文件，根据用户在 resource.json 中设置的 `explore`，自动生成slurm 脚本，提交运行。

用户需要在脚本中读取 POSCAR 文件后运行 MD，将生成的轨迹转换为 `extxyz`格式的文件，文件名称固定为 `traj.xyz`。之后，pwact 将检测该文件，用于后续处理。

## 接入 direct 采样
对于 direct 采样，提供了用户自定义接口，要求用户direct 方法的运行环境，可参考例子中使用的[direct.py](https://github.com/LonxunQuantum/PWact/blob/main/examples/si_pwmatgaussion_bigmodel_direct/direct.py)。

如目录 `bigmodel/direct/` 所示，在 大模型MD 运行结束后，会生成多条轨迹文件，pwact 会自动探测轨迹文件，将文件合并为 一个 名为 `candidate.xyz`的文件，放到目录`bigmodel/direct` 下。拷贝用户在 [direct_input](./init_param_zh.md#direct_input) 提供的运行 direct 脚本的接口文件到该目录，如 direct.py 文件，根据用户在 resource.json 中设置的 `direct`，自动生成 slurm 脚本，提交运行。

用户需要在脚本中读取 `candidate.xyz` 文件，之后需要生成 `select_idx.dat` 和 `select.xyz` 两个文件，其中 select_idx.dat 保存筛选出的结构在 candidate.xyz 中对应的下标，select.xyz 保存筛选出的结构。pwact 会自动读取这两个文件用于后续的执行。

# 主动学习

我们使用 INIT_BULK 案例中的预训练数据和微扰后的结构，在 500K、800K 和 1100K 下做主动学习。

启动命令：
执行完毕 init_bulk 命令之后，进入 `examples/si_pwmatgaussion_bigmodel_direct/run_iter_direct_bigmodel` 目录：
```
pwact run param.json resource.json
```

## 主动学习文件目录

主动学习的目录结构与 [si_pwmat 例子](./example_si_init_zh.md#主动学习)中相似。

### train 目录
train 目录 与 [si_pwmat 例子](./example_si_init_zh.md#train-目录) 相同

### explore 目录

`explore`目录除了`md`和`select`子目录外，新增加了一个名为`bigmodel`的子目录，子目录内容与 [init_bulk direct](#接入-direct-采样) 中相同。

`md`和`select`子目录与 [si_pwmat 例子](./example_si_init_zh.md#explore-目录) 相同

### label 目录

如果设置了使用大模型做标注[`bigmodel_script`](./run_param_zh.md#bigmodel_script)，则在 label 目录下新增一个`bigmodel`子目录。该子目录结构如下所示：
```txt
bigmodel/
├── 0-bigmodel.job
├── eqv2_label.py
├── select.xyz
└── train.xyz
```
- `eqv2_label.py` 为 用户设置的 bigmodel_script 脚本文件，pwact 运行时会将改文件拷贝到 bigmodel目录下
- `select.xyz`为 大模型标注的输入结构文件，格式为 extxyz
- `train.xyz` 为 大模型标注后的输出结构文件，格式为 extxyz，相比于 select.xyz，结构顺序相同，但是多了 能量和力的信息
- `0-bigmodel.job` 为 pwact 根据用户在 resource.json 中的 DFT 设置，生成的 slurm 脚本

#### 接入 大模型 标记
对于 大模型 标记，提供了用户自定义接口，要求用户提供 大模型 的运行环境，可参考例子中使用的[eqv2_label.py](https://github.com/LonxunQuantum/PWact/blob/main/examples/si_pwmatgaussion_bigmodel_direct/eqv2_label.py)。

如目录 `bigmodel/` 所示，在 explore 步骤，经过多模型偏差筛选（或继续使用direct 筛选）后，pwact 会自动探测筛选出的结构，将文件合并为 一个 名为 `select.xyz`的文件，放到目录`bigmodel/` 下。拷贝用户在 [bigmodel_script](./run_param_zh.md#bigmodel_script) 提供的运行 bigmodel 脚本的接口文件到该目录，如 eqv2_label.py 文件，根据用户在 resource.json 中设置的 `DFT`，自动生成 slurm 脚本，提交运行。

用户需要在脚本中读取 `select.xyz` 文件，之后需要生成 `train.xyz` 文件，train.xyz 相比于 select.xyz 多了能量和力信息。pwact 会自动读取这该文件用于后续的执行。

#### result
`result` 为标记结束后的带标签数据集汇总，如果设置 `data_format` 为 `extxyz` 格式，将提取为 train.xyz 文件。如果为 `pwmlff/npy` 格式，则为 PWdata 目录，目录下是具体数据。
