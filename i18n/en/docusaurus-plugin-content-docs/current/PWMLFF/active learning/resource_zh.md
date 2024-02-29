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

#### DFT calculations

If using PWMAT, set it to the PWMAT execution command, e.g., "command": "mpirun -np 4 PWmat".

If using VASP, set it to the corresponding VASP command, e.g., "command": "vasp_std".

#### explore MD

If using the GPU version of Lammps, set it to "command": "mpirun -np 1 lmp_mpi_gpu -in in.lammps". The number after -np represents the number of GPUs used, which should match the [`gpu_per_node`](#gpu_per_node) setting.

If using the CPU version of Lammps, set it to "command": "mpirun -np 8 lmp_mpi -in in.lammps". The number after -np represents the number of CPUs used, which should match the [`cpu_per_node`](#cpu_per_node) setting.


#### train

If following the [PWMLFF documentation](http://doc.lonxun.com/PWMLFF/) for installation, set it to `"command":"PWMLFF"`.
#

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
        "source /opt/rh/devtoolset-8/enable",
        "export PATH=/path/PWMLFF/src/bin:$PATH"
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
