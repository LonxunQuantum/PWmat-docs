---
sidebar_position: 1
title: Offline Installation
---
## Offline Installation

For [Lonxun Supercomputing Cloud](https://mcloud.lonxun.com/) (`Mcloud`) users, MatPL is preinstalled and [ready to load](./README.md). The offline package provides a GPU version.

- The offline package bundles MatPL-2026.3, the open-source MatPL-2026.3 LAMMPS interface, and the required Python environment. The target machine must provide `GCC 8.x or later`, `CUDA 11.8 or later`, `OpenMPI 4.1.4 or later`, and an `NVIDIA GPU`. `NN and Linear models additionally require the Intel toolchain (ifort, icc, and MKL).`

- Because MatPL-2026.3 does not improve CPU-only training or simulation, no online or offline CPU package is provided. CPU-only users should use [MatPL-2025.3](http://doc.lonxun.com/2025.03/MatPL/install/).

- The offline package includes PyTorch 2.2. The latest package is `matpl-2026.3-update3`. Compared with update1, it adds type-wise ZBL support to NEP, accelerates LAMMPS NEP Kokkos on NVIDIA GPUs, and extends the six-component LAMMPS Kokkos virial to nine components to support heat-flux calculations. The bundled LAMMPS version is `stable_22Jul2025_update4`.

<!-- - `Offline update package`: If MatPL-2026.3 is already installed, subsequent updates can be applied with the provided patch package, avoiding reinstallation of the large Python runtime. The package contains only updated code (approximately 6 MB) and recompiles only changed modules, reducing installation time. -->

### Download the Offline Package
Method 1 (recommended): Request the package by email from `matpl@pwmat.com`, `wuxingxing@pwmat.com`, or `support@pwmat.com`. Downloads from the emailed link are significantly faster than from Baidu Netdisk.

Method 2: Download from Baidu Netdisk. If the link expires, contact `matpl@pwmat.com`, `wuxingxing@pwmat.com`, or `support@pwmat.com`:
👉 [Download the offline package](https://pan.baidu.com/s/1dyaLxTKbOIu8JRZB3WvOfQ?pwd=pwmt). Access code: `pwmt`.

<!-- 👉 [Download offline patch packages](https://pan.baidu.com/s/1veyMqqX5g0Ie5NEL3xU0Zw?pwd=pwmt). Access code: pwmt. -->

Method 3: Visit the [MatPL-2026.3_update3 GitHub release](https://github.com/LonxunQuantum/MatPL/releases/tag/MatPL-2026.3_update3) and download the following files:
```txt
matpl-2026.3-update3.sh.tar.gz.part_aa  matpl-2026.3-update3.sh.tar.gz.part_ab  matpl-2026.3-update3.sh.tar.gz.part_ac  matpl-2026.3-update3.sh.tar.gz.part_ad  matpl-2026.3-update3.sh.tar.gz.part_ae
```

### Extract the Package

Because the offline package is large, it is split into several smaller files. Reassemble and extract it as follows:

```bash
# Combine the parts into one archive
cat matpl-2026.3-update3.sh.tar.gz.part_aa  matpl-2026.3-update3.sh.tar.gz.part_ab  matpl-2026.3-update3.sh.tar.gz.part_ac  matpl-2026.3-update3.sh.tar.gz.part_ad  matpl-2026.3-update3.sh.tar.gz.part_ae > matpl-2026.3-update3.sh.tar.gz
# Extract the archive
tar -xzvf matpl-2026.3-update3.sh.tar.gz
```
Extraction produces the following files:
`matpl-2026.3-update3.sh`， `check_offenv.sh`

<!-- Patch packages do not need to be extracted and can be installed directly with bash. -->

### Check Compiler Versions

Most installation failures result from incompatible compiler versions. Use the provided `check_offenv.sh` script to inspect the environment:

```bash
bash check_offenv.sh
```

The script lists the required compiler versions and those detected in the current environment. A valid result looks like this:

```txt
========================================
      Environment Check Starting
========================================

=== Checking ifort compiler and MKL library ===
✓ ifort version: 19.1 (>= 19.1)
✓ MKL library is installed

=== Checking GCC version ===
✓ GCC version: 8 (>= 8.0)

=== Checking CUDA version ===
✓ CUDA version: 11.8.89 (>= 11.8)

=== Checking nvcc availability ===
✓ nvcc command exists

=== Checking OpenMPI ===
✓ OpenMPI found (via ompi_info), version: 4.1.6
✓ OpenMPI version meets requirement (>= 4.0)

========================================
        Environment Summary
========================================
✓ Environment check completed. All requirements are satisfied.
========================================
```

### Run the Installation Command
After the environment check, install the package with:

```bash
bash matpl-2026.3-update3.sh [-jN] [-m nn] [-a ARCH] [-d] [-u] [-h]
```

<!-- For a patch package, run:
```bash
bash patch-package-name.sh [-jN] [-m nn] [-a ARCH] [-d] [-u] [-h]
``` -->

- `-jN`: `N` is the number of parallel compilation cores. For example, `bash matpl-2026.3-update3.sh -j4` uses four cores. The default is one core.

- `-m nn`: Also compiles the Fortran code for Linear and NN models. This requires Intel ifort, icc, and MKL. Fortran code is not compiled by default.

- `-a ARCH`: Selects the Kokkos CUDA architecture used to build `lammps-2026.3`. The default is `AMPERE86`. For example:
  ```bash
  bash matpl-2026.3-update3.sh -a AMPERE80
  ```
  `ARCH` is a Kokkos CUDA architecture suffix, such as `AMPERE80`, `AMPERE86`, `ADA89`, or `HOPPER90`. For additional architectures, see https://docs.lammps.org/Build_extras.html#kokkos.

- `-d`: Enables 64-bit-precision NEP inference when building `lammps-2026.3`:
  ```bash
  -DPREC_NEPINFER=ON
  ```
  When enabled, `lammps-2026.3` is built in `build-64`. By default, this option is disabled and the build directory is `build`.

- `-u`: Extracts the package without building it, for environments that require installation in separate stages. The extracted contents include the `lammps-2026.3` source directory, the `MatPL-2026.3` source directory, and the `matpl-2026.3` Python environment.

To verify the installation:

After compilation, the `MatPL-2026.3` directory has the following structure:

```txt
MatPL-2026.3
    ├── lammps-2026.3/
    ├── matpl-2026.3/
    ├── MatPL-2026.3/
    └── matpl-env.sh
```

- `MatPL-2026.3` is the machine-learning force-field training platform.
- `matpl-2026.3` is the Python environment.
- `lammps-2026.3` is the LAMMPS interface for DP and NEP force fields.
- `matpl-env.sh` defines all environment variables for MatPL-2026.3 and `lammps-2026.3`.

### Load the Environment

Before using the GPU version of MatPL, load the same CUDA environment used during compilation. NN or Linear training also requires MKL. Then run the following command to load the Python environment, MatPL-2026.3, and LAMMPS:
```bash
source /the/path/of/MatPL-2026.3/matpl-env.sh

# For the Fortran LAMMPS interface:
source /the/path/of/MatPL-2026.3/matpl-fortran-env.sh
```

You can also load each component separately:
```bash
## Step 1. Load the Python environment
source /the/path/MatPL-2026.3/matpl-2026.3/bin/activate
## Step 2. Load MatPL-2026.3
source /the/path/MatPL-2026.3/MatPL-2026.3/env.sh
## Step 3. Load LAMMPS
source /the/path/MatPL-2026.3/lammps-2026.3/env.sh
```

### LAMMPS Packages Included in the Offline Installation

The LAMMPS offline package includes the following commonly used packages:

`CG-SPICA`  `CLASS2`  `COLLOID` `COLVARS`  `COMPRESS`  `CORESHELL` `DIELECTRIC` `DIFFRACTION`  `DIPOLE`  `DPD-BASIC` `DPD-MESO` `DPD-REACT`  `DPD-SMOOTH`  `DRUDE` `EFF`  `ELECTRODE` `EXTRA-COMMAND`  `EXTRA-COMPUTE` `EXTRA-FIX`  `EXTRA-DUMP`  `EXTRA-MOLECULE`  `EXTRA-PAIR`  `FEP` `GRANULAR` `INTEL`  `INTERLAYER`  `KSPACE`  `LATBOLTZ`  `LEPTON`  `MANIFOLD`  `MANYBODY`  `MC`  `MEAM`  `MGPT`  `MISC`  `MOFFF` `MOLECULE` `MOLFILE`  `OPENMP`  `OPT` `ORIENT` `PERI` `PHONON` `PLUMED` `POEMS`  `PTM` `PYTHON` `QEQ`  `QMMM`  `QTB` `REACTION` `REAXFF` `REPLICA`  `RIGID` `SHOCK`  `SMTBQ` `SPH`  `SPIN`  `SRD` `TALLY`  `UEF` `VORONOI`  `YAFF`
