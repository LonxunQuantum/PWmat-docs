---
sidebar_position: 0
---

# Runtime Error

This chapter organizes common runtime errors for the `PWMLFF` and `LAMMPS` interfaces.

## Common Runtime Errors for PWMLFF

### Environment Variable Check

Runtime errors caused by not properly loading or missing related environment variables generally manifest as an inability to find the `PWMLFF` command or missing `***.so` dynamic libraries. In such cases, check if the following environment variables have been loaded:

```bash
# Python environment - Check if the Python environment is activated
source /the/path/etc/profile.d/conda.sh
conda activate PWMLFF

# Check if the Intel and CUDA toolsets are loaded
module load intel cuda/11.8

# Check if the PWMLFF environment variables are loaded
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

The Intel Math Kernel Library (MKL) is not loaded. The `intel/2020` module (one of the modular software components in Intel Parallel Studio XE 2020 or Intel oneAPI Toolkits 2020) typically contains the Intel MKL library. Loading this module makes the MKL library available in your compilation and runtime environment.

```bash
module load intel/2020
```

## Common Runtime Errors for LAMMPS Interface

### Environment Variable Check

Runtime errors caused by not properly loading or missing related environment variables generally manifest as an inability to find the `lmp_mpi` or `lmp_mpi_gpu` command, or missing `***.so` dynamic libraries. In such cases, check if the following environment variables have been loaded:

```bash
# 1. For the mpirun command
module load intel/2020

# 2. Load and activate the conda environment
source /the/path/etc/profile.d/conda.sh
conda activate PWMLFF

# 3. Load PWMLFF environment variables
export PATH=/the/path/to/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF2024.5/src/:$PYTHONPATH

# 4. Import the shared library paths for PWMLFF2024.5
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib

# 5. Load LAMMPS environment variables
export PATH=/the/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$LD_LIBRARY_PATH

# 6. Run the GPU LAMMPS command
mpirun -np 4 lmp_mpi_gpu -in in.lammps
# Or run the CPU LAMMPS command
# mpirun -np 32 lmp_mpi -in in.lammps
```

### LAMMPS DP Model

#### Error Description

When starting LAMMPS for DP model MD, the following error occurs:

```txt
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
```

#### Solution

This error is generally caused by an inconsistency between the PWMLFF dynamic library used when compiling LAMMPS and the PWMLFF dynamic library used when running LAMMPS. If you have multiple versions of PWMLFF, ensure that the PWMLFF environment variables used when running LAMMPS are the same as those used during compilation.

### LAMMPS NEP Model

#### Error Description

When running the NEP model in the GPU interface, the following error occurs after some time:

```txt
    ......
    97000   1293.8659     -70999.672      35.957737     -70963.715      13.66254       13.66254       12.50455       2334.1619    
    98000   1191.7602     -71009.412      33.120127     -70976.292      13.577541      13.577541      12.426755      2290.8676    
    99000   1219.1286     -71013.893      33.880718     -70980.012      13.488421      13.48842       12.345188      2246.0524    
CUDA Error:
    File:       utilities/gpu_vector.cu
    Line:       117
    Error code: 700
    Error text: an illegal memory access was encountered

===================================================================================
=   BAD TERMINATION OF ONE OF YOUR APPLICATION PROCESSES
=   RANK 0 PID 5490 RUNNING AT gn59
=   KILLED BY SIGNAL: 9 (Killed)
===================================================================================

===================================================================================
=   BAD TERMINATION OF ONE OF YOUR APPLICATION PROCESSES
=   RANK 1 PID 5491 RUNNING AT gn59
=   KILLED BY SIGNAL: 9 (Killed)
===================================================================================

===================================================================================
=   BAD TERMINATION OF ONE OF YOUR APPLICATION PROCESSES
=   RANK 2 PID 5492 RUNNING AT gn59
=   KILLED BY SIGNAL: 9 (Killed)
===================================================================================
```

#### Solution

This error generally occurs after the MD simulation has run for some time, where the accuracy of the force field fitting declines, causing significant changes in the neighbor list of some atoms, exceeding the initially set maximum number of neighbors. To resolve this, increase the maximum number of neighbors.

Adjustment method:
In the NEP force field file, such as `nep_to_lmps.txt`, modify the `cutoff` line as follows:

```txt
cutoff 6.0 5.0 500 400
```

Here, `500` is the maximum number of neighbors for the two-body (radial_cutoff) interaction, and `400` is the maximum number of neighbors for the many-body (angular_cutoff) interaction.

:::caution
Please note, if this error occurs, first check whether the MD trajectory file is normal and if the MD simulation itself is stable.
:::