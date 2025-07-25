---
sidebar_position: 0
---

# resource.json

## resource.json

设置计算集群资源，包括对训练、分子动力学（MD）、DFT 计算（SCF、Relax、AIMD）使用的计算节点、CPU、GPU 资源以及对应的运行软件（Lammps、VASP、PWMAT、MatPL）。

所有可设置参数按照用途分为 `train`, `explore`, `DFT`, `direct`四种模块，每个模块中的参数意义相同。

对于初始训练集制备（init_bulk）可设置 `explore`, `DFT`, `direct`，这里以 mcloud 环境设置为例。explore 用于设置大模型 MD 环境，direct 用于设置 direct 采样环境，DFT 用于设置对结构做 SCF 或 AIMD 所用环境。

``` json
{
    "DFT": {
        "command":"mpirun -np 4 PWmat",
        "task_run_num":1,
        "number_node": 1,
        "cpu_per_node": 4,
        "gpu_per_node": 4,
        "group_size": 1,
        "queue_name": "3080ti,3090",
        "custom_flags": [
        ],
        "_custom_flags": [
        ],
        "module_list": [
            "compiler/2022.0.2",
            "mkl/2022.0.2",
            "mpi/2021.5.1",
            "cuda/11.6",
            "pwmat"
        ]
    },

    "explore": {
        "command": "python sevennet_md.py",
        "group_size": 1,
        "number_node": 1,
        "gpu_per_node": 1,
        "cpu_per_node": 1,
        "queue_name": "3080ti",
        "custom_flags": [],
        "source_list": [
            "/share/app/anaconda3/envs/SevenNet/env.sh"
        ],
        "module_list": [
        ],
        "env_list": [
        ]
    },

    "direct": {
        "command": "python direct.py",
        "group_size": 1,
        "number_node": 1,
        "gpu_per_node": 1,
        "cpu_per_node": 1,
        "queue_name": "3080ti",
        "custom_flags": [],
        "source_list": [
            "/share/app/anaconda3/envs/m3gnet/env.sh"
        ],
        "module_list": [
        ],
        "env_list": [
        ]
    }
}
```
对于主动学习（run）可设置 `train`, `explore`, `direct`, `DFT`四个模块，这里以 mcloud 环境设置为例。train 用于设置训练环境，explore用于设置lammps分子动力学环境，direct 用于设置 direct 采样环境，DFT 用于设置对结构做 SCF环境 或者 大模型 MD 环境。
做：

```json
{
  "train": {
    "command": "MatPL",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
    ],
    "source_list": [
      "/share/app/MATPL/MatPL-2025.3/env.sh"
    ],
    "module_list": [
    ],
    "env_list":[
    ]
  },
  "explore": {
    "command": "mpirun -np 1 lmp_mpi -in in.lammps",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [],
    "source_list": [],
    "module_list": [
      "lammps4matpl/2025.3"
    ],
    "env_list":[]
  },
  "DFT": {
    "command": "mpirun -np 4 PWmat",
    "number_node": 1,
    "cpu_per_node": 4,
    "gpu_per_node": 4,
    "group_size": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [],
    "source_list": [],
    "module_list": [],
    "env_list":[
      "compiler/2022.0.2",
      "mkl/2022.0.2",
      "mpi/2021.5.1",
      "cuda/11.6",
      "pwmat"
    ]
  }
}
```
## 参数细节
参数可以分为3类。
用于设置运行命令的`command`；

用于设置每个计算任务的资源数量
`number_node`、`cpu_per_node`、`gpu_per_node`、`group_size`、`queue_name`、`custom_flags`；

用于加载软件和环境变量 `custom_flags`、`source_list`、`module_list`、`env_list`。

详细解释如下。
### command

必选参数，设置模块对应命令。

不同任务的设置，例子：

对于DFT计算设置
```json
    
    PWmat 设置：
    "command":"mpirun -np 4 PWmat"
    VASP设置：
    "command":"vasp_std"
    cp2k设置：
    "command":"mpirun -np $SLURM_NTASKS cp2k.popt"
```

