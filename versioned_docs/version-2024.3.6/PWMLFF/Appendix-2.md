---
sidebar_position: 5
---

# Appendix Ⅱ: pwdata

pwdata 是 PWMLFF 的数据预处理工具，可用于提取特征和标签。同时为不同软件间的数据转换提供了便捷的接口。本附录将介绍 pwdata 的使用方法和数据集的生成。

## 目前支持的数据格式

| Software | file             | multi-Image | label | format           |
| -------- | ---------------- | ----------- | ----- | ---------------- |
| PWmat    | MOVEMENT         | True        | True  | 'pwmat/movement' |
| PWmat    | OUT.MLMD         | False       | True  | 'pwmat/movement' |
| PWmat    | atom.config      | False       | False | 'vasp/config     |
| VASP     | OUTCAR           | True        | True  | 'vasp/outcar'    |
| VASP     | poscar           | False       | False | 'vasp/poscar'    |
| LAMMPS   | lmp.init         | False       | False | 'lammps/lmp'     |
| LAMMPS   | dump             | True        | False | 'lammps/dump'    |
| CP2K     | stdout, xyz, pdb | True        | True  | 'cp2k/md'        |
| CP2K     | stdout           | False       | True  | 'cp2k/scf'       |

## pwdata 调用方式

### 直接结合 PWMLFF 使用

这种使用方式是将 pwdata 作为 PWMLFF 的一个子模块，直接调用 pwdata 的接口。并将分子动力学轨迹标签直接输出保存为 `.npy` 文件。

```bash
pwdata extract.json
```

其中 `extract.json` 是一个 JSON 格式的配置文件，用于指定数据集的生成方式。配置文件的格式如下：

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

- `seed`: 随机数种子，用于数据集的划分
- `valid_shuffle`: 是否对全部数据进行随机打乱。例如，存在 10 个 images，`valid_shuffle` 为 `true` 时，将对 10 个 images 进行随机打乱，然后按照 `train_valid_ratio` 的比例划分训练集和验证集。`valid_shuffle` 为 `false` 时，将按照 `train_valid_ratio` 的比例按顺序划分训练集和验证集。默认为 `True`
- `train_valid_ratio`: 训练集和验证集的比例
- `raw_files`: 原始数据的路径
- `format`: 原始数据的格式，用于训练集的生成，所以支持的格式有 `pwmat/movement`, `vasp/outcar`, `cp2k/md`
- `trainSetDir`: 生成的数据集的保存路径
- `trainDataPath`: 生成的训练集的保存路径
- `validDataPath`: 生成的验证集的保存路径

### 作为独立工具使用 (接口调用)

