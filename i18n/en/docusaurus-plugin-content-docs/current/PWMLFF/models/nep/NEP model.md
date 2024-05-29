---
sidebar_position: 1
---

## NEP Model

The NEP model was initially implemented in the GPUMD software package ([2022b NEP4 GPUMD](https://doi.org/10.1063/5.0106617)). In GPUMD, NEP training uses the [separable natural evolution strategy (SNES)](https://doi.org/10.1145/2001576.2001692), which is simple to implement as it does not rely on gradient information. However, for standard supervised learning tasks, especially deep learning, gradient-based optimization algorithms are more suitable. In `PWMLFF 2024.5`, we have implemented the NEP model (NEP4, with the network structure shown in Figure 1), which can be trained using the gradient-based LKF or ADAM optimizers in PWMLFF. We have also implemented the Lammps molecular dynamics interface for the NEP model, supporting both `CPU` and `GPU` devices.

We compared the training efficiency of LKF and SNES optimization methods across various systems. The test results show that the LKF optimizer demonstrates superior training accuracy and convergence speed in training the NEP model. The NEP model's network structure has only a single hidden layer, offering very fast inference speed, while the LKF optimizer significantly improves training efficiency. Users can obtain high-quality NEP at a low training cost using PWMLFF and utilize it for efficient machine learning molecular dynamics simulations, which is very friendly for users with limited resources or budget.

<div style={{ display: 'inline-block', marginRight: '10px' }}>
  <img src={require("./pictures/nep_net.png").default} alt="nep_net" width="300" />
</div>

The NEP network structure features independent but identical sub-neural networks for different types of elements. Additionally, unlike the NEP4 network structure in the literature, the bias of the last layer is not shared among sub-networks for each layer's bias. We also use the same `cutoff` for multi-body descriptors as for two-body descriptors.

## NEP Command List
1. `train` command: Used for training NEP, similar to DP, NN, and Linear models. For detailed usage, refer to [NEP Model Training](#nep-模型训练).
```bash
PWMLFF train nep.json 
```

2. Python test interface: We provide `infer` and `test` commands, see [Python inference](#python-inference).

`infer` command: Calls the trained model for single structure energy, force, and virial inference.
```bash
PWMLFF infer nep_model.ckpt atom.config pwmat/config
```
`test` command: Used for inference with labeled data (energy, force, virial) in MOVEMENT (PWmat), OUTCAR (VASP), and pwdata formats. Usage is similar to the DP model.
```bash
PWMLFF test nep_test.json
```

3. `topwmlff` command: Converts the NEP.txt force field file trained by GPUMD to PWMLFF Pytorch format.
```bash
PWMLFF topwmlff nep.txt nep.in
```

4. `script` command: Converts the force field file trained by PWMLFF to Lammps input format, similar to the DP model.
```bash
PWMLFF script nep_model.ckpt
```

## NEP Model Training

Here we take an HfO2 dataset as an example, located at [[PWMLFF_nep/example/NEP]](https://github.com/LonxunQuantum/PWMLFF/tree/dev_nn_nep/example/NEP).

### Input File Setup

The input file for training the NEP model is similar to those for Linear, NN, and DP models. You need to prepare an input control JSON file. The simplest input setup is shown below, specifying the model type as `NEP`, the atom type order, and the list of MOVEMENT files or pwdata format for training. LKF optimizer will be used for training. Here, pwdata format dataset is used as an example.

```json 
{
    "model_type": "NEP",
    "atom_type": [8, 72],
    "max_neigh_num": 100,
    "datasets_path": [
      "./pwdata/init_000_50/",
      "...."
    ]
}
```

If you need to use the MOVEMENT format, use the input setup below:
```json
{
  "model_type": "NEP",
  "atom_type": [8, 72],
  "raw_files": [
    "./mvm_19_300/MOVEMENT",
    "..."
  ]
}
```

It is recommended to convert the data to pwdata format before training. You can use the [pwdata conversion tool](../../Appendix-2.md#直接结合-pwmlff-使用) or the `to_pwdata` conversion command provided in pwact active learning as shown below:

```bash
# pwact command to convert MOVEMENT to pwdata format
pwact to_pwdata -i mvm_init_000_50 mvm_init_001_50 mvm_init_002_50 -s pwdata -f pwmat/movement -r -m -o 0.8
# -i structure file list
# -f structure file format, supports pwmat/movement or vasp/outcar
# -s directory name to save
# -r specify to save data in random order
# -m specify to merge converted data, use this if the MOVEMENT file list has the same element types and number of atoms
# -o specify the training and test set split ratio, default is 0.8
```
If your conda environment does not have `pwact` installed, use the following command to install it online, or refer to the [pwact manual](../../active%20learning/README.md).

```bash
pip install pwact
```

### NEP Configuration Parameters

For details on NEP parameters, refer to the [NEP Parameter Manual](../../Parameter%20details.md#nep-model).

## Training

To train the NEP model, simply run the following command in the directory where `nep.json` is located. For example, in [ [PWMLFF_nep/example/NEP] ](https://github.com/LonxunQuantum/PWMLFF/tree/dev_nn_nep/example/NEP):

```bash
cd /example/NEP
PWMLFF train train.json
# If you use sbatch train.job, remember to modify the environment variables in the job file to match your own.
```


### Training Output Files

After the training is completed, a directory `model_record` will be generated in the current directory, containing the following five files:
`nep.txt`, `nep.in`, `nep_model.ckpt`, `epoch_valid.dat`, `epoch_train.dat`.

- `nep_model.ckpt`: The PWMLFF format force field file after training.
- `nep.txt` and `nep.in`: The GPUMD version of the force field file.
- `epoch_valid.dat` and `epoch_train.dat`: Loss record files during the training process.

## Python Inference

This section introduces how to use the trained NEP model to predict the properties of new atomic structures. The trained model can be used to predict the properties of new atomic structures, such as the system's energy, forces, and stresses, as shown in the following example.

In the `example/NEP` directory, we have prepared the `atom.config` file. Use the `infer` command:
```bash
PWMLFF infer model_record/nep_model.ckpt atom.config pwmat/config
```
After execution, the predicted energy, forces, and virial will be output on the screen.

In the `example/NEP` directory, we have prepared the `test.json` file. Use the `test` command:
```bash
PWMLFF test test.json

# If running sbatch test.job, please replace the environment variables with your own.
```

For the `test.json` file, as shown below:
```json
{
    "model_type": "NEP",
    "atom_type": [8, 72],
    "model_load_file":"./model_record/nep_model.ckpt",
    "format":"pwmat/movement",
    "raw_files":["./mvms/mvm_init_000_50"],
    "datasets_path": ["./pwdata/init_000_50", "./pwdata/init_001_50/valid"]
}
```
- `model_load_file`: The path to the trained `nep_model.ckpt` file.
- `format`: The format of the structure files in `raw_files`.
- `raw_files`: The path to the original structure files.

Users can also use the `pwmlff/npy` format structures directly in `datasets_path`.

For example, for the example `pwmlff/npy` file structure, all structures in the `train` training set and the `valid` test set under the `./pwdata/init_000_50` directory will be used for inference; the structures in the `./pwdata/init_001_50/valid` test set will be used for inference.

Both `raw_files` and `datasets_path` can be used simultaneously.

## NEP for Lammps

We provide the NEP Lammps interface, supporting simulations on CPUs (single-core or multi-core) and GPUs (single-card or multi-card).

### Input File Setup

To use the `nep_model.ckpt` force field file generated after training for Lammps simulations, you need to:

### Step 1: Convert the force field file to libtorch format by entering the following command:
```bash
PWMLFF script nep_model.ckpt
```
After a successful conversion, you will get a force field file named `jit_nep_module.pt`.

### Step 2: Lammps input file setup

To use the force field file generated by PWMLFF, the Lammps input file is set up as follows:
```bash
pair_style   pwmlff   1 jit_nep_module.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
pair_coeff       * * 8 72
```

### Step 3: Start the Lammps simulation

If your `jit_nep_module.pt` file is converted by a GPU node, you can use the following GPU startup command:
```bash
mpirun -np 1 lmp_mpi_gpu -in in.lammps
# 1 indicates using 1 GPU core; you can modify it according to actual resource availability.
```

If your `jit_nep_module.pt` file is converted by a CPU node, please use the following CPU startup command:
```bash
mpirun -np 64 lmp_mpi -in in.lammps
# 64 indicates using 64 CPU cores; you can modify it according to actual resource availability.
```

### About Lammps Environment Variables

To run Lammps, you need to import the following environment variables, including your PWMLFF path and the Lammps path:
```bash
# Load CUDA
module load cuda/11.8 intel/2020

# Load your conda environment variables
source /the/path/anaconda3/etc/profile.d/conda.sh
conda activate torch2_feat

# Load your PWMLFF environment variables
export PATH=/the/path/codespace/PWMLFF_nep/src/bin:$PATH
export PYTHONPATH=/the/path/codespace/PWMLFF_nep/src/:$PYTHONPATH

# Load your Lammps environment variables
export PATH=/the/path/codespace/lammps_nep/src:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```



## About NEP Model Test Results

### LKF Optimizer is More Suitable for NEP Models

We tested various systems, using 80% of the dataset as the training set and 20% as the validation set. We trained the NEP model on the publicly available HfO2 training set (containing 2200 structures of the P21/c, Pbca, Pca21, and P42/nmc phases) using both LKF and evolutionary algorithms (SNES, GPUMD), with the validation error shown in Figure 2 below. As training epochs increase, the LKF-based NEP model converges to a lower error (lower error means higher accuracy) faster than SNES. Similar results were found in the aluminum system (including 3984 structures) (Figure 3). Additionally, we observed similar results in the LiGePS system and the quinary alloy system. For more detailed data, please refer to the uploaded training and test data.


<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/hfo2_lkf_snes_energy.png").default} alt="hfo2_lkf_snes_energy" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/hfo2_lkf_snes_force.png").default} alt="hfo2_lkf_snes_force" width="300" />
  </div>
  <p>Convergence of energy (left) and force (right) for the NEP model with LKF and SNES optimizers on the HfO2 system (2200 structures). The dashed line indicates the lowest loss level achievable by the SNES algorithm.</p>

  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/al_lkf_snes_energy.png").default} alt="al_lkf_snes_energy" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/al_lkf_snes_force.png").default} alt="al_lkf_snes_force" width="300" />
  </div>
    <p>Convergence of energy (left) and force (right) for the NEP model with LKF and SNES optimizers on the Al system (3984 structures). The dashed line indicates the lowest loss level achievable by the SNES algorithm.</p>
</div>

### Accuracy Comparison Between NEP Models and Deep Potential Models in PWMLFF

Deep Potential (DP) models are a widely used type of neural network model. PWMLFF implements a Pytorch version of the DP model, which can also use the LKF optimizer. We compared the training of NEP models and DP (PWMLFF) models using the LKF optimizer across multiple systems, as shown in Figure 4. In Al, HfO2, LiGePS (containing 10,000 structures), and quinary alloy systems [Ru, Rh, Ir, Pd, Ni] (containing 9486 structures), NEP models in PWMLFF converge faster and with higher accuracy than DP models. Notably, for the quinary alloy, we used type embedding DP to reduce the impact of the number of elements on the training speed. (In previous tests, we found that introducing type embedding in PWMLFF DP training for more than five elements can achieve higher accuracy than regular DP.)

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/NEP_Al.png").default} alt="al1" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/NEP_HfO2.png").default} alt="hfo2" width="300" />
  </div>
  <p></p>
  <div style={{ display: 'inline-block' }}>
    <img src={require("./pictures/NEP_Alloy.png").default} alt="Alloy" width="300" />
  </div>
  <div style={{ display: 'inline-block' }}>
  <img src={require("./pictures/NEP_LiGePS.png").default} alt="LiGePS" width="300" />
  </div>
</div>

NEP and DP models' training error convergence with the LKF optimizer.

### Test Data
Test data and models have been uploaded. You can download them from our [Baidu Cloud link](https://pan.baidu.com/s/1beFMBU1IehmNEpIQ9B8ybg?pwd=pwmt) or our [open source dataset repository](https://github.com/LonxunQuantum/PWMLFF_library/tree/main/PWMLFF_NEP_test_examples).
