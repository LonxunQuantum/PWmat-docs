---
sidebar_position: 0
---

# Resource allocation

## resource.json

设置计算集群资源，包括对训练、分子动力学（MD）、DFT 计算（SCF、Relax、AIMD）使用的计算节点、CPU、GPU 资源以及对应的运行软件（Lammps、VASP、PWMAT、PWMLFF）。

分为三个模块参数， `train`, `explore` 和 `DFT`，对于初始训练集制备（init_bulk）只需要设置 `DFT` 即可。

```json
{
  "train": {
    "command": "",
    "group_size": 1,
    "_parallel_num": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "new3080ti,3080ti,3090",
    "custom_flags": [],
    "source_list": [],
    "module_list": []
  },
  "explore": {
    "command": "mpirun -np 8 lmp_mpi -in in.lammps",
    "group_size": 1,
    "number_node": 1,
    "gpu_per_node": 1,
    "cpu_per_node": 1,
    "queue_name": "new3080ti,3080ti,3090",
    "custom_flags": [],
    "source_list": [],
    "module_list": []
  },
  "DFT": {
    "command": "mpirun -np 4 PWmat",
    "number_node": 1,
    "cpu_per_node": 4,
    "gpu_per_node": 4,
    "group_size": 1,
    "queue_name": "3080ti,new3080ti,3090",
    "custom_flags": [],
    "source_list": [],
    "module_list": []
  }
}
```

## 参数细节

### command

必选参数，设置模块对应命令。

#### DFT 计算

如果使用 PWMAT，则设置为 PWMAT 运行命令，如 "command":"mpirun -np 4 PWmat" ；

如果使用 VASP，则设置为 VASP 对应命令，如 "command":"vasp_std"。

#### explore MD

如果使用 GPU 版本的 lammps，则设置为 "command":"mpirun -np 1 lmp_mpi_gpu -in in.lammps"。 -np 后面为使用的 GPU 数量，需要与 [`gpu_per_node`](#gpu_per_node) 设置保持一致。

如果使用 CPU 版本的 lammps，则设置为 "command":"mpirun -np 8 lmp_mpi -in in.lammps"。-np 后面为使用的 CPU 数量，需要与 [`cpu_per_node`](#cpu_per_node) 设置保持一致。

#### train

如按照 [PWMLFF 文档](http://doc.lonxun.com/PWMLFF/) 安装，请设置为 `"command":"PWMLFF"`。

#

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

必选参数，用于设置使用的计算机群分区，为字符串列表，例如 `"queue_name":"cpu, 3080ti,new3080ti, 3090"`。

### custom_flags

用于设置 Slurm 脚本中的其他 `#SBATCH` 参数，可选参数，为 list 格式。例如，对于

```json
    "custom_flags": [
            "#SBATCH -x gn43,gn66,login"
    ]
```

在执行，将会把 `"#SBATCH -x gn43,gn66,login"` 自动拼接到 Slrum 脚本中。

### source_list

用于设置 slurm 脚本在运行时需要导入的环境变量，可选参数，list 格式。例如，对于

```json
    "source_list": [
        "source /opt/rh/devtoolset-8/enable",
        "export PATH=/path/PWMLFF/src/bin:$PATH"
    ]
```

在执行时，将把字符串 "source /opt/rh/devtoolset-8/enable" 和 "export PATH=/path/PWMLFF/src/bin:$PATH" 自动写入 slrum 脚本中。

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
