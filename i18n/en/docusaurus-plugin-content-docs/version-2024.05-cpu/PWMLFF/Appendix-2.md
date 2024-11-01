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


# Command-Line Usage of pwdata
`pwdata` supports both command-line and source-based usage.

## 1. Command-Line Operations

Command list:
The following is a list of `pwdata` commands. You can use the '-h' option for detailed explanations and all supported arguments for each command. Use `pwdata -h` to output all available commands and examples of their usage.

```bash
pwdata -h
pwdata convert_config or cvt_config -h
pwdata convert_configs or cvt_configs -h
pwdata scale_cell or scale -h
pwdata super_cell or super -h
pwdata perturb -h
```

Detailed descriptions of the commands are as follows:

### 1. Structure Conversion: `convert_config`

This command is used for conversions between various structures. You can use `convert_config` or its abbreviation `cvt_config`.
Parameters are as follows:
```bash
pwdata convert_config [-h] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Outputs help information, listing all available parameters for the scale command and their explanations.

#### `-i`
The path of the input file, supporting absolute or relative paths. This parameter is required.

#### `-f`
The format of the input file. Supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp', 'cp2k/scf']. This is a required parameter.

#### `-o`
The format of the output file. Supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp']. If not specified, the input structure's format will be used. For `cp2k/scf` input, the default output format is `pwmat/config`.

#### `-s`
The name of the output file, used with `-o`. If not specified, `pwmat/config` uses `atom.config`, `vasp/poscar` uses `POSCAR`, and `lammps/lmp` uses `lammps.lmp` as the file name.

#### `-c`
Whether to use fractional coordinates. If specified, Cartesian coordinates are used when saving the structure; otherwise, fractional coordinates are used. Note that PWmat only supports fractional coordinates, so this parameter will be ignored in such cases.

#### `-t`
Specifies the atomic types of the input structure. This parameter applies when the input structure is in `lammps/lmp` or `lammps/dump` format. Element names or atomic numbers should match the order of atoms in the input structure. This parameter is ignored for other formats.

Examples are provided in the [examples directory](https://github.com/LonxunQuantum/pwdata/tree/master/examples) in the root directory of the source code. You can download and test these examples as shown below:

```bash
# Example of convert_config command
pwdata convert_config -i examples/pwmat_data/LiGePS_atom.config -f pwmat/config -s examples/test_workdir/cvtcnf_atom.POSCAR -o vasp/poscar

# Or abbreviated command
pwdata cvt_config -i examples/pwmat_data/LiGePS_atom.config -f pwmat/config -s examples/test_workdir/cvtcnf_atom.POSCAR -o vasp/poscar

