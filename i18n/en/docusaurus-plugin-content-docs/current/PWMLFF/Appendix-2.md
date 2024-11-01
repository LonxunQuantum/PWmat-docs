---

sidebar_position: 6

---

# Appendix II: pwdata

`pwdata` is a data preprocessing tool for PWMLFF with the following features:

1. File conversion between `atom.config (PWmat)`, `POSCAR (VASP)`, `lmp.init (LAMMPS)`, and `cp2k.init (CP2K)`.
2. Lattice scaling, cell expansion, and perturbations to lattice or atomic positions for these structures.
3. Extraction of various trajectory files, such as `MOVEMENT (PWmat)`, `OUTCAR (VASP)`, `lammps dump file (LAMMPS)`, `cp2k md file (CP2K)`, or common training data formats like `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, or the [meta OMAT24 open-source dataset](https://huggingface.co/datasets/fairchem/OMAT24) to `pwmlff/npy` or `extxyz` formats.
   For meta datasets, CPU parallelism and query operations are supported, allowing users to quickly locate structures within databases of over one hundred million entries.

## Supported Data Types

| Software          | File             | Multi-Image | Label | Format                     |
| ----------------- | ---------------- | ----------- | ----- | -------------------------- |
| PWmat             | MOVEMENT         | True        | True  | 'pwmat/movement'           |
| PWmat             | OUT.MLMD         | False       | True  | 'pwmat/movement'           |
| PWmat             | atom.config      | False       | False | 'pwmat/config'             |
| VASP              | OUTCAR           | True        | True  | 'vasp/outcar'              |
| VASP              | POSCAR           | False       | False | 'vasp/poscar'              |
| LAMMPS            | lmp.init         | False       | False | 'lammps/lmp'               |
| LAMMPS            | dump             | True        | False | 'lammps/dump'              |
| CP2K              | stdout, xyz, pdb | True        | True  | 'cp2k/md'                  |
| CP2K              | stdout           | False       | True  | 'cp2k/scf'                 |
| PWMLFF            | \*.npy           | True        | True  | 'pwmlff/npy'               |
| DeepMD (read)     | \*.npy, \*.raw   | True        | True  | 'deepmd/npy', 'deepmd/raw' |
| \* (extended xyz) | \*.xyz           | True        | True  | 'extxyz'                   |
| Meta (read)       | \*aselmdb        | True        | True  | 'meta'                     |

## Installation Method
To install via pip:
```bash
pip install pwdata

# Install pwdata; if already installed, upgrade to the latest version
pip install pwdata --upgrade

# List all available versions
pip index versions pwdata
# Example output:
# pwdata (0.3.2)
# Available versions: 0.3.2, 0.3.1, 0.3.0, 0.2.16, 0.2.15
#   INSTALLED: 0.3.2
#   LATEST:    0.3.2

# Install a specific version
pip install pwdata==n.m.o
```


# pwdata Command Line Usage
`pwdata` supports both command-line operations and integration in source code.

## 1. Command-Line Operations

### Command List
The list of `pwdata` commands is as follows. You can use the `-h` option to get a detailed explanation of each command and all supported parameters. Running `pwdata -h` will display all available commands along with usage examples.

```bash
pwdata -h
pwdata convert_config or cvt_config -h
pwdata convert_configs or cvt_configs -h
pwdata scale_cell or scale -h
pwdata super_cell or super -h
pwdata perturb -h
```

Detailed explanations for each command are provided below.

### 1. Structure Conversion: `convert_config`

This command is used for converting between various structures. You can use either `convert_config` or its abbreviation `cvt_config`.

Parameters:
```bash
pwdata convert_config [-h] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

- `-h`: Displays help information listing all available parameters and their descriptions for the `scale` command.
- `-i`: Required. Specifies the path of the input file, supporting absolute or relative paths.
- `-f`: Optional. Specifies the format of the input file. If not specified, the format will be inferred from the input file. Supported formats: `['pwmat/config', 'vasp/poscar', 'lammps/lmp', 'cp2k/scf']`.
- `-o`: Optional. Specifies the output format. Supported formats: `['pwmat/config', 'vasp/poscar', 'lammps/lmp']`. If not specified, the input format will be used, except when the input format is `cp2k/scf`, which will default to `pwmat/config`.
- `-s`: Specifies the output file name, used in conjunction with `-o`. Default names are `atom.config` for `pwmat/config`, `POSCAR` for `vasp/poscar`, and `lammps.lmp` for `lammps/lmp`.
- `-c`: Saves the structure in Cartesian coordinates if specified; otherwise, fractional coordinates are used. Note: `pwmat/config` supports only fractional coordinates, so this parameter is ignored.
- `-t`: Specifies atom types for the structure if the input format is `lammps/lmp` or `lammps/dump`, using element names or atomic numbers in the same order as in the input structure. Ignored for other formats.