pwdata 也可以作为一个独立的工具使用，通过调用 pwdata 的接口来生成数据集或者进行数据转换。pwdata 的接口调用方式如下：

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**Config**</font> <font color='#2ecc71'>_(self, format: str, data_path: str, pbc = None, atom_names = None, index = ':', **kwargs)_</font> 
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L110)</p>
>
> Read the data from the input file.
>
> **Parameters:**
>
> - **format**: str. The format of the input file. Supported formats are `pwmat/config`, `vasp/poscar`, `lammps/dump`, `lammps/lmp`, `pwmat/movement`, `vasp/outcar`, `cp2k/md`, `cp2k/scf`
>
>   - `pwmat/config`: PWmat configuration file, for example, `atom.config`.
>   - `pwmat/movement`: PWmat trajectory file, for example, `MOVEMENT`.
>   - `lammps/dump`: LAMMPS dump file, for example, `dump.lammpstrj`.
>   - `lammps/lmp`: LAMMPS configuration file, for example, `in.lmp`.
>   - `vasp/poscar`: VASP configuration file, for example, `POSCAR`.
>   - `vasp/outcar`: VASP trajectory file, for example, `OUTCAR`.
>   - `cp2k/md`: CP2K trajectory file, for example, `cp2k.out`, `*pos-1.xyz`, `*pos-1.pdb`, `*frac-1.xyz`.
>   - `cp2k/scf`: CP2K SCF output file, for example, `cp2k.out`.
>
>   :::caution
>   CP2K 的输入控制文件中需要设置`PRINT_LEVEL MEDIUM`，标准输出文件从才会存在晶格信息。
>   :::
>
> - **data_path**: str, **required**. The path of the input file.
>
> - **pbc**: array_like, optional. The periodic boundary conditions. Default is None. For example, `[1, 1, 1]` means the system is periodic in x, y, z directions.
>
> - **atom_names**: list, optional. The names of the atoms for <font color='red'>lammps/dump files</font>. Default is None. For example, `['C', 'H', 'O']` means the system contains carbon, hydrogen, and oxygen atoms.
>
> - **index**: int, slice or str, optional. The index of the configuration to read for <font color='red'>multi_image files</font> (Temporarily). Default is `:`, which means all configurations.
>
>   - `index=0`: first configuration
>   - `index=-2`: second to last
>   - `index=':'` or `index=slice(None)`: all
>   - `index='-3:'` or `index=slice(-3, None)`: three last
>   - `index='::2'` or `index=slice(0, None, 2)`: even
>   - `index='1::2'` or `index=slice(1, None, 2)`: odd
>
> - **kwargs**: dict, optional. Additional keyword arguments for reading the input file.
>
>   - **unit**: str, optional. for lammps, the unit of the input file. Default is 'metal'.
>
>   - **style**: str, optional. for lammps, the style of the input file. Default is 'atomic'.
>
>   - **sort_by_id**: bool, optional. for lammps, whether to sort the atoms by id. Default is True.
>
> **Returns:**
> A list of Image objects. Each Image object contains the information of a configuration.
>
> **EXAMPLES:**
>
> ```python
> from pwdata import Config
>
> data_file = "./cp2k.out"
> format = "cp2k/scf"
> config = Config(format, data_file)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**Config.to**</font> <font color='#2ecc71'>_(self, output_path, save_format = None, **kwargs)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L178)</p>
>
> Write all images (>= 1) object to a new file.
>
> **Parameters:**
>
> - **output_path**: str, **required**. The path to save the file.
>
> - **save_format**: str, **required**. The format of the file. Default is None. Supported formats are `pwmat/config`, `pwmat/movement`, `vasp/poscar`, `lammps/lmp`, `extxyz`, `pwmlff/npy`.
>
> - **Kwargs**:
>   - 1. Additional keyword arguments for image or <font color='red'>multi_image</font> format. (e.g. `pwmat/config`, `vasp/poscar`, `lammps/lmp`, `pwmat/movement`, `extxyz`)
>     - **data_name**: str, Save name of the configuration file.
>     * **sort**: bool, **required**. Whether to sort the atoms by atomic number. Default is None.
>     * **wrap**: bool, optional. Whether to wrap the atoms into the simulation box (for pbc). Default is False.
>     * **direct**: bool, **required**. The coordinates of the atoms are in fractional coordinates or cartesian coordinates. (0 0 0) -> (1 1 1)
>   - 2. Additional keyword arguments for <font color='red'>`pwmlff/npy`</font> format.
>     - **data_name**: str, Save name of the dataset folder.
>     * **train_data_path**: str, optional. Save path of the training dataset. Default is "train". ("./PWdata/train")
>     * **valid_data_path**: str, optional. Save path of the validation dataset. Default is "valid". ("./PWdata/valid")
>     * **train_ratio**: float, **required**. The ratio of the training dataset. Default is None. If None is given, the error will be raised.
>     * **random**: bool, optional. Whether to shuffle the raw data and then split the data into the training and validation datasets. Default is True.
>     * **seed**: int, optional. The random seed. Default is 2024.
>     * **retain_raw**: bool, optional. Whether to retain raw data. Default is False.
>
> :::caution
>
> 1. Set sort to False for CP2K, because data from CP2K is already sorted!!!. It will result in a wrong order if sort again.
> 2. `pwmlff/npy` is used to save the label of the dataset. It can be used to train the ML model.
> 3. PWmat are in fractional coordinates only, useless for direct.
> 4. LAMMPS are in cartesian coordinates only, useless for direct.
>    :::
>
> **EXAMPLES:**
>
> ```python
> from pwdata import Config
>
> data_file = "./POSCAR"
> format = "vasp/poscar"
> config = Config.read(format, data_file)
> config.to(output_path = "./", data_name = "lmp.init", save_format = "lammps/lmp", direct = False, sort = True)
> ```
>
> :::tip
> For the same configurations, the `.append()` method can be called to piece them together before calling the `.to()` method.
>
> For example:
> ```python
> from pwdata import Config
> 
> raw_data = ["./OUTCAR0", "./OUTCAR1", "./OUTCAR2"]    # the same atoms...
> format = "vasp/outcar"
> multi_data = Config(format, raw_data[0])
> for data in raw_data[1:]:
>    image_data = Config(format, data)
>    multi_data.append(image_data)
> multi_data.to(output_path = "./PWdata", save_format='pwmlff/npy', train_data_path='train', valid_data_path='valid', train_ratio=0.8, random=True, seed=2024, retain_raw=False)
> ```
> :::

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**build.supercells.make_supercell**</font> <font color='#2ecc71'>_(image_data, supercell_matrix: list, pbc: list = None, wrap=True, tol=1e-5)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/build/supercells.py#L8)</p>
>
> Construct supercell from image_data and supercell_matrix
>
> **Parameters:**
>
> - **image_data**: **required**. Image object or The list of Image objects. Each Image object contains the information of a original configuration.
>
> - **supercell_matrix**: list, **required**. The supercell matrix (3x3). For example, `[[2, 0, 0], [0, 2, 0], [0, 0, 2]]` means the supercell is 2x2x2.
>
> - **pbc**: list, optional. The periodic boundary conditions. Default is None. For example, `[1, 1, 1]` means the system is periodic in x, y, z directions.
>
> - **wrap**: bool, optional. Whether to wrap the atoms into the simulation box (for pbc). Default is True.
>
> - **tol**: float, optional. The tolerance for the fractional coordinates. Default is 1e-5. Small number to prevent slightly negative coordinates from being wrapped.
>
> **Returns:**
> A new Image object. This object contains the information of the supercell.
>
> **EXAMPLES:**
>
> ```python
> from pwdata import Config, make_supercell
>
> data_file = "./atom.config"
> config = Config('pwmat/config', data_file)
> supercell_matrix = [[2, 0, 0], [0, 2, 0], [0, 0, 2]]
> supercell = make_supercell(config, supercell_matrix, pbc=[1, 1, 1])
> supercell.to(output_path = "./", data_name = "atom_2x2x2.config", save_format = "pwmat/config", sort = True)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**pertub.perturbation.perturb_structure**</font> <font color='#2ecc71'>_(image_data, pert_num:int, cell_pert_fraction:float, atom_pert_distance:float)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/pertub/perturbation.py#L22)</p>
>
> Perturb the structure.
>
> **Parameters:**
>
> - **image_data**: Include Image object, The system to be perturbed.
>
> - **pert_num**: int, **required**. The number of perturbed structures.
>
> - **cell_pert_fraction**: float, **required**. A fraction determines how much (relatively) will cell deform.
>
> - **atom_pert_distance**: float, **required**. The distance of the atom perturbation. A distance determines how far atoms will move. The perturbation is a distance in Angstrom.
>
> **Returns:**
> A list of new Image objects. Each Image object contains the information of a perturbed configuration.
>
> **EXAMPLES:**
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
> perturbed_structs.to(output_path = "~/pwdata/test/pertubed/",
>           data_name = "pertubed",
>           save_format = save_format,
>           direct = True,
>           sort = True)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**pertub.scale.scale_cell**</font> <font color='#2ecc71'>_(image_data, scale_factor:float)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/pertub/scale.py#L5)</p>
>
> **Parameters:**
>
> - **image_data**: Include Image object, The system to be scaled.
>
> - **scale_factor**: float, **required**. The scale factor of the cell.
>
> **Returns:**
> A list of new Image objects. Each Image object contains the information of a scaled configuration.
>
> **EXAMPLES:**
>
> ```python
> from pwdata import Config, scale_cell
>
> data_file = "./atom.config"
> config = Config('pwmat/config', data_file)
> scale_factor = 0.95
> scaled_structs = scale_cell(config, scale_factor)
> scaled_structs.to(output_path = "~/test/scaled/",
>           data_name = "scaled",
>           save_format = "pwmat/config",
>           direct = True,
>           sort = True)
> ```