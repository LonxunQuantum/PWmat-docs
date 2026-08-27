---
sidebar_position: 0
title: resource Configuration
---

## resource Configuration

### resource.json File
This file configures cluster resources for training, molecular dynamics, and DFT calculations (SCF, relaxation, and AIMD), including compute nodes, CPUs, GPUs, and software such as LAMMPS, VASP, PWmat, and MatPL.

Parameters are grouped into `train`, `explore`, `DFT`, and `direct` modules. The resource fields have the same meaning in every module.

For initial training-set preparation (`init_bulk`), configure `explore`, `DFT`, and `direct`. In the Mcloud example below, `explore` defines the foundation-model MD environment, `direct` defines the DIRECT sampling environment, and `DFT` defines the environment for SCF or AIMD calculations.

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
For active learning (`run`), configure all four modules. In the Mcloud example below, `train` defines the training environment, `explore` defines the LAMMPS MD environment, `direct` defines the DIRECT sampling environment, and `DFT` defines the environment for SCF calculations or foundation-model labeling.

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

### Parameter Details
The parameters fall into three categories:
`command`, which defines the executable command;

resource fields for each computational task:
`number_node`、`cpu_per_node`、`gpu_per_node`、`group_size`、`queue_name`、`custom_flags`；

and `custom_flags`, `source_list`, `module_list`, and `env_list`, which load software and environment variables.

The fields are described below.
### command

Required. Sets the command for the module.

Examples for different tasks:

For DFT calculations:
```json
    
    PWmat:
    "command":"mpirun -np 4 PWmat"
    VASP:
    "command":"vasp_std"
    CP2K:
    "command":"mpirun -np $SLURM_NTASKS cp2k.popt"
```

For LAMMPS:
```
    "command":"mpirun -np 10 lmp_mpi"
```
The value after `-np` is the CPU process count and must match [`cpu_per_node`](#cpu_per_node). When [`gpu_per_node`](#gpu_per_node) is set, these processes are distributed evenly across the configured GPUs.

For model training with [MatPL](http://doc.lonxun.com/MatPL):
```
    "command":"MatPL"
```

### group_size

Groups multiple submitted calculations. Tasks within a group run sequentially, while groups run in parallel.

For example, with `34` SCF calculations and `"group_size": 5`, PWact creates `7` groups (six groups of five and one group of four), represented by seven Slurm jobs. The Slurm jobs are submitted in parallel, while the calculations inside each job run sequentially.

- For training or exploration, the default is `1`, so each task forms its own group and all tasks are submitted together.
- For AIMD or SCF tasks under `DFT`, the default is `-1`, placing all tasks in one group for sequential execution. Set this value according to the workload to avoid submitting enough DFT jobs to consume all cluster resources.

### number_node

Sets the number of compute nodes per Slurm job. The default is `1`.

In the `train` module, this value is automatically set to `1`.

### gpu_per_node

Sets the number of GPUs per node. The default is `0`. For PWmat DFT calculations (SCF, relaxation, or AIMD), it must match the GPU count specified by [`command`](#command).

In the `train` module, this value is automatically set to `1`.

### cpu_per_node

Sets the number of CPUs per node. The default is `1`, and it must be greater than or equal to [`gpu_per_node`](#gpu_per_node).

In the `train` module, this value is automatically set to `1`.

### queue_name

Required. Sets the cluster partitions as a comma-separated string, for example `"queue_name":"cpu, 3080ti, 3090"`.

### custom_flags

Optional list of additional `#SBATCH` options for the Slurm script. For example:

```json
    "custom_flags": [
      "#SBATCH -x gn43,gn66"
    ]
```

PWact adds `"#SBATCH -x gn43,gn66"` to the Slurm script. The `#SBATCH` prefix may be omitted, leaving only `-x gn43,gn66`.

:::info
For example, with the following settings:
```json
    "number_node": 1,
    "cpu_per_node": 4,
    "gpu_per_node": 4,
    "queue_name": "3080ti,3090",
    "custom_flags": [
      "#SBATCH -x gn43,gn66"
    ]
```
the generated Slurm header is:
```bash
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --ntasks-per-node=4
#SBATCH --partition=3080ti,3090
#SBATCH -x gn43,gn66
```
Because some systems do not support `--gpus-per-task`, PWact does not generate it automatically. Add it through `custom_flags` when needed.
:::

### source_list

Optional list of environment scripts to source at runtime. For example:

```json
    "source_list": [
        "~/anaconda3/etc/profile.d/conda.sh"
    ]
```

PWact prefixes each string with `source ` and writes it to the Slurm script.

### module_list

Optional list of software modules to load in the Slurm script.

For example:
```json
    "module_list": [
        "cuda/11.8",
        "intel/2020"
    ]
```


PWact writes `module load cuda/11.8` and `module load intel/2020` to the Slurm script.

### env_list
Optional list of arbitrary environment commands written verbatim to the Slurm script.

For example:
```json
    "env_list": [
        "source the/path/MatPL-2025.3/env.sh"
    ]
```


The string is copied directly into the Slurm script.

With the [queue_name](#queue_name), [custom_flags](#custom_flags), [source_list](#queue_name), [module_list](#module_list), and [env_list](#env_list) settings above, the generated Slurm script contains:

```bash

#SBATCH --partition=3080ti,3090
#SBATCH -x gn43,gn66

source /opt/rh/devtoolset-8/enable
module load cuda/11.8
module load intel/2020
source the/path/MatPL-2025.3/env.sh
```

### Configuration Example: train Module

The `train` module requires the MatPL Python environment. To use the MatPL installation on [Mcloud](../install/README.md), configure:
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

Each training task uses one node, one GPU, and one CPU from either the `3080ti` or `3090` partition.

For a MatPL installation built from source, use:

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

Here, `"~/anaconda3/etc/profile.d/conda.sh"` is the Conda initialization script, `matpl-2025.3` is the MatPL Python environment, and `the/path/MatPL-2025.3` is the source path.

### Configuration Example: explore Module

For the `explore` module with the LAMMPS installation on Mcloud, load `lammps4matpl` as follows:
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

Each LAMMPS task uses one node, one GPU, and one CPU, with two LAMMPS tasks per group.

For LAMMPS built from source, use:
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
Here, `the/path/of/lammps/env.sh` is the environment file in the LAMMPS source tree.

### Configuration Example: DFT Module

The following example configures PWmat in the `DFT` module:
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
Each PWmat task uses one node, four GPUs, and four CPUs, with five DFT tasks per group.
