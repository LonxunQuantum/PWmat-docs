---
sidebar_position: 1
---

# Initializes the input

# init_param.json
Initial Training Set Preparation, including relaxation, supercell, scaling, perturbation, and AIMD (DFTB, PWMAT, VASP) settings for configurations in VASP and PWmat formats.

## Parameter List

### reserve_work
Whether to keep the temporary working directory, default value is `false`.

### data_shuffle
Whether to randomly divide the prepared data into training and validation sets, default value is `true`. If `false`, divide training and validation sets in order.

### train_valid_ratio
Sets the ratio for dividing the training and validation sets, default value is `0.8`, which divides the training set and validation set into 80% and 20% respectively.

### interval
Used to set the interval for selecting structures from the trajectory when extracting data, that is, to select a configuration every few structures in the trajectory, with a default value of `1`.

### sys_config_prefix
Sets the path prefix for initial configurations, `optional parameter`, used in conjunction with [`sys_configs/config`](#config). It can be an absolute path or a relative path, where the relative path is relative to the current directory.

Example: `"sys_config_prefix":"/data/structure"`, `"config":"atom.config"`, then the actual path of `atom.config` is `/data/structure/atom.config`

#
## sys_configs
Sets the file paths for configurations, relaxation, supercell, scaling lattice, perturbing atomic positions, and AIMD. The complete parameters are shown in the following example.

### config
Sets the file path for configurations. If [`sys_config_prefix`](#sys_config_prefix) is set, the path is concatenated. Otherwise, the path set in the config is used as the config path.

### format
Sets the file type for configurations, supporting `POSCAR` format for `VASP` or `atom.config` format for `PWMAT`. If it is a `POSCAR` file, the value is `"vasp/poscar"`, default value is `"pwmat/config"`.

### relax
Whether to perform relaxation for the config, default value is `"true"`.

### relax_input_idx
Sets the control file used for relaxation, used in conjunction with [relax_input](#relax_input), specifying the position of the control file. For example, in the example, the `relax_input` sets the `relax_etot1.input` file as the PWMAT control file. Default value is 0, which means using the first file in `relax_input` as the control file.

### super_cell
Used for supercell settings, optional parameter. If not set, no supercell is applied to the structure. The data format is a list, supporting the following input formats: `[1, 1, 2]` or `[[1,0,0],[0, 2, 0],[0,0,1]]` or `[1,0,0,0, 2, 0,0,0,1]`.

### scale
Used for scaling the lattice, optional parameter. If not set, no scaling is applied to the structure. The data format is a list, such as `[0.9, 0.95，0.96, 0.97]`, which represents four perturbations of the lattice with 0.9, 0.95, 0.96, 0.97.

### perturb
Perturbs the atomic positions of the structure, used in conjunction with [`cell_pert_fraction`](#cell_pert_fraction) and [`atom_pert_distance`](#atom_pert_distance). The value of `perturb` is the number of structures generated after perturbation. Optional parameter, if not set, no perturbation is applied.

### cell_pert_fraction
Perturbation of the lattice. Add randomly sampled values from a uniform distribution within the range of [- cell_pert_fraction, cell_pert_fraction] to each of the 9 lattice values, with a default value of `0.03`.

### atom_pert_distance
The perturbation of atomic coordinates (Angstrom). For each atom's three coordinate values, add randomly sampled values from a uniform distribution within the range of [-atom_pert_distance, atom_pert_distance]. The default value is `0.01`.

### aimd
Whether to perform molecular dynamics simulation for the structure, default value is `true`.

### aimd_input_idx
Sets the control file used for AIMD, used in conjunction with [aimd_input](#aimd_input), specifying the position of the control file. For example, in the [example](#example), the `aimd_input` sets the `aimd_etot.input` file as the PWMAT control file. Default value is 0, which means using the first file in `aimd_input` as the control file.

#

### dft_style
Sets which DFT calculation software to use for [`Relax`](#relax) and [`AIMD`](#aimd), default value is `pwmat`, also supports VASP format. If it is VASP format, set it to `vasp`.

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


### relax_input
Sets the input control file for Relax. If there are multiple relax control files, they are organized in list format. For cases where only a single file is used, it can also be set in dict format.

### aimd_input
Set the input control files for AIMD. If there are multiple AIMD control files, they should be organized in a list format. For cases where only a single file is used, it can also be set in dict format.

#### input
Set the path to the input control file. It can be an absolute or relative path (relative to the current directory).

#### kspacing
This parameter is an optional parameter for PWMAT, used to set the K points. If the `MP_N123` parameter is not set in the etot.input file, it will be set using this parameter. If the `MP_N123` is already set in the file, setting this parameter will cause an error. Please ensure that only one of `MP_N123` and `kspacing` is set.

If the `etot.input` file does not set `MP_N123` and `kspacing` is not set, the default value of `kspacing` will be `0.5`.

Note that `MP_N123` and `kspacing` cannot be set simultaneously.

#### flag_symm
This parameter is an optional parameter for PWMAT, used to set the K points. For Relax or SCF calculations, the default value is `0`. For AIMD calculations, the default value is `3`.

### example
```json
    {
        "reserve_work": true,
        "data_shuffle":true,
        "train_valid_ratio": 0.8,
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
            "_flag":"1个整数，relax or scf 0 , aimd 3, 磁性体系2"
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
### Purpose of the above parameters

1. Perform relaxation on the `atom.config`.
2. Apply a supercell transformation with dimensions (1, 1, 2) to the relaxed structure.
3. Scale the lattice of the supercell structure by factors of 0.9 and 0.95, respectively.
4. Apply atomic positional perturbations to the scaled structures, generating 20 perturbed structures for each.
5. Perform AIMD simulations on the 40 perturbed structures.
6. Automatically extract the AIMD trajectories as **PWdata** data format for pretraining data.

### Supplementary Explanation for [relax_input](#relax_input) and [aimd_input](#aimd_input) Parameters

The parameters [`kspacing`](#kspacing) and [`flag_symm`](#flag_symm) are used for setting the K-points in PWMAT. If the `MP_N123` parameter is not set in the `etot.input` file, the program will use these two parameters to set the K-points. Therefore, if you have already set the `MP_N123` parameter in the `etot.input` file, you can simplify the [relax_input](#relax_input) or [aimd_input](#aimd_input) parameters as follows:

```json
"relax_input": [
  "relax_etot.input",
  "relax_etot1.input",
  "relax_etot2.input"
],

"aimd_input": [
  "aimd_etot.input",
  "aimd_etot1.input"
]
```

If you are using the same relax or AIMD input for all structures in [sys_configs](#sys_configs), you can further simplify the parameters as follows:

```json
"relax_input": "relax_etot.input",
"aimd_input": "aimd_etot.input"
```

In this case, you do not need to specify the [relax_input_idx](#relax_input_idx) or [aimd_input_idx](#aimd_input_idx) parameters in [sys_configs](#sys_configs). Your [sys_configs](#sys_configs) can be written as follows:

```json
"sys_configs": [{
  "config": "atom.config",
  "relax": true,
  "super_cell": [1, 1, 2],
  "scale": [0.9, 0.95],
  "perturb": 20,
  "cell_pert_fraction": 0.03,
  "atom_pert_distance": 0.01,
  "aimd": true
}]
```
