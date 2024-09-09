---
sidebar_position: 1
---

# Load and install

## PWMLFF

:::tip
PWMLFF includes `Fortran`, `Python (Pytorch2.0)`, `C++`, and `C++ CUDA` code, and requires installation in an environment with `Python`, `gcc compiler`, `Intel compiler suite` (including `ifort`, `icc` compilers and `tbb`, `mkl`, and `mpi` libraries), and `nvidia GPU` hardware. We offer three methods to install PWMLFF.
:::

### 1. Directly Load from Mcloud

[Longxun Supercomputing Cloud](https://mcloud.lonxun.com/) (`Mcloud`) provides a pre-configured conda environment and PWMLFF package, avoiding the time-consuming process of installing anaconda, cudatoolkit, pytorch, etc. To use `PWMLFF`, simply load the following environment variables:

```bash
# Load the conda environment
$ source /share/app/anaconda3/etc/profile.d/conda.sh
$ module load conda/3-2020.07
$ conda deactivate
$ conda activate PWMLFF
$ module load pwmlff/2024.5
```

### 2. Offline Installation

For devices without internet access, you can download the offline installation package with a pre-configured conda environment:

#### 1. Download

👉 [Baidu Cloud Link](https://pan.baidu.com/s/1K4TrZuh4WVzSwfu2ZzL5mg?pwd=pwmt) Select the version to download (2024.05).

#### 2. Unpacking

```bash
$ gzip -d pwmlff.2024.5.sh.gz
```

After unpacking, you will get the `pwmlff.2024.5.sh` file. Execute this file to complete the environment installation.

```bash
$ ./pwmlff.2024.5.sh
# or sh pwmlff.2024.5.sh
```

:::caution
Before running `pwmlff.2024.5.sh`, you need to load the required modules for compilation, namely `intel`, `cuda`, and `gcc`. For mcloud users, load the following environment directly:

```
$ module load cuda/11.8-share intel/2020
$ source /opt/rh/devtoolset-8/enable
```

We recommend using the `intel2020` version, `cuda/11.8`, and `gcc version 8.n`. The `pytorch` version used in PWMLFF is `2.0` or higher, and it must use `cuda/11.8` or a later version.

For the `intel/2020` compilation suite, it uses its `ifort` and `icc` compilers (`19.1.3`), `mpi(2019)`, and `mkl library (2020)`. If loading separately, ensure the versions are not lower than these.
:::

After running, a folder named `PWMLFF2024.5` will be created in the working directory, containing the runtime environment (`pwmlff2024.5`) and the package (`PWMLFF`).

After unpacking and compiling, update the environment variables:

```bash
$ source ~/.bashrc
```

:::tip
After installation, the PWMLFF2024.5 environment variables (as shown below) will be written to `.bashrc` by default. If you do not need this, please manually remove them from `.bashrc`. After deletion, you will need to manually import these environment variables before each run of PWMLFF.

```bash
$ export PATH=/the/path/PWMLFF2024.5/PWMLFF/src/bin:$PATH
$ export PYTHONPATH=/the/path/PWMLFF2024.5/PWMLFF/src/:$PYTHONPATH
```
:::

#### 3. Usage

Activate the Python environment:

```bash
$ source /the/path/PWMLFF2024.5/pwmlff2024.5/bin/activate
# The environment address needs to be the full path, e.g., /data/home/wuxingxing/pack/PWMLFF-2024.5/pwmlff/bin/activate
```

Load `intel/2020` and `cuda/11.8`:

```bash
$ module load intel/2020 cuda/11.8-share
```

If your `./bashrc` (automatically written after offline installation) does not contain the environment variables below, import them:

```bash
$ export PATH=/the/path/PWMLFF2024.5/PWMLFF/src/bin:$PATH
$ export PYTHONPATH=/the/path/PWMLFF2024.5/PWMLFF/src/:$PYTHONPATH
```

Deactivate the environment:

```bash
$ source /the/path/PWMLFF2024.5/pwmlff2024.5/bin/deactivate
# The environment address needs to be the full path, e.g., /data/home/wuxingxing/pack/PWMLFF-2024.5/pwmlff/bin/deactivate
```

### 3. Online Installation

To compile and run PWMLFF-2024.5, you need to download the source code, install the conda environment, and install the PWMLFF-2024.5 dependencies in the conda environment. The process is as follows:

#### 1. Download Source Code

We provide two methods: online code pull and offline package download.

- Pull the PWMLFF repository code via github or gitee:

```bash
  $ git clone https://github.com/LonxunQuantum/PWMLFF.git PWMLFF-2024.5
  Or
  $ git clone https://gitee.com/pfsuo/PWMLFF.git PWMLFF-2024.5
```

- Or download the release offline source package. You can download it directly via the browser or with the wget prefix:

```bash
  $ wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/tags/2024.5.zip
  Or
  $ wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```

After downloading the release offline source package, extract it using the unzip command:

```bash
  # After extraction, you will get a source directory named PWMLFF-2024.5
  $ unzip 2024.5.zip
```

#### 2. Create Conda Virtual Environment

##### Step 1. Install Anaconda3 (skip if already installed)

Make sure Anaconda3 is installed, then create a new python virtual environment (search for Linux Anaconda3 installation tutorial online).

You can download Anaconda3 directly to the server directory with this command:

```bash
$ curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
# If download fails, enter the download address in the browser, then upload to the server
# https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh 
# You can also visit the website to download other versions https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/
```

##### Step 2. Create Virtual Environment

After installing conda, create a virtual environment specifying `python3.11` as the interpreter. Other versions may cause dependency conflicts or syntax issues. All subsequent compilation work will be done in this virtual environment.

```bash
$ conda create -n pwmlff2024.5 python=3.11
# We recommend python 3.11; higher versions might cause errors during compilation, which we have not yet addressed.
```

After creating the virtual environment, activate it:

```bash
$ conda activate pwmlff2024.5
```

##### Step 3. Install Dependencies

Next, install the third-party dependencies required for PWMLFF. All dependencies are listed in `requirements.txt`. Execute the pip command in the directory where this file is located to install all dependencies. This step can be time-consuming as it installs packages like pytorch, so please be patient.

```bash
# First step: Activate the conda environment
$ conda activate pwmlff2024.5
# Second step: Navigate to the source root directory
# For online downloaded source, enter the PWMLFF-2024.5 directory
$ cd PWMLFF-2024.5
# For offline downloaded source, enter the PWMLFF-master directory after extraction
$ pip install -r requirements.txt
```

#### 3. Compile and Install

##### Step 1. Check Compilation Environment

Navigate to the `src` directory, which is at the same level as `requirements.txt`.
First, check if `cuda/11.8`, `intel/2020`, and `gcc8.n` are loaded, and ensure the `conda` virtual environment is activated.

For the `intel/2020` compiler suite, it uses `ifort` and `icc` compilers (`19.1.3`), `mpi(2019)`, and `mkl library(2020)`. If loaded separately, ensure the versions are not lower than these.

Since most compilation issues are caused by compiler version mismatches, we provide a script `check_env.sh` to check if the compilation environment is properly set up. Run this script to verify your environment.

```bash
$ cd src
$ sh check_env.sh
```

The output will provide information about your compilation environment. A correct environment will look like this:

```txt
1. CUDA version is 11.8.
2. nvcc command exists.
3. ifort version is no less than 19.1, current version is 19.1.
4. MKL library is installed.
5. GCC version is not 8.x, current version is 8.
6. PyTorch is installed.
7. PyTorch version is 2.0 or above, current version is 2.2.
```

##### Step 2. Compile Code

If your environment passes the checks, proceed to compile the code. Run the following commands to start the compilation:

```bash
$ sh clean.sh
$ sh build.sh
```

If you encounter errors during compilation, please refer to [Common Installation Errors of PWMLFF](./Error%20Record/InstallError.md).

:::tip
If your issue persists, please send your machine environment information, compilation error logs, and the compilation steps you followed to support@pwmat.com or wuxingxing@pwmat.com. We will contact you promptly.

- `After compilation, the PWMLFF environment variables will be automatically added to the .bashrc file. If not needed, manually remove these environment variables from .bashrc.` You can execute the following command to update environment variables:

```bash
source ~/.bashrc
```
:::

This completes the compilation and installation of PWMLFF.

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