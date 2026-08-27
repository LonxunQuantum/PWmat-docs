---
sidebar_position: 1
title: Installation Guide
---
# Installation Guide

## Offline and Online Installation

MatPL-2026.3 provides both [offline installation](./Installation-offline.md) and [online installation](./Installation-online.md). The offline package includes the complete Python runtime, eliminating the time required to install the Python environment separately.

For users of [Lonxun Supercomputing Cloud](https://mcloud.lonxun.com/) (`Mcloud`) or a `Lonxun integrated appliance`, MatPL is preinstalled and only needs to be loaded as shown below.

:::tip
The primary difference between MatPL-2026.3 and MatPL-2025.3 is the extensive optimization of NEP. For single-GPU training, optimized gradient operators provide a `more than threefold speedup` over MatPL-2025.3. Multi-node, multi-GPU large-batch training has also been introduced, together with measures that mitigate the loss of accuracy associated with large batches, substantially improving efficiency on large training datasets.

Because this release does not improve CPU-only training or simulation, no online or offline CPU package is provided for MatPL-2026.3. CPU-only users should use [MatPL-2025.3-cpu](http://doc.lonxun.com/2025.03/MatPL/install/).
:::

### Lonxun Supercomputing Cloud (Mcloud) Users

``` bash
# Load MatPL
source /share/app/MATPL/MatPL-2026.3/env.sh

# Alternatively, load it step by step as follows
# Step 1: Load the Python runtime
# Load Conda
module load conda/3-2020.07
eval "$(conda shell.bash hook)"
# Activate the Python environment
conda activate matpl-2026.3
# Step 2: Load MatPL
module load matpl/2026.3
```

```bash
# Load LAMMPS
module load lammps4matpl/2026.3
# For Linear and NN models, load the CPU LAMMPS interface implemented in Fortran
module load lammps4matpl/fortran
```

### Lonxun Integrated Appliance (GPU) Users

``` bash
# Load MatPL and LAMMPS
module load cuda/11.8 openmpi/4.1.6 # OpenMPI is required to run LAMMPS
# Replace this with the actual installation path
source /share/app/MATPL/MatPL-2026.3/matpl-env.sh
```

```bash
# For Linear and NN models, load the CPU LAMMPS interface implemented in Fortran
module load intel/2020
source /share/app/MATPL/MatPL-2026.3/matpl-fortran-env.sh
```

### Lonxun Integrated Appliance (CPU) Users

This release does not improve CPU-only training or simulation, so no online or offline CPU package is provided for MatPL-2026.3. CPU-only users should use [MatPL-2025.3](http://doc.lonxun.com/2025.03/MatPL/install/).


:::tip
The `lammps4matpl/2026.3 module on the Mcloud platform` and the `offline installation package` include the following commonly used LAMMPS packages:

`CG-SPICA`  `CLASS2`  `COLLOID` `COLVARS`  `COMPRESS`  `CORESHELL` `DIELECTRIC` `DIFFRACTION`  `DIPOLE`  `DPD-BASIC` `DPD-MESO` `DPD-REACT`  `DPD-SMOOTH`  `DRUDE` `EFF`  `ELECTRODE` `EXTRA-COMMAND`  `EXTRA-COMPUTE` `EXTRA-FIX`  `EXTRA-DUMP`  `EXTRA-MOLECULE`  `EXTRA-PAIR`  `FEP` `GRANULAR` `INTEL`  `INTERLAYER`  `KSPACE`  `LATBOLTZ`  `LEPTON`  `MANIFOLD`  `MANYBODY`  `MC`  `MEAM`  `MGPT`  `MISC`  `MOFFF` `MOLECULE` `MOLFILE`  `OPENMP`  `OPT` `ORIENT` `PERI` `PHONON` `PLUMED` `POEMS`  `PTM` `PYTHON` `QEQ`  `QMMM`  `QTB` `REACTION` `REAXFF` `REPLICA`  `RIGID` `SHOCK`  `SMTBQ` `SPH`  `SPIN`  `SRD` `TALLY`  `UEF` `VORONOI`  `YAFF` 

Run `lmp -h` to list all compiled pair styles.
:::

