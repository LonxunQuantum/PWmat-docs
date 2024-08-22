---
sidebar_position: 1
---

# Load and Install (In Mcloud)

## PWMLFF

:::tip
PWMLFF includes Fortran, Python (Pytorch2.0), C++ and C++ CUDA acceleration. Installation requires a Python environment, GCC compiler, and GPU hardware. Here we provide 3 methods for installing PWMLFF.
:::

### 1. Direct Loading in Mcloud

[`mcloud`](https://mcloud.lonxun.com/) has pre-configured conda environments and PWMLFF packages, avoiding the time-consuming process of installing anaconda, cudatoolkit, pytorch, etc. To use `PWMLFF`, simply load the following environment variables:

```bash
# Load conda environment
module load anaconda
conda activate PWMLFF
module load pwmlff/2024.5
```

### 2. Offline Installation

For offline devices, you can download the pre-configured conda environment and program package directly:

#### 1. Download

👉[Baidu Cloud Link](https://pan.baidu.com/s/1K4TrZuh4WVzSwfu2ZzL5mg?pwd=pwmt) Choose the latest version to download (current latest version is 2024.05).

#### 2. Unzip

```bash
gzip -d pwmlff.2024.5.sh.gz
```

After unzipping, you will get the `pwmlff.2024.5.sh` file. Run this file to complete the environment installation.
```bash
./pwmlff.2024.5.sh
# Or sh pwmlff.2024.5.sh
```
:::caution
Before running `pwmlff.2024.5.sh`, you need to load the required modules for compilation, i.e., intel, cuda, and gcc.
For mcloud users, directly load the following environment:
``` bash
module load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable
```

We recommend using `intel2020`, `cuda/11.8`, `cmake version >= 3.21`, and `gcc version 8.n`.
Note: The version of `pytorch` used in PWMLFF is `2.0 or above`, and `CUDA/11.8` or higher must be used.
:::

After running, a folder named `PWMLFF2024.5` will be created in the running directory, containing all the environment configurations (`pwmlff`) and program packages (`PWMLFF`).

After unzipping and compiling, update the environment variables:
```bash
source ~/.bashrc
```

:::tip
After installation, the PWMLFF2024.5 environment variables (as shown below) will be automatically written into your `.bashrc`. If you do not need this, you can manually delete them from `.bashrc`. After deletion, you will need to manually import these environment variables each time before running PWMLFF.

```bash
export PATH=/the/path/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF2024.5/src/:$PYTHONPATH
```
:::

#### 3. Usage

Activate the environment

```bash
source /the/path/PWMLFF2024.5/pwmlff/bin/activate
# Replace with the full path, e.g., /data/home/wuxingxing/pack/PWMLFF2024.5/pwmlff/bin/activate
```

If your `.bashrc` (automatically written after offline installation) does not include the following environment variables, please import them

```bash
export PATH=/the/path/PWMLFF2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF2024.5/PWMLFF/src/:$PYTHONPATH
```

Deactivate the environment

```bash
source /the/path/PWMLFF2024.5/pwmlff/bin/deactivate
# Replace with the full path, e.g., /data/home/wuxingxing/pack/PWMLFF2024.5/pwmlff/bin/deactivate
```

### 3. Online Installation

For online installation, you need to configure the environment first, then download and compile the source code.

#### Configure Environment
To compile and run PWMLFF2024.5, you need to install the conda environment and install the necessary packages in the conda environment as follows.

1. First, load the compilers required for compiling PWMLFF
```bash
# For mcloud users, directly load the following environment
module load cuda/11.8-share intel/2020 cmake/3.21.6
source /opt/rh/devtoolset-8/enable
```
We recommend using `intel2020`, `cuda/11.8`, `cmake version >= 3.21`, and `gcc version 8.n`.
Note: The version of `pytorch` used in PWMLFF is `2.0 or above`, and `CUDA/11.8` or higher must be used.

2. Create a new Python virtual environment in your user directory. It is recommended to manually download and use Anaconda3 for environment management (search for Linux Anaconda3 installation tutorial online).

You can use this command to download Anaconda3 directly to the server directory:

```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh

# If you cannot download it, visit the webpage https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/ to download, or use other methods.
```

After installing conda, create a virtual environment, specifying Python3.11 as the interpreter. Other versions may have dependency conflicts or syntax issues. The subsequent compilation work will be done in this virtual environment.

```bash
conda create -n pwmlff2024.5 python=3.11
# We recommend Python 3.11. Higher versions may have compilation errors that we have not yet resolved.
```

3. After creating the virtual environment, reactivate it:

```bash
conda deactivate
conda activate pwmlff2024.5
```

4. Install the third-party dependencies required by PWMLFF

```bash
pip3 install numpy==1.26.4
#it is recommended to install a version of numpy < 2.0. Versions above this may cause conflicts with some dependencies during compilation.

pip3 install numpy tqdm cmake pyyaml pandas scikit-learn-intelex matplotlib pwdata pwact pybind11 
pip3 install charset_normalizer==3.3.2

# Install the latest version of charset_normalizer (version 3.3.2 or above) to avoid encoding errors when compiling Fortran code
# UnicodeDecodeError: 'ascii' codec can't decode byte 0xe4 in position 144: ordinal not in range(128)
```

```python
pip install torch==2.2.0  --index-url https://download.pytorch.org/whl/cu118
# it is recommended to use version 2.2.0 of PyTorch. Higher versions may result in compilation errors.
```

For other versions of `pytorch`, refer to the [Pytorch official website](https://pytorch.org/get-started/previous-versions/).

5. After installing the third-party dependencies, proceed to the [source code compilation and installation](#compile-and-install).

#### Compile and Install

6. After preparing the environment, download and compile the source code. We provide two methods for compiling: online pulling code and downloading offline packages.

- Pull PWMLFF repository code online via GitHub or Gitee
```bash
  $ git clone https://github.com/LonxunQuantum/PWMLFF.git
  or
  $ git clone https://gitee.com/pfsuo/PWMLFF.git
```

After pulling the code, go to the PWMLFF source `src` directory and compile the source code
```bash
  $ cd PWMLFF/src
  $ sh build.sh
```

- Or download the release offline package. You can directly input the following address in your browser to download, or add a prefix to download with wget:
```bash
  $ wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/heads/master.zip
  or
  $ wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```
After downloading the release offline package, unzip and compile it as follows:

```bash
  $ unzip master.zip
  $ cd PWMLFF-master/src
  $ sh build.sh
```
:::tip
- `After compiling, PWMLFF environment variables will be automatically added to the .bashrc file. If you don't need it, manually remove the environment variables from .bashrc`. You can execute the following command to update the environment variables:
```bash
source ~/.bashrc
```
:::

At this point, the compilation and installation of PWMLFF are complete. Ensure to use the PWMLFF virtual environment and load the Intel compiler when using it.

## LAMMPS (Recompiled version for PWMLFF)

:::tip
The current version of LAMMPS is suitable for DP and NEP model extracted force field models.

For the old version Linear, NN, and DP model extracted force field models, see [Lammps for PWMLFF](http://doc.lonxun.com/1.1/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85)
:::

We provide two schemes for LAMMPS installation. For Mcloud users, you can directly load and use the pre-installed LAMMPS interface. We also provide a method for compiling and installing from source code.

### 1. Direct Loading in Mcloud

Mcloud has already installed the LAMMPS interface corresponding to PWMLFF2024.5. Load it with the following command:

```bash
module load lammps4pwmlff/2024.5
```
:::tip
This LAMMPS interface also includes the following features:
`KSPACE`, `MANYBODY`, `REAXFF`, `MOLECULE`, `QEQ`, `REPLICA`, `RIGID`, `MEAM`, `MC`, `PWMLFF`.

The `lammps4pwmlff/2024.5` interface is designed for MD simulations with both DP and NEP models and supports multi-GPU acceleration.

For Linear and NN models, we offer a CPU version of the LAMMPS interface, which can be accessed by loading `lammps4pwmlff/0.1.0`.
:::

### 2. Installing from Source Code
Installing from source involves the following steps.

1. **Downloading LAMMPS Source Code**: You can download the source code from GitHub or download the release package.
- Clone the source code via GitHub or Gitee:
```bash
$ git clone -b libtorch_nep https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
or
$ git clone -b libtorch_nep https://gitee.com/pfsuo/Lammps_for_PWMLFF.git
```

- Or download the release package:
```bash
$ wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/tags/2024.5.zip
or
$ wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/2024.5

$ unzip 2024.5.zip    # Unzip the source code
```

2. **Loading Compilation Environment Variables**

Note, you need to ensure that the same Python virtual environment is used for compiling PWMLFF and LAMMPS. To compile LAMMPS, you need to load the following environment variables.

```bash
# Load compilers
load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable # This is for GCC compiler, you can load your own version 8.n

# Example of loading PWMLFF environment
# Load conda environment
source /the/path/anaconda3/etc/profile.d/conda.sh
# Activate conda environment, note the virtual environment here needs to be the same as the one used to compile PWMLFF2024.5
conda activate pwmlff2024.5 
# Load PWMLFF2024.5 environment variables
export PATH=/the/path/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF2024.5/src/:$PYTHONPATH
# Load shared library files
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```

:::info
1. Model export uses the Libtorch library, ensure to load the virtual environment where PWMLFF resides when compiling the software.
2. Compiling and executing the program requires the `op` (custom operator) library included in the PWMLFF package, ensure it is in the environment variables.
:::

3. **Compiling LAMMPS Code**

To use the GPU version of the NEP model, you need to compile the NEP C++ CUDA code into a share library file as shown below.
```bash
cd src/PWMLFF/NEP_GPU
make clean
make
# After compiling, you will get a share library file src/libnep_gpu.so
```

Compile LAMMPS interface:
```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
make clean-all && make mpi -j4
```
If you cannot find the `cuda_runtime.h` header file during compilation, please replace the CUDA path in line 24 of `src/MAKE/Makefile.mpi` with your own path, `/the/path/cuda/cuda-11.8`. The `cuda_runtime.h` file is located in the `include` directory under this path.

```txt
CUDA_HOME = $(CUDADIR)
Replace with 
CUDA_HOME = /the/path/cuda/cuda-11.8
```
:::tip
Here is a list of commonly used software in LAMMPS that you can install alongside PWMLFF:
```bash
make yes-KSPACE
make yes-MANYBODY
make yes-REAXFF
make yes-MOLECULE
make yes-QEQ
make yes-REPLICA
make yes-RIGID
make yes-MEAM
make yes-MC
```
For the LAMMPS interface for `Linear` and `NN` models, please refer to [`lammps4pwmlff/0.1.0 Installation`](http://doc.lonxun.com/en/1.0/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85).
:::

### LAMMPS Environment Setup and MD Example

#### Method 1: Load Mcloud Pre-installed LAMMPS for MD

```bash
module load lammps4pwmlff/2024.5

mpirun -np 4 lmp_mpi_gpu -in in.lammps
# If you are using the CPU version
# mpirun -np 1 lmp_mpi -in in.lammps
```

#### Method 2: Loading Your Own Installed LAMMPS
```bash
# 1. For mpirun command
module load intel/2020

# 2. Load conda environment and activate conda virtual environment
source /data/home/wuxingxing/anaconda3/etc/profile.d/conda.sh
conda activate torch2_feat

# 3. Load PWMLFF environment variables
export PATH=/the/path/to/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF2024.5/src/:$PYTHONPATH

# 4. Import PWMLFF2024.5 shared library path
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib

# 5. Load LAMMPS environment variables
export PATH=/the/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$LD_LIBRARY_PATH

# 6. GPU LAMMPS command
mpirun -np 4 lmp_mpi_gpu -in in.lammps

# CPU LAMMPS command
# mpirun -np 32 lmp_mpi -in in.lammps
```

:::caution
When submitting a training task, ensure that the task script loads the relevant environment as shown below:

```bash
module load intel/2020
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF

# The following lines address potential issues
export MKL_SERVICE_FORCE_INTEL=1
export MKL_THREADING_LAYER=GNU
export I_MPI_HYDRA_BOOTSTRAP=slurm
export I_MPI_PMI_LIBRARY=/lib64/libpmi.so
```

- Lines 5 and 6 solve the issue of mismatched PyTorch and NumPy versions.
- The last two lines resolve issues with running multiple LAMMPS tasks in parallel.

**Loading `pwmlff` and the virtual environment is necessary to obtain `LD_LIBRARY_PATH`.**
**The `LD_LIBRARY_PATH` environment variable must be included when running LAMMPS, otherwise, specific libraries cannot be called.**
:::