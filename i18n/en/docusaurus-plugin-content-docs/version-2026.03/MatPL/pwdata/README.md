---
sidebar_position: 6
title: pwdata Structure Conversion
---
# pwdata Data Conversion
## Overview

`This page applies to pwdata >= 0.5.10.`

pwdata is MatPL's data-preprocessing toolkit. It can:

- Convert among `atom.config` (PWmat), `POSCAR` (VASP), `lmp.init` (LAMMPS), and `cp2k.init` (CP2K).

- Build supercells, scale lattices, and perturb lattices or atomic positions.

- Extract `MOVEMENT` (PWmat), `OUTCAR` (VASP), LAMMPS dump, and CP2K MD trajectories, or read `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, and the [`Meta OMAT24 dataset`](https://huggingface.co/datasets/fairchem/OMAT24), then write `pwmlff/npy` or `extxyz`.
For Meta datasets, CPU-parallel queries make it practical to search databases containing over 100 million structures.

### Supported Data Types

| Software          | file             | multi-Image | label | format                     |
| ----------------- | ---------------- | ----------- | ----- | -------------------------- |
| PWmat             | MOVEMENT         | True        | True  | 'pwmat/movement'           |
| PWmat             | OUT.MLMD         | False       | True  | 'pwmat/movement'           |
| PWmat             | atom.config      | False       | False | 'pwmat/config'             |
| VASP              | OUTCAR           | True        | True  | 'vasp/outcar'              |
| VASP              | poscar           | False       | False | 'vasp/poscar'              |
| LAMMPS            | lmp.init         | False       | False | 'lammps/lmp'               |
| LAMMPS            | dump             | True        | False | 'lammps/dump'              |
| CP2K              | stdout, xyz, pdb | True        | True  | 'cp2k/md'                  |
| CP2K              | stdout           | False       | True  | 'cp2k/scf'                 |
| MatPL            | \*.npy           | True        | True  | 'pwmlff/npy'               |
| DeepMD (read)     | \*.npy, \*.raw   | True        | True  | 'deepmd/npy', 'deepmd/raw' |
| \* (extended xyz) | \*.xyz           | True        | True  | 'extxyz'                   |
| Meta (read)       | \*aselmdb        | True        | True  | 'meta'                     |

### Installation
Install with pip:
```bash
pip install pwdata

# Install or upgrade pwdata
pip install pwdata --upgrade

# List available versions
pip index versions pwdata
# Example output:
# pwdata (0.5.10)
# Available versions: 0.5.10, 0.5.9, 0.5.8, 0.5.7, 0.5.6, 0.5.5, 0.5.4, 0.5.3, 0.4.7, 0.4.0, 0.3.2, 0.2.16

# Install a specific version
pip install pwdata==n.m.o
```

## Command-Line Usage

pwdata supports both `command-line use` and `Python API integration`.

Command list:
Use `-h` for descriptions, options, and examples. `pwdata -h` lists all commands.

```bash
pwdata -h
pwdata convert_config or cvt_config -h
pwdata convert_configs or cvt_configs -h
pwdata scale_cell or scale -h
pwdata super_cell or super -h
pwdata perturb -h
pwdata count -h
```

### pwdata convert_config: Convert a Structure

Converts between structure formats. Use `convert_config` or `cvt_config`.
Options:
```bash
pwdata convert_config [-h] -i INPUT -f INPUT_FORMAT -o OUTPUT_FORMAT [-s SAVENAME] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays all options and their descriptions.

#### `-i`
Required input path, absolute or relative.

#### `-f`
Optional input format. If omitted, it is inferred. Supported values: `pwmat/config`, `vasp/poscar`, `lammps/lmp`, and `cp2k/scf`.

#### `-o`
Required output format: `pwmat/config`, `vasp/poscar`, or `lammps/lmp`.

#### `-s`
Output filename used with `-o`. Defaults are `atom.config`, `POSCAR`, and `lammps.lmp` for the respective formats.

#### `-c`
Use `-c` to write Cartesian coordinates; otherwise fractional coordinates are used. `pwmat/config` always uses fractional coordinates.

#### `-t`
For `lammps/lmp` or `lammps/dump`, specifies atom types as symbols or atomic numbers in input-file order. Ignored for other formats.

