---
sidebar_position: 1
title: init_bulk Parameters
---

## init_bulk param.json Configuration

`init_bulk` prepares an initial training set by applying `relaxation`, `supercell construction`, `scaling`, `perturbation`, and `AIMD` to structures in formats such as VASP and PWmat. AIMD supports DFTB, PWmat, and VASP. The parameters are described below.

### data_format
Sets the output data format after `init_bulk` completes. The default is extended XYZ (`extxyz`).

### reserve_work
Whether to retain temporary working directories. The default is `false`.

### interval
Sets the interval for extracting structures from trajectories. A value of `N` selects every N-th structure. The default is `1`.

### sys_config_prefix
Optional path prefix for initial configurations, used together with [`sys_configs/config`](#config). It may be absolute or relative to the current directory.

Example: with `"sys_config_prefix":"/data/structure"` and `"config":"atom.config"`, the resolved path is `/data/structure/atom.config`.

### sys_configs
Configures structure paths, relaxation, supercell construction, lattice scaling, atomic-position perturbation, and AIMD. A complete example appears below.

#### config
Sets the structure-file path. If [`sys_config_prefix`](#sys_config_prefix) is set, the prefix and `config` are joined; otherwise, the value of `config` is used directly.

#### format
Sets the structure format. Supported values are VASP `POSCAR` (`"vasp/poscar"`) and PWmat `atom.config` (`"pwmat/config"`, the default).

#### relax
Whether to relax the configuration. The default is `true`.

#### relax_input_idx
Selects the relaxation control file from [relax_input](#relax_input). The default is `0`, selecting the first file. For example, an index may select `relax_etot1.input` as the PWmat control file.

#### super_cell
Optional supercell setting. If omitted, no supercell is created. Accepted list forms include `[1, 1, 2]`, `[[1,0,0],[0,2,0],[0,0,1]]`, and `[1,0,0,0,2,0,0,0,1]`.

#### scale
Optional lattice-scaling list. For example, `[0.9, 0.95, 0.96, 0.97]` produces four structures by multiplying the lattice by each factor. If omitted, no scaling is applied.

#### perturb
Sets the number of perturbed structures generated using [`cell_pert_fraction`](#cell_pert_fraction) and [`atom_pert_distance`](#atom_pert_distance). If omitted, no perturbation is applied.

#### cell_pert_fraction
Perturbs each of the nine lattice components by a value sampled uniformly from `[-cell_pert_fraction, cell_pert_fraction]`. The default is `0.03`.

#### atom_pert_distance
Perturbs atomic coordinates in ångströms. Each coordinate is shifted by a value sampled uniformly from `[-atom_pert_distance, atom_pert_distance]`. The default is `0.01`.


#### aimd
Whether to run molecular dynamics on the structure. The default is `true`.

#### aimd_input_idx
Selects the AIMD control file from [aimd_input](#aimd_input). The default is `0`, selecting the first file. For example, an index may select `aimd_etot.input` as the PWmat control file.

#### bigmodel
Whether to run MD with a foundation model. The default is `false`.

#### bigmodel_input_idx
Selects the foundation-model script from [bigmodel_input](#bigmodel_input).

#### direct
Whether to select structures with DIRECT. The default is `false`. When `direct` is `true`, [direct_input](#direct_input) must specify the DIRECT script.

### sys_config Example
```json
    "sys_config_prefix": "../../si_example/init_bulk",
    "sys_configs": [{"config":"./structures/49.config", 
                    "relax":true, 
                    "_relax_input_idx":0, 
                    "super_cell":[1, 1, 2], 
                    "scale":[0.9,0.95], 
                    "perturb":3, 
                    "cell_pert_fraction":0.03, 
                    "atom_pert_distance":0.01, 
                    "aimd":true, 
                    "_aimd_input_idx":0
                    },
                    {"config":"./structures/44_POSCAR", 
                    "format":"vasp/poscar", 
                    "relax":false, 
                    "super_cell":[[1,0,0],[0, 2, 0],[0,0,1]], 
                    "perturb":2, 
                    "aimd":true, 
                    "aimd_input_idx": 1
                    }
        ]
```
This example configures `49.config` in the default `pwmat/config` format and `44_POSCAR` in `vasp/poscar` format.
- For `49.config`: Step 1 relaxes the structure with the first file in `relax_input`. Step 2 scales the relaxed lattice by 0.9 and 0.95; see [lattice scaling](../pwdata/README.md#pwdata-scale_cell-scale-a-lattice). Step 3 applies lattice and coordinate perturbations to each scaled structure, generating three variants from each; see [perturbation](../pwdata/README.md#pwdata-perturb-perturb-a-lattice-and-atomic-positions). Step 4 runs AIMD on the resulting six structures using the first file in `aimd_input`. The workflow produces six AIMD trajectories.
- For `44_POSCAR`: Step 1 creates a supercell with `[[1,0,0],[0,2,0],[0,0,1]]`; see [supercell construction](../pwdata/README.md#pwdata-super_cell-build-a-supercell). Step 2 perturbs the supercell. Step 3 runs AIMD on the two perturbed structures using the second file in `aimd_input`. The workflow produces two AIMD trajectories.

After `init_bulk` completes, trajectories are automatically extracted into the format specified by `data_format`.

### dft_style
Sets the DFT software used for [`relax`](#relax) and [`AIMD`](#aimd). The default is `pwmat`; use `vasp` for VASP.

### pseudo 
List of PWmat or VASP pseudopotential files. Paths may be absolute or relative to the current directory.

<!-- ### in_skf
Sets the parent directory of DFTB pseudopotentials in PWmat. The string may be an absolute path or relative to the current directory. -->
<!-- 
#### basis_set_file
See [potential_file](#potential_file).

#### potential_file
Sets the paths to the CP2K `BASIS_MOLOPT` and `POTENTIAL` files. For example:
```josn
    "basis_set_file":"~/datas/systems/cp2k/data/BASIS_MOLOPT",
    "potential_file":"~/datas/systems/cp2k/data/POTENTIAL"
``` -->

### gaussian_param
Gaussian-basis parameters for CP2K or PWmat. `basis_set_file` and `potential_file` specify basis-set and potential files. `atom_list`, `basis_set_list`, and `potential_list` map elements to basis sets and potentials. `kspacing` configures k-points in the same way as the [PWmat kspacing setting](#kspacing).
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

### relax_input
Sets relaxation control files. Use a list when multiple files are provided. See the examples below.

### aimd_input
Sets AIMD control files. Use a list for multiple files; a dictionary is also accepted for a single file.

#### input
Sets the input-control-file path, either absolute or relative to the current directory.

#### kspacing
Optional PWmat k-point setting. Use it only when `MP_N123` is absent from `etot.input`; configuring both causes an error.

If neither `MP_N123` nor `kspacing` is set, `kspacing` defaults to `0.5`.

Do not set `MP_N123` and `kspacing` simultaneously.

#### flag_symm
Optional PWmat symmetry setting. The default is `0` for relaxation or SCF and `3` for AIMD.

### bigmodel_input
Sets foundation-model scripts. Use a list for multiple scripts.

For interface configuration, see the [si_direct_bigmodel example](./example_si_direct_bigmodel.md#integrate-foundation-model-md-into-init_bulk).

### direct_input
Sets the DIRECT sampling script as a single file path.

For interface configuration, see the [si_direct_bigmodel example](./example_si_direct_bigmodel.md#integrate-direct-sampling-into-init_bulk).

### Complete Example
```json
    {
        "reserve_work": true,
        "sys_configs":[{
            "config":"atom.config", 
            "relax":true, 
            "relax_input_idx":1, 
            "super_cell":[1, 1, 2], 
            "scale":[0.9,0.95], 
            "perturb":20, 
            "cell_pert_fraction":0.03, 
            "atom_pert_distance":0.01, 
            "aimd":true, 
            "aimd_input_idx":0
        }],

    "dft_style":"PWmat",
    "pseudo" : ["/path/Si.SG15.PBE.UPF"],

    "relax_input":[{
            "input":"relax_etot.input",
            "kspacing":0.5,
            "flag_symm":"0"
        },{
            "input":"relax_etot1.input",
            "kspacing":0.3,
            "flag_symm":"0"
        },{
            "input":"relax_etot2.input",
            "kspacing":0.4,
            "flag_symm":"0",
            "_flag":"One integer: 0 for relax or SCF, 3 for AIMD, and 2 for magnetic systems"
        }],

    "aimd_input":[{
            "input":"aimd_etot.input",
            "kspacing":0.5,
            "flag_symm":"3"
        },{
            "input":"aimd_etot1.input",
            "kspacing":0.5,
            "flag_symm":"3"
        }]
    }
```

The configuration above:
- Relaxes `atom.config`.
- Creates a `(1,1,2)` supercell.
- Scales the supercell lattice by 0.9 and 0.95.
- Perturbs atomic positions in each scaled structure, generating 20 structures from each.
- Runs AIMD on the 40 perturbed structures.
- Extracts the AIMD trajectories automatically into `PWdata` as pretraining data.

#### [relax_input](#relax_input) and [aimd_input](#aimd_input)

[kspacing](#kspacing) and [flag_symm](#flag_symm) configure PWmat k-points when `MP_N123` is absent from `etot.input`. If `MP_N123` is already present, [relax_input](#relax_input) and `aimd_input` can be abbreviated as follows:

```json
    "relax_input":[
        "relax_etot.input",
        "relax_etot1.input",
        "relax_etot2.input"
    ],

    "aimd_input":[
        "aimd_etot.input"
        "aimd_etot1.input"
    ]
```

If every structure in [sys_configs](#sys_configs) uses the same relaxation or AIMD input, abbreviate the parameters further:
```json
    "relax_input":"relax_etot.input",
    "aimd_input": "aimd_etot.input"
```

In this case, omit [relax_input_idx](#relax_input_idx) and [aimd_input_idx](#aimd_input_idx) from [sys_configs](#sys_configs):
```json
    "sys_configs":[{
        "config":"atom.config", 
        "relax":true, 
        "super_cell":[1, 1, 2], 
        "scale":[0.9,0.95], 
        "perturb":20, 
        "cell_pert_fraction":0.03, 
        "atom_pert_distance":0.01, 
        "aimd":true
    }]
```

#### PWmat Examples
Set PWmat k-points with `MP_N123` in the control file:
``` json
    "dft_style":"PWmat",
    "relax_input":["relax-agau-etot.input", "relax_ag-etot.input", "relax_au-etot.input"],
    "aimd_input": ["aimd_agau-etot.input",   "aimd_ag-etot.input", "aimd_au-etot.input" ],
    "pseudo" : ["../Ag.SG15.PBE.UPF", "../Au.SG15.PBE.UPF"]
```

Or set PWmat k-points with `kspacing`:
``` json
    "dft_style":"PWmat",
    "relax_input":[{
            "input":"relax_etot0.input",
            "kspacing":0.5,
            "flag_symm":"0"
        },{
            "input":"relax_etot1.input",
            "kspacing":0.3,
            "flag_symm":"0"
        },{
            "input":"relax_etot2.input",
            "kspacing":0.4,
            "flag_symm":"0",
            "_flag":"One integer: 0 for relax or SCF, 3 for AIMD, and 2 for magnetic systems"
        }],

    "aimd_input":[{
            "input":"aimd_etot0.input",
            "kspacing":0.5,
            "flag_symm":"3"
        },{
            "input":"aimd_etot1.input",
            "kspacing":0.5,
            "flag_symm":"3"
        }],
    "pseudo" : ["../Ag.SG15.PBE.UPF", "../Au.SG15.PBE.UPF"]
```

PWmat Gaussian-basis example:
``` json
    "dft_style":"PWmat",
    "relax_input":["relax_etot.input", "relax_etot1.input","relax_etot2.input"],
    "aimd_input": ["aimd_etot1.input", "aimd_etot2.input"],
    "gaussian_param": {
        "basis_set_file":"./BASIS_MOLOPT_1",
        "potential_file":"./POTENTIAL_1",
        "atom_list":["Si"],
        "basis_set_list":["SZV-MOLOPT-SR-GTH"],
        "potential_list":["GTH-PBE-q4"]
    }
```

#### VASP Example
``` json
    "dft_style":"vasp",
    "relax_input":["INCAR_relax_AgAu", "INCAR_relax_Ag", "INCAR_relax_Au"],
    "aimd_input": ["INCAR_md_AgAu",   "INCAR_md_Ag", "INCAR_md_Au" ],
    "pseudo" : ["../Ag_POTCAR", "../Au_POTCAR"]
```

#### CP2K Example
```json
    "dft_style":"cp2k",
    "gaussian_param": {
        "basis_set_file":"../BASIS_MOLOPT_1",
        "potential_file":"../POTENTIAL_1",
        "atom_list":["Ag", "Au"],
        "basis_set_list":["SZV-MOLOPT-SR-GTH-q11", "SZV-MOLOPT-SR-GTH-q11"],
        "potential_list":["GTH-PBE", "GTH-PBE"],
        "kspacing":0.5
    },
    "aimd_input":["aimd_cp2k_AgAu.inp", "aimd_cp2k_Ag.inp", "aimd_cp2k_Au.inp"],
    "relax_input":["relax_cp2k_AgAu.inp", "relax_cp2k_Ag.inp", "relax_cp2k_Au.inp"]
```
