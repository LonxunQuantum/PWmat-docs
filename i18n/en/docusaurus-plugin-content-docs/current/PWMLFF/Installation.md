---
sidebar_position: 1
---

# Load and Install (In Mcloud)

## PWMLFF

:::tip
PWMLFF includes Fortran, Python, and CUDA acceleration, requiring installation in an environment with Python, gcc compiler, and GPU hardware. We provide three ways to install PWMLFF.
:::

### 1. Direct Loading in Mcloud

`mcloud` already has a configured conda environment, which can be directly called to avoid the time-consuming process of installing anaconda, cudatoolkit, pytorch, etc. The steps are as follows:

```
module load pwmlff
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
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

Online installation requires that you have already installed the relevant compilers and a conda virtual environment.

#### Environment Configuration

1. First, load the compilers (**intel ≥ 2016, gcc ≥ 7.0**) and cuda (recommended **11.8**) required to compile PWMLFF

```
module load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable
```

2. Create a new Python virtual environment in the user directory. It is recommended to manually download and use Anaconda3 for environment management (search for a Linux installation Anaconda3 tutorial using a search engine).

You can use this command to download Anaconda3 directly to the server directory:

```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
```

After conda installation, create a virtual environment, specifying the installation of the python3.11 interpreter. Other versions may cause dependency conflicts or syntax support issues. All subsequent compilation work will be carried out in this virtual environment.

```
conda create -n PWMLFF python=3.11
```

3. Reactivate the virtual environment after installation

```
conda deactivate
conda activate PWMLFF
```

4. Install third-party dependencies required for PWMLFF

```bash
pip3 install numpy tqdm cmake pyyaml pandas scikit-learn-intelex matplotlib pwdata pwact pybind11 
pip3 install charset_normalizer==3.3.2

# Ensure charset_normalizer is installed to the latest version (version 3.3.2 or above), otherwise there will be encoding errors when compiling fortran code 
#UnicodeDecodeError: 'ascii' codec can't decode byte 0xe4 in position 144: ordinal not in range(128)
```

```python
pip3 install torch --force-reinstall --index-url https://download.pytorch.org/whl/cu118
```

If you need to install other versions of `pytorch`, please refer to the [Pytorch official website](https://pytorch.org/get-started/previous-versions/).

5. After installing the third-party dependencies, proceed with the [compilation and installation](#compilation-and-installation) of PWMLFF.

#### Compilation and Installation

- Online installation:

  ```bash
  $ git clone https://github.com/LonxunQuantum/PWMLFF.git
  or
  $ git clone https://gitee.com/pfsuo/PWMLFF.git

  $ cd PWMLFF/src
  $ sh build.sh
  ```

  - Source code download:
    - https://github.com/LonxunQuantum/PWMLFF
    - https://gitee.com/pfsuo/PWMLFF

  Alternatively, use the following commands to download the source code to the user directory and unzip for installation:

  ```bash
  $ wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/heads/master.zip
  or
  $ wget https://gitee.com/pfsuo/PWMLFF/repository/archive/master.zip

  $ unzip master.zip
  $ cd PWMLFF-master/src
  $ sh build.sh
  ```

- After the compilation is complete, update the environment variables by executing the following command:

```bash
source ~/.bashrc
```

At this point, the complete compilation and installation of PWMLFF is finished. Ensure that you are in the PWMLFF virtual environment and have loaded the intel compiler for subsequent use.

## Lammps (Recompiled version for PWMLFF)

:::tip
The current version of Lammps is suitable for force field models extracted using DP and NEP models.

For the old Linear, NN, and DP models, see [Lammps for PWMLFF](http://doc.lonxun.com/1.1/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85).
:::

### Direct Loading in Mcloud

```bash
module load lammps4pwmlff
```

### Compilation and Installation

After constructing the force field model using PWMLFF, use the matching Lammps for molecular dynamics simulations. Here are the detailed installation steps:

1. Load the required modules for compilation (example for Mcloud)

```
module load pwmlff
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
```

:::info

1. Model export uses the Libtorch library, ensure that the PWMLFF virtual environment is loaded when compiling the software.
2. The compilation and execution program needs to use the `op` (custom operator) library included in the PWMLFF package, ensure it is in the environment variables.
:::

- Online installation:

```bash
$ git clone -b libtorch https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
or
$ git clone -b libtorch https://gitee.com/pfsuo/Lammps_for_PWMLFF.git
```

```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
make clean-all && make mpi -j4
```

- Source code download:

  - https://github.com/LonxunQuantum/Lammps_for_PWMLFF/tree/libtorch
  - https://gitee.com/pfsuo/Lammps_for_PWMLFF/tree/libtorch/

  Alternatively, use the following commands to download the source code to the user directory and unzip for installation:

```bash
$ wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/tags/2024.5.zip
or
$ wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/2024.5.zip

$ unzip 2024.5.zip    # After unzipping, enter the source directory and complete the above compilation and installation steps
```

2. Add the Lammps executable file to the environment variables

```bash
vim ~/.bashrc
export PATH=absolute/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
source ~/.bashrc
```

3. Add Pytorch-related libraries to the environment variables

```bash
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib" >> ~/.bashrc
```

**The purpose of loading `pwmlff` and the virtual environment is to get `LD_LIBRARY_PATH`.**

**The `LD_LIBRARY_PATH` environment variable must be included when running Lammps, otherwise, the specific libraries cannot be called.**

---

:::caution
When submitting training tasks, ensure that the relevant environment is loaded in the task script, as shown below:

```
module load intel/2020
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF

# The following lines solve potential issues
export MKL_SERVICE_FORCE_INTEL=1
export MKL_THREADING_LAYER=GNU
export I_MPI_HYDRA_BOOTSTRAP=slurm
export I_MPI_PMI_LIBRARY=/lib64/libpmi.so
```

- The 5th and 6th lines resolve the issue of version mismatch between pytorch and numpy.
- The last two lines solve the issue of multiple Lammps tasks not running in parallel.

:::