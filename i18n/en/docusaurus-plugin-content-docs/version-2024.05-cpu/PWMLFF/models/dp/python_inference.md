---
sidebar_position: 19
---

# Python inference
We provide two types of Python inference methods. The first one is direct prediction for structures, as shown in the section [Predict Structures](#predict-structures), use `infer` command. The second is for predicting a large number of `pwmlff/npy`, `vasp/outcar`, `pwmat/movement` formats or their mixed formats. For this, we offer the option of using a JSON configuration file, as detailed in the section [Mixed Data Prediction](#mixed-data-prediction), use `test` command.

## Predict Structures
This section explains how to use a trained model to predict the properties of atomic structures. The trained model can predict properties of atomic structures, such as system energy, forces, and stress. Once model training is completed, a model file (i.e., `.ckpt` file) is generated. Then, we can execute the following command to predict the properties of new atomic structures:

```bash
PWMLFF infer dp_model.ckpt atom.config pwmat/config
```

Where `dp_model.ckpt` is the model file, `atom.config` is the atomic structure file, and `pwmat/config` is the format of the atomic structure file.

This also supports formats like `pwmat/movement`, `vasp/poscar`, `vasp/outcar`, and `lammps/lmp`, `lammps/dump`. For `lammps/dump`, the user needs to specify the element types in the file, for example:
```
PWMLFF infer dp_model.ckpt lmps.dump lammps/dump Hf O
```
Once the command is executed, the total energy, per-atom energy, forces, and virial of the structure will be directly output in the terminal.

## Mixed Data Prediction
This section explains how to use a trained DP model to predict a large number of `pwmlff/npy`, `vasp/outcar`, `pwmat/movement` formats or their mixed formats.

The user needs to prepare a JSON file as shown in the following example, and then use the command `PWMLFF test jsonfile`.

```json
{
    "model_type": "DP",
    "atom_type": [28, 44, 45, 46, 77],
    "model_load_file": "dp_model.ckpt",
    "format": "pwmat/movement",
    "raw_files": [
        "movement_0",
        "movement_1"
    ],
    "datasets_path": [
        "PWdata/mvm_files_11",
        "PWdata/mvm_files_12/train",
        "PWdata/mvm_files_13/valid"
    ]
}
```

`model_load_file` is the path to the trained `dp_model`.

`format` is the format of the structure files in `raw_files`.

Users can also directly use directories containing `pwmlff/npy` files in `datasets_path`.

For example, with the following `pwmlff/npy` file structure, if the user sets `"datasets_path": ['pathA']`, all structures under the `train` and `valid` directories will be used for inference. If the user sets `"datasets_path": ['pathA/valid']`, only the structures under `pathA/valid` will be used for inference.

You can also mix and match `raw_files` and `datasets_path`.

```txt
pathA
    ├──train
    │   └──ei.npy, forces.npy, ...
    └──valid
        └──ei.npy, forces.npy, ...
```

After the command finishes execution, a new directory named `test_result` will be created in the current directory, containing the inference results with the following files:

```txt
test_result
    ├──inference_summary.txt
    ├──image_atom_nums.txt
    ├──dft_total_energy.txt
    ├──dft_atomic_energy.txt
    ├──dft_force.txt
    ├──dft_virial.txt
    ├──inference_total_energy.txt
    ├──inference_atomic_energy.txt
    ├──inference_force.txt
    ├──inference_virial.txt
    └──inference_loss.csv
```

`inference_summary.txt`
This file summarizes the inference information, as shown in the following example:

```txt
For 200 images: 
Average RMSE of Etot: 0.34629015882102976 
Average RMSE of Etot per atom: 0.0036071891543857267 
Average RMSE of Ei: 1.3401666387065987 
Average RMSE of RMSE_F: 0.03597006701703569 

More details can be found under the file directory:
/the/path/test_result
```

`image_atom_nums.txt` stores the number of atoms corresponding to each structure in order.

`dft_total_energy.txt` stores the energy labels of each structure in order.

`dft_atomic_energy.txt` stores the per-atom energy labels for each structure (specific to PWmat), with each structure stored as a row.

`dft_force.txt` stores the force labels for each atom in each structure, with the x, y, and z components of the force stored on each line.

`inference_total_energy.txt` stores the predicted total energy for each structure in order.

`inference_atomic_energy.txt` stores the predicted per-atom energy for each structure, with each structure stored as a row.

`inference_force.txt` stores the predicted forces for each atom in each structure, with the x, y, and z components stored on each line.

`inference_loss.csv` contains the RMSE between the predicted results and the labels for each structure. Each column from left to right corresponds to:
`img_idx` representing the structure index, `RMSE_Etot`, `RMSE_Etot_per_atom`, `RMSE_Ei`, and `RMSE_F` representing the RMSE for the total energy, per-atom energy, and forces, respectively.