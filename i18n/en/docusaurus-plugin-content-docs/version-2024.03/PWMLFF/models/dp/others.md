---
sidebar_position: 19
---

# Other Commands

## Python inference

This section introduces how to use the trained model to predict the properties of a new configuration. The trained model can be used to predict the properties of a new configuration, such as the energy, force, and stress of the system.

After the model is trained, we can get the model file, which is a `.ckpt` file. 

then we can execute the following command to predict the properties of a new configuration:

```bash
PWMLFF infer dp_model.ckpt atom.config config
```

where `dp_model.ckpt` is the model file, `atom.config` is the atom configuration file, and `config` is the format of the atom configuration file.

otherwise, POSCAR file with the format of poscar.

> <p style={{backgroundColor: '#E5E1EC'}}> <font color='black'>**mods.infer.Inference**</font> <font color='#2ecc71'>_(self, ckpt_file: str, device: torch.device)_</font> 
> [source](https://github.com/LonxunQuantum/PWMLFF/blob/dev_feature/src/mods/infer.py#L9)</p>
>
> **Parameters:**
> - `ckpt_file` (str) – The path of the model file.
> - `device` (torch.device) – The device to use.
>
> **Returns:**
> - None
>
> **Example:**
> ```python
> from src.mods.infer import Inference
>
> ckpt_file = "dp_model.ckpt"
> structrues_file = "atom.config"
> format = "config"
> device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
> infer = Inference(ckpt_file, device)
> infer.inference(structrues_file, format)
> ```
