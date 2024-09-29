---
sidebar_position: 1
---

# Install and Load

The CPU version PWMLFF offline installation package integrates PWMLFF and the Lammps interface, including `Fortran`, `Python (Pytorch 2.0)`, and `C++` code. It requires a `Python environment`, `gcc compiler`, and `Intel compiler suite` (including `ifort`, `icc` compilers, `mkl`, and `mpi` libraries). Since GPU computing is not used, `NVIDIA GPU` support is not required.

Since configuring the conda environment is time-consuming and some user devices cannot connect to the internet, we have pre-configured the conda environment in the offline installation package. Users only need to download the offline package and install it to use.

## I. Offline Installation

### 1. Download the Offline Installation Package

Please download from Baidu Netdisk. If the link is invalid, please contact `wuxingxing@pwmat.com` or `support@pwmat.com` by email:

👉 [Download the CPU version offline installation package pwmlff_cpu-2024.5.sh.tar.gz](https://pan.baidu.com/s/1-MQBicDKaeudUhjmJRJrZA?pwd=pwmt)

### 2. Extract the Installation Package

```bash
tar -xzvf pwmlff_cpu-2024.5.sh.tar.gz
```

After extraction, you will get the following files:
`pwmlff_cpu-2024.5.sh`, `check_offenv_cpu.sh`

### 3. Check the Compiler Version

After extracting the CPU offline installation package, you will get the installation package `pwmlff_cpu-2024.5.sh` and `check_offenv_cpu.sh`. Run the following command:

```bash
sh check_offenv_cpu.sh
```

After executing the command, the required compiler versions and the currently detected versions will be listed. Below is the result of a correct environment configuration check:

```
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
```

Line 1 outputs that the ifort compiler requires a version not less than 19.1, and the detected current version is 19.1, which meets the requirement.

Line 2 checks whether the MKL library exists, and it is detected as installed, meeting the requirement.

Line 3 outputs that GCC requires version 8.n, and the detected current GCC version is 8, which meets the requirement.

The CPU version does not require CUDA and nvcc compiler support.

### 4. Execute the Installation Command

After the environment check is completed, execute the following command to complete the installation:

```bash
sh pwmlff_cpu-2024.5.sh
```

If the installation window displays the following log output at the end, the installation is successful:

```txt
mpicxx -g -O3 -std=c++17 -L/the/path/to/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/lib -lpython3.11 -static-libstdc++ -static-libgcc -L/the/path/to/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/lib/python3.11/site-packages/torch/lib/ -ltorch -lc10 -ltorch_cpu -L/the/path/to/PWMLFF_cpu-2024.5/PWMLFF/src/op/build/lib -lCalcOps_bind_cpu main.o      -L. -llammps_mpi      -ldl  -o ../lmp_mpi
size ../lmp_mpi
   text	   data	    bss	    dec	    hex	filename
11924907	  37816	  22640	11985363	 b6e1d3	../lmp_mpi
make[1]: Leaving directory `/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src/Obj_mpi'
PyTorch is not a CUDA version. Disabling CUDA support...
make[1]: Entering directory `/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src/Obj_mpi'
Skipping GPU version since CUDA is not enabled.
make[1]: Leaving directory `/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src/Obj_mpi'
Added Lammps PATH to .bashrc
Installation completed successfully!
Added torch lib LD_LIBRARY_PATH to .bashrc
```

:::tip

After installation, the environment variables for PWMLFF_cpu-2024.5 (as shown below) will be written into your `.bashrc` by default. If you do not need them, you can manually delete them from `.bashrc`. After deletion, you will need to manually import these environment variables each time before running PWMLFF.

```bash
# PWMLFF environment variables
export PATH=/the/path/to/PWMLFF_cpu-2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF_cpu-2024.5/PWMLFF/src/:$PYTHONPATH
# Lammps interface environment variables
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
export PATH=/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src:$LD_LIBRARY_PATH

Here `/the/path/to/` is your own installation directory.
```

:::

### 5. Load and Use

After successfully installing the offline package, you need to first activate the installed conda environment and the `intel/2020` module used during compilation. After that, if you need to use PWMLFF for training, load the PWMLFF environment variables; if you need to use the Lammps interface, continue to load the Lammps interface environment variables after loading the PWMLFF environment variables.

#### Step 1. Activate the Installed Conda Environment

```bash
# Here the environment address needs to be a full path, e.g., /data/home/wuxingxing/pack/PWMLFF-2024.5/pwmlff/bin/activate
source /the/path/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/bin/activate
```

#### Step 2. Load the Intel Compiler Package Used During Compilation

```bash
module load intel/2020
```

#### Step 3. Load PWMLFF Environment Variables

If your `./bashrc` (automatically written after offline installation) does not contain the following environment variables, please import them:

```bash
export PATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/:$PYTHONPATH
```

#### Step 4. Load the Lammps Interface

If your `./bashrc` (automatically written after offline installation) does not contain the following environment variables, please import them:

```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
export PATH=/the/path/PWMLFF_cpu-2024.5/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/PWMLFF_cpu-2024.5/lammps-2024.5/src:$LD_LIBRARY_PATH
```

### 6. Exit the Conda Virtual Environment

You can exit the virtual environment using the following command, or simply close the current shell window:

```bash
source /the/path/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/bin/deactivate
```

## 2. Online Installation

The online installation requires compiling and installing both PWMLFF and the LAMMPS interface separately.

To compile and run PWMLFF-2024.5, you need to download the source code, set up a conda environment, and install the necessary dependencies within the conda environment.

The LAMMPS interface requires a successful installation of PWMLFF before compiling.

The process is outlined as follows:

### PWMLFF Compilation and Installation

The CPU version of PWMLFF and the LAMMPS interface source code is the same as the GPU version, with the difference being that the GPU version enables GPU-accelerated code. The compilation process is similar to the GPU version, except that the PyTorch dependency installed for the CPU version does not include CUDA support, and the compilation process does not require CUDA.

### 1. Download the Source Code
We offer two ways to obtain the code: through online repository cloning or downloading offline packages.

- Clone the PWMLFF repository from GitHub or Gitee:
```bash
git clone https://github.com/LonxunQuantum/PWMLFF.git PWMLFF-2024.5
or
git clone https://gitee.com/pfsuo/PWMLFF.git PWMLFF-2024.5
```

- Alternatively, download the release offline source code package:
```bash
wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/tags/2024.5.zip
or
wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```
After downloading the offline package, unzip it:
```bash
unzip 2024.5.zip
```

### 2. Create a Conda Virtual Environment

#### Step 1. Install Anaconda3 (skip if already installed)
You should already have Anaconda3 installed. You can then create a new Python virtual environment (search for "Linux Anaconda3 installation tutorial" for guidance).

You can use the following command to directly download Anaconda3 to your server directory:
```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
# If the download fails, you can open the link below in your browser, download, and upload it to the server
# https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh 
# You can also visit https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/ for more versions
```

#### Step 2. Create a Virtual Environment
After installing Conda, create a virtual environment. Be sure to specify Python 3.11 as the interpreter, as other versions might cause dependency conflicts or syntax issues. The following compilation steps will be conducted in this environment.

```bash
conda create -n pwmlff-2024.5 python=3.11 setuptools=68.0.0
# We recommend Python 3.11. Higher versions may cause errors during compilation, which we haven't yet addressed. Make sure to specify setuptools <75.0.0 to avoid errors during numpy and Fortran data format conversion.
```
After creating the virtual environment, activate it:
```bash
conda activate pwmlff2024.5
```

#### Step 3. Install Dependencies
Next, install the third-party dependencies required by PWMLFF. We've included all necessary dependencies in the `requirement_cpu.txt` file. Simply run the `pip` command in the directory containing this file to install all dependencies. This step may take some time as it installs PyTorch and other Python packages.

```bash
# Step 1: Activate conda environment
conda activate pwmlff2024.5
# Step 2: Enter the source code root directory
# For the code cloned online, go to the PWMLFF-2024.5 directory
cd PWMLFF-2024.5
# For the offline package, enter the PWMLFF-2024.5 directory after unzipping
pip install -r requirement_cpu.txt
```

### 3. Compilation and Installation

#### Step 1. Check Compilation Environment
Enter the `src` directory where the `requirement_cpu.txt` file is located. First, check if the `intel/2020` and `gcc8.n` compilers are loaded, and confirm that the `conda` virtual environment is activated.

The `intel/2020` compiler suite includes `ifort` and `icc` compilers (`19.1.3`), `mpi(2019)`, and `mkl(2020)`. If you load these components individually, ensure the versions are no lower than these.

Most compilation failures are due to incorrect compiler versions. We provide a script, `check_env_cpu.sh`, located in the `/src/check/` directory, to check if your compilation environment is properly set up.

```bash
cd src
sh ./check/check_env_cpu.sh
```
The script will output your environment information. A correct environment might look like this:
```txt
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
PyTorch is installed.
PyTorch version is 2.0 or above, current version is 2.2.
```

#### Step 2. Compile the Code
If your environment passes the checks, proceed with the code compilation:
```bash
sh clean.sh
sh build.sh
```

If errors occur during compilation, check the [PWMLFF Installation Error Summary](./Error%20Record/InstallError.md) for possible solutions.

:::tip
If you cannot resolve the issue, send your machine's environment information, compilation error logs, and a description of the compilation process to support@pwmat.com or wuxingxing@pwmat.com, and we will assist you promptly.

- After compilation, the PWMLFF environment variables will be automatically added to the `.bashrc` file. If not needed, you can manually remove them.
```txt
export PATH=/the/path/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF-2024.5/src/:$PYTHONPATH
```
:::

At this point, the PWMLFF installation is complete.

### LAMMPS for PWMLFF Compilation and Installation

:::tip
The current version of LAMMPS is suitable for force field models extracted using DP and NEP models.

For older models such as Linear, NN, and DP, please refer to [LAMMPS for PWMLFF v0.0.1 installation guide](http://doc.lonxun.com/1.1/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85) or the [source code repository](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/blob/master/README.md).
:::

The installation of LAMMPS from source involves downloading the source code, loading PWMLFF environment variables, and compiling the code, as shown below.

### 1. Download Source Code
You can download the source code from GitHub or the release package.
- Clone the source code from GitHub or Gitee:
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

unzip 2024.5.zip    # Unzip the source code
```

### 2. Load Compilation Environment Variables

Make sure to use the same Python virtual environment for both compiling PWMLFF and LAMMPS. To compile LAMMPS, load the following environment variables.

```bash
# Load the compiler
load intel/2020
source /opt/rh/devtoolset-8/enable # This is for GCC; you can load your own version 8.x

# Example of loading the PWMLFF environment
# Load the conda environment
source /the/path/anaconda3/etc/profile.d/conda.sh
# Activate the conda environment; ensure this environment is the same as the one used to compile PWMLFF-2024.5
conda activate pwmlff2024.5 
# Load the PWMLFF-2024.5 environment variables
export PATH=/the/path/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF-2024.5/src/:$PYTHONPATH
# Load shared library files
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```

:::info

1. The model export uses the Libtorch library. Ensure the PWMLFF virtual environment is loaded when compiling.
2. Both compilation and execution require the `op` (custom operator) library included in the PWMLFF package, which must be set in the environment variables.
:::

### 3. Compile LAMMPS Code
For a CPU-based system without using NEP model GPU acceleration, you can directly compile the LAMMPS interface.

```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
make clean-all && make mpi -j4
```
:::tip
Here are some commonly used LAMMPS packages that you can install along with PWMLFF:
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
For the LAMMPS interface with Linear and NN models, please refer to [`lammps4pwmlff/0.1.0 Installation`](http://doc.lonxun.com/en/1.0/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85).
:::

### 4. Run LAMMPS with Loaded Environment for MD Examples
```bash
# 1. Use the mpirun command
module load intel/2020
# 2. Load the conda environment and activate the conda virtual environment
source /the/path/to/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
# 3. Load PWMLFF environment variables
export PATH=/the/path/to/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF-2024.5/src/:$PYTHONPATH
# 4. Import shared library paths for PWMLFF-2024.5
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
# 5. Load LAMMPS environment variables
export PATH=/the/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$LD_LIBRARY_PATH
# 6. Run the LAMMPS GPU command
mpirun -np 4 lmp_mpi -in in.lammps
# Or run the LAMMPS CPU command
# mpirun -np 32 lmp_mpi -in in.lammps
```
:::caution
When submitting training jobs, ensure the relevant environments are loaded in the script, as shown below:

```
source /share/app/anaconda3/etc/profile.d/conda.sh
module load conda/3-2020.07
conda deactivate
conda activate PWMLFF
module load pwmlff/2024.5
```
**Loading `pwmlff` and the virtual environment is necessary to obtain `LD_LIBRARY_PATH`.**
**The `LD_LIBRARY_PATH` environment variable must be set when running LAMMPS, otherwise specific libraries cannot be called.**
:::

