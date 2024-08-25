---
sidebar_position: 0
---

# Runtime Error

This chapter organizes common runtime errors related to `PWMLFF` and the `Lammps` interface.

## Common Runtime Errors in PWMLFF

### Environment Variable Check
Runtime errors caused by not loading or incorrectly loading the relevant environment variables typically manifest as missing `PWMLFF` commands or missing `***.so` dynamic libraries. In this case, please check if the following environment variables have been loaded.

```bash
# Check if the Python environment is activated
source /the/path/etc/profile.d/conda.sh
conda activate PWMLFF

# Check if the Intel and CUDA toolsets are loaded
module load intel cuda/11.8

# Check if PWMLFF environment variables are loaded
export PYTHONPATH=/the/path/PWMLFF_feat/src:$PYTHONPATH
export PATH=/the/path/PWMLFF_feat/src/bin:$PATH
```

### Dynamic Library Loading Error - MKL Library

#### Error Description

```bash
exec(code, run_globals)
File "/the/path/PWMLFF_nep/pwmlff_main.py", line 6, in <module>
    from src.user.dp_work import dp_train, dp_test
File "/the/path/PWMLFF_nep/src/user/dp_work.py", line 6, in <module>
    from src.PWMLFF.dp_network import dp_network
File "/the/path/PWMLFF_nep/src/PWMLFF/dp_network.py", line 42, in <module>
    import src.pre_data.dp_mlff as dp_mlff
File "/the/path/PWMLFF_nep/src/pre_data/dp_mlff.py", line 11, in <module>
    from src.lib.NeighConst import neighconst
ImportError: libmkl_rt.so: cannot open shared object file: No such file or directory
```

#### Solution
The Intel Math Kernel Library (MKL) has not been loaded. The `intel/2020` module (one of the modular software components in Intel Parallel Studio XE 2020 or Intel oneAPI Toolkits 2020) usually includes the Intel MKL library. When you load this module, the MKL library will be available in your compilation and runtime environment.

```bash
module load intel/2020
```

## Common Runtime Errors in the Lammps Interface

### Environment Variable Check

Runtime errors caused by not loading or incorrectly loading the relevant environment variables typically manifest as missing `lmp_mpi` or `lmp_mpi_gpu` commands or missing `***.so` dynamic libraries. In this case, please check if the following environment variables have been loaded.

```bash
#1. For the mpirun command
module load intel/2020

#2. Load the conda environment and activate the conda virtual environment
source /the/path/etc/profile.d/conda.sh
conda activate PWMLFF

#3. Load PWMLFF environment variables
export PATH=/the/path/to/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF2024.5/src/:$PYTHONPATH

#4. Import the shared library path for PWMLFF2024.5
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib

#5. Load Lammps environment variables
export PATH=/the/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$LD_LIBRARY_PATH

#6. Run the GPU Lammps command
mpirun -np 4 lmp_mpi_gpu -in in.lammps
# Or run the CPU Lammps command
# mpirun -np 32 lmp_mpi -in in.lammps
```