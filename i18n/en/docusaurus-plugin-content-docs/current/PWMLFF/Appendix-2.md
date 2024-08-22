---

sidebar_position: 6

---

# Appendix II: pwdata

pwdata is a data preprocessing tool for PWMLFF, used for feature and label extraction. It also provides convenient interfaces for data conversion between different software. This appendix will introduce the usage of pwdata and the generation of datasets.

## Supported Data Formats

| Software          | File             | Multi-Image | Label | Format                     |
| ----------------- | ----------------- | ----------- | ----- | -------------------------- |
| PWmat             | MOVEMENT          | True        | True  | 'pwmat/movement'           |
| PWmat             | OUT.MLMD          | False       | True  | 'pwmat/movement'           |
| PWmat             | atom.config       | False       | False | 'vasp/config'              |
| VASP              | OUTCAR            | True        | True  | 'vasp/outcar'              |
| VASP              | poscar            | False       | False | 'vasp/poscar'              |
| LAMMPS            | lmp.init          | False       | False | 'lammps/lmp'               |
| LAMMPS            | dump              | True        | False | 'lammps/dump'              |
| CP2K              | stdout, xyz, pdb  | True        | True  | 'cp2k/md'                  |
| CP2K              | stdout            | False       | True  | 'cp2k/scf'                 |
| PWMLFF            | *.npy             | True        | True  | 'pwmlff/npy'               |
| DeepMD (read)     | *.npy, *.raw      | True        | True  | 'deepmd/npy', 'deepmd/raw' |
| * (extended xyz)  | *.xyz             | True        | True  | 'extxyz'                   |

## Calling pwdata

### Integration with PWMLFF

In this usage, pwdata is integrated as a submodule of PWMLFF, and its interfaces are called directly. Molecular dynamics trajectory labels are output and saved as `.npy` files.

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

### Using as an Independent Tool (Interface Calls)

pwdata can also be used as an independent tool to generate datasets or perform data conversion by calling pwdata's interfaces. The interface call for pwdata is as follows:

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**Config**</font> <font color='#2ecc71'>_(self, format: str, data_path: str, pbc = None, atom_names = None, index = ':', **kwargs)_</font> 
> [Source Code](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L110)</p>
>
> Reads data from the input file.
>
> **Parameters:**
>
> - **format**: String. Format of the input file. Supported formats include: `pwmat/config`, `vasp/poscar`, `lammps/dump`, `lammps/lmp`, `pwmat/movement`, `vasp/outcar`, `cp2k/md`, `cp2k/scf`, `pwmlff/npy`, `deepmd/npy`, `deepmd/raw`, `extxyz`.
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