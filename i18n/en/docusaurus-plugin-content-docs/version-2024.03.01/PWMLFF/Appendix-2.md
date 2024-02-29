---
sidebar_position: 5
---

# Appendix Ⅱ: pwdata

PWDATA 是 PWMLFF 的数据预处理工具，可用于提取特征和标签。同时为不同软件间的数据转换提供了便捷的接口。本附录将介绍 PWDATA 的使用方法和数据集的生成。

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
  "format": "movement",
  "trainSetDir": "PWdata",
  "trainDataPath": "train",
  "validDataPath": "valid"
}
```

- `seed`: 随机数种子，用于数据集的划分
- `valid_shuffle`: 是否对全部数据进行随机打乱。例如，存在 10 个 images，`valid_shuffle` 为 `true` 时，将对 10 个 images 进行随机打乱，然后按照 `train_valid_ratio` 的比例划分训练集和验证集。`valid_shuffle` 为 `false` 时，将按照 `train_valid_ratio` 的比例按顺序划分训练集和验证集。默认为 `True`
- `train_valid_ratio`: 训练集和验证集的比例
- `raw_files`: 原始数据的路径
- `format`: 原始数据的格式，用于训练集的生成，所以支持的格式有 `movement`, `outcar`, `cp2k/md`
- `trainSetDir`: 生成的数据集的保存路径
- `trainDataPath`: 生成的训练集的保存路径
- `validDataPath`: 生成的验证集的保存路径

### 作为独立工具使用 (接口调用)

pwdata 也可以作为一个独立的工具使用，通过调用 pwdata 的接口来生成数据集或者进行数据转换。pwdata 的接口调用方式如下：

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**main.Configs.read**</font> <font color='#2ecc71'>_(format: str, data_path: str, pbc = None, atom_names = None, index = -1, **kwargs)_</font> 
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L127)</p>
>
> Read the data from the input file.
>
> **Parameters:**
>
> - **format**: str. The format of the input file. Supported formats are `config`, `poscar`, `dump`, `lmp`, `movement`, `outcar`, `cp2k/md`, `cp2k/scf`
>
>   - `config`: PWmat configuration file, for example, `atom.config`.
>   - `poscar`: VASP configuration file, for example, `POSCAR`.
>   - `dump`: LAMMPS dump file, for example, `dump.lammpstrj`.
>   - `lmp`: LAMMPS configuration file, for example, `in.lmp`.
>   - `movement`: PWmat trajectory file, for example, `MOVEMENT`.
>   - `outcar`: VASP trajectory file, for example, `OUTCAR`.
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
> - **index**: int, slice or str, optional. The index of the configuration to read for <font color='red'>lammps/dump files</font> (Temporarily). Default is -1, the last configuration will be returned by default.
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
>   - **retain_raw**: bool, optional. Whether to retain raw data. Default is False.
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
> from pwdata.main import Configs
>
> data_file = "./cp2k.out"
> format = "cp2k/scf"
> config = Configs.read(format, data_file)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**main.Configs.get**</font> <font color='#2ecc71'>_(image_data: list[Image]):_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L179)</p>
>
> Get and process the data from the input file.
>
> **Parameters:**
>
> - **image_data**: list[Image]. The list of Image objects. Each Image object contains the information of a configuration.
>
> **Returns:**
> A dictionary of the processed data. The keys are the names of the datasets, and the values are the processed data.
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import Configs
>
> data_file = "./traj"
> format = "dump"
> config = Configs.read(format, data_file, atom_names=["Si"], index=-1)    # We only read the last configuration here.
> image_data = Configs.get(config)    # Processed data
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**main.Configs.save**</font> <font color='#2ecc71'>_(image_data_dict: dict, datasets_path = "./PWdata", train_data_path = "train", valid_data_path = "valid", train_ratio = None, random = True, seed = 2024, retain_raw = False, data_name = None)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L185)</p>
>
> Save the data to the datasets.
>
> **Parameters:**
>
> - **image_data_dict**: dict, **required**. The dictionary of the processed data. The keys are the names of the datasets, and the values are the processed data.
>
> - **datasets_path**: str, optional. Save path of the datasets. Default is "./PWdata".
>
> - **train_data_path**: str, optional. Save path of the training dataset. Default is "train". ("./PWdata/train")
>
> - **valid_data_path**: str, optional. Save path of the validation dataset. Default is "valid". ("./PWdata/valid")
>
> - **train_ratio**: float, **required**. The ratio of the training dataset. Default is None. If None is given, the error will be raised.
>
> - **random**: bool, optional. Whether to shuffle the raw data and then split the data into the training and validation datasets. Default is True.
>
> - **seed**: int, optional. The random seed. Default is 2024.
>
> - **retain_raw**: bool, optional. Whether to retain raw data. Default is False.
>
> - **data_name**: str, optional. The name of the dataset. Default is None.
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import Configs
>
> raw_data_path = ["./OUT.MLMD0", "./OUT.MLMD1", "./OUT.MLMD2"]
> format = "movement"
> multi_data = []
> for data_path in raw_data_path:
>     config = Configs.read(format, data_path)
>     multi_data += config        # Concatenate the data because these datas are from the same atoms' configurations.
> image_data = Configs.get(multi_data)
> Configs.save(image_data, datasets_path = "./alldata", train_data_path = "train", valid_data_path = "valid", train_ratio = 0.8, random = True)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**image.Image.to**</font> <font color='#2ecc71'>_(self, file_path, file_name, file_format, direct, sort, wrap = False)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/image.py#L71)</p>
>
> Save the data to the configuration file.
>
> **Parameters:**
>
> - **file_path**: str, **required**. Save path of the configuration file.
>
> - **file_name**: str, **required**. Save name of the configuration file.
>
> - **file_format**: str, **required**. The format of the configuration file. Supported formats are `config`, `poscar`, `lammps` temporarily.
>
> - **direct**: bool, **required**. The coordinates of the atoms are in fractional coordinates or cartesian coordinates. (0 0 0) -> (1 1 1)
>
> - **sort**: bool, **required**. Whether to sort the atoms by atomic number. Default is None.
>
> - **wrap**: bool, optional. Whether to wrap the atoms into the simulation box (for pbc). Default is False.
>
> :::caution
>
> 1. Set sort to False for CP2K, because data from CP2K is already sorted!!!. It will result in a wrong order if sort again.
> 2. PWmat are in fractional coordinates only, no use for direct.
> 3. LAMMPS are in cartesian coordinates only, no use for direct.
>    :::
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import Configs
>
> data_file = "./POSCAR"
> config = Configs.read('poscar', data_file)
> config.to(file_path = "./", file_name = "lmp.init", file_format = "lammps", direct = False, sort = True)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**build.supercells.make_supercell**</font> <font color='#2ecc71'>_(image_data: Image, supercell_matrix: list, pbc: list = None, wrap=True, tol=1e-5)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/build/supercells.py#L8)</p>
>
> Construct supercell from image_data and supercell_matrix
>
> **Parameters:**
>
> - **image_data**: Image, **required**. The list of Image objects. Each Image object contains the information of a original configuration.
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
> from pwdata.main import Configs
> from pwdata.build.supercells import make_supercell
>
> data_file = "./atom.config"
> config = Configs.read('config', data_file)
> supercell_matrix = [[2, 0, 0], [0, 2, 0], [0, 0, 2]]
> supercell = make_supercell(config, supercell_matrix, pbc=[1, 1, 1])
> supercell.to(file_path = "./", file_name = "atom_2x2x2.config", file_format = "config", direct = True, sort = True)
> ```
>
> We can also use the <font color='black'>**main.SUPERCELL**</font> <font color='#2ecc71'>_(self, config: Image, output_path = "./", output_file = "supercell", supercell_matrix = [[1, 0, 0], [0, 1, 0], [0, 0, 1]], direct = True, sort = True, pbc = None, save_format: str = None)_</font> to construct supercell from image_data and supercell_matrix.
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L314)
>
> **Parameters:**
>
> - **config**: Image, **required**. The list of Image objects. Each Image object contains the information of a original configuration.
>
> - **output_path**: str, optional. Save path of the supercell file. Default is "./".
>
> - **output_file**: str, optional. Save name of the supercell file. Default is "supercell".
>
> - **supercell_matrix**: list, optional. The supercell matrix (3x3). For example, `[[2, 0, 0], [0, 2, 0], [0, 0, 2]]` means the supercell is 2x2x2. Default is [[1, 0, 0], [0, 1, 0], [0, 0, 1]].
>
> - **direct**: bool, optional. The coordinates of the atoms are in fractional coordinates or cartesian coordinates. (0 0 0) -> (1 1 1). Default is True.
>
> - **sort**: bool, optional. Whether to sort the atoms by atomic number. Default is True.
>
> - **pbc**: three bool, Periodic boundary conditions flags. Examples: [True, True, False] or [1, 1, 0]. True (1) means periodic, False (0) means non-periodic.
>
> - **save_format**: str, **required**. The format of the supercell file. Supported formats are `config`, `poscar`, `lammps` temporarily. Default is None.
>
> **Returns:**
> None
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import Configs, SUPERCELL
>
> data_file = "./atom.config"
> config = Configs.read('config', data_file)
> SUPERCELL_MATRIX = [[2, 0, 0], [0, 2, 0], [0, 0, 2]]
> pbc = [1, 1, 1]
> SUPERCELL(config, output_path = "./", output_file = "atom_2x2x2.config", supercell_matrix = SUPERCELL_MATRIX, direct = True, pbc = pbc, save_format = "config")
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**pertub.perturbation.BatchPerturbStructure.batch_perturb**</font> <font color='#2ecc71'>_(raw_obj:Image, pert_num:int, cell_pert_fraction:float, atom_pert_distance:float)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/pertub/perturbation.py#L100)</p>
>
> Perturb the structure.
>
> **Parameters:**
>
> - **raw_obj**: Image, **required**. The list of Image objects. Each Image object contains the information of a original configuration.
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
> from pwdata.main import Configs
> from pwdata.pertub.perturbation import BatchPerturbStructure
>
> data_file = "./atom.config"
> config = Configs.read('config', data_file)
> pert_num = 50
> cell_pert_fraction = 0.03
> atom_pert_distance = 0.01
> perturbed_structs = BatchPerturbStructure.batch_perturb(config, pert_num, cell_pert_fraction, atom_pert_distance)
> ```
>
> We can also use the <font color='black'>**main.PerturbStructure**</font> <font color='#2ecc71'>_(self, perturbed_file: Image, pert_num = 50, cell_pert_fraction = 0.03, atom_pert_distance = 0.01, output_path = "./", direct = True, sort = None, pbc = None, save_format: str = None)_</font> to perturb the structures.
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L347)
>
> **Parameters:**
>
> - **perturbed_file**: Image, **required**. The list of Image objects. Each Image object contains the information of a original configuration.
>
> - **pert_num**: int, optional. The number of perturbed structures. Default is 50.
>
> - **cell_pert_fraction**: float, optional. A fraction determines how much (relatively) will cell deform. Default is 0.03.
>
> - **atom_pert_distance**: float, optional. The distance of the atom perturbation. A distance determines how far atoms will move. The perturbation is a distance in Angstrom. Default is 0.01.
>
> - **output_path**: str, optional. Save path of the perturbed file. Default is "./".
>
> - **direct**: bool, optional. The coordinates of the atoms are in fractional coordinates or cartesian coordinates. (0 0 0) -> (1 1 1). Default is True.
>
> - **sort**: bool, optional. Whether to sort the atoms by atomic number. Default is None.
>
> - **pbc**: three bool, Periodic boundary conditions flags. Examples: [True, True, False] or [1, 1, 0]. True (1) means periodic, False (0) means non-periodic.
>
> - **save_format**: str, **required**. The format of the perturbed file. Supported formats are `config`, `poscar`, `lammps` temporarily. Default is None.
>
> **Returns:**
> None
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import Configs, PerturbStructure
>
> data_file = "./atom.config"
> PERT_NUM = 50
> CELL_PERT_FRACTION = 0.03
> ATOM_PERT_DISTANCE = 0.01
> config = Configs.read('config', data_file)
> PerturbStructure(config, pert_num = PERT_NUM, cell_pert_fraction = CELL_PERT_FRACTION, atom_pert_distance = ATOM_PERT_DISTANCE, output_path = "./", save_format = "config")
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**pertub.perturbation.BatchScaleCell.batch_scale**</font> <font color='#2ecc71'>_(raw_obj:Image, scale_factor:float)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/pertub/scale.py#L32)</p>
>
> **Parameters:**
>
> - **raw_obj**: Image, **required**. The list of Image objects. Each Image object contains the information of a original configuration.
>
> - **scale_factor**: float, **required**. The scale factor of the cell.
>
> **Returns:**
> A list of new Image objects. Each Image object contains the information of a scaled configuration.
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import Configs
> from pwdata.pertub.scale import BatchScaleCell
>
> data_file = "./atom.config"
> config = Configs.read('config', data_file)
> scale_factor = 0.95
> scaled_structs = BatchScaleCell.batch_scale(config, scale_factor)
> ```
>
> We can also use the <font color='black'>**main.ScaleCell**</font> <font color='#2ecc71'>_(self, scaled_file: Image, scale_factor = 1.0, output_path = "./", direct = True, sort = None, pbc = None, save_format: str = None)_</font> to scale the cell.
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L380)
>
> **Parameters:**
>
> - **scaled_file**: Image, **required**. The list of Image objects. Each Image object contains the information of a original configuration.
>
> - **scale_factor**: float, optional. The scale factor of the cell. Default is 1.0.
>
> - **output_path**: str, optional. Save path of the scaled file. Default is "./".
>
> - **direct**: bool, optional. The coordinates of the atoms are in fractional coordinates or cartesian coordinates. (0 0 0) -> (1 1 1). Default is True.
>
> - **sort**: bool, optional. Whether to sort the atoms by atomic number. Default is None.
>
> - **pbc**: three bool, Periodic boundary conditions flags. Examples: [True, True, False] or [1, 1, 0]. True (1) means periodic, False (0) means non-periodic.
>
> - **save_format**: str, **required**. The format of the scaled file. Supported formats are `config`, `poscar`, `lammps` temporarily. Default is None.
>
> **Returns:**
> None
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import Configs, ScaleCell
>
> data_file = "./atom.config"
> SCALE_FACTOR = 0.95
> config = Configs.read('config', data_file)
> ScaleCell(config, scale_factor = SCALE_FACTOR, output_path = "./", save_format = "config")
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**main.OUTCAR2MOVEMENT**</font> <font color='#2ecc71'>_(self, outcar_file, output_path, output_file)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L277)</p>
>
> Convert OUTCAR file to MOVEMENT file.
>
> **Parameters:**
>
> - **outcar_file**: str, **required**. The path of the OUTCAR file.
>
> - **output_path**: str, **required**. Save path of the MOVEMENT file.
>
> - **output_file**: str, **required**. Save name of the MOVEMENT file.
>
> **Returns:**
> None
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import OUTCAR2MOVEMENT
>
> outcar_file = "./OUTCAR"
> output_path = "./"
> output_file = "MOVEMENT"
> OUTCAR2MOVEMENT(outcar_file, output_path, output_file)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**main.MOVEMENT2XYZ**</font> <font color='#2ecc71'>_(self, movement_file, output_path, output_file)_</font>
> [source](https://github.com/LonxunQuantum/pwdata/blob/master/main.py#L296)</p>
>
> Convert MOVEMENT file to XYZ file.
>
> **Parameters:**
>
> - **movement_file**: str, **required**. The path of the MOVEMENT file.
>
> - **output_path**: str, **required**. Save path of the XYZ file.
>
> - **output_file**: str, **required**. Save name of the XYZ file.
>
> **Returns:**
> None
>
> **EXAMPLES:**
>
> ```python
> from pwdata.main import MOVEMENT2XYZ
>
> movement_file = "./MOVEMENT"
> output_path = "./"
> output_file = "1.xyz"
> MOVEMENT2XYZ(movement_file, output_path, output_file)
> ```

---

## 目前支持的数据格式

| Software | file             | multi-Image | label | format     |
| -------- | ---------------- | ----------- | ----- | ---------- |
| PWmat    | MOVEMENT         | True        | True  | 'movement' |
| PWmat    | OUT.MLMD         | False       | True  | 'movement' |
| PWmat    | atom.config      | False       | False | 'config    |
| VASP     | OUTCAR           | True        | True  | 'outcar'   |
| VASP     | poscar           | False       | False | 'poscar'   |
| LAMMPS   | lmp.init         | False       | False | 'lmp'      |
| LAMMPS   | dump             | True        | False | 'dump'     |
| CP2K     | stdout, xyz, pdb | True        | True  | 'cp2k/md'  |
| CP2K     | stdout           | False       | True  | 'cp2k/scf' |
