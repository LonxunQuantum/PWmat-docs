---
sidebar_position: 6
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
| PWMLFF   | \*.npy           | True        | True  | 'pwmlff/npy'     |

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
> [源码](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L110)</p>
>
> 从输入文件中读取数据。
>
> **参数:**
>
> - **format**: 字符串. 输入文件的格式。支持的格式有：`pwmat/config`, `vasp/poscar`, `lammps/dump`, `lammps/lmp`, `pwmat/movement`, `vasp/outcar`, `cp2k/md`, `cp2k/scf`.
>
>   - `pwmat/config`: PWmat 结构文件，例如 `atom.config`.
>   - `pwmat/movement`: PWmat 分子动力学轨迹文件，例如 `MOVEMENT`.
>   - `lammps/dump`: LAMMPS dump 文件, 例如 `dump.lammptraj`.
>   - `lammps/lmp`: LAMMPS 结构文件，例如 `in.lmp`.
>   - `vasp/poscar`: VASP 结构文件，例如 `POSCAR`.
>   - `vasp/outcar`: VASP 分子动力学轨迹文件，例如 `OUTCAR`.
>   - `cp2k/md`: CP2K 标准输出文件，原子位置文件及对应的原子力文件，例如 `cp2k.out`, `*pos-1.xyz`, `*pos-1.pdb`, `*frac-1.xyz`.
>   - `cp2k/scf`: CP2K 标准输出文件，例如 `cp2k.out`.
>
>   :::caution
>   CP2K 的输入控制文件中需要设置`PRINT_LEVEL MEDIUM`，标准输出文件从才会存在晶格信息。
>   :::
>
> - **data_path**: 字符串, **必选**. The path of the input file.
>
> - **pbc**: 列表, 可选. 周期性边界条件。默认为 None。例如，`[1, 1, 1]` 表示系统在 x, y, z 方向上是周期性的。
>
> - **atom_names**: 列表, 可选. 用于 <font color='red'>lammps/dump</font> 文件的原子名称。默认为 None。例如，`['C', 'H', 'O']` 表示系统包含碳、氢和氧原子。
>
> - **index**: 整数, 切片 或 字符串, 可选. 用于读取包含多个结构的文件时，可以通过 index 参数指定读取的结构。默认为 `:`，表示读取所有结构。
>
>   - `index=0`: 第一个结构
>   - `index=-2`: 倒数第二个结构
>   - `index=':'` 或 `index=slice(None)`: 所有结构
>   - `index='-3:'` 或 `index=slice(-3, None)`: 倒数第三个到最后一个结构
>   - `index='::2'` 或 `index=slice(0, None, 2)`: 偶数个数的结构
>   - `index='1::2'` 或 `index=slice(1, None, 2)`: 奇数个数的结构
>
> - **kwargs**: 键值对（字典）, 可选. 其他关键字参数用于读取输入文件。
>
>   - **unit**: 字符串, 可选. 对于 LAMMPS 文件，输入文件的单位。默认为 'metal'。
>
>   - **style**: 字符串, 可选. 对于 LAMMPS 文件，用于 lammps 模拟种原子相关联的每个原子的属性。默认为 'atomic'。详情见 [LAMMPS atom_style](https://docs.lammps.org/atom_style.html)。
>
>   - **sort_by_id**: 布尔值, 可选. 对于 LAMMPS 文件，是否按照 id 排序原子。默认为 True。
>
> **返回:**
> 返回一个 Image 对象的列表。每个 Image 对象包含一个结构的一些信息。
>
> **例子:**
>
> ```python
> from pwdata import Config
>
> data_file = "./cp2k.out"
> format = "cp2k/scf"
> config = Config(format, data_file)
> ```

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**Config.to**</font> <font color='#2ecc71'>_(self, output_path, save_format = None, **kwargs)_</font>
> [源码](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L178)</p>
>
> 根据读入的文件格式，将数据保存为指定格式的文件。
>
> **参数:**
>
> - **output_path**: 字符串, **必选**. 保存文件的路径。
>
> - **save_format**: 字符串, **必选**. 保存文件的格式。默认为 None。支持的格式有 `pwmat/config`, `pwmat/movement`, `vasp/poscar`, `lammps/lmp`, `extxyz`, `pwmlff/npy`.
>
> - **Kwargs**:
>   - 1. 其他用于保存文件的关键字参数。用于以下格式的文件：`pwmat/config`, `vasp/poscar`, `lammps/lmp`, `extxyz`。
>     - **data_name**: 字符串, **必选**. 结构文件的保存名称。
>     * **sort**: bool, **可选**. 是否按照原子序数排序。默认为 None。
>     * **wrap**: bool, 可选. 是否将原子映射到模拟盒中。默认为 False。
>     * **direct**: bool, **必选**. 原子坐标是分数坐标还是笛卡尔坐标。(0 0 0) -> (1 1 1)
>   - 2. 用于保存标签文件的关键字参数。用于 `pwmlff/npy` 格式的文件。
>     - **data_name**: 字符串, **必选**. 数据集文件夹的保存名称。
>     * **train_data_path**: 字符串, 可选. 训练集的保存路径。默认为 "train"。（"./PWdata/train"）
>     * **valid_data_path**: 字符串, 可选. 验证集的保存路径。默认为 "valid"。（"./PWdata/valid"）
>     * **train_ratio**: float, **必选**. 训练集的比例。默认为 None。如果给定 None，将会报错。
>     * **random**: bool, 可选. 是否对原始数据进行随机打乱，然后将数据划分为训练集和验证集。默认为 True。
>     * **seed**: int, 可选. 随机数种子。默认为 2024。
>     * **retain_raw**: bool, 可选. 是否保留原始数据。默认为 False。
>
> :::caution
>
> 1. 输入为 `CP2K` 的数据时，`sort` 参数需要设置为 `False`，因为 CP2K 的数据已经是按照原子序数排序的，再次排序会导致数据顺序错误。
> 2. `pwmlff/npy` 用于保存数据集的标签。它可以用于训练机器学习模型。
> 3. PWmat 结构文件只能保存为分数坐标，不能保存为笛卡尔坐标，因此 `direct` 参数无效。
> 4. LAMMPS 结构文件只能保存为笛卡尔坐标，不能保存为分数坐标，因此 `direct` 参数无效。
>    :::
>
> **例子:**
>
> ```python
> from pwdata import Config
>
> data_file = "./POSCAR"
> format = "vasp/poscar"
> config = Config(format, data_file)
> config.to(output_path = "./", data_name = "lmp.init", save_format = "lammps/lmp", direct = False, sort = True)
> ```
>
> :::tip
> 对于具有相同结构的多个配置，如果有需要的话，可以在调用 `.to()` 方法之前调用 `.append()` 方法将它们拼接在一起。
>
> 例如:
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
> multi_data.to(output_path = "./PWdata", save_format='pwmlff/npy', train_data_path='train', valid_data_path='valid', train_ratio=0.8, random=True, seed=2024, retain_raw=False)
> ```
>
> :::

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**build.supercells.make_supercell**</font> <font color='#2ecc71'>_(image_data, supercell_matrix: list, pbc: list = None, wrap=True, tol=1e-5)_</font>
> [源码](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/build/supercells.py#L8)</p>
>
> 根据输入的原始结构和超晶胞矩阵构建超晶胞。
>
> **参数:**
>
> - **image_data**: **必选**. Image 对象，包含原始结构的一些信息。
>
> - **supercell_matrix**: 列表, **必选**. 超晶胞矩阵 (3x3)。例如，`[[2, 0, 0], [0, 2, 0], [0, 0, 2]]` 表示超晶胞是 2x2x2 的。
>
> - **pbc**: 列表, 可选. 周期性边界条件。默认为 None。例如，`[1, 1, 1]` 表示系统在 x, y, z 方向上是周期性的。
>
> - **wrap**: 布尔值, 可选. 是否将原子映射到模拟盒中（对于周期性边界条件）。默认为 True。
>
> - **tol**: 浮点数, 可选. 分数坐标的容差。默认为 1e-5。防止轻微负坐标被映射到模拟盒中。
>
> **返回:**
> 一个新的 Image 对象(的列表)。每个对象包含超晶胞的一些信息。
>
> **例子:**
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
> [源码](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/pertub/perturbation.py#L22)</p>
>
> Perturb the structure. 微扰结构。
>
> **参数:**
>
> - **image_data**: **必选**. 需要被微扰的 Image 对象，包含原始结构的一些信息。
>
> - **pert_num**: 整数, **必选**. 要生成的微扰结构的数量。
>
> - **cell_pert_fraction**: 浮点数, **必选**. 决定晶胞变形的程度。例如，`0.03` 表示晶胞变形的程度是相对原始晶胞的 3%。
>
> - **atom_pert_distance**: 浮点数, **必选**. 原子微扰的距离，决定原子相对原始位置的移动距离。微扰是以埃为单位的距离。例如，`0.01` 表示原子的移动距离是 0.01 埃。
>
> **返回:**
> 一个新的 Image 对象的列表。每个 Image 对象包含一个微扰结构的一些信息。
>
> **例子:**
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
> [源码](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/pertub/scale.py#L5)</p>
>
> **参数:**
>
> - **image_data**: **必选**. 需要被缩放的 Image 对象，包含原始结构的一些信息。
>
> - **scale_factor**: 浮点数, **必选**. 晶胞的缩放因子。
>
> **返回:**
> 一个新的 Image 对象(的列表)。每个 Image 对象包含一个缩放后的结构的一些信息。
>
> **例子:**
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
