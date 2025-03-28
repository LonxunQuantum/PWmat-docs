---
sidebar_position: 6
title: pwdata 结构转换工具
---
# pwdata

pwdata 是 MatPL 的数据预处理工具，包括如下功能：

1. `atom.config(PWmat)`、`POSCAR(VASP)`、`lmp.init(Lammps)`、`cp2k.init(CP2K)` 之间的文件互转；

2. 对这些结构做阔胞、晶格缩放、晶格或原子位置微扰；

3. 提取各种轨迹文件 `MOVEMENT(PWmat)`、`OUTCAR(VASP)`、`lammps dump file(Lammps)`、`cp2k md file(CP2K)` 或常用训练数据` pwmlff/npy`、`extxyz`、`deepmd/npy`、`deepmd/raw`、[`meta OMAT24 开源数据集`](https://huggingface.co/datasets/fairchem/OMAT24) 之后转换为 `pwmlff/npy` 或者 `extxyz` 格式文件。
对于meta数据集，增加了cpu并行和查询操作，以快速从超过一亿结构的数据库中查找自己想要的结构。

## 支持的数据类型

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

## 安装方式
pip命令安装：
```bash
pip install pwdata

#安装pwdata,如果已安装，则升级到最新版本
pip install pwdata --upgrade

# 列出所有可安装版本 
pip index versions pwdata
# 输出结果示例：
# pwdata (0.3.2)
# Available versions: 0.3.2, 0.3.1, 0.3.0, 0.2.16, 0.2.15
#   INSTALLED: 0.3.2
#   LATEST:    0.3.2
# 安装指定版本
pip install pwdata==n.m.o
```

# pwdata 命令行调用方式
pwdata支持命令行操作以及源码接入两种方式。

## 一、命令行操作

命令列表：
pwdata 命令列表如下，您可以通过 '-h' 选项获取该命令列表的详细解释以及所有支持参数。这里 `pwdata -h` 用于输出所有可用命令，以及该命令的使用例子。

```bash
pwdata -h
pwdata convert_config or cvt_config -h
pwdata convert_configs or cvt_configs -h
pwdata scale_cell or scale -h
pwdata super_cell or super -h
pwdata perturb -h
pwdata count -h
```

下面对命令做详细说明
### 1. 结构互转 convert_config

该命令用于各种结构之间的互转，您可以使用 `convert_config` 或者它的缩写 `cvt_config`
参数如下所示
```bash
pwdata convert_config [-h] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]

```

#### `-h`
输出帮助信息，将列出命令的所有可用参数及其解释

#### `-i`
必选参数，输入文件的文件路径，支持绝对路径或者相对路径

#### `-f`
可选参数，输入文件的格式，如不指定将根据输入文件自动推测输入格式，支持的格式有 ['pwmat/config','vasp/poscar', 'lammps/lmp', 'cp2k/scf']

#### `-o`
可选参数，输出文件的格式，支持的格式有['pwmat/config','vasp/poscar', 'lammps/lmp']，如果未指定该参数，将会使用输入结构的格式，此时如果输入的文件格式是`cp2k/scf`，那么将使用`pwmat/config`格式

#### `-s`
输出文件的名称，与 `-o` 配合使用。如果未指定，对于 `pwmat/config` 格式将使用 `atom.config` 作为文件名，对于 `vasp/poscar` 格式使用 `POSCAR`,对于 `lammps/lmp` 格式使用 `lammps.lmp` 作为文件名

#### `-c`
是否使用分数坐标，如果指定了 `-c` 参数，在保存结构时将使用`笛卡尔坐标`，否则使用`分数坐标`。注意，`pwmat/config` 只支持分数坐标，此时该参数将失效

#### `-t`
输入结构的原子类型，该参数用于当输入结构是 `lammps/lmp`或 `lammps/dump` 格式时指定结构的原子类型，可以是元素名称或者原子编号，顺序需要与输入结构中保持一致。对于其他格式的输入文件，该参数失效

我们在源码的根目录下提供了 [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples)，您可以下载后使用这些测试例子：

```bash
# convert_config 案例：atom.config 转 poscar
# 执行完毕后将在examples/test_workdir目录下生成结构文件 cvtcnf_atom.POSCAR
pwdata cvt_config -i examples/pwmat_data/LiGePS_atom.config -s examples/test_workdir/cvtcnf_atom.POSCAR -o vasp/poscar
```

### 2. 训练数据提取 convert_configs
提取各种轨迹文件 `MOVEMENT(PWmat)`、`OUTCAR(VASP)`、`lammps dump file(Lammps)`、`cp2k md file(CP2K)` 或常用训练数据` pwmlff/npy`、`extxyz`、`deepmd/npy`、`deepmd/raw`、[`meta OMAT24 开源数据集`](https://huggingface.co/datasets/fairchem/OMAT24)为 `pwmlff/npy` 或者 `extxyz` 格式文件。您可以使用 `convert_configs` 或者它的缩写 `cvt_configs`.

参数如下所示
```bash
pwdata [-h] -i INPUT [INPUT ...] [-f INPUT_FORMAT] [-s SAVEPATH] [-o OUTPUT_FORMAT] [-r]
              [-m MERGE] [-g GAP] [-q QUERY] [-n CPU_NUMS] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h` 

输出帮助信息，将列出命令的所有可用参数及其解释

#### `-i`
必选参数，输入文件的文件路径，支持绝对路径或者相对路径。该参数为列表形式，支持输入多个文件路径或者目录。pwdata对` pwmlff/npy`、`extxyz`、`deepmd/npy`、`deepmd/raw`、`meta OMAT24 开源数据集`实现了目录自动查询，您只需要指定数据源根目录即可。

例如对于[examples/pwmlff_data/LiSiC](https://github.com/LonxunQuantum/pwdata/tree/master/examples/pwmlff_data/LiSiC)，该目录下存在'C2, C448, C448Li75, C64Si32, Li1Si24, Li3Si8, Li8, Li88Si20, Si1, Si217'这些子目录, 输入`'-i examples/pwmlff_data'` 即可。

此外，如果您的文件或者目录较多（如meta数据库这类非常多的子文件），您也可以将这些路径写入一个json文件中，如下所示，命令中指定`-i jsonfile `即可。
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
可选参数，输入文件的格式，pwdata实现了对输入数据的格式自动推理，不需要显式指定输入格式。支持的格式有 ['pwmat/movement', 'vasp/outcar', 'lammps/dump', 'cp2k/md', 'pwmlff/npy', 'deepmd/npy', 'deepmd/raw', 'extxyz', 'meta']

#### `-o`
可选参数，输出文件的格式，支持的格式有['pwmlff/npy','extxyz']，默认格式为`'pwmlff/npy'`

#### `-s`
可选参数，输出文件的目录，如不指定，将使用当前目录

<!-- #### `-c`
是否使用分数坐标，如果指定了 `-c` 参数，在保存结构时将使用`笛卡尔坐标`，否则使用`分数坐标`。注意，对于`pwmlff/npy`格式数据固定使用分数坐标；对于`extxyz`格式固定使用笛卡尔坐标 -->

#### `-m`
可选参数，int类型，该参数仅用于输出文件格式为extxyz，设置 `'-m 1'` 所有结构会保存到一个xyz文件中，默认保存到一个xyz文件中。设置 `'-m 0'` 将按照元素类型保存到不同的xyz文件中，

#### `-g`
可选参数，int类型，该参数用于提取轨迹文件时，指定每隔多少步取一帧结构。默认值为1

#### `-q`
可选参数，str类型，该参数值在输入类型为`meta`时生效，用于查询数据库操作，详细的使用参考 [meta查询演示](#convert_configs-meta-查询例子)

#### `-n`
可选参数，int类型，该参数在输入类型为`meta`时生效，用于设置并行查询数据库时使用的CPU核数，默认使用单核

#### `-t`
如果输入格式是 `lammps/lmp`或 `lammps/dump` 格式，该参数用于指定结构的原子类型，可以是元素名称或者原子编号，顺序需要与输入结构中保持一致

如果输入格式是`meta`，该该参数用于查找所有`只存在这些元素类型`的结构。

### convert_configs 案例
我们在源码的根目录下提供了 [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples)，您可以下载后使用这些测试例子：

例1. 将目录 examples/pwmlff_data/LiSiC 下的所有 pwmlff/npy 格式数据提取为 xyz格式，其中训练集占80%，测试集占20%，执行完毕后，在examples/test_workdir/0_1_configs_extxyz目录下会产生train.xyz 和 valid.xyz两个文件。
```bash
pwdata convert_configs -i examples/pwmlff_data/LiSiC -s examples/test_workdir/0_1_configs_extxyz -o extxyz -p 0.8
```

例2. 将PWmat 轨迹文件 50_LiGePS_movement 和 lisi_50_movement 每隔5步提取一帧，随机划分80%结构做为训练集20%作为测试集，存在examples/test_workdir/3_1_configs_extxyz目录下
```bash
pwdata convert_configs -i examples/pwmat_data/50_LiGePS_movement examples/pwmat_data/lisi_50_movement -s examples/test_workdir/3_1_configs_extxyz -o extxyz -p 0.8 -r -g 5
```

例3. 将examples/deepmd_data/alloy目录下的所有 deepmd/npy 格式文件提取为pwmlff/npy格式，不划分测试集
```bash
pwdata convert_configs -i examples/deepmd_data/alloy -s ./test_workdir/7_0_configs_PWdata
```

例4. 将 examples/xyz_data 目录下的所有后缀为 xyz 的文件提取为pwmlff/npy格式，随机划分80%和20%作为训练和测试集，保存在examples/test_workdir/5_0_configs_PWdata目录
```bash
pwdata convert_configs -i examples/xyz_data -s examples/test_workdir/5_0_configs_PWdata -p 0.8 -r -g 1
```

例5.在examples/meta_data/alex_val 目录下所有后缀为.aselmdb的 meta数据库中，查询元素类型为Pt和Ge的结构,将查询到的所有结构保存到./test_workdir/10_1_configs_extxyz目
录下不划分测试集
```bash
pwdata convert_configs -i examples/meta_data/alex_val -s ./test_workdir/10_1_configs_extxyz -t Pt Ge
```

例6. 在meta_data['data_path']中列出的所有目录或者文件下的所有后缀为.aselmdb的 meta数据库中，查询元素类型为Pt和Ge的结构,把查询到的所有结构保存到./test_workdir/
10_1_configs_extxyz目录下，不划分测试集
```bash
pwdata convert_configs -i examples/meta_data.json -s ./test_workdir/10_1_configs_extxyz -o extxyz -t Pt Ge
```

### convert_configs meta 查询例子
例1. 查询`只包含` `Pt`和`Ge` 两种元素的结构，并将查询结果输出到为xyz格式。执行完成后将会在examples/test_workdir/10_1_configs_extxyz目录下生成一个train.xyz和valid.xyz两个文件

```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -t Pt Ge
```

例2. 使用`-q 参数`查询，查询包含了`Cu`元素的所有结构
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q Cu
```

例3. 使用`-q 参数`查询，查询结构中`H`原子数目少于3个的所有结构
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q H<3
```

例4. 使用`-q 参数`查询，查询结构中，包含`Cu`原子并且`H`原子数目少于3个的所有结构
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q Cu,H<3
```

例5. 使用`-q 参数`查询，查询结构中，至少包含2个`H`原子且至少包含1个`O`原子的所有结构
```bash
pwdata convert_configs -i examples/meta_data/alex_val/alex_go_aao_001.aselmdb examples/meta_data/alex_val/alex_go_aao_002.aselmdb -s examples/test_workdir/10_1_configs_extxyz -o extxyz -p 0.8 -r -q H2O 
```

一些其他查询语句

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
pwdata 使用了输入格式的自动推测，以及数据目录自动查询，指定` pwmlff/npy`、`extxyz`、`deepmd/npy`、`deepmd/raw`、`meta OMAT24 开源数据集` 这些数据源的根目录即可自动读取。

注意：pwdata在自动查找数据源时，如您未显式指定数据源格式，pwdata会将输入目录下的所有可用数据源都作为输入数据。
:::

### 3. 晶格缩放 scale_cell
该命令用于对结构的晶格做缩放，您可以使用 `scale_cell` 或者它的缩写 `scale`
参数如下所示

```bash
pwdata scale_cell [-h] -r SCALE_FACTOR [SCALE_FACTOR ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
输出帮助信息，将列出命令的所有可用参数及其解释


#### `-r`
必选参数，晶格的缩放因子，$Lattic_{new}= factor * Lattice_{old}$， factor 取值范围 (0.0, 1.0)，浮点类型的列表，用空格隔开。例如 `'-r 0.97 0.98 0.99'` 表示对输入结构分别做0.97、0.98、0.99的晶格缩放，必选参数


#### `-i`
必选参数，输入文件的文件路径，支持绝对路径或者相对路径，必选参数


#### `-f`
可选参数，如不显式指定，将根据输入文件自动推测。输入文件的格式，支持的格式有 ['pwmat/config','vasp/poscar', 'lammps/lmp', 'cp2k/scf']，必选参数

#### `-o`
可选参数，输出文件的格式，支持的格式有['pwmat/config','vasp/poscar', 'lammps/lmp']，如果未指定该参数，将会使用输入结构的格式，此时如果输入的文件格式是`cp2k/scf`，那么将使用`pwmat/config`格式

#### `-s`
可选参数，输出文件的名称，与 `-o` 配合使用，并将缩放因子作为前缀。如果未指定，对于 `pwmat/config` 格式将使用 `atom.config` 作为文件名，对于 `vasp/poscar` 格式使用 `POSCAR` ,对于 `lammps/lmp` 格式使用 `lammps.lmp` 作为文件名。例如 `'-o pwmat/config -s atom.config -r 0.99'` 缩放后的新文件名称为 `'0.99_atom.config'`


#### `-c`
可选参数，是否使用分数坐标，如果指定了 `-c` 参数，在保存结构时将使用`笛卡尔坐标`，否则使用`分数坐标`。注意，PWmat只支持分数坐标，此时该参数将失效


#### `-t`
输入结构的原子类型，该参数用于当输入结构是 `lammps/lmp`或 `lammps/dump` 格式时指定结构的原子类型，可以是元素名称或者原子编号，顺序需要与输入结构中保持一致。对于其他格式的输入文件，该参数失效

我们在源码的根目录下提供了 [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples)，您可以下载后使用这些测试例子：

```bash
# scale_cell 命令例子
pwdata scale_cell -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

#或命令的缩写
pwdata scale -r 0.98 0.99 0.97 0.95 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/scale_atom.config -o pwmat/config

#执行完毕后将在examples/test_workdir目录下生成4个缩放后的文件，分被名为 0.98_scale_atom.config、0.99_scale_atom.config、0.97_scale_atom.config、0.95_scale_atom.config
```

### 4. 阔胞 super_cell
该命令用于对结构的晶格做缩放，您可以使用 `super_cell` 或者它的缩写 `super`。
参数如下所示

```bash
pwdata super_cell [-h] -m SUPERCELL_MATRIX [SUPERCELL_MATRIX ...] -i INPUT -f INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-p PERIODICITY [PERIODICITY ...]] [-l TOLERANCE] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
输出帮助信息，将列出命令的所有可用参数及其解释

#### `-m`
必选参数，超晶胞矩阵 (3x3)，3个或者9个值，例如 `'-m 2 0 0 0 2 0 0 0 2'` 或者 `'-m 2 2 2'` 表示超晶胞是 `2x2x2` 的，必选参数

#### `-i`
必选参数，输入文件的文件路径，支持绝对路径或者相对路径，必选参数


#### `-f`
可选参数，如不显式指定，将根据输入文件自动推测。输入文件的格式，支持的格式有 ['pwmat/config','vasp/poscar', 'lammps/lmp', 'cp2k/scf']，必选参数

#### `-o`
可选参数，输出文件的格式，支持的格式有['pwmat/config','vasp/poscar', 'lammps/lmp']，如果未指定该参数，将会使用输入结构的格式，此时如果输入的文件格式是`cp2k/scf`，那么将使用`pwmat/config`格式

#### `-s`
可选参数，输出文件的名称，与 `-o` 配合使用。如果未指定，对于 `pwmat/config` 格式将使用 `atom.config` 作为文件名，对于 `vasp/poscar` 格式使用 `POSCAR` ,对于 `lammps/lmp` 格式使用 `lammps.lmp` 作为文件名。例如 `'-o pwmat/config -s super_atom.config'` 缩放后的新文件名称为 `'super_atom.config'`

#### `-c`
可选参数，是否使用分数坐标，如果指定了 `-c` 参数，在保存结构时将使用`笛卡尔坐标`，否则使用`分数坐标`。注意，PWmat只支持分数坐标，此时该参数将失效

#### `-t`
输入结构的原子类型，该参数用于当输入结构是 `lammps/lmp`或 `lammps/dump` 格式时指定结构的原子类型，可以是元素名称或者原子编号，顺序需要与输入结构中保持一致。对于其他格式的输入文件，该参数失效

#### `-p`
可选参数，周期性边界条件。例如，[1, 1, 1] 表示系统在 x, y, z 方向上是周期性的。默认为 [1,1,1]

#### `-l`
可选参数，分数坐标的容差。默认为 1e-5。防止轻微负坐标被映射到模拟盒中

我们在源码的根目录下提供了 [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples)，您可以下载后使用这些测试例子：

```bash
# super_cell 命令例子
pwdata super_cell -m 2 3 4 -i examples/pwmat_data/lisi_atom.config -s examples/test_workdir/super_atom.config -o pwmat/config 

#或命令的缩写
pwdata super -m 2 0 0 0 3 0 0 0 4 -i examples/pwmat_data/lisi_atom.config -s examples/test_workdir/super_atom.config -o pwmat/config 

# 执行完成后将在 examples/test_workdir 目录下生成一个名为 super_atom.config 的文件，采用了2X3X4阔胞
```

### 5. 晶格和原子位置微扰 perturb
该命令用于对结构的晶格或者原子位置坐微扰。
参数如下所示

```bash
pwdata perturb [-h] [-d ATOM_PERT_DISTANCE] [-e CELL_PERT_FRACTION] -n PERT_NUM -i INPUT -f  INPUT_FORMAT [-s SAVENAME] [-o OUTPUT_FORMAT] [-c] [-t ATOM_TYPES [ATOM_TYPES ...]]
```

#### `-h`
输出帮助信息，将列出命令的所有可用参数及其解释

#### `-d`
可选参数，原子微扰的距离，决定原子相对原始位置的移动距离。对每个原子的三个坐标值，分别加上从 [-atom_pert_distance，atom_pert_distance] 范围内的均匀分布中随机采样的值。微扰是以埃为单位的距离。例如，0.01 表示原子的移动距离是 0.01 埃，默认值为0，即不对原子位置微扰

#### `-e`
可选参数，晶胞变形的程度。对 9 个晶格值分别加上从[-cell_pert_fraction，cell_pert_fraction] 范围内的均匀分布中随机采样的值。例如，0.03 表示晶胞变形的程度是相对原始晶胞的 3%，默认值为0，即不对晶格做微扰

#### `-n`
必选参数，需要微扰的结构数量

#### `-i`
必选参数，输入文件的文件路径，支持绝对路径或者相对路径，必选参数

#### `-f`
可选参数，如不显式指定，将根据输入文件自动推测。输入文件的格式，支持的格式有 ['pwmat/config','vasp/poscar', 'lammps/lmp', 'cp2k/scf']，必选参数

#### `-o`
可选参数，输出文件的格式，支持的格式有['pwmat/config','vasp/poscar', 'lammps/lmp']，如果未指定该参数，将会使用输入结构的格式，此时如果输入的文件格式是`cp2k/scf`，那么将使用`pwmat/config`格式

#### `-s`
可选参数，输出文件的名称，与 `-o` 配合使用。如果未指定，对于 `pwmat/config` 格式将使用 `atom.config` 作为文件名，对于 `vasp/poscar` 格式使用 `POSCAR` ,对于 `lammps/lmp` 格式使用 `lammps.lmp` 作为文件名。例如 `'-o pwmat/config -s super_atom.config'` 缩放后的新文件名称为 `'super_atom.config'`

#### `-c`
可选参数，是否使用分数坐标，如果指定了 `-c` 参数，在保存结构时将使用`笛卡尔坐标`，否则使用`分数坐标`。注意，PWmat只支持分数坐标，此时该参数将失效

#### `-t`
输入结构的原子类型，该参数用于当输入结构是 `lammps/lmp`或 `lammps/dump` 格式时指定结构的原子类型，可以是元素名称或者原子编号，顺序需要与输入结构中保持一致。对于其他格式的输入文件，该参数失效

我们在源码的根目录下提供了 [examples](https://github.com/LonxunQuantum/pwdata/tree/master/examples)，您可以下载后使用这些测试例子：

```bash
# perturb 命令例子
pwdata perturb -e 0.01 -d 0.04 -n 20 -i examples/pwmat_data/lisi_atom.config -f pwmat/config -s examples/test_workdir/perturb_atom -o pwmat/config
# 微扰后将在 examples/test_workdir/pertub_atom 目录下生成20个微扰后的结构
```

### 6. 统计结构数量 count
统计各种轨迹文件 `MOVEMENT(PWmat)`、`OUTCAR(VASP)`、`lammps dump file(Lammps)`、`cp2k md file(CP2K)` 或常用训练数据` pwmlff/npy`、`extxyz`、`deepmd/npy`、`deepmd/raw`、[`meta OMAT24 开源数据集`](https://huggingface.co/datasets/fairchem/OMAT24)为 `pwmlff/npy` 或者 `extxyz` 中的结构数量。

参数如下所示
```bash
pwdata convert_configs [-h] [-h] -i INPUT [INPUT ...] [-f INPUT_FORMAT] [-q QUERY] [-n CPU_NUMS] [-t ATOM_TYPES [ATOM_TYPES ...]]

```

#### `-h` 

输出帮助信息，将列出命令的所有可用参数及其解释

#### `-i`
必选参数，输入文件的文件路径，支持绝对路径或者相对路径。该参数为列表形式，支持输入多个文件路径或者目录。pwdata对` pwmlff/npy`、`extxyz`、`deepmd/npy`、`deepmd/raw`、`meta OMAT24 开源数据集`实现了目录自动查询，您只需要指定数据源根目录即可。

例如对于[examples/pwmlff_data/LiSiC](https://github.com/LonxunQuantum/pwdata/tree/master/examples/pwmlff_data/LiSiC)，该目录下存在'C2, C448, C448Li75, C64Si32, Li1Si24, Li3Si8, Li8, Li88Si20, Si1, Si217'这些子目录, 输入`'-i examples/pwmlff_data'` 即可。

此外，如果您的文件或者目录较多（如meta数据库这类非常多的子文件），您也可以将这些路径写入一个json文件中，如下所示，命令中指定`-i jsonfile `即可。
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
可选参数，输入文件的格式，pwdata实现了对输入数据的格式自动推理，不需要显式指定输入格式。支持的格式有 ['pwmat/movement', 'vasp/outcar', 'lammps/dump', 'cp2k/md', 'pwmlff/npy', 'deepmd/npy', 'deepmd/raw', 'extxyz', 'meta']

#### `-q`
可选参数，str类型，该参数值在输入类型为`meta`时生效，用于查询数据库操作，详细的使用参考 [meta查询演示](#convert_configs-meta-查询例子)

#### `-n`
可选参数，int类型，该参数在输入类型为`meta`时生效，用于设置并行查询数据库时使用的CPU核数，默认使用单核

#### `-t`
如果输入格式是 `lammps/lmp`或 `lammps/dump` 格式，该参数用于指定结构的原子类型，可以是元素名称或者原子编号，顺序需要与输入结构中保持一致

如果输入格式是`meta`，该该参数用于查找所有`只存在这些元素类型`的结构。

## 二、作为独立工具使用 (接口调用)

pwdata 也可以作为一个独立的工具使用，通过调用 pwdata 的接口来生成数据集或者进行数据转换。pwdata 的接口调用方式如下：

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**Config**</font> <font color='#2ecc71'>_(self, format: str, data_path: str, pbc = None, atom_names = None, index = ':', **kwargs)_</font> 
> [源码](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L110)</p>
>
> 从输入文件中读取数据。
>
> **参数:**
>
> - **format**: 字符串. 输入文件的格式。支持的格式有：`pwmat/config`, `vasp/poscar`, `lammps/dump`, `lammps/lmp`, `pwmat/movement`, `vasp/outcar`, `cp2k/md`, `cp2k/scf`, `pwmlff/npy`, `deepmd/npy`, `deepmd/raw`, `extxyz`、`meta`。
>
>   - `pwmat/config`: PWmat 结构文件，例如 `atom.config`.
>   - `pwmat/movement`: PWmat 分子动力学轨迹文件，例如 `MOVEMENT`.
>   - `lammps/dump`: LAMMPS dump 文件, 例如 `dump.lammptraj`.
>   - `lammps/lmp`: LAMMPS 结构文件，例如 `in.lmp`.
>   - `vasp/poscar`: VASP 结构文件，例如 `POSCAR`.
>   - `vasp/outcar`: VASP 分子动力学轨迹文件，例如 `OUTCAR`.
>   - `cp2k/md`: CP2K 标准输出文件，原子位置文件及对应的原子力文件，例如 `cp2k.out`, `*pos-1.xyz`, `*pos-1.pdb`, `*frac-1.xyz`.
>   - `cp2k/scf`: CP2K 标准输出文件，例如 `cp2k.out`.
>   - `pwmlff/npy`: MatPL 数据集文件，例如 `energies.npy`.
>   - `deepmd/npy`: DeepMD 数据集文件，例如 `force.npy`.
>   - `deepmd/raw`: DeepMD 数据集文件，例如 `force.raw`.
>   - `extxyz`: 扩展的 xyz 文件，例如 `*.xyz`.
>   - `meta`: meta开源的数据文件，后缀名为`.aselmdb`.
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

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**Config.to**</font> <font color='#2ecc71'>_(self, data_path, format = None, **kwargs)_</font>
> [源码](https://github.com/LonxunQuantum/pwdata/blob/master/pwdata/main.py#L178)</p>
>
> 根据读入的文件格式，将数据保存为指定格式的文件。
>
> **参数:**
>
> - **data_path**: 字符串, **必选**. 保存文件的路径。
>
> - **format**: 字符串, **必选**. 保存文件的格式。默认为 None。支持的格式有 `pwmat/config`, `pwmat/movement`, `vasp/poscar`, `lammps/lmp`, `extxyz`, `pwmlff/npy`.
>
> - **Kwargs**:
>   - 1. 其他用于保存文件的关键字参数。用于以下格式的文件：`pwmat/config`, `vasp/poscar`, `lammps/lmp`, `extxyz`。
>     - **data_name**: 字符串, **必选**. 结构文件的保存名称。
>     * **sort**: bool, **可选**. 是否按照原子序数排序。默认为 None。
>     * **wrap**: bool, 可选. 是否将原子映射到模拟盒中。默认为 False。
>     * **direct**: bool, **必选**. 原子坐标是分数坐标还是笛卡尔坐标。(0 0 0) -> (1 1 1)
>   - 2. 用于保存标签文件的关键字参数。用于 `pwmlff/npy` 格式的文件。
>     - **data_name**: 字符串, **必选**. 数据集文件夹的保存名称。
>     * **random**: bool, 可选. 是否对原始数据进行随机打乱，然后将数据划分为训练集和验证集。默认为 True。
>     * **seed**: int, 可选. 随机数种子。默认为 2024。

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
> config.to(data_path = "./", format = "lammps/lmp", data_name = "lmp.init", direct = False, sort = True)
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
> multi_data.to(data_path = "./PWdata", format='pwmlff/npy')
> ```
>
> :::
> **例子2:**

> 将'pwmat/movement'、'vasp/outcar'、'cp2k/md'、 或者 'lammps/dump' 轨迹文件转换为单结构文件'pwmat/config'、 'vasp/poscar'、 'lammps/lmp'
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
> supercell.to(data_path = "./", data_name = "atom_2x2x2.config", format = "pwmat/config", sort = True)
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
> perturbed_structs.to(data_path = "~/pwdata/test/pertubed/",
>           data_name = "pertubed",
>           format = save_format,
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
> scaled_structs.to(data_path = "~/test/scaled/",
>           data_name = "scaled",
>           format = "pwmat/config",
>           direct = True,
>           sort = True)
> ```

## 四、一些代码案例

#### 将MPtraj文件转换为lmdb格式

MPtraj 开源数据集为json格式，转换为lmdb格式后，配合 [cvt_configs 命令 -t 和 -q 选项](#2-训练数据提取-convert_configs) 可以快速查找到指定结构，转换为extxyz或者pwmlff/npy格式做训练。

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