# After execution, the structure file cvtcnf_atom.POSCAR will be generated in the examples/test_workdir directory.
```

### 2. Training Data Extraction: `convert_configs`
Extracts various trajectory files (`MOVEMENT (PWmat)`, `OUTCAR (VASP)`, `lammps dump file (LAMMPS)`, `cp2k md file (CP2K)`) or commonly used training data (`pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, or [meta OMAT24 open-source dataset](https://huggingface.co/datasets/fairchem/OMAT24)) to `pwmlff/npy` or `extxyz` format files. You can use `convert_configs` or its abbreviation `cvt_configs`.
Parameters are as follows:
```bash
pwdata convert_configs [-h] -i INPUT [INPUT ...] -f INPUT_FORMAT [-t ATOM_TYPES [ATOM_TYPES ...]] [-s SAVEPATH] [-o OUTPUT_FORMAT] [-c] [-p TRAIN_VALID_RATIO] [-r] [-g GAP] [-q QUERY] [-n CPU_NUMS] [-m]
```

#### `-h`
Outputs help information, listing all available parameters for the scale command and their explanations.

#### `-i`
Path of the input file, supporting absolute or relative paths. This parameter is required and takes a list format, supporting multiple files or directories. For trajectory files, specify the exact path without directory search. For input formats like ['pwmlff/npy', 'deepmd/npy', 'deepmd/raw', 'extxyz', 'meta'], you may specify a directory, and `pwdata` will automatically search for all extractable files within it, such as in [examples/pwmlff_data/LiSiC](https://github.com/LonxunQuantum/pwdata/tree/master/examples/pwmlff_data/LiSiC), which contains subdirectories like 'C2, C448, C448Li75, C64Si32, Li1Si24, Li3Si8, Li8, Li88Si20, Si1, Si217'. Inputting '-i examples/pwmlff_data' will prompt `pwdata` to detect these subdirectories.

For multiple files or directories (like the extensive meta database), you can list these paths in a JSON file and input it using `-i jsonfile`, as shown below:
```json
{
    "datapath" : [
        "/share/public/PWMLFF_test_data/eqv2-models/datasets/decompress/Omat24/train/rattled-1000-subsampled",
        "/share/public/PWMLFF_test_data/eqv2-models/datasets/decompress/Omat24/train/rattled-300",
        "/share/public/PWMLFF_test_data/eqv2-models/datasets/decompress/Omat24/train/rattled-300-subsampled"
    ]
}
```

#### `-f`
The format of the input file. Supported formats are ['pwmat/movement', 'vasp/outcar', 'lammps/dump', 'cp2k/md', 'pwmlff/npy', 'deepmd/npy', 'deepmd/raw', 'extxyz', 'meta']. This parameter is required.

#### `-o`
The format of the output file. Supported formats are ['pwmlff/npy', 'extxyz'], with a default format of `'pwmlff/npy'`.

#### `-s`
Specifies the output file name, used together with the `-o` option. If not specified, it defaults to `atom.config` for the `pwmat/config` format, `POSCAR` for the `vasp/poscar` format, and `lammps.lmp` for the `lammps/lmp` format.

#### `-c`
Determines whether to use fractional coordinates. If `-c` is specified, Cartesian coordinates will be used when saving the structure; otherwise, fractional coordinates are used. Note: Fixed use of fractional coordinates for `'pwmlff/npy'` format data; Fixed use of Cartesian coordinates for the `'extxyz'` format.

#### `-p`
Sets the ratio of data split between training and test sets after extraction, with values ranging from `[0.0, 1.0]`. The default is `1.0`, meaning no test set is created.

#### `-r`
Boolean parameter. When splitting data into a test set, it specifies whether to split randomly. Used with the `-p` option, for example, `-p 0.8 -r` randomly splits 80% as the training set and 20% as the test set, while `-p 0.8` uses the first 80% as the training set and the last 20% as the test set.

#### `-m`
Integer type. This parameter is only applicable when the output file format is `extxyz`. Setting `-m 1` saves all structures into a single XYZ file (default). Setting `-m 0` saves each structure in a separate XYZ file according to element types.

#### `-g`
Integer type. When extracting from trajectory files, this parameter specifies the interval of steps between frames to extract structures. The default is `1`, meaning every frame is extracted.

#### `-q`
String type. This parameter is effective when the input type is `meta` and is used for database queries. For detailed usage, refer to the [meta query example](#convert_configs-meta-查询例子).

#### `-n`
Integer type. This parameter is effective when the input type is `meta` and is used to set the number of CPU cores for parallel database queries. By default, all available cores are used.

#### `-t`
For `lammps/lmp` or `lammps/dump` formats, this parameter specifies the atomic types of the structure, which can be element names or atomic numbers. The order must match that in the input structure.

For the `meta` format, this parameter is used to search for structures that contain **only these specific element types**.

### convert_configs Examples
We provide an [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples) folder in the root directory of the source code. You can download and use these test examples:

Example 1: Extract all data in `pwmlff/npy` format from the `examples/pwmlff_data/LiSiC` directory and convert it to `xyz` format, with 80% of the data as the training set and 20% as the test set. After execution, two files, `train.xyz` and `valid.xyz`, will be generated in the `examples/test_workdir/0_1_configs_extxyz` directory.
```bash
pwdata convert_configs -i examples/pwmlff_data/LiSiC -f pwmlff/npy -s examples/test_workdir/0_1_configs_extxyz -o extxyz -p 0.8
```

Example 2: Extract one frame every 5 steps from the PWmat trajectory files `50_LiGePS_movement` and `lisi_50_movement`, randomly dividing 80% of the structures as the training set and 20% as the test set. The results are saved in `examples/test_workdir/3_1_configs_extxyz`.
```bash
pwdata convert_configs -i examples/pwmat_data/50_LiGePS_movement examples/pwmat_data/lisi_50_movement -f pwmat/movement -s examples/test_workdir/3_1_configs_extxyz -o extxyz -p 0.8 -r -g 5
```

Example 3: Extract all `deepmd/npy` files from the `examples/deepmd_data/alloy` directory and convert them to `pwmlff/npy` format without creating a test set.
```bash
pwdata convert_configs -i examples/deepmd_data/alloy -f deepmd/npy -s ./test_workdir/7_0_configs_PWdata -o pwmlff/npy
```

Example 4: Extract all files with the `xyz` suffix from the `examples/xyz_data` directory, convert them to `pwmlff/npy` format, and randomly split them 80/20 into training and test sets. The results are saved in `examples/test_workdir/5_0_configs_PWdata`.
```bash
pwdata convert_configs -i examples/xyz_data -f extxyz -s examples/test_workdir/5_0_configs_PWdata -o pwmlff/npy -p 0.8 -r -g 1
```

Example 5: Query structures with element types Pt and Ge from all `.aselmdb` meta databases in `examples/meta_data/alex_val`, saving all queried structures in `./test_workdir/10_1_configs_extxyz` without splitting a test set.
```bash
pwdata convert_configs -i examples/meta_data/alex_val -f meta -s ./test_workdir/10_1_configs_extxyz -o extxyz -t Pt Ge
```

Example 6: Query structures with element types Pt and Ge from all `.aselmdb` meta databases in the directories or files listed in `meta_data['data_path']` and save all queried structures in `./test_workdir/10_1_configs_extxyz` without splitting a test set.
```bash
pwdata convert_configs -i examples/meta_data.json -f meta -s ./test_workdir/10_1_configs_extxyz -o extxyz -t Pt Ge
```

### convert_configs meta Query Examples
Example 1: Query structures containing **only** `Pt` and `Ge` elements, and output the results in `xyz` format. After execution, two files, `train.xyz` and `valid.xyz`, will be created in `examples/test_workdir/10_1_configs_extxyz`.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -f meta -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -t Pt Ge
```

Example 2: Use the `-q` parameter to query all structures containing the element `Cu`.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -f meta -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q Cu
```

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
This command is used to scale the lattice of a structure. You can use `scale_cell` or its shorthand `scale`.
Parameters are as follows:

```bash
pwdata scale_cell [-h] -r SCALE_FACTOR [SCALE_FACTOR ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Outputs help information, listing all available parameters and descriptions for the `scale` command.

#### `-r`
Lattice scaling factor, where $Lattic_{new} = factor * Lattice_{old}$. The factor is a floating-point list in the range (0.0, 1.0), separated by spaces. For example, `'-r 0.97 0.98 0.99'` applies scaling factors of 0.97, 0.98, and 0.99 to the input structure. Required parameter.

#### `-i`
Path to the input file, supports absolute or relative paths. Required parameter.

#### `-f`
Format of the input file; supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp', 'cp2k/scf']. Required parameter.

#### `-o`
Output file format; supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp']. If not specified, the input structure’s format is used. If the input file format is `cp2k/scf`, `pwmat/config` format will be used by default.

#### `-s`
Name of the output file, used with `-o`. The scaling factor is used as a prefix. If not specified, `pwmat/config` format uses `atom.config`, `vasp/poscar` uses `POSCAR`, and `lammps/lmp` uses `lammps.lmp`. For example, `'-o pwmat/config -s atom.config -r 0.99'` creates `'0.99_atom.config'`.

#### `-c`
Specifies if fractional coordinates should be used. If `-c` is specified, Cartesian coordinates are used when saving the structure; otherwise, fractional coordinates are used. Note: PWmat only supports fractional coordinates, making this parameter ineffective.

#### `-t`
Atom types of the input structure, used only for `lammps/lmp` or `lammps/dump` formats to specify the structure’s atom types. It can be element names or atom numbers, and the order should match the input structure. This parameter is ignored for other input formats.

Example in the [source code root directory](https://github.com/LonxunQuantum/pwdata/tree/master/examples) that you can download and use for testing:

```bash
# scale_cell command example
pwdata scale_cell -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

# or using shorthand command
pwdata scale -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

# After execution, four scaled files are created in the examples/test_workdir directory with names: 0.98_scale_atom.config, 0.99_scale_atom.config, 0.97_scale_atom.config, and 0.95_scale_atom.config.
```

### 4. Supercell Expansion with `super_cell`
This command is used to expand the lattice into a supercell. You can use `super_cell` or its shorthand `super`.
Parameters are as follows:

```bash
pwdata super_cell [-h] -m SUPERCELL_MATRIX [SUPERCELL_MATRIX ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-p PERIODICITY [PERIODICITY ...]] [-l TOLERANCE] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Outputs help information, listing all available parameters and descriptions for the `super` command.

#### `-m`
Supercell matrix (3x3), either 3 or 9 values, such as `'-m 2 0 0 0 2 0 0 0 2'` or `'-m 2 2 2'`, specifying a `2x2x2` supercell. Required parameter.

#### `-i`
Path to the input file, supports absolute or relative paths. Required parameter.

#### `-f`
Format of the input file; supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp', 'cp2k/scf']. Required parameter.

#### `-o`
Output file format; supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp']. If not specified, the input structure’s format is used. If the input file format is `cp2k/scf`, `pwmat/config` format will be used by default.

#### `-s`
Name of the output file, used with `-o`. If not specified, `pwmat/config` uses `atom.config`, `vasp/poscar` uses `POSCAR`, and `lammps/lmp` uses `lammps.lmp`. For example, `'-o pwmat/config -s super_atom.config'` creates `'super_atom.config'`.

#### `-c`
Specifies if fractional coordinates should be used. If `-c` is specified, Cartesian coordinates are used when saving the structure; otherwise, fractional coordinates are used. Note: PWmat only supports fractional coordinates, making this parameter ineffective.

#### `-t`
Atom types of the input structure, used only for `lammps/lmp` or `lammps/dump` formats to specify the structure’s atom types. It can be element names or atom numbers, and the order should match the input structure. This parameter is ignored for other input formats.

#### `-p`
Periodicity of boundary conditions, e.g., `[1, 1, 1]` makes the system periodic in x, y, and z directions. Default is `[1,1,1]`.

#### `-l`
Tolerance for fractional coordinates. Default is `1e-5`. Prevents slightly negative coordinates from being mapped into the simulation box.

Example in the [source code root directory](https://github.com/LonxunQuantum/pwdata/tree/master/examples) that you can download and use for testing:

```bash
# super_cell command example
pwdata super_cell -m 2 3 4 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/super_atom.config -o pwmat/config 

# or using shorthand command
pwdata super -m 2 0 0 0 3 0 0 0 4 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/super_atom.config -o pwmat/config 

# After execution, a supercell file named super_atom.config is created in the examples/test_workdir directory, using a 2x3x4 supercell.
```

### 5. Lattice and Atomic Position Perturbation: `perturb`

This command is used to apply perturbations to the lattice or atomic positions of a structure. Parameters are as follows:

```bash
pwdata perturb [-h] [-d ATOM_PERT_DISTANCE] [-e CELL_PERT_FRACTION] -n PERT_NUM -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays help information listing all available options and explanations for the `perturb` command.

#### `-d`
Distance for atomic perturbation, determining the displacement of atoms relative to their original positions. For each atom's three coordinates, a random value is sampled from a uniform distribution within [-atom_pert_distance, atom_pert_distance]. Perturbation is applied in Angstrom units. For example, `0.01` moves atoms by `0.01` Å. Default is `0`, meaning no atomic perturbation.

#### `-e`
Degree of cell deformation. Each of the nine lattice values will be adjusted by adding a random value sampled from a uniform distribution within [-cell_pert_fraction, cell_pert_fraction]. For example, `0.03` means a 3% deformation relative to the original cell. Default is `0`, meaning no lattice perturbation.

#### `-n`
Number of structures to be perturbed. This is a required parameter.

#### `-i`
File path for the input file, supporting absolute or relative paths. This is a required parameter.

#### `-f`
Input file format. Supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp', 'cp2k/scf']. This is a required parameter.

#### `-o`
Output file format. Supported formats are ['pwmat/config', 'vasp/poscar', 'lammps/lmp']. If not specified, the input structure’s format will be used. If the input file format is `cp2k/scf`, then `pwmat/config` format will be used.

#### `-s`
Output file name, used in combination with `-o`. If not specified, for the `pwmat/config` format, the file name will default to `atom.config`; for `vasp/poscar`, it will be `POSCAR`; for `lammps/lmp`, it will be `lammps.lmp`. For example, `'-o pwmat/config -s super_atom.config'` names the perturbed file `'super_atom.config'`.

#### `-c`
Specifies whether to use fractional coordinates. If `-c` is provided, structures will be saved in Cartesian coordinates; otherwise, fractional coordinates will be used. Note that PWmat only supports fractional coordinates, so this option will be ignored in such cases.

#### `-t`
Atomic types for the input structure, used when the input format is `lammps/lmp` or `lammps/dump` to specify atomic types, which can be element names or atomic numbers, matching the order in the input structure. This option is ignored for other formats.

Examples are available in the [examples directory](https://github.com/LonxunQuantum/pwdata/tree/master/examples) in the source code root, which you can download and use for testing:

```bash
# Example command for `perturb`
pwdata perturb -e 0.01 -d 0.04 -n 20 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/perturb_atom -o pwmat/config
# This will generate 20 perturbed structures in the examples/test_workdir/perturb_atom directory
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
> - **format**: String. Format of the input file. Supported formats include: `pwmat/config`, `vasp/poscar`, `lammps/dump`, `lammps/lmp`, `pwmat/movement`, `vasp/outcar`, `cp2k/md`, `cp2k/scf`, `pwmlff/npy`, `deepmd/npy`, `deepmd/raw`, `extxyz`,`meta`.
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