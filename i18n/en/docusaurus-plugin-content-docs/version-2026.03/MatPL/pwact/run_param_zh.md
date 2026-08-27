---
sidebar_position: 2
title: run Parameters
---

## run param.json Configuration

The active-learning workflow includes training settings (network and optimizer), exploration settings (LAMMPS and selection strategy), and labeling settings (VASP/PWmat self-consistent calculations). The parameters are described below.

### reserve_work

Whether to retain temporary working directories. The default is `false`, so they are deleted after each iteration.

### reserve_md_traj

Whether to retain MD trajectories. The default is `false`, so trajectories are deleted after each iteration.

### reserve_scf_files

Whether to retain all SCF outputs. The default is `false`. After each iteration, PWmat calculations retain only `REPORT`, `etot.input`, `OUT.MLMD`, and `atom.config`; VASP calculations retain only `OUTCAR`, `POSCAR`, and `INCAR`.


### data_format
Sets the format of initial and collected datasets. The default is extended XYZ (`extxyz`).

### init_data

List of initial training-set directories, as absolute paths or paths relative to the current directory.

### valid_data

List of validation-set directories. Paths may be absolute or relative. If omitted, no validation results are generated during active-learning training.

### init_model_list
Sets initial exploration models. To begin exploration from existing MatPL DP or NEP force fields, list their paths in `init_model_list`.

The number of force fields must match [strategy/model_num](#model_num), and their model type must match `train/model_type`. Training parameters are extracted from the force fields, so network and descriptor settings in `train_input_file` or the `train` dictionary are ignored.

### use_pre_model
Whether the current exploration step uses force fields trained in the previous step. The default is `true`.

### train

Model-training settings for the network and optimizer. See the [`MatPL Training Parameters`](../parameterdetail.md). Configure them inline as below or specify a separate JSON file with `train_input_file`.

#### train_input_file

Optional path to a standalone MatPL input file. If omitted, configure the parameters inline. See the [MatPL Parameter Reference](../parameterdetail.md).

#### train Example
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
            "optimizer": "ADAM",
            "epochs": 30,
            "batch_size": 1,
            "print_freq": 10,
            "train_energy": true,
            "train_force": true,
            "train_virial": false
        }
    }
```

You can also place the training settings in a separate file such as `nep.json`:
```json
  "train": {
      "model_type": "NEP",
      "atom_type": [14],
      "train_input_file":"nep.json"
  }
```

Because the MatPL defaults cover most training needs, the configuration can be abbreviated as follows to train a standard `NEP` model with `ADAM`.
```json
  "train": {
        "model_type": "NEP",
        "atom_type": [14]
  }
```

PWact supports both MatPL DP and NEP force fields.

### strategy

Configures uncertainty estimation and optional model compression.

#### uncertainty

Sets the uncertainty strategy. The multi-model Committee Query method (`committee`) is supported.

<!-- The KPU method is under development and will be released later. -->
<!-- 
The default is `committee`, which estimates prediction deviation from multiple models. Use it with [`model_num`](#model_num), [`lower_model_devi_f`](#lower_model_devi_f), and [`upper_model_devi_f`](#upper_model_devi_f). Structures between the lower and upper thresholds become candidates for DFT labeling. The default committee contains four models.

When set to `kpu`, uncertainty is estimated from one model with a Kalman-filter method. Use it with [`kpu_lower`](#kpu_lower) and [`kpu_upper`](#kpu_upper).

##### lower_model_devi_f

With [`"uncertainty":"committee"`](#uncertainty), sets the lower deviation threshold. Structures below it are considered accurate and are not labeled. The default is `0.05`.

##### upper_model_devi_f

With [`"uncertainty":"committee"`](#uncertainty), sets the upper deviation threshold. Structures above it are considered unphysical and are not labeled. The default is `0.15`.

##### model_num

Sets the committee size. The default is `4`, and the value must be at least `3`.

##### kpu_lower

With [`"uncertainty":"kpu"`](#uncertainty), sets the lower KPU threshold. Structures below it are not labeled. The default is `5`.

##### kpu_upper

With [`"uncertainty":"kpu"`](#uncertainty), sets the upper KPU threshold. Structures above it are considered unphysical and are not labeled. The default is `10`. -->
#### lmps_tolerance

Whether to continue active learning when some LAMMPS trajectories fail because of lost atoms, excessively short distances, or similar problems. The default is `true`, meaning the workflow continues.

#### lower_model_devi_f

Sets the lower deviation threshold. Structures below it are considered accurate and are not labeled. The default is `0.05`.

#### upper_model_devi_f

Sets the upper deviation threshold. Structures above it are considered unphysical and are not labeled. The default is `0.15`.

The maximum deviation is calculated as

$$\varepsilon_{t} = \max_i\left(\sqrt{\frac{\sum_{1}^{w} \left\| F_{w,i}(R_t) - \hat{F_{i}} \right\|^2}{W}}\right), \quad \hat{F_{i}} = \frac{\sum_{1}^{W}F_{w,i}}{W}$$

where $W$ is the number of models and $i$ indexes atoms.

#### model_num

Sets the number of committee models. The default is `4`, and the value must be at least `3`.

#### max_select

Sets the maximum number of configurations labeled for `each initial exploration structure` when [`select_sys`](#select_sys) is not set. If more candidates are available, `max_select` are selected randomly. By default, no limit is applied.

For an MD setting with two structures in [`sys_idx`](#sys_idx) and no [`select_sys`](#select_sys), each structure contributes at most `max_select` candidates, for a total of $2 \times max\_select$.

#### direct
Whether to apply DIRECT sampling to the structures selected by model deviation and remove similar configurations. The default is `false`.

#### direct_script
Sets the DIRECT processing script. It is required when `direct` is `true`.

For interface setup, see the [si_direct_bigmodel example](./example_si_direct_bigmodel.md#integrate-direct-sampling-into-init_bulk).

<!--
##### md_type
Selects the force-field interface used by LAMMPS. `"md_type":1` (the default) uses LibTorch C++ on CPUs or GPUs and is faster than `"md_type":2`, the CPU-only Fortran interface. -->

#### compress

Whether to compress the model. Compression may slightly reduce accuracy but can approximately double simulation speed. The default is `false`.

#### compress_order

Sets the polynomial compression order. The default is `3`; `5` provides higher accuracy but is slightly slower.

#### Compress_dx

Sets the compression-grid spacing. The default is `0.01`.


#### Example

Committee Query selection:
```json
    "strategy": {
        "uncertainty":"committee",
        "lower_model_devi_f": 0.1,
        "upper_model_devi_f": 0.2,
        "model_num": 4,
        "max_select": 50,
        "compress": false
    }

