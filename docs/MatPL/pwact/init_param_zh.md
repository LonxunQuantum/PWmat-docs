---
sidebar_position: 1
---

# init_bulk param.json

初始训练集制备，包括对构型（VASP、PWmat等格式）进行`驰豫`、`阔胞`、`缩放`、`微扰`和`AIMD`（支持 DFTB、PWMAT、VASP）设置。参数列表如下。

## data_format
用于设置init_bulk 执行结束后的得到的数据格式，默认为扩展的xyz格式 `extxyz`。

## reserve_work
是否保留临时工作目录，默认值为 `false` , 不保存。

## interval
用于设置提取数据时，从轨迹中选取结构的间隔，即在轨迹中，每隔多少个结构选取一个构型，默认值为`1`。

## sys_config_prefix
用于设置初始构型的路径前缀，`可选参数`，与 [`sys_configs/config`](#config) 配合设置。可以是绝对路径或者相对路径，相对路径为当前目录。

例子：`"sys_config_prefix":"/data/structure"`, `"config":"atom.config"`, 则 `atom.config` 的实际路径是 `/data/structure/atom.config`

## sys_configs
设置构型的文件路径、驰豫（relax）、阔胞（super cell）、缩放晶格（scale）、微扰原子位置（pertub）、AIMD。完整的参数如下例所示。

### config
设置构型的文件路径，如果设置了 [`sys_config_prefix`](#sys_config_prefix) 则进行路径拼接，否则使用 config 中设置的路径作为config路径。

### format
设置构型的文件类型，支持 `VASP` 的 `POSCAR` 或者 `PWMAT` 的 `atom.config` 格式。如果是 `POSCAR` 文件，则值为 `"vasp/poscar"`, 默认值为 `"pwmat/config"`。

### relax
是否对 config 做驰豫，默认值为 `"true"`。

### relax_input_idx
设置驰豫使用的控制文件，与 [relax_input](#relax_input) 配合使用，指定控制文件的位置，如 [例子](#例子) 中所示，使用 `relax_input` 中设置的 `relax_etot1.input` 文件作为 PWMAT 控制文件。默认值为0，即使用 `relax_input` 中的第一个文件作为控制文件。

### super_cell
用于阔胞设置，可选参数，如不设置，则对结构不做阔胞。数据格式为 list，支持如下格式输入：`[1, 1, 2]` 或 `[[1,0,0],[0, 2, 0],[0,0,1]]` 或 `[1,0,0,0, 2, 0,0,0,1]`。

### scale
用于对晶格的缩放设置，可选参数，如不设置，则对结构不做缩放。数据格式为 list，如 `[0.9, 0.95，0.96, 0.97]`，表示对结构晶格分别进行 0.9, 0.95，0.96, 0.97 微扰，将得到四个微扰后的结构。

### perturb
对结构的原子位置做扰动，配合 [`cell_pert_fraction`](#cell_pert_fraction) 、[`atom_pert_distance`](#atom_pert_distance) 使用，`perturb` 值为扰动后生成的结构数量。可选参数，不设置则不做扰动。

### cell_pert_fraction
对晶格的扰动。对 9 个晶格值分别加上从[-cell_pert_fraction，cell_pert_fraction]范围内的均匀分布中随机采样的值，默认值为 `0.03`。

### atom_pert_distance
原子坐标的扰动（Angstrom）。对每个原子的三个坐标值，分别加上从 [-atom_pert_distance，atom_pert_distance] 范围内的均匀分布中随机采样的值。默认值为 `0.01`。


### aimd
是否对结构做分子动力学模拟，默认值为 true。

### aimd_input_idx
设置 AIMD 使用的控制文件，与 [aimd_input](#aimd_input) 配合使用，指定控制文件的位置，如 [例子](#例子) 中所示，使用 `aimd_input` 中设置的 `aimd_etot.input` 文件作为 PWMAT 控制文件。默认值为0，即 使用 `aimd_input` 中的第一个文件作为控制文件。

### bigmodel
是否使用大模型运行 MD，默认值为 False

### bigmodel_input_idx
设置 bigmodel 使用的脚本，与 [bigmodel_input](#bigmodel_input) 配合使用，指定脚本文件的位置。

### direct
设置 是否使用 direct 方法筛选结构，默认值 False， 与 [direct_input](#direct_input) 配合使用，direct 为 True 时，必须在 direct_input 中指定 direct的 脚本文件所在位置。

## sys_config 设置例子
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
这里设置了`49.config` 和 `44_POSCAR` 两个结构，分别是 pwmat/config （默认格式）和 vasp/poscar格式。
- 对 49.config 操作如下：step1. 对 49.config 做 relax，使用的 relax 控制文件为 `relax_input` 中的第一个文件；step2.对relax得到的结构，分别对晶格做0.9, 0.95缩放，[缩放方式参考](../pwdata/README.md#3-晶格缩放-scale_cell)；step3. 对缩放后得到两个文件做晶格和原子位置微扰，各自微扰出3个结构，[微扰方式参考](../pwdata/README.md#5-晶格和原子位置微扰-perturb)；step4. 对微扰后得到的6个结构做 AIMD，使用的 md 控制文件为 `aimd_input` 中设置的第1个文件。init_bulk执行结束后将得到6条 AIMD 轨迹。
- 对 44_POSCAR 操作如下：step1. 对 49.config 做阔胞，按照 [1,0,0],[0, 2, 0],[0,0,1] 阔胞，[阔胞方式参考](../pwdata/README.md#4-阔胞-super_cell)；step2. 对阔胞后的结构做微扰；step3. 对微扰后得到的2个结构做 AIMD，使用的 md 控制文件为 `aimd_input` 中设置的第2个文件。init_bulk 执行结束后将得到2条AIMD轨迹。

因此init_bulk执行结束后将得到6条轨迹，之后会自动将轨迹提取为`data_format`中指定的文件格式。

## dft_style
设置 [`Relax`](#relax) 和 [`AIMD`](#aimd) 使用哪种DFT计算软件，默认值为 `pwmat`, 也支持 VASP格式，如果是 VASP 格式，则设置为 `vasp`。

## pseudo 
设置 `PWMAT` 或 `VASP` 赝势文件所在路径，为list格式，赝势文件路径可以为绝对路径或相对路径（相对于当前路径）。

<!-- ## in_skf
设置 `DFTB`(PWMAT封装) 的赝势文件上一级目录所在路径，为string 格式，绝对路径或相对路径（相对于当前路径）。 -->
<!-- 
### basis_set_file
参考 [potential_file](#potential_file)。

### potential_file
设置 `CP2K` 赝势文件 `BASIS_MOLOPT` 和 `POTENTIAL` 文件所在路径。例如
```josn
    "basis_set_file":"~/datas/systems/cp2k/data/BASIS_MOLOPT",
    "potential_file":"~/datas/systems/cp2k/data/POTENTIAL"
``` -->

## gaussian_param
CP2K 或 PWMAT 高斯基组参数设置，
`basis_set_file` 和 `potential_file` 指定基组和势函数文件路径。
`atom_list`, `basis_set_list`, `potential_list` 配合使用，分别指定元素对应的基组和势函数设置。kspacing 用于设置 K点，用法与 [PWMAT KSPACKING 设置](#kspacing) 相同。
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

## relax_input
设置 Relax 的 输入控制文件。如果存在多个 relax 控制文件，则按照list 格式组织。详细的设置请参考下面的例子。

## aimd_input
设置 AIMD 的 输入控制文件。如果存在多个 aimd 控制文件，则按照list 格式组织，对于只是用单个文件的情况，也可以设置为dict格式。

### input
设置输入控制文件的路径，可以为绝对路径或相对路径（相对于当前路径）。

### kspacing
该参数为PWMAT的输入参数，用于设置K点，可选参数。如果在etot.input文件中未设置 `MP_N123` 参数，则使用该参数设置 K点。如果文件中已经设置了 `MP_N123`，则对该参数的设置会造成错误，请确保 `MP_N123` 与 `kspacing` 只能同时存在一个。
该参数为PWMAT的输入参数，用于设置K点，可选参数。如果在etot.input文件中未设置 `MP_N123` 参数，则使用该参数设置 K点。

如果 `etot.input` 文件中未设置 `MP_N123`，且 `kspacing` 未设置，则采用默认设置 `kspacing` 值为 `0.5`。

注意，不能同时设置 `MP_N123` 与 `kspacing`。

### flag_symm
该参数为PWMAT的输入参数，用于设置K点，可选参数。对于 Relax 或者 SCF 计算，默认值为 `0`, 对于 AIMD计算，默认值为 `3`。

## bigmodel_input
设置 大模型的脚本文件。如果存在多个脚本文件，则按照 list 格式组织。

对大模型的接口设置，请参考[例子 si_direct_bigmodel](./example_si_direct_bigmodel.md#接入-大模型-md)。

## direct_input
设置 direct 采样的脚本文件，为单文件路径。

对 direct 的接口设置，请参考[例子 si_direct_bigmodel](./example_si_direct_bigmodel.md#接入-direct-采样)。

## 完整例子
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
### 上述参数作用
1. 对 atom.config 做relax；
2. 对relax后的结构做阔胞（1,1,2）；
3. 对阔胞后的结构对晶格分别进行0.9、0.95缩放;
4. 对缩放后得到两个结构的原子位置微扰，各自扰动生成20个结构；
5. 对扰动后得到的40个结构做AIMD模拟；
6. 将AIMD轨迹自动提取为 `PWdata` 数据格式作为预训练数据。

### [relax_input](#relax_input) 和 [aimd_input](#aimd_input)

[kspacing](#kspacing)和[flag_symm](#flag_symm)是PWMAT的K点设置，如果没有在 etot.input文件中设置 MP_N123 参数，那么程序会使用这两个参数设置K点。因此，如果您已经etot.input设置了 MP_N123 ，那么，您可以将[relax_input](#relax_input) 和 [aimd_input] 简写为如下形式

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

如果您对在 [sys_configs](#sys_configs) 中的所有结构，都使用同一个relax或者aimd，那么您可以进一步将参数简写为
```json
    "relax_input":"relax_etot.input",
    "aimd_input": "aimd_etot.input"
```

此时，在 [sys_configs](#sys_configs) 您不必再写 [relax_input_idx](#relax_input_idx) 和 [aimd_input_idx](#aimd_input_idx) 参数，此时您的 [sys_configs](#sys_configs)可以写为如下所示。
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

### pwmat 设置例子
pwmat K点通过在控制文件中设置 MP_N123，例子：
``` json
    "dft_style":"PWmat",
    "relax_input":["relax-agau-etot.input", "relax_ag-etot.input", "relax_au-etot.input"],
    "aimd_input": ["aimd_agau-etot.input",   "aimd_ag-etot.input", "aimd_au-etot.input" ],
    "pseudo" : ["../Ag.SG15.PBE.UPF", "../Au.SG15.PBE.UPF"]
```

pwmat K点通过 kspacing 设置，例子：
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
            "_flag":"1个整数，relax or scf 0 , aimd 3, 磁性体系2"
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

pwmat gaussian基组设置例子：
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

### vasp 设置例子
``` json
    "dft_style":"vasp",
    "relax_input":["INCAR_relax_AgAu", "INCAR_relax_Ag", "INCAR_relax_Au"],
    "aimd_input": ["INCAR_md_AgAu",   "INCAR_md_Ag", "INCAR_md_Au" ],
    "pseudo" : ["../Ag_POTCAR", "../Au_POTCAR"]
```

### cp2k 设置例子
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
