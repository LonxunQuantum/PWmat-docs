---
sidebar_position: 2
title: NEP Tutorial
---

## NEP Tutorial
This tutorial uses the MatPL [`source root/example/HfO2/nep_demo`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo) example ([source of the HfO2 training dataset](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)) to demonstrate training, testing, LAMMPS simulation, and other operations for an NEP model. The current example directory is organized as follows:

``` txt
nep_demo/
├── nep_kokkos_lmps/
│   ├── kkin.lmp
│   ├── lmp.config
│   ├── nep_to_lmps.txt
│   ├── rungpu_mcloud.job
│   └── rungpu_station.job
├── nep_lmps/
│   ├── in.lmp-cpu-25
│   ├── in.lmp-kk
│   ├── lmp.config
│   ├── nep_to_lmps.txt
│   ├── runcpu_mcloud.job
│   ├── runcpu_station.job
│   ├── rungpu_mcloud.job
│   └── rungpu_station.job
├── nep_lmps_deviation/
│   ├── in.lmp-kk
│   ├── lmp.config
│   ├── nep0.txt
│   ├── nep1.txt
│   ├── nep2.txt
│   ├── nep3.txt
│   ├── rungpu_mcloud.job
│   └── rungpu_station.job
├── nep_test.json
├── nep_train.json
├── train_mcloud.job
└── train_station.job
```

- `nep_train.json` and `nep_test.json` are the NEP training and testing configurations. Their `../pwdata/` paths refer to the `HfO2/pwdata` training-data directory.
- `train_mcloud.job` and `train_station.job` are example Slurm training scripts for Mcloud and a self-managed cluster, respectively.
- `nep_lmps` provides input files and job scripts for both CPU and NEP Kokkos GPU simulations.
- `nep_kokkos_lmps` provides an NEP Kokkos GPU simulation example.
- `nep_lmps_deviation` provides a four-model deviation example for active-learning workflows.
- In each LAMMPS example directory, `lmp.config` is the initial structure; `nep_to_lmps.txt` or `nep*.txt` are NEP force-field files; `*.lmp*` are LAMMPS input files; and `*.job` are Slurm job scripts.


### train

Run the following command in the `nep_demo` directory to start training:
``` bash
MatPL train nep_train.json
# Alternatively, adapt the Slurm script to the environment and submit it
sbatch train_mcloud.job
# On a self-managed cluster, use sbatch train_station.job
```

**Input file description**

