---
sidebar_position: 0
---

# resource.json

## resource.json

设置计算集群资源，包括对训练、分子动力学（MD）、DFT 计算（SCF、Relax、AIMD）使用的计算节点、CPU、GPU 资源以及对应的运行软件（Lammps、VASP、PWMAT、PWMLFF）。

分为三个模块参数， `train`, `explore` 和 `DFT`，每个模块中的参数意义相同。对于初始训练集制备（init_bulk）只需要 `DFT` 模块即可。如下json文件中所示，设置了用于三个模块的资源设置。

加载 mcloud 环境做主动学习：

```json
{
  "train": {
    "command": "PWMLFF",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
      "#SBATCH -x gn43,gn66"
    ],
    "source_list": [
      "/share/app/PWMLFF/PWMLFF2024.5/env.sh"
    ],
    "module_list": [
    ],
    "env_list":[
    ]
  },
  "explore": {
    "command": "mpirun -np 1 lmp_mpi_gpu -in in.lammps",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [],
    "source_list": [],
    "module_list": [
      "lammps4pwmlff/2024.5"
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

加载自己安装软件环境做主动学习：

```json
{
  "train": {
    "command": "PWMLFF",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
      "#SBATCH -x gn43,gn66"
    ],
    "source_list": [
      "/the/path/anaconda3/etc/profile.d/conda.sh"
    ],
    "module_list": [
      "cuda/11.8-share",
      "intel/2020"
    ],
    "env_list":[
      "conda activate PWMLFF",
      "export PYTHONPATH=/the/path/PWMLFF2024.5/src/:$PYTHONPATH"
    ]
  },
  "explore": {
    "command": "mpirun -np 1 lmp_mpi_gpu -in in.lammps",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [],
    "source_list": [
      "/the/path/anaconda3/etc/profile.d/conda.sh"
    ],
    "module_list": [
      "cuda/11.8-share",
      "intel/2020"
    ],
    "env_list":[
      "conda activate PWMLFF",
      "export PYTHONPATH=/the/path/PWMLFF2024.5/src:$PYTHONPATH",
      "export PATH=/the/path/PWMLFF2024.5/src/bin:$PATH",
      "export PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$PATH",
      "export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src/:$LD_LIBRARY_PATH",
      "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c \"import torch; print(torch.__path__[0])\")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib"
    ]
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

对于 Lammps 计算设置（GPU版本和CPU版本）：
```
    "command":"mpirun -np 1 lmp_mpi_gpu" 
    "command":"mpirun -np 10 lmp_mpi"
```
-np 后面为使用的 GPU 或者 CPU 数量，需要与 [`gpu_per_node`](#gpu_per_node)或[`cpu_per_node`](#cpu_per_node) 设置保持一致。

对于 [PWMLFF 文档](http://doc.lonxun.com/MatPL/) 模型训练设置：
```
    "command":"PWMLFF"
```

### group_size

该参数用于多个计算任务提交时的分组，同组内的计算任务将顺序执行。组间任务并行。默认值为`1`，即不分组。

例如，对于 `34` 个 自洽计算任务，`"group_size":5`，此时将把 34 个自洽计算任务分为 `6` 个组，即 6 个 slurm 任务，每个 slrum 任务包含 5 个自洽计算（最后一个组有 4 个计算任务）。执行时，6 个 slurm 任务将同时提交到计算集群（slurm 任务内部的 5 个自洽计算将串行执行）。

在 train 模块，该参数自动设置 1。

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
        "cuda/11.6",
        "intel/2020"
    ]
```


在执行时，将会把字符串 "module load cuda/11.6" 和 "module load intel/2020" 自动写入 slurm 脚本中。

### env_list
用于设置slurm脚本在运行时需要加载的环境信息，可选参数，list格式。

例如，对于
```json
    "env_list": [
        "export PATH=~/codespace/PWMLFF2024.5/src/bin:$PATH",
        "export PYTHONPATH=~/codespace/PWMLFF2024.5/src/:$PYTHONPATH",
    ]
```


在执行时，会将两条字符串完整写入slurm脚本中。

按照上述 [queue_name](#queue_name)、[custom_flags](#custom_flags)、[source_list](#queue_name)、[module_list](#module_list)、[env_list](#env_list) 中的设置，生成的slurm脚本内容如下：

```bash

#SBATCH --partition=3080ti,3090
#SBATCH -x gn43,gn66

source /opt/rh/devtoolset-8/enable
module load cuda/11.6
module load intel/2020
export PATH=~/codespace/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=~/codespace/PWMLFF2024.5/src/:$PYTHONPATH
```

# 配置案例详解

## train模块

对于 `train` 模块，需要加载 PWMLFF的Python运行环境，如果使用 [MCLOUD](#https://mcloud.lonxun.com/) 上已安装的 PWMLFF 做训练，对应的设置如下：
```json
  "train": {
    "command": "PWMLFF",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
    ],
    "source_list": [
    "/share/app/PWMLFF/PWMLFF2024.5/env.sh"
    ],
    "env_list": [
    ],
    "module_list": [
    ]
  }
```

这里对于每个训练任务使用`1`个计算节点，使用该节点的`1`张GPU,`1`个CPU，该节点位于分区`3080ti` 或 `3090`。

如果从 PWMLFF 源码编译安装，这里以笔者的计算机群环境配置为例，对应的设置如下：

```json
  "train":{
    "command": "PWMLFF",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
    ],
    "source_list": [
        "~/anaconda3/etc/profile.d/conda.sh"
    ],
    "env_list": [
        "conda activate PWMLFF",
        "export PATH=~/codespace/PWMLFF2024.5/src/bin:$PATH",
        "export PYTHONPATH=~/codespace/PWMLFF2024.5/src/:$PYTHONPATH"
    ],
    "module_list": [
        "cuda/11.8-share",
        "intel/2020"
    ]
  }

