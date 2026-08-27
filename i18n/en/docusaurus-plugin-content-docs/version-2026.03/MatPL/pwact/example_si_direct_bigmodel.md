---
sidebar_position: 4
title: Silicon Example (Foundation-Model Sampling)
---

## Silicon Example (Foundation-Model Sampling)

This example demonstrates active learning for silicon using a foundation model (EquiformerV2) and DIRECT sampling. [`PWact/examples/`](https://github.com/LonxunQuantum/PWact/tree/main/pwact/example) provides several combinations; see [`PWact/examples/README.md`](https://github.com/LonxunQuantum/PWact/blob/main/examples/README.md) for details. Mcloud users can find the examples under `/share/public/PWMLFF_test_data/pwact_examples/25-pwact-demo`. The [`PWact/examples/si_pwmatgaussion_bigmodel_direct`] example illustrates the parameters and scripts for foundation-model and DIRECT workflows.
For constructing an initial training set with `init_bulk`, see [`examples/si_pwmatgaussion_bigmodel_direct/init_bulk_bigmodel`](https://github.com/LonxunQuantum/PWact/tree/main/examples/si_pwmatgaussion_bigmodel_direct/init_bulk_bigmodel):

 - Step 1. Relax the structure with PWmat using a Gaussian basis.
 - Step 2. Run molecular dynamics with a foundation model (SevenNet).
 - Step 3. Apply DIRECT sampling to the MD trajectories, remove similar structures, and use the selected structures for subsequent active learning.

The Gaussian-basis PWmat settings in this directory are intended only for quick workflow testing. The generated data are not suitable for scientific use.

### Prepare Pretraining Data with init_bulk

`Command`:
Enter `examples/si_pwmatgaussion_bigmodel_direct/init_bulk_bigmodel`. The directory provides an Mcloud job script, or you can run:
```bash
pwact init_bulk init_param.json resource.json
```

### init_bulk Directory Structure

The `init_bulk` directory resembles that of the [si_pwmat example](./example_si_init_zh.md#init_bulk), with an additional `bigmodel` directory:
```
.
├── datapath.txt
├── init_config_0/
├── init_config_1/
└── bigmodel/
    ├── 0-bigmodel.job
    ├── 0-tag.bigmodel.success
    ├── 1-bigmodel.job
    ├── 1-tag.bigmodel.success
    ├── ...
    ├── direct/
    │   ├── 0-direct.job
    │   ├── 0-tag.direct.success
    │   ├── candidate.json
    │   ├── candidate.xyz
    │   ├── Cov_score.png
    │   ├── direct.py
    │   ├── PCA_direct.png
    │   ├── PCA_variance.png
    │   ├── PWdata
    │   ├── select_idx.dat
    │   ├── select.xyz
    │   └── tag.direct.success
    ├── init_config_0/
    │   ├── 0.95_scale/
    │   │   ├── 3_bigmodel/
    │   │   │   ├── npt.log
    │   │   │   ├── POSCAR
    │   │   │   ├── sevennet_md.py
    │   │   │   ├── tag.bigmodel.success
    │   │   │   ├── tmp.traj
    │   │   │   └── traj.xyz
    │   │   ├── 4_bigmodel/
    │   │   └── 5_bigmodel/
    │   ├── 0.9_scale/
    │   └── 1.0_scale/
    └── init_config_*/
```

- `*-bigmodel.job` and `*-tag.bigmodel.success` are Slurm scripts for foundation-model MD and success-marker files.
- `init_config_0`, `init_config_1`, and so on are working directories for foundation-model MD.
- `direct` is the working directory for structure selection with DIRECT.

### Integrate Foundation-Model MD into init_bulk
Foundation-model MD uses a user-defined interface and requires the corresponding runtime environment. See [sevennet_md.py](https://github.com/LonxunQuantum/PWact/blob/main/examples/si_pwmatgaussion_bigmodel_direct/sevennet_md.py) in the example.

As illustrated by `bigmodel/init_config_0/0.95_scale/3_bigmodel/`, when PWact detects a [bigmodel](./init_param_zh.md#bigmodel) setting during `init_bulk`, it creates a working directory for each structure, writes the structure as a VASP/POSCAR file, copies the user-provided MD interface script such as `sevennet_md.py`, generates a Slurm script from the `explore` settings in `resource.json`, and submits the job.

The interface script must read `POSCAR`, run MD, and convert the trajectory to an `extxyz` file named `traj.xyz`. PWact detects this file and uses it in subsequent processing.

### Integrate DIRECT Sampling into init_bulk
DIRECT sampling uses a user-defined interface and requires a configured DIRECT environment. See [direct.py](https://github.com/LonxunQuantum/PWact/blob/main/examples/si_pwmatgaussion_bigmodel_direct/direct.py) in the example.

After foundation-model MD produces multiple trajectories, PWact detects and merges them into `bigmodel/direct/candidate.xyz`. It copies the DIRECT interface script specified by [direct_input](./init_param_zh.md#direct_input), such as `direct.py`, into that directory, generates a Slurm script from the `direct` settings in `resource.json`, and submits the job.

The script must read `candidate.xyz` and generate `select_idx.dat` and `select.xyz`. `select_idx.dat` stores the indices of selected structures in `candidate.xyz`, while `select.xyz` stores the selected structures themselves. PWact reads both files for subsequent steps.

### Active Learning with run

This example uses the pretraining data and perturbed structures from `init_bulk` for active learning at 500 K, 800 K, and 1100 K.

Command:
After `init_bulk` completes, enter `examples/si_pwmatgaussion_bigmodel_direct/run_iter_direct_bigmodel`:
```bash
pwact run param.json resource.json
```

### Active-Learning Directory

The directory structure resembles that of the [si_pwmat example](./example_si_init_zh.md#run-active-learning-directory).

### train Directory
The `train` directory is identical to that in the [si_pwmat example](./example_si_init_zh.md#run-00train-directory).

### explore Directory

In addition to `md` and `select`, `explore` contains a `bigmodel` subdirectory whose contents match those described for [DIRECT sampling in init_bulk](#integrate-direct-sampling-into-init_bulk).

The `md` and `select` subdirectories are identical to those in the [si_pwmat example](./example_si_init_zh.md#run-01explore-directory).

### label Directory

When [`bigmodel_script`](./run_param_zh.md#bigmodel_script) is configured for foundation-model labeling, a `bigmodel` subdirectory is added under `label`:
```txt
bigmodel/
├── 0-bigmodel.job
├── eqv2_label.py
├── select.xyz
└── train.xyz
```
- `eqv2_label.py` is the user-specified `bigmodel_script`; PWact copies it into `bigmodel`.
- `select.xyz` is the extxyz input containing structures to label.
- `train.xyz` is the labeled extxyz output. It preserves the structure order of `select.xyz` and adds energies and forces.
- `0-bigmodel.job` is the Slurm script generated from the `DFT` settings in `resource.json`.

### Integrate Foundation-Model Labeling into run
Foundation-model labeling uses a user-defined interface and requires the corresponding runtime environment. See [eqv2_label.py](https://github.com/LonxunQuantum/PWact/blob/main/examples/si_pwmatgaussion_bigmodel_direct/eqv2_label.py) in the example.

After multi-model deviation selection—or additional DIRECT selection—during `explore`, PWact detects the selected structures, merges them into `bigmodel/select.xyz`, copies the interface script specified by [bigmodel_script](./run_param_zh.md#bigmodel_script), such as `eqv2_label.py`, generates a Slurm script from the `DFT` settings in `resource.json`, and submits the job.

The script must read `select.xyz` and generate `train.xyz`, adding energy and force information. PWact reads this file for subsequent steps.

### result
`result` collects the labeled dataset. When `data_format` is `extxyz`, the result is `train.xyz`; when it is `pwmlff/npy`, the result is a `PWdata` directory containing the dataset files.
