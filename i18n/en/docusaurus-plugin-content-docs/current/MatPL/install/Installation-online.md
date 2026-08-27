---
sidebar_position: 2
title: Online Installation
---
## Online Installation

For [Lonxun Supercomputing Cloud](https://mcloud.lonxun.com/) (`Mcloud`) users, MatPL is preinstalled and [ready to load](./README.md).

An online installation requires building and installing MatPL-2026.3 and its LAMMPS interface separately.

- MatPL-2026.3 is used for model training. The target machine must provide `GCC 8.x or later`, `CUDA 11.8 or later`, `OpenMPI 4.1.4 or later`, and an `NVIDIA GPU`. The Python environment requires Python >= 3.11 and PyTorch >= 2.2.0+cu118.

- NN and Linear models additionally require the Intel toolchain (ifort, icc, and MKL). The `intel/2020` suite provides `ifort` and `icc` version `19.1.3` and MKL. If loading these components separately, use versions no older than these.

- The MatPL-2026.3 LAMMPS interface runs NEP and DP models. Installation and execution require OpenMPI; version `4.1.4` or later is recommended. Two interface variants are available:

  The open-source interface, whose performance is comparable to GPUMD;
  
  The closed-source interface, which is more than twice as fast as the open-source version.

### Build and Install MatPL

To build and run MatPL-2026.3, download the source, create a Conda environment, install the required Python dependencies in that environment, and then compile the source.

In the commands below, `sh` means `bash`. If you invoke scripts with `sh`, verify that it links to `bash`; on some systems it links to `dash` instead.

#### Download the Source
You can clone the repository online or download a source archive.

- Clone the MatPL repository from GitHub or Gitee:
```bash
  git clone https://github.com/LonxunQuantum/MatPL.git MatPL-2026.3
  or
  git clone https://gitee.com/pfsuo/MatPL.git MatPL-2026.3
```

- Alternatively, download a release archive in a browser or with `wget`:
``` bash
  wget https://github.com/LonxunQuantum/MatPL/archive/refs/tags/MatPL-2026.3_update2.zip
  or download from Gitee
  wget https://gitee.com/pfsuo/MatPL/repository/archive/2026.3
```
Extract the downloaded release archive with `unzip`.
``` bash
  ## Extraction creates a source directory named MatPL-MatPL-2026.3_update2
  unzip MatPL-MatPL-2026.3_update2.zip
  mv MatPL-MatPL-2026.3_update2 MatPL-2026.3 # Rename it for consistency with the rest of this guide
```

#### Create a Conda Virtual Environment
Install Anaconda3 if it is not already available, then create a new Python virtual environment. Consult an Anaconda3 installation guide for Linux if necessary.

Download Anaconda3 directly to the server with:
```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
## If the download fails, open the URL below in a browser and upload the downloaded file to the server
## https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh 
## Other versions are available at https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/
```

#### Create the Python Virtual Environment
After installing Conda, create an environment with the `Python 3.11` interpreter. Other versions may cause dependency conflicts or unsupported syntax. Perform all subsequent compilation in this environment.

``` bash
conda create -n matpl-2026.3 python=3.11 setuptools=68.0.0
## Python 3.11 is recommended; newer versions may cause build errors and are not yet supported. Use setuptools below 75.0.0 to avoid NumPy–Fortran data-conversion errors.
```
Activate the environment after creation:
``` bash
conda activate matpl-2026.3
```

#### Install Dependencies in the Python Environment
The required third-party packages are listed in `requirements.txt`. Run `pip` from the directory containing that file to install them. This step installs PyTorch and other packages and may take some time.

- `MatPL-2026.3/requirements.txt` defines the Python environment for the GPU version.

- `MatPL-2026.3/requirements_cpu.txt` defines the Python environment for the CPU version.

```bash
# Step 1: Activate the Conda environment
conda activate matpl-2026.3
# Step 2: Enter the source root
# For a cloned repository, enter MatPL-2026.3
cd MatPL-2026.3
# For the GPU version
pip install -r requirements.txt
# For the CPU version
pip install -r requirements_cpu.txt
```

#### Build and Install: Check the GPU Build Environment
Enter the `src` directory alongside `requirements.txt`.
For the GPU version, verify `GCC 8.x or later`, `CUDA 11.8 or later`, `OpenMPI 4.1.4 or later`, and NVIDIA GPU hardware. `NN and Linear models additionally require the Intel toolchain (ifort, icc, and MKL).` Because compiler-version problems cause most build failures, use `/src/check/check_env.sh` to verify the environment.

``` bash
cd src
bash ./check/check_env.sh
```
The script prints information about the build environment.
```txt
========================================
      Environment Check Starting
========================================

=== Checking ifort compiler and MKL library ===
✓ ifort version: 19.1 (>= 19.1)
✓ MKL library is installed

=== Checking GCC version ===
✓ GCC version: 8 (>= 8.0)

=== Checking PyTorch installation ===
✓ PyTorch is installed

=== Checking PyTorch version ===
✓ PyTorch version: 2.2.0+cu118 (>= 2.0)

=== Checking PyTorch CUDA support ===
✓ PyTorch is compiled with CUDA 11.8

=== Checking CUDA version ===
✓ CUDA version: 11.8.89 (>= 11.8)

=== Checking nvcc availability ===
✓ nvcc command exists

========================================
        Environment Summary
========================================
✓ Environment check completed. All requirements are satisfied.
========================================
```

#### Build and Install: Check the CPU Build Environment
Skip this step for the GPU version. The CPU version does not require CUDA. Run `/src/check/check_env_cpu.sh` to list the required and detected compiler versions:
```
========================================
      CPU Environment Check Starting
========================================

=== Checking ifort compiler and MKL library ===
✓ ifort version: 19.1 (>= 19.1)
✓ MKL library is installed

=== Checking GCC version ===
✓ GCC version: 8 (>= 8.0)

=== Checking PyTorch installation ===
✓ PyTorch is installed

=== Checking PyTorch version ===
✓ PyTorch version: 2.2.0+cu118 (>= 2.0)

========================================
        Environment Summary
========================================
✓ Environment check completed. All requirements are satisfied.
========================================
```

#### Build and Install: Compile the Code

If the environment passes the checks above, compile the code with:
```bash
bash clean.sh
bash build.sh [-jN] [-m nn]
```
- `-jN`: `N` is the number of parallel compilation cores. For example, `sh build.sh -j4` uses four cores. The default `bash build.sh` uses one core.

- `-m nn`: Also compiles the Fortran code for Linear and NN models and requires the Intel compiler. `Fortran code is not compiled by default.`

:::tip
If compilation fails, consult [Common MatPL Installation Errors](./InstallError.md).

If the issue remains unresolved, email the machine-environment details, build log, and the commands you ran to `matpl@pwmat.com`, `wuxingxing@pwmat.com`, or `support@pwmat.com`.
:::
After a successful build, output similar to the following appears:
```
[100%] Linking CXX shared library ../../lib/libCalcOps_bind.so
[100%] Built target CalcOps_bind
Operators built successfully
Creating symbolic links in bin directory...
Created symbolic link for main_MD.x

=================================
MatPL has been successfully installed.
Please load the MatPL environment variables before use.

Recommended method:
  source /data/home/wuxingxing/codespace/MatPL-2025.12-tmp/env.sh

Or manually set environment variables:
  export PYTHONPATH=/data/home/wuxingxing/codespace/MatPL-2025.12-tmp:$PYTHONPATH
  export PATH=/data/home/wuxingxing/codespace/MatPL-2025.12-tmp/src/bin:$PATH
=================================
```
The build creates `env.sh` in the source root. Load the MatPL environment variables with:
```bash
  source /the/path/of/MatPL-2026.3/env.sh
```

You can also set them manually:
```
  export PYTHONPATH=/the/path/of/MatPL-2026.3:$PYTHONPATH
  export PATH=/the/path/of/MatPL-2026.3/src/bin:$PATH
```

#### Load and Use MatPL
Before using MatPL, load the Python environment, CUDA, and the MatPL environment variables. The CPU version does not require CUDA.

```bash
conda activate matpl-2026.3
module load cuda/11.8-share
source /the/path/of/MatPL-2026.3/env.sh
```
You can then start training with MatPL commands. See the [tutorials](../models/README.md) for usage examples.

### Build and Install the Open-Source MatPL LAMMPS 2026.3 Interface

The MatPL-2026.3 LAMMPS interface supports NEP (including QNEP), DP, and D3. A Fortran interface is available for NN and Linear force fields; see the [2025.3 Fortran LAMMPS interface guide](http://doc.lonxun.com/2025.03/MatPL/install/Installation-online/#lammps-matpl-fortran-%E7%BC%96%E8%AF%91%E5%AE%89%E8%A3%85).

To install the interface, download the LAMMPS source, load the build environment, and compile it as described below.

#### Download the MatPL-2026.3 LAMMPS Interface Source

The open-source MatPL-2026.3 LAMMPS interface is hosted in this [GitHub repository](https://github.com/LonxunQuantum/lammps-MatPL). Clone it with:

```bash
git clone https://github.com/LonxunQuantum/lammps-MatPL.git
cd lammps-MatPL
```

The source tree is organized as follows:

```txt
├── .gitignore
├── KOKKOS/
├── MATPLD3/
├── MATPLDP/
├── compute_qnep_bec_atom.cpp
├── compute_qnep_bec_atom.h
├── examples/
├── kknep-patch.sh
├── nep_cpu.cpp
├── nep_cpu.h
├── nep_gpu/
├── pair_nep.cpp
├── pair_nep.h
├── test/
├── test_qnep/
└── README.md
```

- `KOKKOS`, `nep_gpu`, `nep_cpu.cpp`, `nep_cpu.h`, `pair_nep.cpp`, and `pair_nep.h` contain the NEP LAMMPS interface with NEP Kokkos GPU acceleration. `compute_qnep_bec_atom.cpp` and `compute_qnep_bec_atom.h` output per-atom Born effective-charge tensors for QNEP.

- `MATPLDP` contains the DP interface; `MATPLD3` contains the D3 interface. D3 requires CUDA and cannot be used together with `matpl/nep/kk`.

- `examples` contains force-field MD examples; `test` and `test_qnep` contain NEP and QNEP tests, respectively.

- `kknep-patch.sh` copies the interface source into the LAMMPS source tree and modifies `cmake/CMakeLists.txt` before compilation with CMake.

- Compared with MatPL-2025.3, the NEP Kokkos interface uses Kokkos to build neighbor lists on the GPU, while custom C++/CUDA operators evaluate energies and forces. This reduces GPU memory usage and improves inference performance.

- The repository supports the 2023, 2024, and 2025 LAMMPS releases. Recommended versions are `stable_2Aug2023_update4`, `stable_29Aug2024_update4`, and `stable_22Jul2025_update4`.

#### Copy the MatPL-2026.3 Interface into the LAMMPS Source Tree

Run `kknep-patch.sh` from the `lammps-MatPL` repository root. The script copies the interface files into the LAMMPS source tree and updates `cmake/CMakeLists.txt`:

```bash
bash kknep-patch.sh /the/rootpath/of/lammps
```

On success, it prints output similar to the following:
```txt
...
Patch process completed successfully!

Compilation Environment:
Recommended compilation environment: cuda/11.6 (with nvcc compiler) openmpi4.1.4 cmake/3.31.6 gcc8.n

Compilation Process:
cd /data/home/wuxingxing/codespace/suzhou/lmpversions/lammps-23-4-changerowcol/
mkdir build & cd build
cmake -C ../cmake/presets/basic.cmake \
    -DPKG_MESONT=no \
    -DPKG_JPEG=no \
    -DPKG_KOKKOS=yes \
    -DPKG_NEP_KK=yes \
    -DKokkos_ENABLE_CUDA=yes \
    -DKokkos_ENABLE_OPENMP=yes \
    -DKokkos_ENABLE_CUDA_LAMBDA=yes \
    -DFFT_KOKKOS=CUFFT \
    -DKokkos_ARCH_AMPERE86=ON \
    -DTEST_TIME=ON \
    ../cmake

cmake --build . --parallel 4 #(number of parallel compilation cores)


If you also need to compile the DP interface, please import the PyTorch path, import the MKL library, and enable the C++ STD17 standard for compilation.
export Torch_DIR=$(python -c "import torch; print(torch.utils.cmake_prefix_path)")/Torch
Then, add the following option in cmake:
-DTorch_DIR=${Torch_DIR} \
-DCMAKE_CXX_STANDARD=17 \
-DPKG_MATPLDP=yes \


```

<!-- For the D3 interface, please add the following option in cmake. Note that D3 requires CUDA support and cannot be used in combination with matpl/nep/kk.
-DPKG_MATPLD3=yes \ -->

#### Load the Build Environment and Compile
After copying the files, load the build environment. The LAMMPS interface requires `CUDA`, `GCC`, `CMake`, and `OpenMPI`. We recommend OpenMPI 4.1.4 or later, CUDA 11.6 or later, CMake 3.x or later, and GCC 8.x or later.

Following the instructions printed by the script, enter the LAMMPS root, create a `build` directory, and run the following CMake command:
```bash
# Enter the LAMMPS root
mkdir build & cd build
cmake -C ../cmake/presets/basic.cmake \
    -DPKG_MESONT=no \
    -DPKG_JPEG=no \
    -DPKG_KOKKOS=yes \
    -DPKG_NEP_KK=yes \
    -DKokkos_ENABLE_CUDA=yes \
    -DKokkos_ENABLE_OPENMP=yes \
    -DKokkos_ENABLE_CUDA_LAMBDA=yes \
    -DFFT_KOKKOS=CUFFT \
    -DKokkos_ARCH_AMPERE86=ON \
    -DTEST_TIME=ON \
    ../cmake

cmake --build . --parallel 4 #(number of parallel compilation cores)
```

Only the NEP interface is enabled by default. To build the DP interface, load `MKL`, provide the `LibTorch path from PyTorch`, and compile with the `C++17 standard`.
```bash
export Torch_DIR=$(python -c "import torch; print(torch.utils.cmake_prefix_path)")/Torch

# Enable the DP interface in the CMake command:
-DTorch_DIR=${Torch_DIR} \
-DCMAKE_CXX_STANDARD=17 \
-DPKG_MATPLDP=yes \
```

<!-- `-DPKG_MATPLD3=yes` enables code from [SevenNet on GitHub](https://github.com/MDIL-SNU/SevenNet/tree/main/sevenn/pair_e3gnn). D3 cannot be used together with matpl/nep/kk. -->

After compilation, output similar to the following appears and `env.sh` is generated in the LAMMPS source root. Load this file before using LAMMPS.

``` txt
[ 98%] Building CUDA object CMakeFiles/lammps.dir/data/home/wuxingxing/codespace/suzhou/lmpversions/lammps-23-4-opt/src/nep_gpu/utilities/gpu_vector.cu.o
[100%] Linking CXX static library liblammps.a
[100%] Built target lammps
[100%] Building CXX object CMakeFiles/lmp.dir/data/home/wuxingxing/codespace/suzhou/lmpversions/lammps-23-4-opt/src/main.cpp.o
[100%] Linking CXX executable lmp
[100%] Built target lmp
```

#### Load and Use LAMMPS
Before using MatPL-2026.3 LAMMPS, load OpenMPI, CUDA, and the LAMMPS environment variables.
```bash
module load cuda/11.8 openmpi/4.1.6
# Add the lmp executable to PATH
export PATH=/the/path/of/lammpsroot/dir/build:$PATH
```

<!-- For detailed usage, see:
- [MatPL tutorial: NEP LAMMPS](../models/nep/nep-tutorial.md#lammps-md)
- [MatPL tutorial: DP LAMMPS](../models/dp/dp-tutorial.md#lammps-md) -->

### Build and Install the Closed-Source MatPL LAMMPS 2026.3 Interface

The closed-source MatPL LAMMPS 2026.3 interface separates the LAMMPS interface code from the NEP GPU inference kernels. C++ interface components such as `pair_nep.cpp`, the Kokkos wrapper, and `nep_gpu_loader.h` are compiled into LAMMPS, while the optimized NEP GPU kernels are supplied as the precompiled `libnep_gpu.so` shared library. At runtime, the interface loads the library dynamically with `dlopen` and validates the license file.

You therefore do not compile the NEP GPU inference library. Download the LAMMPS interface source, the precompiled library matching the CUDA version, and a valid license, then compile only the C++ interface code.

#### Download the Closed-Source Interface Files

Download the interface source, precompiled libraries, and evaluation license from the [MatPL-pro-v2026.6 release](https://github.com/LonxunQuantum/lammps-MatPL/releases/tag/MatPL-pro-v2026.6).

| File | CUDA / Precision |
| --- | --- |
| [`libnep_gpu_cu118.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu118.so) | CUDA 11.8, default mixed precision |
| [`libnep_gpu_cu118_fp64.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu118_fp64.so) | CUDA 11.8, FP64 |
| [`libnep_gpu_cu128.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu128.so) | CUDA 12.8, default mixed precision |
| [`libnep_gpu_cu128_fp64.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu128_fp64.so) | CUDA 12.8，FP64 |
| [`summer_holiday.lic or 2026.lic`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/summer_holiday.lic) | License |
| [Source code (zip)](https://github.com/LonxunQuantum/lammps-MatPL/archive/refs/tags/MatPL-pro-v2026.6.zip) | LAMMPS interface source |
| [Source code (tar.gz)](https://github.com/LonxunQuantum/lammps-MatPL/archive/refs/tags/MatPL-pro-v2026.6.tar.gz) | LAMMPS interface source |

Select one shared library for the runtime environment:

- A `cu118` library requires the CUDA 11.x runtime (`libcudart.so.11.0`).
- A `cu128` library requires the CUDA 12.x runtime (`libcudart.so.12`).
- Libraries without `_fp64` use the default mixed precision. When using an `_fp64` library, compile the LAMMPS interface with `-DPREC_NEPINFER=ON`.

> **Note:** The CUDA major version of the shared library must match that of the runtime `libcudart`. CUDA 11.x and CUDA 12.x libraries are not interchangeable.

#### Closed-Source Interface Source Tree

After extracting the source archive, the root directory has the following structure:

```txt
├── .gitignore
├── examples/
├── kknep-patch-cpu.sh
├── kknep-patch.sh
├── KOKKOS/
├── matpl-patch.sh
├── MATPLD3/
├── MATPLDP/
├── MatPLPackages.cmake
├── nep_cpu.cpp
├── nep_cpu.h
├── nep_gpu/
│   ├── cuda-11.8/
│   ├── cuda-12.8/
│   └── 2026.lic # Expires at the end of 2026
│   └── summer_holiday.lic # Expires at the end of August 2026
├── nep_gpu_loader.h
├── pair_nep.cpp
├── pair_nep.h
├── README.md
└── test/
```

The main components are:

- `kknep-patch.sh` backs up and modifies LAMMPS `cmake/CMakeLists.txt`, then copies the NEP CPU interface, `nep_gpu_loader.h`, the Kokkos wrapper, and MatPL heat-flux interface files.
- `nep_gpu_loader.h` loads `libnep_gpu.so` at runtime, so the closed-source library does not need to be linked directly into LAMMPS during compilation.
- `KOKKOS` contains the NEP Kokkos interface, the MatPL heat-flux compute, and the time-averaging fix.
- `examples` and `test` contain usage examples and test scripts, respectively.

#### Build Environment

The following software versions are recommended:

| Component | Recommended version | Notes |
| --- | --- | --- |
| LAMMPS | `stable_2Aug2023_update4`, `stable_29Aug2024_update4`, or `stable_22Jul2025_update4` | `kknep-patch.sh` supports the 2023–2025 releases |
| CUDA Toolkit | 11.8 or 12.8 | Must match the major version of the downloaded library |
| GCC | 8.3 or later | C++17 support is required |
| OpenMPI | 4.1.x | Used for multi-process and multi-node parallelism |
| CMake | 3.18 or later | LAMMPS build system |

For example, load build environments for CUDA 11.8 or CUDA 12.8 as follows:

```bash
# CUDA 11.8, for libnep_gpu_cu118*.so
module --ignore-cache load openmpi/4.1.6 cuda/11.8-share gcc/8.3.1 cmake/3.31.6

# CUDA 12.8, for libnep_gpu_cu128*.so
module --ignore-cache load openmpi/4.1.6 cuda/12.8-share gcc/11.2.1 cmake/3.31.6
```

> The `module` names above are examples for a cluster environment. Adjust them to match the installed software.

#### Copy the Interface Files into the LAMMPS Source Tree

Enter the root of the extracted source and run:

```bash
cd /the/path/of/lammps-MatPL-MatPL-pro-v2026.6
bash kknep-patch.sh /the/path/of/lammps
```

The script copies the interface files into the LAMMPS `src` directory and adds the `PKG_NEP_KK` build option to `cmake/CMakeLists.txt`. The message `Patch process completed successfully!` confirms completion.

#### Build LAMMPS with CMake

Enter the LAMMPS source directory and create a separate build directory:

```bash
cd /the/path/of/lammps
mkdir build && cd build

cmake -C ../cmake/presets/basic.cmake \
    -DPKG_MESONT=no \
    -DPKG_JPEG=no \
    -DPKG_KOKKOS=yes \
    -DPKG_NEP_KK=yes \
    -DKokkos_ENABLE_CUDA=yes \
    -DKokkos_ENABLE_OPENMP=yes \
    -DKokkos_ENABLE_CUDA_LAMBDA=yes \
    -DFFT_KOKKOS=CUFFT \
    -DKokkos_ARCH_AMPERE86=ON \
    ../cmake

cmake --build . --parallel 8
```

`-DKokkos_ARCH_AMPERE86=ON` is an example for SM 8.6 GPUs such as the A6000 and RTX 3090. Select the Kokkos architecture for the actual GPU: `-DKokkos_ARCH_AMPERE80=ON` for A100, `-DKokkos_ARCH_ADA89=ON` for RTX 4090, or `-DKokkos_ARCH_HOPPER90=ON` for H100.

When using an `_fp64.so` library, add the following option to the CMake command:

```bash
-DPREC_NEPINFER=ON \
```

#### Configure the Shared Library and License

After compilation, set `NEP_GPU_LIB_PATH` to the full path of the precompiled library and `NEP_LICENSE_PATH` to the license file:

```bash
# LAMMPS executable
export PATH=/the/path/of/lammps/build:$PATH

# CUDA 11.8 default mixed-precision example
export NEP_GPU_LIB_PATH=/the/path/of/libnep_gpu_cu118.so
export NEP_LICENSE_PATH=/the/path/of/summer_holiday.lic
```

Alternatively, rename the library to `libnep_gpu.so` and add its directory to `LD_LIBRARY_PATH`:

```bash
export LD_LIBRARY_PATH=/the/path/of/libnep_gpu_dir:$LD_LIBRARY_PATH
```

`NEP_GPU_LIB_PATH` takes precedence over the system library search path, so specifying the `.so` file directly is recommended. Similarly, point `NEP_LICENSE_PATH` directly to the downloaded `summer_holiday.lic`.

> **License:** The `summer_holiday.lic` included in the release is a non-commercial evaluation license for up to 16 GPUs and expires on August 31, 2026. For commercial use or renewal, contact `matpl@pwmat.com`.

### Run LAMMPS

#### Run Commands

Before running LAMMPS, make sure `NEP_GPU_LIB_PATH` and `NEP_LICENSE_PATH` are set and that the input, structure, and NEP force-field files are ready.

```bash
# One GPU
mpirun -np 1 --bind-to numa lmp -k on g 1 -sf kk -pk kokkos -in input.in

# Multiple GPUs on one node (four GPUs)
mpirun -np 4 --bind-to numa lmp -k on g 4 -sf kk -pk kokkos -in input.in

# Multiple nodes (two nodes with four GPUs each)
mpirun -np 8 --bind-to numa --map-by ppr:4:node lmp -k on g 4 -sf kk -pk kokkos -in input.in
```

For multi-node execution, set the same `NEP_GPU_LIB_PATH` and `NEP_LICENSE_PATH` on every compute node and ensure that all nodes can access the shared library, license, input files, and force-field files.

#### LAMMPS Input Script

The NEP Kokkos interface requires a half neighbor list with Newton communication enabled:

```lammps
package kokkos neigh half comm device
newton on
```

For single-model inference, configure `pair_style` as follows:

```lammps
pair_style   matpl/nep/kk nep.txt
pair_coeff   * * Hf O
```

The element names after `pair_coeff * *` correspond one-to-one with the atom types in the data file and map to the element order in the NEP force-field file.

#### Multi-Model Deviation Calculation

In an active-learning workflow, load several NEP force fields simultaneously to output model deviations:

```lammps
pair_style   matpl/nep/kk nep1.txt nep2.txt nep3.txt out_freq 10 out_file explr.error
pair_coeff   * * Hf O
```

- Multiple `nep*.txt` files enable model-deviation calculation.
- `out_freq N` outputs the deviation every `N` steps; the default is `1`.
- `out_file name` sets the deviation-output file; the default is `explr.error`.

#### NPT Example

The following is a complete NPT input script for an HfO2 NEP force field:

```lammps
package kokkos neigh half comm device
newton on

units           metal
boundary        p p p
atom_style      atomic
neighbor        1.0 bin
neigh_modify    delay 10

read_data       structure.lmp
replicate       10 10 10

mass            1 178.49
mass            2 15.999

pair_style      matpl/nep/kk nep.txt
pair_coeff      * * Hf O

velocity        all create 300.0 12345
fix             1 all npt/kk temp 300 300 0.1 iso 0.0 0.0 0.5

thermo_style    custom step temp pe ke etotal press vol
thermo          10
timestep        0.002

run             1000
```

#### MatPL Heat-Flux Calculation

> **Interface distinction:** The open-source version supports only `matpl/heatflux`; the closed-source version supports the Kokkos GPU heat-flux interface `matpl/heatflux/kk`. The commands below apply only to the closed-source version.

`matpl/heatflux/kk` calculates MatPL heat flux directly on the GPU and does not require the conventional `ke/atom + pe/atom + centroid/stress/atom + heat/flux` post-processing chain:

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

The virial contribution to heat flux is therefore the total heat flux minus the convective heat flux: `(1-4, 2-5, 3-6)`. `fix matpl/heatflux/ave/kk` time-averages the heat-flux vector and writes the result to `compute_HeatFlux.out`.

#### More Examples

- [H2O multi-node, multi-GPU example](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/H2O)
- [HfO2 multi-node, multi-GPU example](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/HfO2)
- [Graphene heat-flux calculation and validation example](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/Heat_flux)

#### Troubleshooting

| Error or symptom | Cause | Solution |
| --- | --- | --- |
| `Failed to load NEP GPU library` | The shared library cannot be found | Check `NEP_GPU_LIB_PATH` or add the library directory to `LD_LIBRARY_PATH` |
| `Symbol not found: nep_*` | The interface and library versions do not match | Use the source and `libnep_gpu*.so` from the same release |
| `NEP GPU license check failed` or `License file not found` | The license is missing, incorrectly addressed, or expired | Check `NEP_LICENSE_PATH`, file permissions, and the expiration date |
| A `libcudart` error occurs while loading the `.so` | CUDA major versions do not match | Use a `cu118` library with CUDA 11.x and a `cu128` library with CUDA 12.x |
| The GPU does not match the license or the GPU count exceeds the limit | The current hardware is outside the licensed scope | Inspect GPUs with `nvidia-smi --query-gpu=uuid`; restrict `CUDA_VISIBLE_DEVICES` or update the license if necessary |


<!-- ### Build and Install Lammps-MatPL (Fortran)

lammps-MatPL (Fortran version) supports MatPL NN and Linear force fields without GPU acceleration.

The source is located under `lmps/lammps-fortran` in the MatPL source tree. You can also download it from the [Fortran branch on GitHub](https://github.com/LonxunQuantum/lammps-MatPL/tree/fortran) or from a release archive.

For installation, see the [2025.3 Fortran LAMMPS interface guide](http://doc.lonxun.com/2025.03/MatPL/install/Installation-online/#lammps-matpl-fortran-%E7%BC%96%E8%AF%91%E5%AE%89%E8%A3%85).

For detailed usage, see:
- [MatPL tutorial: Linear LAMMPS](../models/linear/linear-tutorial.md#lammps-md)
- [MatPL tutorial: NN LAMMPS](../models/nn/nn-tutorial.md#lammps-md)


See also common [installation errors](./InstallError.md) and [runtime errors](./RuntimeError.md) for MatPL software. -->
