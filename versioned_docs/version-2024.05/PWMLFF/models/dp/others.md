---
sidebar_position: 19
---

# Other Commands

## Python inference
我们提供了两种 python inference 方式，一种是直接对结构做预测，如 [章节-预测结构](#预测结构) 所示，第二种是对大量的 pwmlff/npy、vasp/outcar、pwmat/movement 格式或者它们的混合格式做预测，对于这类需求，我们提供了使用 json 配置文件的方式，如 [章节-混合数据预测](#预测结构) 所示。

## 预测结构
本章节介绍如何使用训练好的模型对`原子结构`进行性质预测。训练好的模型可以用来预测原子结构的性质，如系统的能量、力和应力等。
在模型训练完成后，我们可以得到模型文件，即 `.ckpt` 文件。
然后我们可以执行以下命令来预测新的原子结构的性质：

```bash
PWMLFF infer dp_model.ckpt atom.config pwmat/config
```

其中 `dp_model.ckpt` 是模型文件，`atom.config` 是原子结构文件，`pwmat/config` 是原子结构文件的格式。

或者，POSCAR 结合`vasp/poscar`格式。

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**mods.infer.Inference**</font> <font color='#2ecc71'>_(self, ckpt_file: str, device: torch.device)_</font> 
> [source](https://github.com/LonxunQuantum/PWMLFF/blob/dev_feature/src/mods/infer.py#L9)</p>
>
> **Parameters:**
>
> - `ckpt_file` (str) – The path of the model file. 模型文件的路径。
> - `device` (torch.device) – The device to use. 使用的设备是 CPU 还是 GPU。
>
> **Returns:**
>
> - None
>
> **Example:**
>
> ```python
> from mods.infer import Inference
> import torch
>
> ckpt_file = "dp_model.ckpt"
> structrues_file = "atom.config"
> format = "pwmat/config"
> device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
> infer = Inference(ckpt_file, device)
> infer.inference(structrues_file, format)
> ```

## 混合数据预测
本部分介绍如何使用训练好的 DP 模型对大量的 pwmlff/npy、vasp/outcar、pwmat/movement 格式或者它们的混合格式做预测。

用户需要准备如下例子所示的 json 文件，之后使用 `PWMLFF test jsonfile` 命令即可开始推理。

```json
{
    "model_type": "DP",
    "atom_type": [28, 44, 45, 46, 77],
    "model_load_file":"dp_model.ckpt",
    "format": "pwmat/movement",
    "raw_files":[
        "movement_0",
        "movement_1"
    ],
    "datasets_path":[
        "PWdata/mvm_files_11",
        "PWdata/mvm_files_12/train",
        "PWdata/mvm_files_13/valid"
    ]
}

```
`model_load_file` 为 训练好的 `dp模型` 所在路径;

`format` 为 `raw_files` 中的结构文件格式;

用户也可以直接在 `datasets_path` 中使用 `pwmlff/npy` 格式的文件所在目录。

例如对于如下的`pwmlff/npy`文件结构，如果用户设置 "datasets_path":['pathA']，那么`train`和`valid`所在目录下的所有结构都会用于推理；如果用户设置 "datasets_path":['pathA/valid']，那么只使用p`athA/valid`下的结构做推理。

您也可以混合使用 `raw_files`、`datasets_path`。
```txt
pathA
    ├──train
    │   └──ei.npy,forces.npy,...
    └──valid
        └──ei.npy,forces.npy,...
```