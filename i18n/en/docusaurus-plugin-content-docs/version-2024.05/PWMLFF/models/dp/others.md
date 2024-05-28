---
sidebar_position: 19
---

# Other Commands

## Python Inference
We provide two Python inference methods. One is to directly predict properties for structures, as demonstrated in [Predicting Structures](#predicting-structures) section. The second is to predict properties for a large amount of data in pwmlff/npy, vasp/outcar, pwmat/movement formats, or their hybrid formats. For such needs, we offer a way to use JSON configuration files, as shown in the [Hybrid Data Prediction](#hybrid-data-prediction) section.

## Predicting Structures
This section describes how to use a trained model to predict properties for **atomic structures**. A trained model can be used to predict various properties of atomic structures, such as energy, forces, and stresses of a system.

After training the model, we obtain the model file, typically a `.ckpt` file. Then, we can execute the following command to predict properties for new atomic structures:

```bash
PWMLFF infer dp_model.ckpt atom.config pwmat/config
```

where `dp_model.ckpt` is the model file, `atom.config` is the atom configuration file, and `pwmat/config` is the format of the atom configuration file.

otherwise, POSCAR file with the format of `vasp/poscar`.

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

## Hybrid Data Prediction
This section introduces how to utilize a trained DP model to make predictions on a large amount of data in pwmlff/npy, vasp/outcar, pwmat/movement formats, or their hybrid formats.

Users need to prepare a JSON file as shown in the example below, and then use the command `PWMLFF test jsonfile` to start the inference.

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

- `model_load_file`: Path to the trained `DP model`.
- `format`: Format of the structure files in `raw_files`.
- Users can also directly use directories containing files in the `pwmlff/npy` format in `datasets_path`.

For example, for the structure file structure shown below in `pwmlff/npy` format, if the user sets "datasets_path":['pathA'], then all structures in both the `train` and `valid` directories will be used for inference; if the user sets "datasets_path":['pathA/valid'], only the structures in `pathA/valid` will be used for inference.

You can also mix the usage of `raw_files` and `datasets_path`.
```txt
pathA
    ├──train
    │   └──ei.npy,forces.npy,...
    └──valid
        └──ei.npy,forces.npy,...
```