See the repository's [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples):

```bash
# convert_config example: atom.config to POSCAR
# Creates examples/test_workdir/cvtcnf_atom.POSCAR
pwdata cvt_config -i examples/pwmat_data/LiGePS_atom.config -s examples/test_workdir/cvtcnf_atom.POSCAR -o vasp/poscar
```

### pwdata convert_configs: Convert Training Data
Extracts supported trajectories and datasets—including `MOVEMENT`, `OUTCAR`, LAMMPS dump, CP2K MD, `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, and [`Meta OMAT24`](https://huggingface.co/datasets/fairchem/OMAT24)—to `pwmlff/npy` or `extxyz`. Use `convert_configs` or `cvt_configs`.

Options:
```bash
pwdata [-h] -i INPUT [INPUT ...] [-f INPUT_FORMAT] [-s SAVEPATH] [-o OUTPUT_FORMAT] [-r]
              [-m MERGE] [-g GAP] [-q QUERY] [-n CPU_NUMS] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h` 

Displays all options and descriptions.

#### `-i`
Required list of input files or directories, absolute or relative. For `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, and Meta OMAT24, pwdata searches directories recursively, so only the data root is required.

For example, to read all dataset subdirectories under [examples/pwmlff_data/LiSiC](https://github.com/LonxunQuantum/pwdata/tree/master/examples/pwmlff_data/LiSiC), use `-i examples/pwmlff_data`.

For many files or directories, such as a Meta database, list the paths in JSON and pass that file with `-i`.
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
Optional input format; inferred by default. Supported values are `pwmat/movement`, `vasp/outcar`, `lammps/dump`, `cp2k/md`, `pwmlff/npy`, `deepmd/npy`, `deepmd/raw`, `extxyz`, and `meta`.

#### `-o`
Optional output format: `pwmlff/npy` (default) or `extxyz`.

#### `-s`
Optional output directory; defaults to the current directory.

<!-- #### `-c`
Use `-c` for Cartesian coordinates; otherwise fractional coordinates are used. `pwmlff/npy` always uses fractional coordinates and `extxyz` always uses Cartesian coordinates. -->

#### `-m`
Optional integer for extxyz output. `-m 1` (default) writes all structures to one XYZ file; `-m 0` separates files by element combination.

#### `-g`
Optional integer trajectory interval. The default is `1`.

#### `-q`
Optional query string for `meta` input. Quote expressions such as `H>4` so the shell does not interpret `>` as redirection. See the [Meta query examples](#meta-query-examples-for-convert_configs).

#### `-n`
Optional CPU count for parallel Meta queries. The default is one core.

#### `-t`
For LAMMPS input, specifies atom types as symbols or atomic numbers in input order.

For Meta input, selects structures containing `only these element types`.

### pwdata convert_configs Examples
See the repository's [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples):

Example 1. Extract every fifth frame from two PWmat trajectories to `examples/test_workdir/3_1_configs_extxyz`.
```bash
pwdata convert_configs -i examples/pwmat_data/50_LiGePS_movement examples/pwmat_data/lisi_50_movement -s examples/test_workdir/3_1_configs_extxyz -o extxyz -g 5
```

Example 2. Convert all `deepmd/npy` data under `examples/deepmd_data/alloy` to `pwmlff/npy`.
```bash
pwdata convert_configs -i examples/deepmd_data/alloy -s ./test_workdir/7_0_configs_PWdata
```

Example 3. Convert all XYZ files under `examples/xyz_data` to `pwmlff/npy` in `examples/test_workdir/5_0_configs_PWdata`.
```bash
pwdata convert_configs -i examples/xyz_data -s examples/test_workdir/5_0_configs_PWdata -g 1
```

Example 4. Query all `.aselmdb` databases under `examples/meta_data/alex_val` for structures containing only Pt and Ge, then save them under `./test_workdir/10_1_configs_extxyz`.
```bash
pwdata convert_configs -i examples/meta_data/alex_val -s ./test_workdir/10_1_configs_extxyz -t Pt Ge
```

Example 5. Query the `.aselmdb` databases listed in `meta_data['data_path']` for Pt–Ge structures and save them under `./test_workdir/10_1_configs_extxyz`.
```bash
pwdata convert_configs -i examples/meta_data.json -s ./test_workdir/10_1_configs_extxyz -o extxyz -t Pt Ge
```

### Meta Query Examples for convert_configs
Example 1. Query structures containing `only` Pt and Ge and write XYZ.

```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -t Pt Ge
```

Example 2. Use `-q` to find all structures containing Cu.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -q 'Cu'
```

Example 3. Find structures with fewer than three H atoms.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -q 'H<3'
```

Example 4. Find structures containing Cu and fewer than three H atoms.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -q 'Cu,H<3'
```

Example 5. Find structures with at least two H atoms and at least one O atom.
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -q 'H2O' 
```

Additional query expressions:

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


:::tip
pwdata infers formats and searches dataset directories automatically. For `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, and Meta OMAT24, specify only the data root.

If no format is specified, every supported data source under the input directory is included.
:::

### pwdata scale_cell: Scale a Lattice
Use `scale_cell` or `scale`.
Options:

```bash
pwdata scale_cell [-h] -r SCALE_FACTOR [SCALE_FACTOR ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays all options and descriptions.


#### `-r`
Required space-separated scale factors in `(0,1)`, with $Lattice_{new}=factor\times Lattice_{old}$. For example, `-r 0.97 0.98 0.99` creates three scaled structures.


#### `-i`
Required input path, absolute or relative.


#### `-f`
Optional input format, inferred by default. Supported values: `pwmat/config`, `vasp/poscar`, `lammps/lmp`, and `cp2k/scf`.

#### `-o`
Optional output format: `pwmat/config`, `vasp/poscar`, or `lammps/lmp`. Defaults to the input format, except `cp2k/scf` defaults to `pwmat/config`.

#### `-s`
Optional base output filename used with `-o`; the scale factor is prefixed. Defaults are `atom.config`, `POSCAR`, and `lammps.lmp`. Example: `-o pwmat/config -s atom.config -r 0.99` writes `0.99_atom.config`.


#### `-c`
Use `-c` for Cartesian coordinates; otherwise fractional coordinates are used. PWmat always uses fractional coordinates.


#### `-t`
For LAMMPS input, specifies atom types as symbols or atomic numbers in input order.

See the repository's [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples):

```bash
# scale_cell example
pwdata scale_cell -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

# or the abbreviated command
pwdata scale -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

# Creates four scaled files under examples/test_workdir
```

### pwdata super_cell: Build a Supercell
Use `super_cell` or `super`.
Options:

```bash
pwdata super_cell [-h] -m SUPERCELL_MATRIX [SUPERCELL_MATRIX ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-p PERIODICITY [PERIODICITY ...]] [-l TOLERANCE] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays all options and descriptions.

#### `-m`
Required 3×3 supercell matrix, supplied as three or nine values. `-m 2 0 0 0 2 0 0 0 2` and `-m 2 2 2` both define a 2×2×2 supercell.

#### `-i`
Required input path.


#### `-f`
Optional input format, inferred by default: `pwmat/config`, `vasp/poscar`, `lammps/lmp`, or `cp2k/scf`.

#### `-o`
Optional output format: `pwmat/config`, `vasp/poscar`, or `lammps/lmp`. Defaults to input format, except CP2K defaults to PWmat.

#### `-s`
Optional output filename used with `-o`. Defaults are `atom.config`, `POSCAR`, and `lammps.lmp`. Example: `-o pwmat/config -s super_atom.config`.

#### `-c`
Use `-c` for Cartesian coordinates; otherwise fractional coordinates are used. PWmat always uses fractional coordinates.

#### `-t`
For LAMMPS input, specifies atom types in input order.

#### `-p`
Optional periodic boundaries. `[1,1,1]` (default) is periodic in x, y, and z.

#### `-l`
Optional fractional-coordinate tolerance. The default is `1e-5` and prevents tiny negative coordinates from being mapped incorrectly.

See the repository's [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples):

```bash
# super_cell example
pwdata super_cell -m 2 3 4 -i examples/pwmat_data/lisi_atom.config -s examples/test_workdir/super_atom.config -o pwmat/config 

# or the abbreviated command
pwdata super -m 2 0 0 0 3 0 0 0 4 -i examples/pwmat_data/lisi_atom.config -s examples/test_workdir/super_atom.config -o pwmat/config 

# Creates examples/test_workdir/super_atom.config with a 2×3×4 supercell
```

### pwdata perturb: Perturb a Lattice and Atomic Positions
Perturbs a structure's lattice or atomic positions.
Options:

```bash
pwdata perturb [-h] [-d ATOM_PERT_DISTANCE] [-e CELL_PERT_FRACTION] -n PERT_NUM -i INPUT -f  INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
Displays all options and descriptions.

#### `-d`
Optional atomic perturbation distance in ångströms. Each coordinate is shifted by a value sampled uniformly from `[-atom_pert_distance, atom_pert_distance]`. The default `0` disables atomic perturbation.

#### `-e`
Optional cell-deformation fraction. Each of the nine lattice values is perturbed by a uniformly sampled value in `[-cell_pert_fraction, cell_pert_fraction]`. For example, `0.03` represents approximately 3% deformation. The default `0` disables lattice perturbation.

#### `-n`
Required number of perturbed structures to generate.

#### `-i`
Required input path.

#### `-f`
Optional input format, inferred by default: `pwmat/config`, `vasp/poscar`, `lammps/lmp`, or `cp2k/scf`.

#### `-o`
Optional output format: `pwmat/config`, `vasp/poscar`, or `lammps/lmp`. Defaults to input format, except CP2K defaults to PWmat.

#### `-s`
Optional output filename used with `-o`. Defaults are `atom.config`, `POSCAR`, and `lammps.lmp`.

#### `-c`
Use `-c` for Cartesian coordinates; otherwise fractional coordinates are used. PWmat always uses fractional coordinates.

#### `-t`
For LAMMPS input, specifies atom types in input order.

See the repository's [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples):

```bash
# perturb example
pwdata perturb -e 0.01 -d 0.04 -n 20 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/perturb_atom -o pwmat/config
# Generates 20 perturbed structures under examples/test_workdir/pertub_atom
```

### pwdata count: Count Structures
Counts structures in supported trajectories and datasets, including `MOVEMENT`, `OUTCAR`, LAMMPS dump, CP2K MD, `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, and [`Meta OMAT24`](https://huggingface.co/datasets/fairchem/OMAT24).

Options:
```bash
pwdata convert_configs [-h] [-h] -i INPUT [INPUT ...] [-f INPUT_FORMAT] [-q QUERY] [-n CPU_NUMS] [-t ATOM_TYPES [ATOM_TYPES ...]]

```

#### `-h` 

Displays all options and descriptions.

#### `-i`
Required list of input files or directories. For `pwmlff/npy`, `extxyz`, `deepmd/npy`, `deepmd/raw`, and Meta OMAT24, specify only the data root; pwdata searches recursively.

For example, to count all datasets under [examples/pwmlff_data/LiSiC](https://github.com/LonxunQuantum/pwdata/tree/master/examples/pwmlff_data/LiSiC), use `-i examples/pwmlff_data`.

For many inputs, list their paths in JSON and pass the file with `-i`.
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
Optional input format, inferred by default. Supported values are `pwmat/movement`, `vasp/outcar`, `lammps/dump`, `cp2k/md`, `pwmlff/npy`, `deepmd/npy`, `deepmd/raw`, `extxyz`, and `meta`.

#### `-q`
Optional query string for Meta input. See the [Meta query examples](#meta-query-examples-for-convert_configs).

#### `-n`
Optional CPU count for parallel Meta queries. The default is one core.

#### `-t`
For LAMMPS input, specifies atom types in input order.

For Meta input, selects structures containing only the specified element types.

## Using pwdata as a Python Library

Use the pwdata API to generate datasets or convert data programmatically.

### pwdata Config: Read Data

```python
Config (self, format: str, data_path: str, pbc = None, atom_names = None, index = ':', **kwargs)
```

**Parameters:**
- **format**: String. Input format: `pwmat/config`, `vasp/poscar`, `lammps/dump`, `lammps/lmp`, `pwmat/movement`, `vasp/outcar`, `cp2k/md`, `cp2k/scf`, `pwmlff/npy`, `deepmd/npy`, `deepmd/raw`, `extxyz`, or `meta`.

- `pwmat/config`: PWmat structure, e.g. `atom.config`.
- `pwmat/movement`: PWmat MD trajectory, e.g. `MOVEMENT`.
- `lammps/dump`: LAMMPS dump, e.g. `dump.lammptraj`.
- `lammps/lmp`: LAMMPS structure, e.g. `in.lmp`.
- `vasp/poscar`: VASP structure, e.g. `POSCAR`.
- `vasp/outcar`: VASP MD trajectory, e.g. `OUTCAR`.
- `cp2k/md`: CP2K output plus positions and forces, e.g. `cp2k.out`, `*pos-1.xyz`, `*pos-1.pdb`, or `*frac-1.xyz`.
- `cp2k/scf`: CP2K output, e.g. `cp2k.out`.
- `pwmlff/npy`: MatPL dataset, e.g. `energies.npy`.
- `deepmd/npy`: DeepMD dataset, e.g. `force.npy`.
- `deepmd/raw`: DeepMD dataset, e.g. `force.raw`.
- `extxyz`: Extended XYZ, e.g. `*.xyz`.
- `meta`: Open Meta data with `.aselmdb` extension.

:::caution
Set `PRINT_LEVEL MEDIUM` in CP2K input so the standard output contains lattice information.
:::

- **data_path**: String, **required**. Input path.

- **pbc**: Optional list of periodic boundaries. Default `None`; `[1,1,1]` is periodic in x, y, and z.

- **atom_names**: Optional list of atom names for `lammps/dump`, e.g. `['C','H','O']`. Default `None`.

- **index**: Optional integer, slice, or string selecting structures from a multi-structure file. Default `:` reads all.

    - `index=0`: first structure
    - `index=-2`: second-to-last structure
    - `index=':'` or `slice(None)`: all structures
    - `index='-3:'` or `slice(-3,None)`: last three structures
    - `index='::2'` or `slice(0,None,2)`: even indices
    - `index='1::2'` or `slice(1,None,2)`: odd indices

- **kwargs**: Optional keyword arguments for the reader.

- **unit**: Optional LAMMPS unit style. Default `metal`.

- **style**: Optional LAMMPS atom style. Default `atomic`. See [LAMMPS atom_style](https://docs.lammps.org/atom_style.html).

- **sort_by_id**: Optional Boolean controlling atom sorting by ID for LAMMPS. Default `True`.

**Returns:**
A list of `Image` objects, one per structure.

**Example:**

```python
from pwdata import Config

data_file = "./cp2k.out"
format = "cp2k/scf"
config = Config(format, data_file)
```

### pwdata Config.to(): Write Data
Writes loaded data in the requested format.

```python
Config.to (self, data_path, format = None, **kwargs)
```

**Parameters:**

- **data_path**: String, **required**. Output path.

- **format**: String, **required**. Output format: `pwmat/config`, `pwmat/movement`, `vasp/poscar`, `lammps/lmp`, `extxyz`, or `pwmlff/npy`.

- **Kwargs**:
Additional output keyword arguments:

- For `pwmat/config`, `vasp/poscar`, `lammps/lmp`, and `extxyz`:
    - **data_name**: String, **required**. Output filename.
    - **sort**: Optional Boolean controlling sorting by atomic number. Default `None`.
    - **wrap**: Optional Boolean controlling wrapping into the simulation cell. Default `False`.
    - **direct**: Boolean, **required**. Selects fractional versus Cartesian coordinates.
- For labeled `pwmlff/npy` output:
    - **data_name**: String, **required**. Dataset-directory name.
    - **random**: Optional Boolean controlling shuffling.
    - **seed**: Optional random seed. Default `2024`.

:::caution

- For CP2K data, set `sort=False`; CP2K is already sorted and re-sorting corrupts ordering.
- `pwmlff/npy` stores labeled datasets for model training.
- PWmat structures always use fractional coordinates, so `direct` is ignored.
- LAMMPS structures always use Cartesian coordinates, so `direct` is ignored.
:::

 **Example 1:**

 ```python
 from pwdata import Config

 data_file = "./POSCAR"
 format = "vasp/poscar"
 config = Config(format, data_file)
 config.to(data_path = "./", format = "lammps/lmp", data_name = "lmp.init", direct = False, sort = True)
 ```

 Multiple configurations with the same structure can be combined with `.append()` before calling `.to()`.

 Example:

 ```python
 from pwdata import Config

 raw_data = ["./OUTCAR0", "./OUTCAR1", "./OUTCAR2"]    # the same atoms...
 format = "vasp/outcar"
 multi_data = Config(format, raw_data[0])
 for data in raw_data[1:]:
    image_data = Config(format, data)
    multi_data.append(image_data)
 multi_data.to(data_path = "./PWdata", format='pwmlff/npy')
 ```

 **Example 2:**

 Convert `pwmat/movement`, `vasp/outcar`, `cp2k/md`, or `lammps/dump` trajectories to individual `pwmat/config`, `vasp/poscar`, or `lammps/lmp` structures.
```python
from pwdata import Config
from pwdata.utils.constant import FORMAT

def trajs2config():
    atom_types = ["Hf", "O"] # for lammps
    input_file = "/data/home/wuxingxing/codespace/pwdata/examples/lmps_data/HfO2/30.lammpstrj"
    input_format="lammps/dump"
    save_format = "pwmat/config"
    image = Config(data_path=input_file, format=input_format, atom_names=atom_types)
    tmp_image_data = image.images
    save_dir = "./tmp_test"
    for id, config in enumerate(tmp_image_data):
        savename = "{}_{}".format(id, FORMAT.get_filename_by_format(save_format))
        image.iamges = [config]
        image.to(data_path = save_dir,
            data_name = savename,
            format = save_format,
            sort = True)

if __name__=="__main__":
    trajs2config()
```

### pwdata build.supercells: Supercell Construction

```python
build.supercells.make_supercell (image_data, supercell_matrix: list, pbc: list = None, wrap=True, tol=1e-5)
```

Construct a supercell from the input structure and supercell matrix.

**Parameters:**

- **image_data**: **Required**. An Image object containing information about the original structure.

- **supercell_matrix**: List, **required**. The 3x3 supercell matrix. For example, `[[2, 0, 0], [0, 2, 0], [0, 0, 2]]` creates a 2x2x2 supercell.

- **pbc**: List, optional. Periodic boundary conditions. The default is None. For example, `[1, 1, 1]` makes the system periodic along the x, y, and z directions.

- **wrap**: Boolean, optional. Whether to wrap atoms into the simulation cell when periodic boundary conditions are used. The default is True.

- **tol**: Float, optional. Tolerance for fractional coordinates. The default is 1e-5. It prevents slightly negative coordinates from being wrapped into the simulation cell.

**Returns:**
A new Image object (or list of Image objects) containing information about the supercell.

**Example:**

```python
from pwdata import Config, make_supercell

data_file = "./atom.config"
config = Config('pwmat/config', data_file)
supercell_matrix = [[2, 0, 0], [0, 2, 0], [0, 0, 2]]
supercell = make_supercell(config, supercell_matrix, pbc=[1, 1, 1])
supercell.to(data_path = "./", data_name = "atom_2x2x2.config", format = "pwmat/config", sort = True)
```

### pwdata pertub.perturbation: Structure Perturbation
Perturb a structure.
``` python
pertub.perturbation.perturb_structure (image_data, pert_num:int, cell_pert_fraction:float, atom_pert_distance:float)
```
**Parameters:**

- **image_data**: **Required**. The Image object to perturb, containing information about the original structure.

- **pert_num**: Integer, **required**. Number of perturbed structures to generate.

- **cell_pert_fraction**: Float, **required**. Magnitude of the cell deformation. For example, `0.03` means that the cell is deformed by 3% relative to the original cell.

- **atom_pert_distance**: Float, **required**. Atomic perturbation distance, in angstroms, that controls how far atoms move from their original positions. For example, `0.01` means that atoms are displaced by 0.01 angstrom.

**Returns:**
A list of new Image objects, each containing information about a perturbed structure.

**Example:**

```python
from pwdata import Config, perturb_structure

data_file = "./atom.config"
config = Config('pwmat/config', data_file)
pert_num = 50
cell_pert_fraction = 0.03
atom_pert_distance = 0.01
save_format = "pwmat/config"
perturbed_structs = perturb_structure(config, pert_num, cell_pert_fraction, atom_pert_distance)
perturbed_structs.to(data_path = "~/pwdata/test/pertubed/",
        data_name = "pertubed",
        format = save_format,
        direct = True,
        sort = True)
```
### pwdata pertub.scale: Cell Scaling
```python
pertub.scale.scale_cell (image_data, scale_factor:float) 
```
**Parameters:**

- **image_data**: **Required**. The Image object to scale, containing information about the original structure.

- **scale_factor**: Float, **required**. Scaling factor for the cell.

**Returns:**
A new Image object (or list of Image objects), each containing information about a scaled structure.

**Example:**

```python
from pwdata import Config, scale_cell

data_file = "./atom.config"
config = Config('pwmat/config', data_file)
scale_factor = 0.95
scaled_structs = scale_cell(config, scale_factor)
scaled_structs.to(data_path = "~/test/scaled/",
        data_name = "scaled",
        format = "pwmat/config",
        direct = True,
        sort = True)
```

### pwdata API Example: Converting MPtraj Files to LMDB Format

The open-source MPtraj dataset is provided in JSON format. After converting it to LMDB, use the [`cvt_configs` command with the `-t` and `-q` options](#2-extract-training-data-convert_configs) to quickly locate selected structures and convert them to extxyz or pwmlff/npy format for training.

```python
import json
from pwdata.fairchem.datasets.ase_datasets import LMDBDatabase
from ase import Atoms
from ase.db.row import AtomsRow
from pwdata.utils.constant import get_atomic_number_from_name
from tqdm import tqdm
import numpy as np

def MPjson2lmdb():
    mp_file = "/data/home/wuxingxing/codespace/pwdata/examples/mp_data/mptest.json"
    save_file = "/data/home/wuxingxing/codespace/pwdata/examples/mp_data/sub.aselmdb"
    Mpjson = json.load(open(mp_file))
    db = LMDBDatabase(filename=save_file, readonly=False)
    for key_1, val_1 in tqdm(Mpjson.items(), total=len(Mpjson.keys())):
        for key_2, val_2 in val_1.items():
            _atomrow, data = cvt_dict_2_atomrow(val_2)
            db._write(_atomrow, key_value_pairs={}, data=data)
    db.close()
    
def cvt_dict_2_atomrow(config:dict):
    cell = read_from_dict('matrix', config['structure']['lattice'], require=True)
    atom_type_list = get_atomic_number_from_name([_['label'] for _ in config['structure']['sites']])
    position = [_['xyz'] for _ in config['structure']['sites']]
    magmom = read_from_dict('magmom', config, require=True)
    atom = Atoms(positions=position,
                numbers=atom_type_list,
                magmoms=magmom,
                cell=cell)

    atom_rows = AtomsRow(atom)
    atom_rows.pbc = np.ones(3, bool)
    # read stress -> xx, yy, zz, yz, xz, xy
    stress = read_from_dict('stress', config, require=True)
    atom_rows.stress = [stress[0][0],stress[1][1],stress[2][2],stress[1][2],stress[0][2],stress[0][1]]
    force = read_from_dict('force', config, require=True)
    energy = read_from_dict('corrected_total_energy', config, require=True)
    atom_rows.__setattr__('force',  force)
    atom_rows.__setattr__('energy', energy)
    data = {}
    data['uncorrected_total_energy'] = read_from_dict('uncorrected_total_energy', config, default=None)
    data['corrected_total_energy'] = read_from_dict('uncorrected_total_energy', config, default=None)
    data['energy_per_atom'] = read_from_dict('energy_per_atom', config, default=None)
    data['ef_per_atom'] = read_from_dict('ef_per_atom', config, default=None)
    data['e_per_atom_relaxed'] = read_from_dict('e_per_atom_relaxed', config, default=None)
    data['ef_per_atom_relaxed'] = read_from_dict('ef_per_atom_relaxed', config, default=None)
    data['bandgap'] = read_from_dict('bandgap', config, default=None)
    data['mp_id'] = read_from_dict('mp_id', config, default=None)
    return atom_rows, data

def read_from_dict(key:str, config:dict, default=None, require=False):
    if key in config:
        return config[key]
    else:
        if require:
            raise ValueError("key {} not found in config".format(key))
        else:
            return default
if __name__=="__main__":
    MPjson2lmdb()
```
