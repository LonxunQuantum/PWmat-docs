---
sidebar_position: 1
title: DP Tutorial
---
## DP Tutorial

This tutorial uses the MatPL [[source root/example/HfO2/dp_demo]](https://github.com/LonxunQuantum/MatPL/blob/master/example/HfO2/dp_demo/) example ([source of the HfO2 training dataset](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)) to demonstrate training, testing, LAMMPS simulation, and other operations for a DP model. The example directory is organized as follows.

``` txt
HfO2/
├── atom.config
├── pwdata/
└── dp_demo/
    ├── dp_test.json
    ├── dp_train.json
    ├── train.job
    └── dp_lmps/
        ├── in.lammps
        ├── lmp.config
        ├── jit_dp.pt
        ├── runcpu.job
        └── rungpu.job
```
- `pwdata` is the training-data directory.
- `dp_train.json` is the input file for training the DP force field.
- `dp_train.json` is the input file for testing the DP force field.
- `train.job` is an example Slurm job script for training.
- The `dp_lmps` directory contains a LAMMPS MD example for the DP force field:
  - Force-field file: `jit_dp.pt`
  - Initial structure: `lmp.config`
  - Control file: `in.lammps`
  - Example Slurm scripts: `runcpu.job` and `rungpu.job`

### train

Run the following command in the `dp_demo` directory to start training:
``` bash
MatPL train dp_train.json
# Alternatively, update the environment variables and submit the training job through Slurm: sbatch train.job
```

**Input file description**

The contents of `dp_train.json` are shown below. For descriptions of the DP parameters, see the [DP Parameter Reference](../../parameterdetail.md#dp-model-hyperparameters):

```json
{
    "model_type": "DP",
    "atom_type": [
        8, 72
    ],
    "format": "pwmlff/npy",
    "train_data": [
        "../pwdata/init_000_50/", "../pwdata/init_002_50/", 
        "../pwdata/init_004_50/", "../pwdata/init_006_50/", 
        "../pwdata/init_008_50/", "../pwdata/init_010_50/", 
        "../pwdata/init_012_50/", "../pwdata/init_014_50/", 
        "../pwdata/init_016_50/", "../pwdata/init_018_50/", 
        "../pwdata/init_020_20/", "../pwdata/init_022_20/", 
        "../pwdata/init_024_20/", "../pwdata/init_026_20/", 
        "../pwdata/init_001_50/", "../pwdata/init_003_50/", 
        "../pwdata/init_005_50/", "../pwdata/init_007_50/", 
        "../pwdata/init_009_50/", "../pwdata/init_011_50/", 
        "../pwdata/init_013_50/", "../pwdata/init_015_30/", 
        "../pwdata/init_017_50/", "../pwdata/init_019_50/", 
        "../pwdata/init_021_20/", "../pwdata/init_023_20/", 
        "../pwdata/init_025_20/", "../pwdata/init_027_20/"
    ],
    "valid_data":[
        "../pwdata/init_000_50/", "../pwdata/init_004_50/", 
        "../pwdata/init_008_50/"       
    ]
}
```

For details about the force-field directory generated after training, see [model_record details](../../matpl-cmd.md#train).


### test
``` bash
MatPL test dp_test.json
```
The contents of `test.json` are shown below. For parameter descriptions, see the [Parameter Reference](../../parameterdetail.md).

``` json
{
    "model_type": "DP",
    "format": "pwmlff/npy",
    "model_load_file": "./model_record/dp_model.ckpt",
    "test_data": [
        "../init_000_50", "../init_004_50", "../init_008_50", 
        "../init_012_50", "../init_016_50", "../init_020_20", 
        "../init_024_20", "../init_001_50", "../init_005_50", 
        "../init_009_50", "../init_013_50", "../init_017_50", 
        "../init_021_20", "../init_025_20", "../init_002_50", 
        "../init_006_50", "../init_010_50", "../init_014_50", 
        "../init_018_50", "../init_022_20", "../init_026_20", 
        "../init_003_50", "../init_007_50", "../init_011_50", 
        "../init_015_30", "../init_019_50", "../init_023_20", 
        "../init_027_20"
    ]
}
```

For details about the force-field directory generated after testing, see [test_result details](../../matpl-cmd.md#test).

### infer a Single Structure
``` bash
MatPL infer dp_model.ckpt atom.config pwmat/config
MatPL infer dp_model.ckpt 0.lammpstrj lammps/dump Hf O
# Hf and O are the element names in the lammps/dump structure: Hf is atom type 1 and O is atom type 2
```
After successful inference, the terminal displays the total energy, per-atom energies, per-atom forces, and virial.

### compress a Model

To compress a trained DP force field, use the following command:

```json
MatPL compress dp_model.ckpt -d 0.01 -o 3 -s cmp_dp_model
```
- `compress` is the compression command.
- `dp_model.ckpt` is the name of the model file to compress and is required.
- `-d` sets the grid spacing for `S_ij`; the default is `0.01`.
- `-o` sets the compression order: `3` selects third-order compression and `5` selects fifth-order compression. The default is `3`.
- `-s` sets the name of the compressed model. The default is `cmp_dp_model`.

After compression, a force-field file named `cmp_dp_model.ckpt` is created in the current directory.

### script: Convert to an MD Force Field
This command converts `dp_model.ckpt` to the LibTorch format recognized by LAMMPS.
```bash
MatPL script dp_model.ckpt
# Or convert a compressed force field
MatPL script cmp_dp_model.ckpt
```
The conversion creates a `jit_dp.pt` file in the current directory for subsequent LAMMPS MD simulations.

### lammps MD

**Step 1. Prepare the force-field file**

Before using the trained `dp_model.ckpt` file in a LAMMPS simulation, extract the deployable force field with the following command:
```
MatPL script dp_model.ckpt
```
After successful conversion, you will obtain the `jit_dp.pt` force-field file.

**Step 2. Prepare the input control file**

Configure the force field in the LAMMPS input control file as shown below. This example uses HfO2 ([`HfO2/dp_demo/dp_lmps`](https://github.com/LonxunQuantum/MatPL/blob/master/example/HfO2/dp_demo/dp_lmps)).

``` bash
pair_style   matpl/dp   jit_dp.pt
pair_coeff   * *     8 72
```

Here:
- `pair_style` sets the path to the force-field file. `matpl/dp` is the required style name for a MatPL force field, and `jit_dp.pt` is the force-field path.

  The interface also supports model-deviation output from multiple models, a feature commonly used in active learning. You can specify several models: the first is used for MD, while the others participate in the deviation calculation. In that case, configure `pair_style` as follows:
  ```txt
  pair_style   matpl/dp    0_jit_dp.pt 1_jit_dp.pt 2_jit_dp.pt 3_jit_dp.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
  pair_coeff   * *     8 72
  ```

- `pair_coeff` maps the atom types in the simulated structure to atomic numbers. For example, if type `1` is `O` and type `2` is `Hf`, use `pair_coeff * * 8 72`.

**Step 3. Start the LAMMPS simulation**

``` bash
# Load the LAMMPS env.sh environment file; after installation, it is located in the LAMMPS source root
source /the/path/of/lammps/env.sh
# Run LAMMPS
mpirun -np N lmp -in in.lammps
```
Here, `N` is the number of CPU cores used for MD. If the system has `M` available GPUs, the `N` LAMMPS processes are distributed evenly across those GPUs. We recommend using the same number of CPU cores and GPUs, because multiple processes sharing one GPU compete for resources and reduce performance.

The LAMMPS interface also supports multi-node parallelism, including GPUs across nodes; specify the required numbers of nodes and GPUs in your job configuration.

### ASE Interface

The DP model provides an ASE interface. See the example scripts on [Gitee](https://gitee.com/pfsuo/MatPL/tree/main/example/ase_calculator/test_dp) or [GitHub](https://github.com/LonxunQuantum/MatPL/tree/main/example/ase_calculator/test_dp).

```python
from src.ase.calculate import MatPL_calculator
calc = MatPL(model_file='dp_model.ckpt')
atoms = ..... # Create ase.atoms.Atoms
atoms.calc = calc # Or use atoms.set_calculator(calc)
energy = atoms.get_potential_energy()
forces = atoms.get_forces()
stress = atoms.get_stress()
```
Before using the ASE interface, make sure the [MatPL environment variables](../../install/README.md) have been loaded.