对于 Lammps 计算设置：
```
    "command":"mpirun -np 10 lmp_mpi"
```
-np 后面为使用的 CPU 数量，需要与[`cpu_per_node`](#cpu_per_node) 设置保持一致，如果 [`gpu_per_node`](#gpu_per_node)设置，那么 np中设置的 cpu 任务将平均分配到 gpu_per_node 所设置的 GPU 上。

对于 [MatPL 文档](http://doc.lonxun.com/MatPL) 模型训练设置：
```
    "command":"MatPL"
```

### group_size

该参数用于多个计算任务提交时的分组，同组内的计算任务将顺序执行。组间任务并行。

例如，对于 `34` 个 自洽计算任务，`"group_size":5`，此时将把 34 个自洽计算任务分为 `6` 个组，即 6 个 slurm 任务，每个 slrum 任务包含 5 个自洽计算（最后一个组有 4 个计算任务）。执行时，6 个 slurm 任务将同时提交到计算集群（slurm 任务内部的 5 个自洽计算将串行执行）。

- 对于训练或探索任务，默认值为`1`，每组1个任务，即所有任务同时提交。
- 对于 AIMD 或 SCF 任务，即`DFT`下的参数，默认值为`-1`，所有任务将分到一个组内，执行时，每个任务串行执行（即任务执行完毕后再提交执行下一个任务）。建议您根据实际的任务数量设置该参数，避免同时提交大量DFT任务，挤占所有计算资源。

### number_node

用于设置每个 slurm 任务的计算节点数量，默认值为 `1`，即 1 个计算节点。

在 train 模块，该参数自动设置 1。

### gpu_per_node

用于设置每个节点下使用的 GPU 数目，默认值为 `0`，如果使用 PWMAT 做 DFT 计算（自洽计算、驰豫或者 AIMD）该值需要与 [`"command"`](#command) 中设置的 GPU 数量一致。

在 train 模块，该参数自动设置 1。

### cpu_per_node

用于设置每个节点使用的 CPU 数目，默认值为 `1`，注意该值需要 ">= [gpu_per_node](#gpu_per_node)"。

在 train 模块，该参数自动设置 1。

### queue_name

必选参数，用于设置使用的计算机群分区，为 `","` 分割的字符串列表，例如 `"queue_name":"cpu, 3080ti, 3090"`。

### custom_flags

用于设置 Slurm 脚本中的其他 `#SBATCH` 参数，可选参数，为 list 格式。例如，对于

```json
    "custom_flags": [
      "#SBATCH -x gn43,gn66"
    ]
```

在执行，将会把 `"#SBATCH -x gn43,gn66"` 自动拼接到 Slrum 脚本中。这里 “#SBATCH” 也可以省略，只写 “-x gn43,gn66”。

:::info
例如对于设置：
```json
    "number_node": 1,
    "cpu_per_node": 4,
    "gpu_per_node": 4,
    "queue_name": "3080ti,3090",
    "custom_flags": [
      "#SBATCH -x gn43,gn66"
    ]
```
生成的 slurm 头文件为：
```bash
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --ntasks-per-node=4
#SBATCH --partition=3080ti,3090
#SBATCH -x gn43,gn66
```
由于部分机器不支持`--gpus-per-task`参数设置，因此 pwact 不会自动生成该行配置，如果需要设置，请写到 `custom_flags`中即可。
:::

### source_list

用于设置 slurm 脚本在运行时需要导入的环境变量，可选参数，list 格式。例如，对于

```json
    "source_list": [
        "~/anaconda3/etc/profile.d/conda.sh"
    ]
```

在执行时，把字符串自动拼接前缀 "source "后，将"source /opt/rh/devtoolset-8/enable" 自动写入 slrum 脚本中。

### module_list

用于设置 slurm 脚本在运行时需要加载的软件模块，可选参数，list 格式。

例如，对于
```json
    "module_list": [
        "cuda/11.8",
        "intel/2020"
    ]
```


在执行时，将会把字符串 "module load cuda/11.8" 和 "module load intel/2020" 自动写入 slurm 脚本中。

### env_list
用于设置slurm脚本在运行时需要加载的环境信息，可选参数，list格式。

例如，对于
```json
    "env_list": [
        "source the/path/MatPL-2025.3/env.sh"
    ]
```


在执行时，会将这条字符串完整写入slurm脚本中。

按照上述 [queue_name](#queue_name)、[custom_flags](#custom_flags)、[source_list](#queue_name)、[module_list](#module_list)、[env_list](#env_list) 中的设置，生成的slurm脚本内容如下：

```bash

#SBATCH --partition=3080ti,3090
#SBATCH -x gn43,gn66

source /opt/rh/devtoolset-8/enable
module load cuda/11.8
module load intel/2020
source the/path/MatPL-2025.3/env.sh
```

# 配置案例详解

## train模块

对于 `train` 模块，需要加载 MatPL 的 Python运行环境，如果使用 [MCLOUD](../install/README.md) 上已安装的 MatPL 做训练，对应的设置如下：
```json
  "train": {
    "command": "MatPL",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
    ],
    "source_list": [
    "/share/app/MATPL/MatPL-2025.3/env.sh"
    ],
    "env_list": [
    ],
    "module_list": [
    ]
  }
```

这里对于每个训练任务使用`1`个计算节点，使用该节点的`1`张GPU,`1`个CPU，该节点位于分区`3080ti` 或 `3090`。

如果从 MatPL 源码编译安装，对应的设置如下：

```json
  "train":{
    "command": "MatPL",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
    ],
    "source_list": [
        "~/anaconda3/etc/profile.d/conda.sh",
        "the/path/MatPL-2025.3/env.sh"
    ],
    "env_list": [
        "conda activate matpl-2025.3"
    ],
    "module_list": [
        "cuda/11.8-share",
        "intel/2020"
    ]
  }

```

这里 `"~/anaconda3/etc/profile.d/conda.sh"`为笔者计算集群中的conda加载路径，`matpl-2025.3` 为 MatPL 的 Python 环境，`the/path/MatPL-2025.3`为源码所在路径。

## explore模块

对于explore模块，如果使用 MCLOUD 已安装的 LAMMPS 为例，直接加载`lammps4matpl` 软件即可，完整的设置如下：
```json
    "explore": {
      "command": "mpirun -np 1 lmp_mpi",
      "group_size": 2,
      "number_node": 1,
      "gpu_per_node": 1,
      "cpu_per_node": 1,
      "queue_name": "3080ti,3090",
      "custom_flags": [
      ],
      "source_list": [

      ],
      "module_list": [
          "lammps4matpl/2025.3"
      ],
      "env_list":[

      ]
    }
``` 

这里对于每个lammps任务，使用`1`个计算节点，使用该节点的`1`张GPU,`1`个CPU，每 `2` 个lammps任务分为1个组。

如果从 LAMMPS 源码编译安装，对应的设置如下：
```json
  "explore": {
    "command": "mpirun -np 1 lmp_mpi",
    "group_size": 2,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
    ],
    "source_list": [
        "the/path/of/lammps/env.sh"
    ],
    "module_list": [
        "cuda/11.8-share",
        "intel/2020"
    ],
    "env_list":[
    ]
    }

``` 
这里 `the/path/of/lammps/env.sh`为 lammps 源码所在路径，lammps力场接口

## DFT 模块

对于DFT 模块，这里以加载PWMAT为例，设置如下。
```json
  "DFT": {
      "command":"PWmat",
      "number_node": 1,
      "cpu_per_node": 4,
      "gpu_per_node": 4,
      "group_size": 5,
      "queue_name": "3080ti,1080ti,3090",
      "custom_flags": [
      "#SBATCH -x gn18,gn17"
      ],
      "module_list": [
          "compiler/2022.0.2",
          "mkl/2022.0.2",
          "mpi/2021.5.1",
          "cuda/11.6"
      ],
      "env_list":[
      ]
  }
```
这里对于每个 PWmat 任务，使用`1`个计算节点，使用该节点的`1`张GPU,`1`个CPU，每 `5` 个DFT任务分为1个组。