```

这里 `"~/anaconda3/etc/profile.d/conda.sh"`为笔者计算集群中的conda加载路径，`PWMLFF` 为 PWMLFF 的 Python 环境，`~/codespace/PWMLFF2024.5`为源码所在路径。

## explore模块

对于explore模块，如果使用 MCLOUD 已安装的 LAMMPS 为例，直接加载`lammps4pwmlff` 软件即可，完整的设置如下：
```json
    "explore": {
      "command": "mpirun -np 1 lmp_mpi_gpu",
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
          "lammps4pwmlff/2024.5"
      ],
      "env_list":[

      ]
    }
``` 

这里对于每个lammps任务，使用`1`个计算节点，使用该节点的`1`张GPU,`1`个CPU，每 `2` 个lammps任务分为1个组。

如果从 LAMMPS 源码编译安装，这里以笔者的计算机群环境配置为例，对应的设置如下：
```json
  "explore": {
    "command": "mpirun -np 1 lmp_mpi_gpu",
    "group_size": 2,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "3080ti,3090",
    "custom_flags": [
    ],
    "source_list": [
        "~/anaconda3/etc/profile.d/conda.sh"
    ],
    "module_list": [
        "cuda/11.8-share",
        "intel/2020"
    ],
    "env_list":[
        "conda activate PWMLFF",
        "export PATH=~/codespace/PWMLFF2024.5/src/bin:$PATH",
        "export PYTHONPATH=~/codespace/PWMLFF2024.5/src/:$PYTHONPATH",
        "export PATH=~/codespace/lammps_torch/src:$PATH",
        "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c \"import torch; print(torch.__path__[0])\")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib"
    ]
    }

``` 
这里 `"~/anaconda3/etc/profile.d/conda.sh"`为笔者计算集群中的conda加载路径，`PWMLFF` 为PWMLFF的Python环境，`~/codespace/PWMLFF2024.5`为 PWMLFF 源码所在路径， `lammps_torch`为 lammps 源码所在路径。

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