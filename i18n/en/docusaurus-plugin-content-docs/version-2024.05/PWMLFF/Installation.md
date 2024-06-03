---
sidebar_position: 1
---

# Load and Install (In Mcloud)

## PWMLFF

:::tip
PWMLFF includes Fortran, Python, and CUDA acceleration, requiring installation in an environment with Python, gcc compiler, and GPU hardware. We provide three ways to install PWMLFF.
:::

### 1. Direct Loading in Mcloud

`mcloud` already has a configured conda environment, which can be directly called to avoid the time-consuming process of installing anaconda, cudatoolkit, pytorch, etc. To use 'PWMLFF', please load the following environment variables:

``` bash
# load conda environment
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
# #PWMLFF is used for PWMLFF2024.5 or pwmff/2024.03.06 versions
module load pwmlff/2024.5
```

### 2. Offline Installation

For non-networked devices, you can directly download the pre-configured conda environment and program package:

#### 1. Download

👉[Baidu Cloud Link](https://pan.baidu.com/s/1K4TrZuh4WVzSwfu2ZzL5mg?pwd=pwmt) Select the latest version to download (the current latest version is 2024.05).

#### 2. Unzip

```bash
gzip -d pwmlff.2024.5.sh.gz
```

After unzipping, you will get the `pwmlff.2024.5.sh` file. Run this file to complete the environment installation.

:::caution
Before running `pwmlff.2024.5.sh`, you still need to load the necessary modules for compilation, namely intel, cuda, and gcc.

for users of Mcloud, jsut load
module load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable
:::

```bash
./pwmlff.2024.5.sh
# or sh pwmlff.2024.5.sh
```

After running, a folder named `PWMLFF2024.5` containing all environment configurations (`pwmlff`) and program packages (`PWMLFF`) will be generated in the running directory.

After unzipping and compiling, update the environment variables:

```bash
source ~/.bashrc
```

#### 3. Usage

Activate the environment

```bash
source /the/path/PWMLFF2024.5/pwmlff/bin/activate
```

Deactivate the environment

```bash
source /the/path/PWMLFF2024.5/pwmlff/bin/deactivate
```

### 3. Online Installation

1. First, load the compilers required to compile PWMLFF
```bash
# Mcloud users can directly load the following environment
module load cuda/11.8-share intel/2020 cmake/3.21.6
source /opt/rh/devtoolset-8/enable
```
We recommend using `intel2020` version, `cuda/11.8`, `cmake version >= 3.21`, and `gcc version 8.n`.

2. Create a new Python virtual environment in the user's directory. It is recommended to manually download and use Anaconda3 for environment management (search for Linux Anaconda3 installation tutorials via search engines).

You can use this command to download Anaconda3 directly to the server directory:

```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh

#If you cannot download, please visit the webpage https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/ to download, or use other methods to download.
```

After installing conda, create a virtual environment specifying the Python 3.11 interpreter. Other versions may cause dependency conflicts or syntax issues. All subsequent compilation work will be done in this virtual environment.

```bash
conda create -n pwmlff2024.5 python=3.11
```

3. After the virtual environment is installed, reactivate the environment:

```bash
conda deactivate
conda activate pwmlff2024.5
```

4. Install third-party dependencies required by PWMLFF:

```bash
pip3 install numpy tqdm cmake pyyaml pandas scikit-learn-intelex matplotlib pwdata pwact pybind11 
pip3 install charset_normalizer==3.3.2

# Ensure charset_normalizer is the latest version (3.3.2 or above), otherwise, there will be encoding errors when compiling Fortran code
# UnicodeDecodeError: 'ascii' codec can't decode byte 0xe4 in position 144: ordinal not in range(128)
```

```python
pip install torch==2.2.0  --index-url https://download.pytorch.org/whl/cu118
# If you want to use torch version 2.3 or above, use gcc version 9.0 or above
```

If you need to install other versions of `pytorch`, please refer to the [Pytorch official website](https://pytorch.org/get-started/previous-versions/).

5. After completing the installation of third-party dependencies, proceed with the [compilation and installation](#compilation-installation) of PWMLFF.

#### Compilation and Installation

6. After preparing the environment, you need to download and compile the source code. We provide two ways to compile: pulling the code online and downloading an offline package.

- Pull the PWMLFF repository code online via GitHub or Gitee:
```bash
  $ git clone https://github.com/LonxunQuantum/PWMLFF.git
  or
  $ git clone https://gitee.com/pfsuo/PWMLFF.git
```

After pulling the code, enter the PWMLFF source `src` directory to compile the source code:
```bash
  $ cd PWMLFF/src
  $ sh build.sh
```

- Or download the release offline package. You can directly enter the following address in the browser to download, or use the `wget` command to download:
```bash
  $ wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/heads/master.zip
  or
  $ wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```
After downloading the release offline package, unzip and compile as follows:

```bash
  $ unzip master.zip
  $ cd PWMLFF-master/src
  $ sh build.sh
```

:::tip
- After compilation, the PWMLFF environment variables will be automatically added to the .bashrc file. If not needed, please manually delete the environment variables in .bashrc. You can execute the following command to update the environment variables:
```bash
source ~/.bashrc
```
:::

At this point, the complete compilation and installation of PWMLFF are finished. For subsequent use, ensure you are in the PWMLFF virtual environment and have loaded the Intel compiler.

## Lammps (Recompiled version for PWMLFF)

:::tip
The current version of Lammps is suitable for force field models extracted using DP and NEP models.

For the old Linear, NN, and DP models, see [Lammps for PWMLFF](http://doc.lonxun.com/1.1/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85).
:::

We provide two solutions for installing Lammps. For Mcloud users, the pre-installed Lammps interface can be directly loaded and used. Additionally, users are provided with the option to compile and install from source code.

### 1. Direct Loading via Mcloud

Mcloud has already installed the Lammps interface corresponding to PWMLFF2024.5. You can load it with the following command:

```bash
module load lammps4pwmlff/2024.5
```

### 2. Installation by Compiling from Source Code

The source code installation involves the following steps:

1. Download Lammps source code. You can download the source code from GitHub or a release package.
- Clone the source code via GitHub or Gitee:
```bash
$ git clone -b libtorch https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
or
$ git clone -b libtorch https://gitee.com/pfsuo/Lammps_for_PWMLFF.git
```

- Or download the release package:
```bash
$ wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/tags/2024.5.zip
or
$ wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/2024.5

$ unzip 2024.5.zip    # Unzip the source code
```

2. Load the Compilation Environment Variables

Note that you need to use the same Python virtual environment for compiling PWMLFF and Lammps. To compile Lammps, you need to load the following environment variables.

```bash
# Example of loading the PWMLFF environment
# Load the conda environment
source /the/path/anaconda3/etc/profile.d/conda.sh
# Activate the conda environment. Note that the virtual environment used here needs to be the same as the one used when compiling PWMLFF2024.5
conda activate pwmlff2024.5 
# Load the PWMLFF2024.5 environment variables
export PATH=/the/path/codespace/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/codespace/PWMLFF2024.5/src/:$PYTHONPATH
# Load the shared library files
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```

:::info

1. Model export uses the Libtorch library, ensure the virtual environment where PWMLFF resides is loaded during software compilation.
2. The compilation and execution of the program require the `op` (custom operator) library included in the PWMLFF package, ensure it is in the environment variables.
   :::

3. Compile the Lammps code

```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
make clean-all && make mpi -j4
```

4. Add the Lammps executable to the environment variables

```bash
vim ~/.bashrc
export PATH=absolute/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
source ~/.bashrc
```

5. Add the Pytorch related libraries to the environment variables
When running Lammps, you need to load the following environment variables:
```bash
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```
You can also execute the following command to add the shared library file path to `./bashrc`, so it won't be necessary to load these environment variables every time you use Lammps:
```bash
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib" >> ~/.bashrc
```

**The purpose of loading `pwmlff` and the virtual environment is to obtain the `LD_LIBRARY_PATH`.**

**Lammps must include the `LD_LIBRARY_PATH` environment variable during execution, otherwise specific libraries cannot be called.**

---

:::caution
When submitting a training task, make sure the task script loads the relevant environment as shown below:

```
module load intel/2020
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF

# The following are some solutions to potential problems
export MKL_SERVICE_FORCE_INTEL=1
export MKL_THREADING_LAYER=GNU
export I_MPI_HYDRA_BOOTSTRAP=slurm
export I_MPI_PMI_LIBRARY=/lib64/libpmi.so
```

- Lines 5 and 6 address the issue of mismatched versions of Pytorch and Numpy.
- The last two lines address the issue of multiple Lammps tasks being unable to run in parallel simultaneously.

:::

### Running MD Examples with Lammps Environment Loaded

#### Load the pre-installed Lammps on Mcloud for MD

```bash
module load lammps4pwmlff/2024.5

mpirun -np 1 lmp_mpi_gpu -in in.lammps
# If you are using the CPU version
# mpirun -np 1 lmp_mpi -in in.lammps
```

#### Load your own environment for MD

```bash
# For mpirun command
module load intel/2020

# Load and activate the conda environment
source /data/home/wuxingxing/anaconda3/etc/profile.d/conda.sh
conda activate torch2_feat

# Load the PWMLFF environment variables
export PATH=/data/home/wuxingxing/codespace/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/data/home/wuxingxing/codespace/PWMLFF2024.5/src/:$PYTHONPATH

# Import the shared library path of PWMLFF2024.5
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib

# Load the Lammps environment variables
export PATH=/data/home/wuxingxing/codespace/Lammps_for_PWMLFF-2024.5/src:$PATH

# GPU Lammps command
mpirun -np 1 lmp_mpi_gpu -in in.lammps

# CPU Lammps command
# mpirun -np 32 lmp_mpi -in in.lammps
```