```

<!-- KPU selection:
```json
    "strategy": {
        "uncertainty":"KPU",
        "max_select": 50,
        "kpu_lower":0.5,
        "kpu_upper":1.5
    }
``` -->
To enable model compression:
```json
    "strategy": {
        "uncertainty":"committee",
        "lower_model_devi_f": 0.1,
        "upper_model_devi_f": 0.2,
        "model_num": 4,
        "max_select": 50,
        "compress": true,
        "compress_order":3,
        "Compress_dx":0.01
    }
```

### explore

Configures molecular dynamics during exploration in each iteration.

#### sys_config_prefix

Optional prefix for exploration-structure paths, used with [`sys_configs`](#sys_configs). It may be absolute or relative to the current directory.

#### sys_configs

Sets exploration-structure paths. When [`sys_config_prefix`](#sys_config_prefix) is set, it is joined with each path; otherwise, the values are used directly.

This is a list. PWmat structures can be listed by path; VASP structures also require a `format`, as shown below.
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
For example, the resolved path of `49.config` is `../../structures/49.config`.

#### lmps_prefix

Optional path prefix for LAMMPS exploration input files, used with [`lmps_in`](#lmps_in). It may be absolute or relative.

Example: with `"lmps_prefix":"/data/in_lmps_files"` and `"lmps_in":"in0.lmps"`, the resolved path is `/data/in_lmps_files/in0.lmps`.

#### lmps_in

Optional LAMMPS exploration input-file paths. When [`lmps_prefix`](#lmps_prefix) is set, it is joined with each path; otherwise, `lmps_in` values are used directly.

This parameter is a list, as shown below.

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

#### md_jobs

List of MD settings for each active-learning iteration. Entry `i` configures iteration `i` and may be a dictionary or a list of dictionaries. All time units below assume LAMMPS `units metal`.

PWact supports two forms of LAMMPS control. The first uses `param.json` fields for the step count, temperature, pressure, and ensemble; see the [example](#md-jobs-example). The second uses a `user-provided lammps.in file` through [`lmps_prefix`](#lmps_prefix) and [`lmps_in`](#lmps_in); see the [Au–Ag example](./example_auag_init_zh.md).

:::tip
`lmps_in` is supported in `pwact >= 0.4`.
:::

When a user-provided `lammps.in` runs MD with Kokkos, it must include:
```txt
package kokkos neigh half comm device
newton on
```

At runtime, PWact manages the following fields in a user-provided `lammps.in`:

- `dump_freq`, controlled by [trj_freq](#trj_freq), sets the sampling interval.
- `units`, `boundary`, and `atom_style` are fixed because MatPL supports only periodic systems:
  ```txt
    units           metal
    boundary        p p p
    atom_style      atomic
  ```
- `restart` is automatically set to save state every 10,000 steps.
- `read_data` is automatically updated to the required initial-structure path.
- `mass`, `pair_style`, and `pair_coeff` configure the machine-learning force field. For silicon, PWact generates:
  ```txt
    mass    1    28.086
    pair_style   matpl/dp  0_torch_script_module.pt 1_torch_script_module.pt 2_torch_script_module.pt 3_torch_script_module.pt  out_freq ${DUMP_FREQ}  out_file model_devi.out 
    pair_coeff   * * 14
  ```
- `dump` configures trajectory output. PWact inserts the following before the first `run` command, with `DUMP_FREQ` taken from [trj_freq](#trj_freq):
  ```txt
    dump 1 all custom ${DUMP_FREQ} traj/*.lammpstrj id type x y z fx fy fz
  ```

- For `dump_modify`, PWact replaces the user-provided dump ID with `1` to match `dump`, leaving all other options unchanged.

The following `lmp.in` is an example input for silicon:
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
At runtime, it is transformed into:
```txt
variable        DUMP_FREQ       equal 5
variable        restart         equal 0
units           metal
boundary        p p p
atom_style      atomic

if "${restart} > 0" then "read_restart lmps.restart.*" else "read_data lmp.config"

mass   1    28.086
pair_style   matpl/dp  0_torch_script_module.pt 1_torch_script_module.pt 2_torch_script_module.pt 3_torch_script_module.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
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

##### sys_idx
List of indices in [`sys_configs`](#sys_configs) identifying initial MD structures. Multiple structures may be selected.

##### select_sys
With [`sys_idx`](#sys_idx), limits the number of labeled configurations from each initial structure. If omitted, [`max_select`](#max_select) applies; if neither is set, the default is `100`. For example:
```json
  "sys_idx": [0, 1],
  "select_sys":[20, 30],
```
Here, `sys_idx` selects structure 0 (`POSCAR`) and structure 1 (`49.config`). At most 20 structures are labeled from the first trajectory set and 30 from the second. Without `select_sys`, each is limited by [`max_select`](#max_select).

`"select_sys":20` is equivalent to `"select_sys":[20, 20]`.

##### trj_freq
Sets the trajectory sampling frequency (`thermo`). The default is every `10` steps.

##### lmps_in_idx
With [`lmps_in`](#lmps_in), assigns LAMMPS input files to the initial structures in [`sys_idx`](#sys_idx), as shown below.
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
Here, `"sys_idx": [1,3,4]` selects `49.config`, `41.config`, and `37.config` from the [previous example](#sys_configs), assigns `in0.lmps`, `in1.lmps`, and `in2.lmps`, and samples every five steps.

For `"sys_idx": [0,1]`, `in3.lmps` controls both selected structures and the default ten-step sampling interval is used.

When `lmps_in_idx` is present, [`ensemble`](#ensemble), [`nsteps`](#nsteps), [`md_dt`](#md_dt), [`press`](#press), [`taup`](#taup), [`temps`](#temps), and [`taut`](#taut) are ignored.

##### ensemble

For keyword-based LAMMPS control, sets the ensemble. The default is `nve`; supported values are:

`npt`, `npt-i`, or `npt-iso`:
```txt
fix  1 all npt temp ${TEMP} ${TEMP} ${TAU_T} iso ${PRESS} ${PRESS} ${TAU_P}
```

`npt-a` or `npt-aniso`:
```txt
fix  1 all npt temp ${TEMP} ${TEMP} ${TAU_T} aniso ${PRESS} ${PRESS} ${TAU_P}
```

`npt-t` or `npt-tri`:
```txt
fix  1 all npt temp ${TEMP} ${TEMP} ${TAU_T} tri ${PRESS} ${PRESS} ${TAU_P}
```

`nvt`:
```txt
fix  1 all nvt temp ${TEMP} ${TEMP} ${TAU_T}
```

`nve`:
```txt
fix  1 all nve
```

##### nsteps

For keyword-based control, sets the required total MD step count.
##### md_dt

For keyword-based control, sets `timestep`. The default is `0.001`, or 1 fs.

##### press

For keyword-based control, sets exploration pressures as a list.

##### taup

For keyword-based control, sets the barostat coupling time in ps. The default is `0.5`.

##### temps

For keyword-based control, sets exploration temperatures as a list.

##### taut

For keyword-based control, sets the thermostat coupling time in ps. The default is `0.1`.

##### boundary

For keyword-based control, sets periodic boundaries. MatPL supports only periodic simulations, so this is fixed to `true` (`p p p`) and need not be configured.

##### Example {#md-jobs-example}

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

The example configures one active-learning iteration with two LAMMPS simulation dictionaries in `md_jobs`.

The first dictionary uses NPT for two structures, `0.95_scale.poscar` and `0_pertub.poscar`, at every combination of temperatures `[500,800]` and pressures `[100,200]`. Each run has 1,000 steps, output every 10 steps, and a 2 fs timestep, producing eight trajectories.

The second dictionary uses NVT for `0_pertub.poscar` at 400 K and produces one trajectory.

The following `lammps.in` is generated for `"ensemble":"npt"`, `"nsteps":1000`, `"md_dt":0.002`, `"trj_freq":10`, `"sys_idx":0`, `"temps":500`, `"taut":0.1`, `"press":100`, `"taup":0.5`, and `"boundary":true`:
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
pair_style   matpl/dp  0_torch_script_module.pt 1_torch_script_module.pt 2_torch_script_module.pt 3_torch_script_module.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
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
The velocity seed `76752` is generated randomly.
### DFT

Configures self-consistent labeling calculations as a dictionary.

#### dft_style

Selects the labeling software. The default is `pwmat`; `vasp`, `cp2k`, and `bigmodel` are also supported. For `bigmodel`, specify a script with [`bigmodel_script`](#bigmodel_script).

#### bigmodel_script
Sets the foundation-model labeling script used to infer energies and forces.

For interface setup, see the [si_direct_bigmodel example](./example_si_direct_bigmodel.md#integrate-foundation-model-labeling-into-run).

#### input

Sets the input control file as an absolute path or a path relative to the current directory.

#### kspacing

Optional PWmat k-point setting used when `MP_N123` is absent from `etot.input`. Do not configure both.

If neither is set, `kspacing` defaults to `0.5`.

#### flag_symm

Optional PWmat symmetry setting. The default is `0` for relaxation or SCF and `3` for AIMD.

#### pseudo 
List of PWmat or VASP pseudopotential files. Paths may be absolute or relative.

<!-- #### in_skf
Sets the parent directory of DFTB pseudopotentials in PWmat. The string may be absolute or relative. -->
#### gaussian_param
Gaussian-basis settings for CP2K or PWmat. `basis_set_file` and `potential_file` specify basis and potential files. `atom_list`, `basis_set_list`, and `potential_list` map elements to their basis sets and potentials. `kspacing` configures k-points as described above.
```json
"gaussian_param": {
    "basis_set_file":"./init_bulk/BASIS_MOLOPT_1",
    "potential_file":"./init_bulk/POTENTIAL_1",
    "atom_list":["Si"],
    "kspacing" :0.4,
    "basis_set_list":["SZV-MOLOPT-SR-GTH"],
    "potential_list":["GTH-PBE-q4"]
}
```

#### DFT Examples
Because all SCF labeling tasks share one control file, only a single input is needed. Configure each DFT package as follows.

##### PWmat
PWmat configuration resembles [init_bulk](./init_param_zh.md). If `MP_N123` is absent from `scf_etot.input`, set `kspacing` and `flag_symm`.
```json
  "DFT": {
          "dft_style": "pwmat",
          "input": "scf_etot.input",
          "kspacing":0.5,
          "flag_symm":0,
          "pseudo" : ["../Ag.SG15.PBE.UPF","../Au.SG15.PBE.UPF"],
          "_flag":"One integer: 0 for SCF, 3 for AIMD, and 2 for magnetic systems"
  }
```
<!-- 
For DFTB integrated into PWmat, use:
```json
"DFT": {
      "dft_style": "pwmat",
      "input": "scf_etot.input",
      "in_skf": "./lisi_dftb_pseudo"
    }
``` -->

##### VASP
```json
  "DFT": {
          "dft_style":"vasp",
          "input":"INCAR_scf",
          "pseudo" : ["../Ag_POTCAR", "../Au_POTCAR"]
  }
```

##### CP2K
```json
  "DFT": {
          "dft_style":"cp2k",
          "input":"scf.inp",
          "gaussian_param": {
              "basis_set_file":"../BASIS_MOLOPT_1",
              "potential_file":"../POTENTIAL_1",
              "atom_list":["Ag", "Au"],
              "basis_set_list":["SZV-MOLOPT-SR-GTH-q11", "SZV-MOLOPT-SR-GTH-q11"],
              "potential_list":["GTH-PBE", "GTH-PBE"],
              "_kspacing":0.5
          }
  }
```

Set `IGNORE_CONVERGENCE_FAILURE` in `scf_cp2k.inp` so CP2K exits normally when convergence fails and PWact can continue. Otherwise, PWact treats the exit as abnormal, resubmits the task up to three times, and stops after the third failure.

### run param.json Example

The following standard workflow runs two active-learning iterations with a multi-model committee. For more examples, see the source repository's [`examples`](https://github.com/LonxunQuantum/PWact/tree/main/examples).

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
      "optimizer": "ADAM",
      "epochs": 30,
      "batch_size": 1,
      "print_freq": 10,
      "train_energy": true,
      "train_force": true,
      "train_virial": false
    }
  },

  "strategy": {
    "uncertainty": "committee",
    "lower_model_devi_f": 0.05,
    "upper_model_devi_f": 0.15,
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