The contents of `nep_train.json` are shown below. For descriptions of the NEP parameters, see the [NEP Parameter Reference](../../parameterdetail.md#nep-model-hyperparameters):
``` json
{
    "model_type": "NEP",
    "atom_type": [
        8, 72
    ],
    "optimizer": {
        "optimizer": "ADAM",
        "epochs": 30, 
        "batch_size": 1,
        "print_freq": 10,
        "train_energy": true,
        "train_force": true,
        "train_virial": true
    },

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

### Multi-Node, Multi-GPU Training
Multi-node, multi-GPU training uses the same directory structure. See the MatPL [`source root/example/parallelnep`](https://github.com/LonxunQuantum/MatPL/tree/main/example/parallelnep) example ([source of the HfO2 training dataset](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)).

The directory provides three example launch scripts for Mcloud users: `1node-1g-run.job` for one GPU on one node, `1node-4g-run.job` for multiple GPUs on one node, and `2node-8g-run.job` for multiple nodes and GPUs.
For an online installation, see `env.sh` for the MatPL-2026.3 environment setup.

Multi-node, multi-GPU training requires the `address of the primary node` and an `available port`. We recommend obtaining them automatically with the following shell commands:
```bash
MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
# Dynamically allocate an available port
function get_free_port() {
    python -c 'import socket; s = socket.socket(socket.AF_INET, socket.SOCK_STREAM); s.bind(("", 0)); print(s.getsockname()[1]); s.close()'
}
MASTER_PORT=$(get_free_port)

export MASTER_ADDR=$MASTER_ADDR
export MASTER_PORT=$MASTER_PORT

echo "addrs: $MASTER_ADDR"
echo "port:  $MASTER_PORT"
echo "tasks: $SLURM_NTASKS"

srun MATPL train train.json 
```

:::caution
Multi-GPU NEP training supports only the ADAM optimizer; LKF and GKF are not supported.
:::

### test

The `test` command accepts a MatPL `nep_model.ckpt` force field as well as `nep5.txt` and `nep4.txt` files used by LAMMPS or GPUMD.

``` bash
MatPL test nep_test.json
```
The contents of `test.json` are shown below. For parameter descriptions, see the [Parameter Reference](../../parameterdetail.md).
```json
{
    "model_type": "NEP",
    "format": "pwmlff/npy",
    "model_load_file": "./model_record/nep_model.ckpt",
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
For details about the output directory generated after testing, see [test_result details](../../matpl-cmd.md#test).

### infer a Single Structure

The `infer` command accepts a MatPL `nep_model.ckpt` file, a GPUMD `nep4.txt` file, or a `nep5.txt` file shared by LAMMPS and GPUMD.

``` bash
MatPL infer nep_model.ckpt atom.config pwmat/config
MatPL infer gpumd_nep.txt 0.lammpstrj lammps/dump Hf O
# Hf and O are the element names in the lammps/dump structure: Hf is atom type 1 and O is atom type 2
```
After successful inference, the terminal displays the total energy, per-atom energies, per-atom forces, and virial.

### totxt: Convert a Trained Checkpoint to nep5.txt

This command converts a `nep_model.ckpt` trained by MatPL to a text-format `nep5.txt` file for molecular-dynamics simulations in GPUMD or lammps-MatPL.

``` bash
MatPL totxt nep_model.ckpt
```
When successful, it creates `nep5.txt` in the current directory.

### lammps MD

The HfO2 example provides separate directories for a single model, NEP Kokkos, and multi-model deviation calculations. The workflow below proceeds through preparing the force field, choosing an example, editing the input, and launching the simulation.

#### 1. Prepare the Force-Field File

After normal training, `nep5.txt` is generated in `model_record` and can be used directly in LAMMPS. If only `nep_model.ckpt` is available, convert it with the `totxt` command described above:

```bash
MatPL totxt nep_model.ckpt
```

Copy the generated `nep5.txt` to the selected example directory and name it `nep_to_lmps.txt` as referenced by the input script. lammps-MatPL also supports GPUMD NEP4 and NEP5 force-field files.

#### 2. Select a LAMMPS Example

| Example directory | Purpose | Main input files |
| --- | --- | --- |
| [`nep_lmps`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo/nep_lmps) | CPU and NEP Kokkos GPU simulations | `in.lmp-cpu-25`, `in.lmp-kk` |
| [`nep_kokkos_lmps`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo/nep_kokkos_lmps) | NEP Kokkos GPU simulation | `kkin.lmp` |
| [`nep_lmps_deviation`](https://github.com/LonxunQuantum/MatPL/tree/main/example/HfO2/nep_demo/nep_lmps_deviation) | Four-model deviation calculation | `in.lmp-kk`, `nep0.txt`–`nep3.txt` |

Each directory provides both `*_mcloud.job` and `*_station.job`. Select the appropriate script and update module names, software paths, partitions, and GPU resource parameters for your environment.

#### 3. Configure the LAMMPS Input File

The NEP Kokkos GPU interface uses a half neighbor list with Newton communication enabled. The essential settings for the single-model HfO2 example are:

```lammps
package kokkos neigh half comm device
newton on

pair_style   matpl/nep/kk nep_to_lmps.txt
pair_coeff   * * 72 8
```

List the elements after `pair_coeff * *` in the atom-type order used by the data file. Element symbols or atomic numbers are both accepted. In this example, type `1` is Hf (`72`) and type `2` is O (`8`).

In the multi-model example, the first model drives MD while the others participate in the deviation calculation:

```lammps
pair_style   matpl/nep/kk nep0.txt nep1.txt nep2.txt nep3.txt \
             out_freq ${DUMP_FREQ} out_file model_devi.out
pair_coeff   * * 72 8
```

`out_freq` sets the deviation-output frequency, and `out_file` sets the output filename. For complete NPT control parameters, refer directly to `in.lmp-kk`, `in.lmp-cpu-25`, or `kkin.lmp` in the examples.

#### 4. Start the LAMMPS Simulation

From the example directory, submit the Slurm script appropriate for the runtime environment, for example:

```bash
sbatch rungpu_mcloud.job
# or
sbatch rungpu_station.job
```

You can also run directly after loading the LAMMPS environment:

```bash
# One GPU: nep_kokkos_lmps/kkin.lmp
mpirun -np 1 --bind-to numa lmp -k on g 1 -sf kk -pk kokkos -in kkin.lmp

# Four GPUs on one node: nep_lmps/in.lmp-kk
mpirun -np 4 --bind-to numa lmp -k on g 4 -sf kk -pk kokkos -in in.lmp-kk

# Two nodes with four GPUs per node
mpirun -np 8 --bind-to numa --map-by ppr:4:node \
    lmp -k on g 4 -sf kk -pk kokkos -in in.lmp-kk
```

When using the closed-source MatPL Pro version, set `NEP_GPU_LIB_PATH` and `NEP_LICENSE_PATH` before running. For multi-node jobs, every node must be able to access the shared library, license, input files, and force-field files.

#### MatPL Heat-Flux Calculation

> **Interface distinction:** The open-source version uses `matpl/heatflux`; the closed-source MatPL Pro version uses the Kokkos GPU heat-flux interface `matpl/heatflux/kk`. Select the command that matches the installed lammps-MatPL interface.

For the open-source version, configure the heat-flux compute as follows:

```lammps
compute      flux all matpl/heatflux
```

In the closed-source MatPL Pro version, `matpl/heatflux/kk` calculates MatPL heat flux directly on the GPU and does not require the conventional `ke/atom + pe/atom + centroid/stress/atom + heat/flux` post-processing chain:

```lammps
package kokkos neigh half comm device
newton on

pair_style   matpl/nep/kk nep.txt
pair_coeff   * * C

compute      flux all matpl/heatflux/kk
fix          fluxout all matpl/heatflux/ave/kk 10 100 1000 flux file compute_HeatFlux.out
```

`compute matpl/heatflux/kk` outputs a global vector with six components:

1. `Jx`: total heat flux in the x direction.
2. `Jy`: total heat flux in the y direction.
3. `Jz`: total heat flux in the z direction.
4. `Jconv,x`: convective heat flux in the x direction.
5. `Jconv,y`: convective heat flux in the y direction.
6. `Jconv,z`: convective heat flux in the z direction.

The virial contribution to heat flux is therefore the total heat flux minus the convective heat flux: `(1-4, 2-5, 3-6)`. `fix matpl/heatflux/ave/kk` time-averages the heat-flux vector and writes the results to `compute_HeatFlux.out`.

#### Heat-Flux Examples

- [Open-source Heat_flux example](https://github.com/LonxunQuantum/lammps-MatPL/tree/main/examples/Heat_flux)
- [Closed-source MatPL Pro Heat_flux example](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/Heat_flux)


### ASE Interface
The NEP model provides an ASE interface. See the example scripts on [Gitee](https://gitee.com/pfsuo/MatPL/tree/main/example/ase_calculator/test_nep) or [GitHub](https://github.com/LonxunQuantum/MatPL/tree/main/example/ase_calculator/test_nep).

```python
from src.ase.calculate import MatPL_calculator
calc = MatPL(model_file='nep_model.ckpt or nep.txt')
atoms = ..... # Create ase.atoms.Atoms
atoms.calc = calc # Or use atoms.set_calculator(calc)
energy = atoms.get_potential_energy()
forces = atoms.get_forces()
stress = atoms.get_stress()
```
Before using the ASE interface, make sure the [MatPL environment variables](../../install/README.md) have been loaded.

<!-- ## NEP Model Training Benchmarks

Replace with the latest results; consider moving the benchmark results to the NEP README that introduces the NEP methodology. -->

<!-- We tested multiple systems, using 80% of each dataset for training and 20% for validation. On the public HfO2 dataset (2,200 structures covering the P21/c, Pbca, Pca21, and P42/nmc phases), we trained NEP models with LKF and with the evolutionary SNES algorithm in GPUMD. Figure 2 shows the validation errors. As the epoch count increases, LKF-based NEP converges faster than SNES and reaches a lower error. The aluminum system (3,984 structures) shows similar behavior in Figure 3. Similar results were obtained for LiGePS and the five-component alloy; see the uploaded training and test data for details.

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/hfo2_lkf_snes_energy.png").default} alt="hfo2_lkf_snes_energy" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/hfo2_lkf_snes_force.png").default} alt="hfo2_lkf_snes_force" width="300" />
  </div>
  <p>Energy (left) and force (right) convergence for NEP models trained with LKF and SNES on the HfO2 system (2,200 structures). The dashed line marks the lowest loss reached by SNES.</p>

  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/al_lkf_snes_energy.png").default} alt="al_lkf_snes_energy" width="300" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/al_lkf_snes_force.png").default} alt="al_lkf_snes_force" width="300" />
  </div>
  <p>Energy (left) and force (right) convergence for NEP models trained with LKF and SNES on the Al system (3,984 structures). The dashed line marks the lowest loss reached by SNES.</p>
</div> -->

<!-- 
### Accuracy Comparison Between NEP and Deep Potential in MatPL

Deep Potential (DP) is a widely used neural-network model. MatPL implements DP in PyTorch and supports the LKF optimizer. We compared LKF training of NEP and MatPL DP models on several systems, as shown in Figure 4. For Al, HfO2, LiGePS (10,000 structures), and the five-component [Ru, Rh, Ir, Pd, Ni] alloy (9,486 structures), NEP converges faster and reaches higher accuracy than DP. For the five-component alloy, we used type-embedding DP to reduce the effect of the number of elements on training speed; earlier tests showed that type embedding can also improve DP accuracy for systems containing five or more elements.

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
Training-error convergence of NEP and DP models with the LKF optimizer. -->


<!-- ### Test Data
The test data and models have been uploaded. Download them from [Baidu Netdisk](https://pan.baidu.com/s/1beFMBU1IehmNEpIQ9B8ybg?pwd=pwmt) or visit our [open-source dataset repository](https://github.com/LonxunQuantum/MatPL_library/tree/main/PWMLFF_NEP_test_examples). -->

<!-- 
## LAMMPS Interface Benchmark Results
The figure below shows NPT-ensemble MD performance of the NEP LAMMPS CPU and GPU interfaces on a machine with `4 × RTX 3090` GPUs. CPU-interface performance scales with system size and CPU core count, while GPU-interface performance scales with system size and GPU count.

Based on these results, we recommend the CPU interface for systems below approximately $10^3$ atoms. When using the GPU interface, use the same number of CPU cores and GPUs.

<div style={{ display: 'inline-block', marginRight: '10px' }}>
  <img src={require("./pictures/lmps_speed.png").default} alt="nep_net" width="500" />
</div> -->
