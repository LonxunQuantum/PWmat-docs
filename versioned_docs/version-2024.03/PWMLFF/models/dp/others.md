---
sidebar_position: 19
---

# Other Commands

## Python inference

这部分介绍如何使用训练好的模型对新的原子结构进行性质预测。训练好的模型可以用来预测新的原子结构的性质，如系统的能量、力和应力等。

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
