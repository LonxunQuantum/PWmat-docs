---
sidebar_position: 0
---

# Resource allocation

## resource.json

Set up computing cluster resources for training, molecular dynamics (MD), and DFT calculations (SCF, Relax, AIMD). This includes specifying the computing nodes, CPU/GPU resources, and corresponding software (Lammps, VASP, PWMAT, PWMLFF).

It is divided into three module parameters: `train`, `explore`, and `DFT`. For initial training set preparation (init_bulk), only `DFT` needs to be set, as shown in the following JSON dict.

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

## param details

### command

A mandatory parameter that sets the corresponding command for the module.
Different task configurations, examples:

For DFT calculations:
```json
PWmat settings:
"command": "mpirun -np 4 PWmat"
DFTB (PWmat) settings:
"command": "PWmat"
VASP settings:
"command": "vasp_std"
cp2k settings:
"command": "mpirun -np $SLURM_NTASKS cp2k.popt"
```

For Lammps calculations (GPU version and CPU version):
```
"command": "mpirun -np 1 lmp_mpi_gpu"
"command": "mpirun -np 10 lmp_mpi"
```
The number after -np represents the number of GPUs or CPUs used, which should be consistent with the `gpu_per_node` or `cpu_per_node` settings.

For model training settings in [PWMLFF documentation](http://doc.lonxun.com/PWMLFF/):
```
"command": "PWMLFF"
```


### group_size

This parameter is used for grouping multiple computing tasks, where tasks within the same group are executed sequentially while tasks between groups are parallelized. The default value is `1`, which means no grouping.

For example, if there are `34` self-consistent calculation tasks and `"group_size":5` is set, the 34 self-consistent calculation tasks will be divided into `6` groups, resulting in 6 slurm tasks, each containing 5 self-consistent calculations (the last group will have 4 calculation tasks). During execution, the 6 slurm tasks will be submitted to the computing cluster simultaneously (the 5 self-consistent calculations within each slurm task will be executed sequentially).

In the train module, this parameter is automatically set to 1.

### number_node

Used to set the number of computing nodes for each slurm task. The default value is `1`, indicating 1 computing node.

In the train module, this parameter is automatically set to 1.

### gpu_per_node

Used to set the number of GPUs used per node. The default value is `0`. If PWMAT is used for DFT calculations (self-consistent calculations, relaxation, or AIMD), this value needs to match the number of GPUs set in [`"command"`](#command).

In the train module, this parameter is automatically set to 1.

### cpu_per_node

Used to set the number of CPUs used per node. The default value is `1`. Note that this value needs to be ">= [gpu_per_node](#gpu_per_node)".

In the train module, this parameter is automatically set to 1.

### 

A required parameter used to set the compute cluster partition(s) to be used. It is a string list. For example, `"queue_name":"cpu, 3080ti,new3080ti, 3090"`.

### custom_flags

Used to set additional `#SBATCH` parameters in the Slurm script. It is an optional parameter in list format. For example, for

```json
    "custom_flags": [
            "#SBATCH -x gn43,gn66,login"
    ]
```

During execution, the string `"#SBATCH -x gn43,gn66,login"` will be automatically appended to the Slurm script.

### source_list

Used to set the environment variables that need to be imported during the execution of the Slurm script. It is an optional parameter in list format. For example, for

```json
    "source_list": [
        "source /opt/rh/devtoolset-8/enable"
    ]
```

During execution, the strings "source /opt/rh/devtoolset-8/enable" and "export PATH=/path/PWMLFF/src/bin:$PATH" will be automatically written into the Slurm script.

### module_list

Used to set the software modules that need to be loaded during the execution of the Slurm script. It is an optional parameter in list format.

For example, for

```json
    "module_list": [
        "cuda/11.6",
        "intel/2020"
    ]
```

During execution, the strings "module load cuda/11.6" and "module load intel/2020" will be automatically written into the Slurm script.

### env_list
Used to set the environment information that the slurm script needs to load at runtime. It is an optional parameter in list format.

For example, for

```json
    "env_list": [
        "export PATH=~/codespace/PWMLFF_feat/src/bin:$PATH",
        "export PYTHONPATH=~/codespace/PWMLFF_feat/src/:$PYTHONPATH",
    ]
```

During execution, two complete strings will be written into the slurm script.

According to the settings in [queue_name](#queue_name),[custom_flags](#custom_flags), [source_list](#queue_name), [module_list](#module_list), [env_list](#env_list) mentioned above, the generated slurm script contains the following content.

```bash

#SBATCH --partition=3080ti,new3080ti,3090
#SBATCH -x gn43,gn66,login

source /opt/rh/devtoolset-8/enable
module load cuda/11.6
module load intel/2020
export PATH=~/codespace/PWMLFF_feat/src/bin:$PATH
export PYTHONPATH=~/codespace/PWMLFF_feat/src/:$PYTHONPATH
```


# Configuration Examples in Detail

## Train Module

For the `train` module, it is necessary to load the Python runtime environment of PWMLFF. If you are using PWMLFF installed on [MCLOUD](#https://mcloud.lonxun.com/) for training, the corresponding settings are as follows:
```json
"train": {
  "command": "PWMLFF",
  "group_size": 1,
  "number_node": 1,
  "gpu_per_node": 1,
  "cpu_per_node": 1,
  "queue_name": "new3080ti,3080ti,3090",
  "custom_flags": [],
  "source_list": [
    "/share/app/anaconda3/etc/profile.d/conda.sh"
  ],
  "env_list": [
    "conda activate PWMLFF"
  ],
  "module_list": []
}
```

Here, 1 compute node is used with 1 GPU and 1 CPU. The node is located in the partition `new3080ti`, `3080ti`, or `3090`.

If you compile and install PWMLFF from source code, taking my computer cluster environment configuration as an example, the corresponding settings are as follows:

```json
"train": {
  "command": "PWMLFF",
  "group_size": 1,
  "number_node": 1,
  "gpu_per_node": 1,
  "cpu_per_node": 1,
  "queue_name": "new3080ti,3080ti,3090",
  "custom_flags": [],
  "source_list": [
    "~/anaconda3/etc/profile.d/conda.sh"
  ],
  "env_list": [
    "conda activate torch2_feat",
    "export PATH=~/codespace/PWMLFF_feat/src/bin:$PATH",
    "export PYTHONPATH=~/codespace/PWMLFF_feat/src/:$PYTHONPATH"
  ],
  "module_list": [
    "cuda/11.6",
    "intel/2020"
  ]
}
```

Here, `"~/anaconda3/etc/profile.d/conda.sh"` is the conda loading path in my computer cluster, `torch2_feat` is the Python environment of PWMLFF, and `~/codespace/PWMLFF_feat` is the path where the source code is located.

## Explore Module

For the explore module, if we take LAMMPS installed on MCLOUD as an example, simply load the `lammps4pwmlff` software. The complete settings are as follows:
```json
"explore": {
  "command": "mpirun -np 1 lmp_mpi_gpu",
  "group_size": 2,
  "number_node": 1,
  "gpu_per_node": 1,
  "cpu_per_node": 1,
  "queue_name": "new3080ti,3080ti,3090",
  "custom_flags": [],
  "source_list": [],
  "module_list": [
    "lammps4pwmlff"
  ],
  "env_list": []
}
```

Here, `1` compute node is used with `1` GPU and `1` CPU. Every `2` LAMMPS tasks are grouped into `1` group.

If you compile and install LAMMPS from source code, taking my computer cluster environment configuration as an example, the corresponding settings are as follows:
```json
"explore": {
  "command": "mpirun -np 1 lmp_mpi_gpu",
  "group_size": 2,
  "number_node": 1,
  "gpu_per_node": 1,
  "cpu_per_node": 1,
  "queue_name": "new3080ti,3080ti,3090",
  "custom_flags": [],
  "source_list": [
    "~/anaconda3/etc/profile.d/conda.sh"
  ],
  "module_list": [
    "cuda/11.6",
    "intel/2020"
  ],
  "env_list": [
    "conda activate torch2_feat",
    "export PATH=~/codespace/PWMLFF_feat/src/bin:$PATH",
    "export PYTHONPATH=~/codespace/PWMLFF_feat/src/:$PYTHONPATH",
    "export PATH=~/codespace/lammps_torch/src:$PATH",
    "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c \"import torch; print(torch.__path__[0])\")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib"
  ]
}
```

Here, `"~/anaconda3/etc/profile.d/conda.sh"` is the conda loading path in my computer cluster, `torch2_feat` is the Python environment of PWMLFF, and `~/codespace/PWMLFF_feat` is the path where the sourcecode is located. `lammps_torch` is the path where the LAMMPS source code is located.

## DFT Module

For the DFT module, let's take loading PWMAT as an example, with the following settings:
```json
"DFT": {
  "command": "PWmat",
  "number_node": 1,
  "cpu_per_node": 4,
  "gpu_per_node": 4,
  "group_size": 5,
  "queue_name": "3080ti,new3080ti,1080ti,3090",
  "custom_flags": [
    "#SBATCH -x gn18,gn17"
  ],
  "module_list": [
    "compiler/2022.0.2",
    "mkl/2022.0.2",
    "mpi/2021.5.1"
  ],
  "env_list": [
    "module load cuda/11.6"
  ]
}
```

Here, `1` compute node is used with `4` GPUs and `4` CPUs. Every `5` DFT tasks are grouped into 1 group.