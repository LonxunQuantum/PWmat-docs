---
sidebar_position: 1
---

# Install and load

The `PWMLFF` and `Lammps` molecular dynamics interfaces need to be compiled and installed from source. We offer both offline and online installation methods.

For [Mcloud](https://mcloud.lonxun.com/) users, we have pre-installed the software, so you only need to load the environment to use it.


## Loading for Mcloud Users
### Load PWMLFF
[Mcloud](https://mcloud.lonxun.com/) 
has pre-configured conda environments and the PWMLFF software package, saving you from the time-consuming process of installing Anaconda, CUDA-Toolkit, PyTorch, etc. To use `PWMLFF`, simply load the following environment variables:

```bash
# Load conda environment
source /share/app/anaconda3/etc/profile.d/conda.sh
module load conda/3-2020.07
conda deactivate
conda activate PWMLFF
module load pwmlff/2024.5
```

### Load the Lammps interface

Mcloud has already installed the Lammps interface corresponding to PWMLFF-2024.5. Use the following command to load it:

```bash
module load lammps4pwmlff/2024.5
mpirun -np 4 lmp_mpi_gpu -in in.lammps
# If you're using the CPU version
# mpirun -np 1 lmp_mpi -in in.lammps
```

:::tip
This Lammps interface comes pre-installed with the following features:
`KSPACE`, `MANYBODY`, `REAXFF`, `MOLECULE`, `QEQ`, `REPLICA`, `RIGID`, `MEAM`, `MC`, `PWMLFF`
The `lammps4pwmlff/2024.5` interface is used for DP models and NEP models in MD simulations and supports multi-GPU acceleration.

For the Lammps interface for Linear and NN models, we offer a CPU version of the interface, which can be loaded with:
`lammps4pwmlff/0.1.0`
:::

## Offline Installation of GPU Version

PWMLFF includes `Fortran`, `Python (Pytorch 2.0)`, `C++`, and `C++ CUDA` accelerated operators, and requires a `Python environment`, `gcc compiler`, `Intel compiler suite` (including `ifort`, `icc`, `mkl`, and `mpi` libraries), and `NVIDIA GPU` hardware support.

Since configuring a conda environment can be time-consuming and some user devices may not have internet access, we have pre-configured the conda environment in the offline installation package. You can simply download the package, install it, and use it right away. 

### 1. Download the Offline Installation Package
Please visit Baidu Cloud to download the package. If the link is invalid, contact us via email at `wuxingxing@pwmat.com` or `support@pwmat.com`:

👉 [Download GPU Version Offline Installation Package pwmlff-2024.5.sh.tar.gz](https://pan.baidu.com/s/1sPB9gBEFJd3q9A__O_wpBQ?pwd=pwmt)

### 2. Extract the Installation Package
```bash
tar -xzvf pwmlff.2024.5.sh.tar.gz
```
After extraction, you will get the following files:
`pwmlff-2024.5.sh`, `check_offenv.sh`

### 3. Check Compiler Versions
Most installation failures are due to incorrect compiler versions. We provide a script to help check your environment.

We recommend using the `intel2020` version, `cuda/11.8`, and `gcc version 8.n`. This is because PWMLFF uses `pytorch 2.0+`, which requires `cuda/11.8` or higher. For the `intel/2020` compiler suite, it uses the `ifort` and `icc` compilers (`19.1.3`), `mpi(2019)`, and `mkl(2020)`. If you load them individually, ensure the versions are no lower.

After extracting the GPU offline installation package, you will get `pwmlff-2024.5.sh` and `check_offenv.sh`. Run the following command:

```bash
sh check_offenv.sh
```

This will list the required compiler versions and the currently detected versions. Below is an example of a successful environment check:

```txt
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
CUDA version is 11.8 or higher, current version is 11.8.89.
nvcc command exists.
```

1. The line 1 checks if the ifort compiler version is 19.1 or higher, detecting version 19.1, which meets the requirement.
2. The line 2 checks if the MKL library is installed, confirming that it is.
3. The line 3 verifies that the GCC version is exactly 8, detecting version 8, which is correct.
4. The line 4 checks if the CUDA version is 11.8 or higher, detecting version 11.8.89, which meets the requirement.
5. The line 5 ensures that the nvcc compiler exists, confirming it is present.

### 4. Execute Installation Command
Once the environment check is complete, run the following command to install:
```bash
sh pwmlff-2024.5.sh
```
If the installation log at the end looks like this, the installation was successful:
```txt
mpicxx -g -O3 -std=c++17 -L/the/path/to/PWMLFF-2024.5/pwmlff-2024.5/lib -lpython3.11 -static-libstdc++ -static-libgcc -L/the/path/to/PWMLFF-2024.5/pwmlff-2024.5/lib/python3.11/site-packages/torch/lib/ -ltorch -lc10 -ltorch_cpu -L/the/path/to/PWMLFF-2024.5/lammps-2024.5/src/Obj_mpi/.. -lnep_gpu -L/share/app/cuda/cuda-11.8/lib64 -lcudart -L/the/path/to/PWMLFF-2024.5/PWMLFF/src/op/build/lib -lCalcOps_bind_cpu main.o      -L. -llammps_mpi      -ldl  -o ../lmp_mpi
size ../lmp_mpi
   text    data     bss     dec     hex filename
11935009          37912   22640 11995561         b709a9 ../lmp_mpi
make[1]: Leaving directory `/the/path/to/PWMLFF-2024.5/lammps-2024.5/src/Obj_mpi'
CUDA support enabled...
make[1]: Entering directory `/the/path/to/PWMLFF-2024.5/lammps-2024.5/src/Obj_mpi'
mpicxx -g -O3 -std=c++17 -L/the/path/to/PWMLFF-2024.5/pwmlff-2024.5/lib -lpython3.11 -static-libstdc++ -static-libgcc -L/the/path/to/PWMLFF-2024.5/pwmlff-2024.5/lib/python3.11/site-packages/torch/lib/ -ltorch -lc10 -ltorch_cpu -L/the/path/to/PWMLFF-2024.5/lammps-2024.5/src/Obj_mpi/.. -lnep_gpu -L/share/app/cuda/cuda-11.8/lib64 -lcudart -L/the/path/to/PWMLFF-2024.5/PWMLFF/src/op/build/lib -lCalcOps_bind -L/share/app/cuda/cuda-11.8/lib64 -lcudart main.o      -L. -llammps_mpi      -ldl  -o ../lmp_mpi_gpu
size ../lmp_mpi_gpu
   text    data     bss     dec     hex filename
11936348          37912   22640 11996900         b70ee4 ../lmp_mpi_gpu
make[1]: Leaving directory `/the/path/to/PWMLFF-2024.5/lammps-2024.5/src/Obj_mpi'
Added Lammps PATH to .bashrc
Added Lammps LD_LIBRARY_PATH to .bashrc
Added torch lib LD_LIBRARY_PATH to .bashrc
Installation completed successfully!
```

:::tip
After installation, PWMLFF-2024.5 environment variables (as shown below) are written to `.bashrc` by default. If you do not want this, manually remove the variables from `.bashrc`. After removal, you will need to manually load the environment variables each time before running PWMLFF.
```bash
# PWMLFF environment variables
export PATH=/the/path/to/PWMLFF-2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF-2024.5/PWMLFF/src/:$PYTHONPATH
# LAMMPS interface environment variables
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
export PATH=/the/path/to/PWMLFF-2024.5/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/to/PWMLFF-2024.5/lammps-2024.5/src:$LD_LIBRARY_PATH
```

Here, `/the/path/to/` refers to your own installation directory.
:::

### 5. Load and Use

After successfully installing the offline package, you will need to activate the installed conda environment and load the intel/2020 and CUDA modules before using it. If you need to train with PWMLFF, load the PWMLFF environment variables; if you need to use the LAMMPS interface, load the LAMMPS interface variables after the PWMLFF variables.

#### Step 1: Activate the Installed Conda Environment
```bash
# Use the full path to the environment, e.g., /data/home/wuxingxing/pack/PWMLFF-2024.5/pwmlff/bin/activate
source /the/path/PWMLFF-2024.5/pwmlff-2024.5/bin/activate
```

#### Step 2: Load the Intel Compiler Package and CUDA Used During Compilation
```bash
# For the GPU version:
module load intel/2020 cuda/11.8-share
```

#### Step 3: Load PWMLFF Environment Variables

If your `.bashrc` (automatically written after offline installation) does not include the following environment variables, manually import them:
```bash
export PATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/:$PYTHONPATH
```

#### Step 4. Load LAMMPS Interface
If your `.bashrc` (automatically written after offline installation) does not include the following environment variables, please import them manually:
```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
# For the GPU version of the LAMMPS interface
export PATH=/the/path/PWMLFF-2024.5/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/PWMLFF-2024.5/lammps-2024.5/src:$LD_LIBRARY_PATH
```

### 6. Exit the Conda Virtual Environment
You can exit the virtual environment with the following command, or simply close the current shell window:
```bash
# For the GPU version:
source /the/path/PWMLFF-2024.5/pwmlff-2024.5/bin/deactivate
```


## Online Installation

For online installation, you will need to compile and install both PWMLFF and the LAMMPS interface separately.

To compile and run PWMLFF-2024.5, you need to download the source code, install the Conda environment, and install all the required dependencies in that environment.

The compilation and installation of the LAMMPS interface requires a successful installation of PWMLFF.

The process is as follows:

### PWMLFF Compilation and Installation
### 1. Download the Source Code
We offer two ways to obtain the source code: pulling from the GitHub/Gitee repository or downloading the offline release package.

- Pull the PWMLFF repository from GitHub or Gitee:
```bash
  git clone https://github.com/LonxunQuantum/PWMLFF.git PWMLFF-2024.5
  or
  git clone https://gitee.com/pfsuo/PWMLFF.git PWMLFF-2024.5
```

- Alternatively, download the release offline source package. You can either enter the URL in your browser or use `wget` to download it:
```bash
  wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/tags/2024.5.zip
  or
  wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```
After downloading the release offline source package, use `unzip` to extract it:
```bash
  # After extraction, you will get a source directory named PWMLFF-2024.5
  unzip 2024.5.zip
```

### 2. Create Conda Virtual Environment

#### Step 1. Install Anaconda3 (Skip if already installed)
You need to install Anaconda3 first, and then create a new Python virtual environment (search online for Linux Anaconda3 installation tutorials).

You can use this command to directly download Anaconda3 to your server:
```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
# If the download fails, use the browser to input the following download URL and then upload it to the server:
# https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh 
# You can also visit the webpage for more versions: https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/
```

#### Step 2. Create the Virtual Environment
After Anaconda is installed, create a virtual environment and specify the `python3.11` interpreter. Other versions may cause dependency conflicts or syntax issues. The subsequent compilation will be done in this virtual environment.
```bash
conda create -n pwmlff-2024.5 python=3.11 setuptools=68.0.0
# We recommend Python version 3.11. Higher versions of Python might cause errors during compilation, which we have not fully resolved yet. You must specify a `setuptools` version below 75.0.0 to avoid errors during data format conversion between numpy and Fortran.
```
After creating the virtual environment, activate it:
```bash
conda activate pwmlff2024.5
```

#### Step 3. Install Required Packages
Next, install the third-party dependencies required by PWMLFF. All dependencies are listed in the `requirements.txt` file. You can install them all by executing the `pip` command in the directory where this file is located. The process is shown below. Please be patient as it might take time to install packages like PyTorch.

```bash
# Step 1: Activate the Conda environment
conda activate pwmlff2024.5
# Step 2: Enter the root directory of the source code
# If you downloaded the source code online, enter the PWMLFF-2024.5 directory
cd PWMLFF-2024.5
# For offline source code packages, after extraction, enter the PWMLFF-master directory
pip install -r requirements.txt
```

### 3. Compilation and Installation

#### Step 1. Check Compilation Environment
Enter the `src` directory, which is at the same level as `requirements.txt`. 
First, check if `cuda/11.8`, `intel/2020`, and `gcc8.n` are loaded, and whether the `conda` virtual environment is active.

For the `intel/2020` compiler suite, make sure the `ifort` and `icc` compilers (version `19.1.3`), `mpi(2019)`, and `mkl(2020)` libraries are loaded. If they are loaded individually, ensure the versions are not lower than those mentioned.

As most compilation failures are caused by incorrect compiler versions, we provide a script to check the environment: `check_env.sh` located in the `/src/check/` directory. Run this script to verify that the compilation environment is ready.

```bash
cd src
sh ./check/check_env.sh
```
After execution, the script will display your environment information. A correct environment should look like this:
```txt
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
PyTorch is installed.
PyTorch version is 2.0 or above, current version is 2.2.
PyTorch is compiled with CUDA 11.8.
CUDA version is 11.8 or higher, current version is 11.8.89.
nvcc command exists.
```

The line 1 checks that the `ifort` compiler version is no less than 19.1, and it detects version 19.1, which meets the requirement.

The line 2 confirms that the MKL library is installed.

The line 3 verifies that the GCC version is exactly 8, which meets the requirement.

The line 4 checks that PyTorch is installed in the Python environment, and it is detected successfully.

The line 5 ensures that the PyTorch version is 2.0 or above, and version 2.2 is detected, which meets the requirement.

The line 6 checks if PyTorch is compiled with CUDA support, and it is found to include CUDA.

The line 7 confirms that the CUDA version is 11.8 or higher, and version 11.8.89 is detected.

The line 8 ensures the `nvcc` compiler exists, which is detected successfully.

### Step 2: Compile the Code

If your environment passes the checks mentioned earlier, you can proceed with compiling the code. Run the following commands to start the compilation:

```bash
sh clean.sh
sh build.sh
```

If you encounter any errors during compilation, refer to the [PWMLFF Common Installation Errors Summary](./Error%20Record/InstallError.md).

:::tip
If your issue remains unresolved, please send your system environment information, the compilation error logs, and a description of the steps you followed to support@pwmat.com or wuxingxing@pwmat.com. We will respond to you promptly.

- After compilation, the PWMLFF environment variables will automatically be added to your `.bashrc` file. If you do not wish to keep them, you can manually remove them from `.bashrc`:
```bash
export PATH=/the/path/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF-2024.5/src/:$PYTHONPATH
```
:::

At this point, the PWMLFF compilation and installation process is complete.

### Lammps for PWMLFF Compilation and Installation

:::tip
The current version of Lammps is compatible with the DP and NEP model-extracted force field models.

For force field models extracted from earlier versions of the Linear, NN, and DP models, refer to the [Lammps for PWMLFF documentation](http://doc.lonxun.com/1.1/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85) or the [source code repository](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/blob/master/README.md).
:::

The Lammps source installation requires you to download the Lammps source code, load the PWMLFF environment variables, and compile the source code. Here’s the step-by-step process.

### 1. Download the Source Code

You can download the source code from GitHub or download the release package:

- Download via GitHub or Gitee:
```bash
git clone -b libtorch_nep https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
or
git clone -b libtorch_nep https://gitee.com/pfsuo/Lammps_for_PWMLFF.git
```

- Or download the release package:
```bash
wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/tags/2024.5.zip
or
wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/2024.5

unzip 2024.5.zip  # Unzip the source code
```

### 2. Load the Compilation Environment Variables

Note that you must use the same Python virtual environment to compile both PWMLFF and Lammps. The following environment variables must be loaded before compiling Lammps:

```bash
# Load the compiler
load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable  # This is for GCC compiler. You can load your own 8.n version.

# Example of loading PWMLFF environment:
# Load the conda environment
source /the/path/anaconda3/etc/profile.d/conda.sh
# Activate the conda environment (must be the same as when compiling PWMLFF-2024.5)
conda activate pwmlff2024.5
# Load PWMLFF-2024.5 environment variables
export PATH=/the/path/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF-2024.5/src/:$PYTHONPATH
# Load shared library files
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```

:::info
1. The model export uses the Libtorch library, so ensure that the PWMLFF virtual environment is loaded during the software compilation.
2. The compilation and execution process requires the `op` (custom operator) library included in the PWMLFF package, so make sure it's part of the environment variables.
:::

### 3. Compile Lammps Code

#### Step 1: For the NEP model's GPU version, first compile the NEP C++ CUDA code into a shared library file:
```bash
cd src/PWMLFF/NEP_GPU
make clean
make
# After compilation, you will get a shared library file at /lammps-2024.5/src/libnep_gpu.so
```

#### Step 2: Compile the Lammps Interface

```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
make clean-all && make mpi -j4
```

If you encounter an error that says `cuda_runtime.h` cannot be found, replace line 24 of the `src/MAKE/Makefile.mpi` file with your own CUDA path, such as `/the/path/cuda/cuda-11.8`. The `cuda_runtime.h` file is located in the `include` directory under this path.

```txt
CUDA_HOME = $(CUDADIR)
Replace with:
CUDA_HOME = /the/path/cuda/cuda-11.8
```

:::tip
Here are some commonly used Lammps software packages that you can install along with PWMLFF:
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
For the Linear and NN models' Lammps interface, please refer to [`lammps4pwmlff/0.1.0 Installation`](http://doc.lonxun.com/en/1.0/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85).
:::

### 4. Load Lammps Environment and Run MD Example
```bash
# 1. For mpirun command
module load intel/2020
# 2. Load the conda environment and activate the conda virtual environment
source /the/path/to/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
# 3. Load PWMLFF environment variables
export PATH=/the/path/to/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF-2024.5/src/:$PYTHONPATH
# 4. Import PWMLFF-2024.5 shared library paths
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
# 5. Load Lammps environment variables
export PATH=/the/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$LD_LIBRARY_PATH
# 6. Run GPU Lammps command
mpirun -np 4 lmp_mpi_gpu -in in.lammps
# Or run the CPU Lammps command:
# mpirun -np 32 lmp_mpi -in in.lammps
```

:::caution
When submitting training jobs, ensure that the relevant environment is loaded in your job script, as shown below:

```
source /share/app/anaconda3/etc/profile.d/conda.sh
module load conda/3-2020.07
conda deactivate
conda activate PWMLFF
module load pwmlff/2024.5
```

**Loading the `pwmlff` and virtual environment is necessary to acquire the `LD_LIBRARY_PATH`.**  
**Lammps must include the `LD_LIBRARY_PATH` environment variable during runtime; otherwise, specific libraries cannot be invoked.**
:::
