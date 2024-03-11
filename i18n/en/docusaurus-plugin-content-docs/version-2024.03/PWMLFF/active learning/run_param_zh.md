---
sidebar_position: 2
---

# Exploration parameter input

# run_param.json

Settings for training (network structure, optimizer), exploration (LAMMPS settings, sampling strategy), and tagging (VASP/PWmat self-consistent calculation settings).

#

# Parameter List

### record_file

Set the name of the record file for active learning iterations. The default value is `"al.record"`.

### reserve_work

Specify whether to keep the temporary working directory. The default value is `false`. After each active learning iteration, the temporary working directory is automatically deleted.

### reserve_md_traj

Specify whether to keep the MD trajectory files. The default value is `false`. After each active learning iteration, the MD trajectory files are automatically deleted.

### reserve_scf_files

Specify whether to keep all result files from self-consistent calculations. The default value is `false`. If set to `false`, after each active learning iteration, only four files (`REPORT`, `etot.input`, `OUT.MLMD`, `atom.config`) are kept for PWmat self-consistent calculation, and three files (`OUTCAR`, `POSCAR`, `INCAR`) are kept for VASP.

### init_data

Specify the directory of the initial training set in list format. It can be an absolute path or a relative path (current directory).

#

### train

Parameters for model training, specifying the network structure and optimizer. For detailed parameter settings, refer to the [`PWMLFF documentation`](http://doc.lonxun.com/PWMLFF/). You can either set all the training parameters as shown in the example, or use a separate JSON file by specifying the path to the JSON file in the [`train_input_file`](#train_input_file) parameter.

#### train_input_file

Optional parameter. If you have a separate PWMLFF input file, you can specify the path to the file using this parameter.

Optional parameter, if you have a separate PWMLFF input file, you can use this parameter to specify the file path. Otherwise, you need to set the parameters as shown in the example below. Detailed explanations of the parameters can be found in the [PWMLFF parameter list](../Parameter%20details.md).

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

Since the default parameters set in PWMLFF are already capable of supporting most training requirements, you can simplify it as shown below, which will use the standard `DP` model trained with the `LKF optimizer`.
```json
  "train": {
        "model_type": "DP",
        "atom_type": [14],
        "max_neigh_num": 100
  }   
```

#

### strategy

Used to set the uncertainty measurement method for active learning and whether to use model compression for acceleration.

#### uncertainty

Set the uncertainty measurement strategy.

The default value is `committee`, which calculates the model prediction deviation using a committee of multiple models. This value needs to be used with the [`model_num`](#model_num), [`lower_model_deiv_f`](#lower_model_deiv_f), and [`upper_model_deiv_f`](#upper_model_deiv_f) parameters. Candidate structures are selected if the model prediction deviation falls between `lower_model_deiv_f` and `upper_model_deiv_f`. Subsequently, DFT is used for labeling. The `model_num` parameter sets the number of models when using the `committee` method, with a default value of `4`.

If set to `kpu`, a single model-based uncertainty measurement using Kalman filter is used. This value needs to be used with the [`kpu_lower`](#kpu_lower) and [`kpu_upper`](#kpu_upper) parameters. The `kpu_lower` parameter sets the lower bound of uncertainty, and the `kpu_upper` parameter sets the upper bound of uncertainty.

#### lower_model_deiv_f

This parameter needs to be used with [`"uncertainty":"committee"`](#uncertainty) and sets the lower bound of deviation. If the deviation value is smaller than this lower bound, the model's prediction for the configuration is considered accurate and does not require tagging. The default value is `0.05`.

#### upper_model_deiv_f

This parameter needs to be used with [`"uncertainty":"committee"`](#uncertainty) and sets the upper bound of deviation. If the deviation value is greater than this upper bound, the configuration itself is considered inconsistent with physical meaning and does not require tagging. The default value is `0.15`.

#### model_num

This parameter sets the number of models used when using the `committee` method for uncertainty measurement. The default value is `4`.

#### kpu_lower

This parameter needs to be used with [`"uncertainty":"kpu"`](#uncertainty) and sets the lower bound of KPU (Kalman Predictive Uncertainty). If the KPU value is smaller than this lower bound, the model's prediction for the configuration is considered accurate and does not require tagging. The default value is `5`.

#### kpu_upper

This parameter needs to be used with [`"uncertainty":"kpu"`](#uncertainty) and sets the upper bound of KPU (Kalman Predictive Uncertainty). If the KPU value is greater than this upper bound, the configuration itself is considered inconsistent with physical meaning and does not require tagging. The default value is `10`.

#### max_select

This parameter sets the maximum number of labeled structures in each active learning iteration. When the number of unlabeled structures exceeds this value, `max_select` structures are randomly selected for labeling. The default value is `200`.

<!--
#### md_type
该参数用于设置 lammps 调用力场（机器学习模型）做分子动力学模拟时使用的立场代码。我们这里提供了 fortran 和 libtorch c++ 两种方式，默认值为 `"md_type":1`，即 libtorch 方式，该方式支持 CPU 和 GPU 两种计算资源下的模拟，比 `"md_type":2` （fortran，只支持 CPU计算）方式模拟速度更快。 -->

#### compress

This parameter specifies whether to compress the model. The compressed model has slightly lower accuracy butcan be used for faster prediction. The default value is `false`.

#### compress_order

This parameter is used to set the compression method for the model, with a default value of `"compress_order":3`, which corresponds to third-order polynomial compression. It can also be set to `"compress_order":5`, which corresponds to fifth-order polynomial compression. The higher the order, the higher the accuracy but slightly slower the speed compared to third-order compression.

#### Compress_dx

This parameter is used to set the grid size for model compression, with a default value of `"Compress_dx":0.01`.

#### example

The selection strategy for the commit method
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

The selection strategy for the KPU method
```json
    "strategy": {
        "uncertainty":"KPU",
        "max_select": 50,
        "kpu_lower":0.5,
        "kpu_upper":1.5
    }
```

If you need to enable model compression, then
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

Used to configure the molecular dynamics settings for the exploration process in active learning.

### sys_config_prefix

Used to set the prefix of the path for the structure files to be explored. This parameter is optional and is used in conjunction with [`sys_configs`](#sys_configs). It can be an absolute or relative path, where the relative path is based on the current directory.

Example: `"sys_config_prefix":"/data/structure"`, `"sys_configs":"atom.config"`, then the actual path for `atom.config` is `/data/structure/atom.config`.

### sys_configs

Sets the paths for the structure files to be explored. If [`sys_config_prefix`](#sys_config_prefix) is set, the paths are concatenated using the prefix. Otherwise, the paths set in sys_configs are used as the config paths.

This parameter is in list format. For PWMAT format structure files, simply write the file paths. For VASP format structure files, the `format` needs to be specified as shown in the example below.

```json
    "sys_configs": [
        {"config":"POSCAR", "format":"vasp"},
        "atom1.config",
        "atom2.config"
    ]
```

### md_jobs

Sets the molecular dynamics parameters for each iteration of active learning. It is in list format, where the `i-th` tuple represents the settings for the `i-th` iteration of active learning. Each tuple can be in dict format or a list of dict format.

:::note
In the following md settings, the unit for time is units metal.
:::

#### ensemble

Sets the ensemble, with a default value of `"npt"`. It also supports `"nvt"` ensemble.

#### nsteps

Sets the total number of steps for md, which is a required parameter and needs to be provided by the user.

#### md_dt

Sets the timestep, with a default value of `0.001`, which corresponds to `1 femtosecond`.

#### trj_freq

Sets the trajectory sampling frequency (`thermo`), with a default value of `10`, which means sampling every 10 steps.

#### sys_idx

Sets the initial structures for md, which is in list format and corresponds to the indices of structures in [`sys_configs`](#sys_configs). Multiple structures can be specified here. During exploration, each configuration will be explored with the pressure and temperature specified in [`"press"`](#press) and [`"temps"`](#temps) respectively.

For example, `"sys_idx":[0, 1]`, `"press":[100, 200]`, `"temps":[300, 400]` will perform md on the structures with indices 0 and 1, at [pressures, temperatures] of [100, 300], [100, 400], [200, 300], and [200, 400], resulting in `8` trajectories.

#### press

Sets the pressures for md exploration, in list format.

#### taup

Coupling time of barostat (ps), the default value is `0.5`.

#### temps

Sets the temperatures for md exploration, in list format.

#### taut

Coupling time of thermostat (ps), the default value is `0.1`.

#### boundary

Sets the boundary conditions for the simulated system, with a default value of `true`, which corresponds to `p p p`. Setting it to `false` uses `f f f`.


#### example

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
In the example above, a single round of active learning is configured to perform LAMMPS simulations specified in the two dictionaries in `"md_jobs"`. 

For the first dictionary, the `npt` ensemble is used, and two configurations are specified in `sys_idx`, corresponding to `0.95_scale.poscar` and `0_pertub.poscar`. The lists of temperature and pressure are `[500, 800]` and `[100, 200]` respectively. This means that LAMMPS simulations will be performed for these two structures under temperature and pressure combinations of `[500, 100]`, `[500, 800]`, `[800, 100]`, and `[800, 200]`. The simulations will run for `1000` steps with an output frequency of `10` steps and a time step of `2` femtoseconds. After the simulations, a total of `8` trajectories will be obtained.

For the second dictionary, the `nvt` ensemble is used, and a single configuration is specified in `sys_idx`, corresponding to `0_pertub.poscar`. The temperature is set to `400`, meaning that a LAMMPS simulation will be performed at a temperature of `400K`. After the simulation, a single trajectory will be obtained.

## DFT

Set up self-consistent calculations the input is dict format.

### dft_style

Set the DFT software used for the calculation. The default value is `pwmat`, but it also supports the VASP format. If using the VASP format, set it to `vasp`.

### input

Set the path to the input control file. It can be an absolute path or a relative path (relative to the current directory).

### kspacing

This parameter is specific to PWMAT and is used to set the K points. It is an optional parameter. If the `MP_N123` parameter is not set in the etot.input file, this parameter is used to set the K points. 

Make sure that `MP_N123` and `kspacing` are not set simultaneously.

If `MP_N123` is not set in the etot.input file and `kspacing` is not set, the default value of `kspacing` is `0.5`.

### flag_symm

This parameter is specific to PWMAT and is used to set the K points. It is an optional parameter. The default value is `0` for Relax or SCF calculations, and `3` for AIMD calculations.


### pseudo 
Sets the path to the pseudopotential files of `PWmat` or `VASP`, in list format. The path to the pseudopotential file can be an absolute path or a relative path (relative to the current path).

### in_skf
The `in_skf` parameter is used to set the path to the parent directory of the pseudopotential files for `DFTB` (Integrated by `PWMAT`). It should be specified as a string in either absolute or relative format (relative to the current directory).

### basis_set_file
Refer to [potential_file](#potential_file).

### potential_file
The `potential_file` parameter is used to set the path to the `BASIS_MOLOPT` and `POTENTIAL` files for `CP2K` pseudopotentials. For example:
```json
"basis_set_file": "~/datas/systems/cp2k/data/BASIS_MOLOPT",
"potential_file": "~/datas/systems/cp2k/data/POTENTIAL"
```

### Example
Since the input controls for the self-consistent calculation tasks are the same, only a single-file configuration is needed. For different DFT software, the settings are as follows:

For `PWMAT`, the settings are similar to [INIT_BULK](./init_param_zh.md). If you haven't specified the "MP_N123" parameter in `scf_etot.input`, you need to set the `kspacing` and `flag_symm` parameters.
```json
"DFT": {
    "dft_style": "pwmat",
    "input": "scf_etot.input",
    "kspacing": 0.3,
    "flag_symm": 0
}
```

Alternatively, you can omit the settings, and the default parameters will be used (kspacing=0.5, flag_symm=0). In this case, the settings are as follows:
```json
"DFT": {
    "dft_style": "pwmat",
    "input": "scf_etot.input",
    "pseudo": ["~/NCPP-SG15-PBE/Si.SG15.PBE.UPF"]
}
```

If you are using the `DFTB integrated in PWMAT`, the settings are as follows:
```json
"DFT": {
    "dft_style": "pwmat",
    "input": "scf_etot.input",
    "in_skf": "./lisi_dftb_pseudo"
}
```

For `VASP`, the settings are as follows:
```json
"DFT": {
    "dft_style": "vasp",
    "input": "scf_INCAR",
    "pseudo": ["~/Si/POTCAR"]
}
```

For `CP2K`, the settings are as follows:
```json
"DFT": {
    "dft_style": "cp2k",
    "input": "scf_cp2k.inp",
    "basis_set_file": "~/datas/systems/cp2k/data/BASIS_MOLOPT",
    "potential_file": "~/datas/systems/cp2k/data/POTENTIAL"
}
```

#

### 例子

The following example shows a standard active learning workflow with two rounds of active learning using a multi-model committee query strategy. For more usage examples, please refer to the [`example`](https://github.com/LonxunQuantum/PWMLFF_AL/tree/main/example) directory in the source code root.

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
      { "config": "POSCAR", "format": "vasp" },
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