Example test files are available in the [examples directory](https://github.com/LonxunQuantum/pwdata/tree/master/examples). You can download and test with the following example:

```bash
# Example: Convert atom.config to POSCAR
# Generates the structure file `cvtcnf_atom.POSCAR` in `examples/test_workdir`.
pwdata cvt_config -i examples/pwmat_data/LiGePS_atom.config -s examples/test_workdir/cvtcnf_atom.POSCAR -o vasp/poscar
```

### 2. Extracting Training Data: `convert_configs`
Extract various trajectory files (`MOVEMENT(PWmat)`, `OUTCAR(VASP)`, `lammps dump file(Lammps)`, `cp2k md file(CP2K)`) or common training data (`pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, [`meta OMAT24 open-source dataset`](https://huggingface.co/datasets/fairchem/OMAT24)) into the `pwmlff/npy` or `extxyz` formats. You can use either `convert_configs` or its abbreviation `cvt_configs`.

Parameters:
```bash
pwdata convert_configs [-h] -i INPUT [INPUT ...] -f INPUT_FORMAT [-t ATOM_TYPES [ATOM_TYPES ...]] [-s SAVEPATH] [-o OUTPUT_FORMAT] [-c] [-p TRAIN_VALID_RATIO] [-r] [-g GAP] [-q QUERY] [-n CPU_NUMS] [-m]
```

- `-h`: Displays help information listing all available parameters and their descriptions for the `scale` command.
- `-i`: Required. Specifies paths of input files, supporting absolute or relative paths. Accepts multiple file paths or directories. `pwdata` supports automatic directory search for `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, and `meta OMAT24`. Specify only the root directory of the data source.
- `-f`: Optional. Specifies the input format. `pwdata` can infer data formats automatically, so explicit format specification is not required. Supported formats: `['pwmat/movement', 'vasp/outcar', 'lammps/dump', 'cp2k/md', 'pwmlff/npy', 'deepmd/npy', 'deepmd/raw', 'extxyz', 'meta']`.
- `-o`: Optional. Specifies the output format. Supported formats: `['pwmlff/npy', 'extxyz']`. Defaults to `'pwmlff/npy'`.
- `-s`: Optional. Specifies the output directory. Defaults to the current directory.
- `-p`: Optional. Specifies the train-test split ratio in the range [0.0,1.0]. Defaults to 1.0 (no test split).
- `-r`: Optional. Boolean. Specifies whether to use random splitting when creating a test set, used with the `-p` parameter. For example, `-p 0.8 -r` splits 80% for training and 20% for testing randomly, while `-p 0.8` splits sequentially.
- `-g`: Optional. Integer. Specifies the interval at which frames are extracted from trajectory files. Default is 1.
- `-q`: Optional. String. Only effective when the input type is `meta`, used to query the database. See [meta query examples](#convert_configs-meta-query-examples) below for details.
- `-n`: Optional. Integer. Specifies the number of CPU cores to use for parallel database querying when the input type is `meta`. Defaults to single-core.
- `-t`: For `lammps/lmp` or `lammps/dump` formats, specifies atom types in the structure. For `meta`, specifies filtering structures with only these element types.

### Example Commands for `convert_configs`
Test files are provided in the [examples directory](https://github.com/LonxunQuantum/pwdata/tree/master/examples):

Example 1: Extract all `pwmlff/npy` data in `examples/pwmlff_data/LiSiC` into `xyz` format with an 80/20 train-test split. Results are saved in `examples/test_workdir/0_1_configs_extxyz` with `train.xyz` and `valid.xyz`.
```bash
pwdata convert_configs -i examples/pwmlff_data/LiSiC -s examples/test_workdir/0_1_configs_extxyz -o extxyz -p 0.8
```

Example 2: Extract every 5th frame from PWmat trajectory files, randomly split 80/20 into `examples/test_workdir/3_1_configs_extxyz`.
```bash
pwdata convert_configs -i examples/pwmat_data/50_LiGePS_movement examples/pwmat_data/lisi_50_movement -s examples/test_workdir/3_1_configs_extxyz -o extxyz -p 0.8 -r -g 5
```

Example 3: Extract all `deepmd/npy` files from `examples/deepmd_data/alloy` to `pwmlff/npy` format without test split.
```bash
pwdata convert_configs -i examples/deepmd_data/alloy -s ./test_workdir/7_0_configs_PWdata
```

Example 4: Extract all `.xyz` files from `examples/xyz_data` into `pwmlff/npy` format with an 80/20 split, saved in `examples/test_workdir/5_0_configs_PWdata`.
```bash
pwdata convert_configs -i examples/xyz_data -s examples/test_workdir/5_0_configs_PWdata -p 0.8 -r -g 1
```

### Meta Query Examples for `convert_configs`

Example 1: Query structures containing only `Pt` and `Ge`, and output them in `xyz` format. Generates `train.xyz` and `valid.xyz` in `examples/test_workdir/10_1_configs_extxyz`.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -t Pt Ge
```

Example 2: Query structures containing `Cu` atoms.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q Cu
```

Refer to the full documentation for additional query examples.

Example 3: Use the `-q` parameter to query all structures with fewer than 3 `H` atoms.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -f meta -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q H<3
```

Example 4: Use the `-q` parameter to query all structures that contain `Cu` atoms and fewer than 3 `H` atoms.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -f meta -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q Cu,H<3
```

Example 5: Use the `-q` parameter to query all structures with at least 2 `H` atoms and at least 1 `O` atom.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -f meta -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q H2O 
```

Additional query statements are also available.

```txt
| ---query string---| -------------------------Function Explanation---------------------------- |
| v3                | has ‘v3’ key                                                              |
| abc=bla-bla       | has key ‘abc’ with value ‘bla-bla’                                        |
| v3,abc=bla-bla    | both of the above                                                         |
| calculator=nwchem | calculations done with NWChem                                             |
| 2.2<bandgap<3.0   | ‘bandgap’ key has value between 2.2 and 3.0                               |
| natoms>=10        | 10 or more atoms                                                          |
| id=2345           | specific id                                                               |
| age<1h            | not older than 1 hour                                                     |
| age>1y            | older than 1 year                                                         |
| pbc=TTT           | Periodic boundary conditions along all three axes                         |
| pbc=TTF           | Periodic boundary conditions along the first two axes (F=False, T=True)   |
https://databases.fysik.dtu.dk/ase/ase/db/db.html#id7
```

### 3. Lattice Scaling with `scale_cell`
This command is used to scale the lattice of a structure. You can use either `scale_cell` or its abbreviation `scale`. The parameters are as follows:

```bash
pwdata scale_cell [-h] -r SCALE_FACTOR [SCALE_FACTOR ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays help information, listing all available parameters and their descriptions for the `scale` command.

#### `-r`
Required parameter. Specifies the scaling factor for the lattice, where $Lattice_{new} = factor * Lattice_{old}$. The factor is a list of floating-point numbers between 0.0 and 1.0, separated by spaces. For example, `'-r 0.97 0.98 0.99'` applies lattice scaling factors of 0.97, 0.98, and 0.99 to the input structure.

#### `-i`
Required parameter. Specifies the file path of the input file, which can be an absolute or relative path.

#### `-f`
Optional parameter. If not explicitly specified, the format will be inferred based on the input file. Supported formats are `['pwmat/config', 'vasp/poscar', 'lammps/lmp', 'cp2k/scf']`.

#### `-o`
Optional parameter. Specifies the output format. Supported formats are `['pwmat/config', 'vasp/poscar', 'lammps/lmp']`. If not specified, the output format will match the input format. If the input format is `cp2k/scf`, the output will be saved as `pwmat/config`.

#### `-s`
Optional parameter. Specifies the name of the output file. When used with `-o`, the scaling factor will be added as a prefix to the filename. For example, `'-o pwmat/config -s atom.config -r 0.99'` results in an output file named `0.99_atom.config`.

#### `-c`
Optional parameter. If specified, the structure will be saved in Cartesian coordinates; otherwise, fractional coordinates will be used. Note that PWmat only supports fractional coordinates, making this parameter ineffective for PWmat.

#### `-t`
Specifies the atomic types in the input structure, required if the input structure is in `lammps/lmp` or `lammps/dump` format. This parameter accepts element names or atomic numbers in the same order as in the input structure. For other formats, this parameter is ignored.

You can find [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples) in the root directory of the source code to use for testing:

```bash
# Example for scale_cell command
pwdata scale_cell -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

# Or using the abbreviated command
pwdata scale -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

# This generates four scaled files in the examples/test_workdir directory named 0.98_scale_atom.config, 0.99_scale_atom.config, 0.97_scale_atom.config, and 0.95_scale_atom.config.
```

### 4. Supercell Expansion with `super_cell`
This command is used to expand the lattice structure into a supercell. You can use either `super_cell` or its abbreviation `super`. The parameters are as follows:

```bash
pwdata super_cell [-h] -m SUPERCELL_MATRIX [SUPERCELL_MATRIX ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-p PERIODICITY [PERIODICITY ...]] [-l TOLERANCE] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays help information, listing all available parameters and their descriptions for the `super` command.

#### `-m`
Required parameter. Specifies the supercell matrix (3x3), entered as either three or nine values. For example, `'-m 2 0 0 0 2 0 0 0 2'` or `'-m 2 2 2'` represents a 2x2x2 supercell expansion.

#### `-i`
Required parameter. Specifies the file path of the input file, which can be an absolute or relative path.

#### `-f`
Optional parameter. If not explicitly specified, the format will be inferred based on the input file. Supported formats are `['pwmat/config', 'vasp/poscar', 'lammps/lmp', 'cp2k/scf']`.

#### `-o`
Optional parameter. Specifies the output format. Supported formats are `['pwmat/config', 'vasp/poscar', 'lammps/lmp']`. If not specified, the output format will match the input format. If the input format is `cp2k/scf`, the output will be saved as `pwmat/config`.

#### `-s`
Optional parameter. Specifies the name of the output file. For example, `'-o pwmat/config -s super_atom.config'` results in an output file named `super_atom.config`.

#### `-c`
Optional parameter. If specified, the structure will be saved in Cartesian coordinates; otherwise, fractional coordinates will be used. Note that PWmat only supports fractional coordinates, making this parameter ineffective for PWmat.

#### `-t`
Specifies the atomic types in the input structure, required if the input structure is in `lammps/lmp` or `lammps/dump` format. This parameter accepts element names or atomic numbers in the same order as in the input structure. For other formats, this parameter is ignored.

#### `-p`
Optional parameter. Specifies periodic boundary conditions. For example, `[1, 1, 1]` indicates periodicity in the x, y, and z directions. The default value is `[1, 1, 1]`.

#### `-l`
Optional parameter. Specifies the tolerance for fractional coordinates, defaulting to `1e-5`. Prevents minor negative coordinates from being mapped outside the simulation box.

You can find [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples) in the root directory of the source code to use for testing:

```bash
# Example for super_cell command
pwdata super_cell -m 2 3 4 -i examples/pwmat_data/lisi_atom.config -s examples/test_workdir/super_atom.config -o pwmat/config 

# Or using the abbreviated command
pwdata super -m 2 0 0 0 3 0 0 0 4 -i examples/pwmat_data/lisi_atom.config -s examples/test_workdir/super_atom.config -o pwmat/config 

# This generates a file named super_atom.config in the examples/test_workdir directory with a 2x3x4 supercell expansion.
```

### 5. Lattice and Atom Position Perturbation: `perturb`

This command is used to apply perturbations to the lattice structure or atomic positions.

Parameters are as follows:

```bash
pwdata perturb [-h] [-d ATOM_PERT_DISTANCE] [-e CELL_PERT_FRACTION] -n PERT_NUM -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays help information, listing all available parameters for the `perturb` command and their explanations.

#### `-d`
Optional parameter specifying the distance for atomic perturbations, which determines the displacement distance of atoms relative to their original positions. Each atomic coordinate is randomly offset within the range [-atom_pert_distance, atom_pert_distance] from a uniform distribution. Perturbation is in Angstroms; for example, `0.01` displaces atoms by up to `0.01` Å. The default value is `0`, meaning no atomic perturbation is applied.

#### `-e`
Optional parameter defining the extent of lattice distortion. Each of the nine lattice values is randomly offset within the range [-cell_pert_fraction, cell_pert_fraction]. For example, `0.03` means the lattice is perturbed by up to 3% of the original lattice. The default is `0`, indicating no lattice perturbation.

#### `-n`
Required parameter specifying the number of perturbed structures to generate.

#### `-i`
Required parameter for the input file path, which can be absolute or relative.

#### `-f`
Optional parameter; if not explicitly specified, the input file format is inferred automatically. Supported formats are `['pwmat/config','vasp/poscar', 'lammps/lmp', 'cp2k/scf']`.

#### `-o`
Optional parameter specifying the output file format. Supported formats are `['pwmat/config','vasp/poscar', 'lammps/lmp']`. If unspecified, the format of the input structure will be used. If the input file format is `cp2k/scf`, it defaults to `pwmat/config` format.

#### `-s`
Optional parameter defining the output filename, used with `-o`. If unspecified, `atom.config` is used for `pwmat/config`, `POSCAR` for `vasp/poscar`, and `lammps.lmp` for `lammps/lmp`. For example, `'-o pwmat/config -s perturb_atom.config'` saves the perturbed structure as `perturb_atom.config`.

#### `-c`
Optional parameter that specifies whether to use fractional coordinates. If `-c` is specified, the structure is saved in Cartesian coordinates; otherwise, fractional coordinates are used. Note: PWmat only supports fractional coordinates, so this parameter has no effect in that case.

#### `-t`
Specifies atomic types for the input structure, used when the input format is `lammps/lmp` or `lammps/dump`. Atomic types can be element names or atomic numbers, and the order should match the structure in the input. This parameter is ignored for other input file formats.

Examples are provided in the [examples directory](https://github.com/LonxunQuantum/pwdata/tree/master/examples) in the source code root. Download them to test these commands:

```bash
# Example of the perturb command
pwdata perturb -e 0.01 -d 0.04 -n 20 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/perturb_atom -o pwmat/config
# After execution, 20 perturbed structures will be created in the examples/test_workdir/perturb_atom directory.
```

## Integration with PWMLFF

<s>In this usage, pwdata is integrated as a submodule of PWMLFF, and its interfaces are called directly. Molecular dynamics trajectory labels are output and saved as `.npy` files.</s> `This feature has been moved into the pwdata package, and its usage and input parameters remain unchanged`.

```bash
pwdata extract.json
```

Here, `extract.json` is a JSON-format configuration file used to specify how to generate the dataset. The format of the configuration file is as follows:

```json
{
  "seed": 666,
  "valid_shuffle": false,
  "train_valid_ratio": 0.8,
  "raw_files": ["./MOVEMENT", "./MOVEMENT_alcho", "./MOVEMENT_ec"],
  "format": "pwmat/movement",
  "trainSetDir": "PWdata",
  "trainDataPath": "train",
  "validDataPath": "valid"
}
```

- `seed`: Random seed for dataset splitting.
- `valid_shuffle`: Whether to shuffle all data randomly. For example, if there are 10 images, when `valid_shuffle` is `true`, all 10 images will be shuffled randomly and then split into training and validation sets according to the `train_valid_ratio`. When `valid_shuffle` is `false`, the data will be split sequentially according to the `train_valid_ratio`. Default is `True`.
- `train_valid_ratio`: Ratio of training set to validation set.
- `raw_files`: Paths to raw data.
- `format`: Format of the raw data used for dataset generation. Supported formats are `pwmat/movement`, `vasp/outcar`, `cp2k/md`.
- `trainSetDir`: Path to save the generated dataset.
- `trainDataPath`: Path to save the training set.
- `validDataPath`: Path to save the validation set.

## Using as an Independent Tool (Interface Calls)

pwdata can also be used as an independent tool to generate datasets or perform data conversion by calling pwdata's interfaces. The interface call for pwdata is as follows:

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**Config**</font> <font color='#2ecc71'>_(self, format: str, data_path: str, pbc = None, atom_names = None, index = ':', **kwargs)_</font> 
> [Source Code](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L110)</p>
>
> Reads data from the input file.
>
> **Parameters:**
>
> - **format**: String. Format of the input file. Supported formats include: `pwmat/config`, `vasp/poscar`, `lammps/dump`, `lammps/lmp`, `pwmat/movement`, `vasp/outcar`, `cp2k/md`, `cp2k/scf`, `pwmlff/npy`, `deepmd/npy`, `deepmd/raw`, `extxyz`, `meta`.
>
>   - `pwmat/config`: PWmat structure file, e.g., `atom.config`.
>   - `pwmat/movement`: PWmat molecular dynamics trajectory file, e.g., `MOVEMENT`.
>   - `lammps/dump`: LAMMPS dump file, e.g., `dump.lammptraj`.
>   - `lammps/lmp`: LAMMPS structure file, e.g., `in.lmp`.
>   - `vasp/poscar`: VASP structure file, e.g., `POSCAR`.
>   - `vasp/outcar`: VASP molecular dynamics trajectory file, e.g., `OUTCAR`.
>   - `cp2k/md`: CP2K standard output file, atomic position file, and corresponding atomic force file, e.g., `cp2k.out`, `*pos-1.xyz`, `*pos-1.pdb`, `*frac-1.xyz`.
>   - `cp2k/scf`: CP2K standard output file, e.g., `cp2k.out`.
>   - `pwmlff/npy`: PWMLFF dataset file, e.g., `energies.npy`.
>   - `deepmd/npy`: DeepMD dataset file, e.g., `force.npy`.
>   - `deepmd/raw`: DeepMD dataset file, e.g., `force.raw`.
>   - `extxyz`: Extended xyz file, e.g., `*.xyz`.
>   - `meta`: Meta is an open-source data file with the suffix `.alelmdb`
>
>   :::caution
>   For CP2K input control files, set `PRINT_LEVEL MEDIUM` to ensure lattice information is included in the standard output file.
>   :::
>
> - **data_path**: String, **Required**. Path to the input file.
>
> - **pbc**: List, Optional. Periodic boundary conditions. Default is None. For example, `[1, 1, 1]` indicates periodicity in x, y, and z directions.
>
> - **atom_names**: List, Optional. Atomic names for <font color='red'>lammps/dump</font> files. Default is None. For example, `['C', 'H', 'O']` indicates the presence of carbon, hydrogen, and oxygen atoms in the system.
>
> - **index**: Integer, Slice, or String, Optional. When reading files with multiple structures, use the index parameter to specify which structure to read. Default is `:`, which reads all structures.
>
>   - `index=0`: First structure
>   - `index=-2`: Second-to-last structure
>   - `index=':'` or `index=slice(None)`: All structures
>   - `index='-3:'` or `index=slice(-3, None)`: From the third-to-last to the last structure
>   - `index='::2'` or `index=slice(0, None, 2)`: Even-numbered structures
>   - `index='1::2'` or `index=slice(1, None, 2)`: Odd-numbered structures
>
> - **kwargs**: Key-value pairs (dictionary), Optional. Additional keyword arguments for reading the input file.
>
>   - **unit**: String, Optional. For LAMMPS files, the unit of the input file. Default is 'metal'.
>
>   - **style**: String, Optional. For LAMMPS files, the style for atom-related properties in LAMMPS simulations. Default is 'atomic'. See [LAMMPS atom_style](https://docs.lammps.org/atom_style.html) for details.
>
>   - **sort_by_id**: Boolean, Optional. For LAMMPS files, whether to sort atoms by id. Default is True.
>
> **Returns:**
> A list of Image objects. Each Image object contains information about a structure.
>

---

> **Example:**
>
> ```python
> from pwdata import Config
>
> data_file = "./POSCAR"
> format = "vasp/poscar"
> config = Config(format, data_file)
> config.to(output_path="./", data_name="lmp.init", save_format="lammps/lmp", direct=False, sort=True)
> ```
>
> :::tip
> For multiple configurations with the same structure, you can use the `.append()` method to concatenate them together before calling the `.to()` method, if needed.
>
> For example:
>
> ```python
> from pwdata import Config
>
> raw_data = ["./OUTCAR0", "./OUTCAR1", "./OUTCAR2"]    # the same atoms...
> format = "vasp/outcar"
> multi_data = Config(format, raw_data[0])
> for data in raw_data[1:]:
>    image_data = Config(format, data)
>    multi_data.append(image_data)
> multi_data.to(output_path="./PWdata", save_format='pwmlff/npy', train_data_path='train', valid_data_path='valid', train_ratio=0.8, random=True, seed=2024, retain_raw=False)
> ```
>
> :::

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**build.supercells.make_supercell**</font> <font color='#2ecc71'>_(image_data, supercell_matrix: list, pbc: list = None, wrap=True, tol=1e-5)_</font>
> [Source Code](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/build/supercells.py#L8)</p>
>
> Build a supercell based on the input structure and supercell matrix.
>
> **Parameters:**
>
> - **image_data**: **Required**. An Image object containing information about the original structure.
>
> - **supercell_matrix**: List, **Required**. Supercell matrix (3x3). For example, `[[2, 0, 0], [0, 2, 0], [0, 0, 2]]` represents a 2x2x2 supercell.
>
> - **pbc**: List, Optional. Periodic boundary conditions. Defaults to None. For example, `[1, 1, 1]` indicates that the system is periodic in the x, y, and z directions.
>
> - **wrap**: Boolean, Optional. Whether to map atoms into the simulation box (for periodic boundary conditions). Defaults to True.
>
> - **tol**: Float, Optional. Tolerance for fractional coordinates. Defaults to 1e-5. Prevents minor negative coordinates from being mapped into the simulation box.
>
> **Returns:**
> A new list of Image objects. Each object contains information about a supercell.
>
> **Example:**
>
> ```python
> from pwdata import Config, make_supercell
>
> data_file = "./atom.config"
> config = Config('pwmat/config', data_file)
> supercell_matrix = [[2, 0, 0], [0, 2, 0], [0, 0, 2]]
> supercell = make_supercell(config, supercell_matrix, pbc=[1, 1, 1])
> supercell.to(output_path="./", data_name="atom_2x2x2.config", save_format="pwmat/config", sort=True)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**pertub.perturbation.perturb_structure**</font> <font color='#2ecc71'>_(image_data, pert_num:int, cell_pert_fraction:float, atom_pert_distance:float)_</font>
> [Source Code](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/pertub/perturbation.py#L22)</p>
>
> Perturb the structure.

---

> **Parameters:**
>
> - **image_data**: **Required**. The Image object to be perturbed, containing information about the original structure.
>
> - **pert_num**: Integer, **Required**. The number of perturbed structures to generate.
>
> - **cell_pert_fraction**: Float, **Required**. Determines the degree of cell deformation. For example, `0.03` means the cell deformation is 3% relative to the original cell.
>
> - **atom_pert_distance**: Float, **Required**. The distance for atomic perturbation, which determines how far atoms move relative to their original positions. Perturbation is in angstroms. For example, `0.01` means atoms move by 0.01 angstroms.
>
> **Returns:**
> A list of new Image objects. Each Image object contains information about a perturbed structure.
>
> **Example:**
>
> ```python
> from pwdata import Config, perturb_structure
>
> data_file = "./atom.config"
> config = Config('pwmat/config', data_file)
> pert_num = 50
> cell_pert_fraction = 0.03
> atom_pert_distance = 0.01
> save_format = "pwmat/config"
> perturbed_structs = perturb_structure(config, pert_num, cell_pert_fraction, atom_pert_distance)
> perturbed_structs.to(output_path="~/pwdata/test/pertubed/",
>           data_name="pertubed",
>           save_format=save_format,
>           direct=True,
>           sort=True)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**pertub.scale.scale_cell**</font> <font color='#2ecc71'>_(image_data, scale_factor:float)_</font>
> [Source Code](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/pertub/scale.py#L5)</p>
>
> **Parameters:**
>
> - **image_data**: **Required**. The Image object to be scaled, containing information about the original structure.
>
> - **scale_factor**: Float, **Required**. The scaling factor for the cell.
>
> **Returns:**
> A new list of Image objects. Each Image object contains information about a scaled structure.
>
> **Example:**
>
> ```python
> from pwdata import Config, scale_cell
>
> data_file = "./atom.config"
> config = Config('pwmat/config', data_file)
> scale_factor = 0.95
> scaled_structs = scale_cell(config, scale_factor)
> scaled_structs.to(output_path="~/test/scaled/",
>           data_name="scaled",
>           save_format="pwmat/config",
>           direct=True,
>           sort=True)
> ```