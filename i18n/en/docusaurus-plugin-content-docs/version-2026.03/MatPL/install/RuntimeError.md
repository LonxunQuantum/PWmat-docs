---
sidebar_position: 4
title: Common Runtime Errors
---
## Common Runtime Errors
### Check Environment Variables
Runtime errors caused by missing or incorrectly loaded environment variables usually appear as a missing `MatPL` command or missing `***.so` shared libraries. Verify that all of the following environments have been loaded.
``` bash
# Python environment: verify that it has been activated
source /the/path/etc/profile.d/conda.sh
conda activate matpl-2025.3

# Intel and CUDA toolchains
module load intel/2020 cuda/11.8

# MatPL environment variables
source /the/path/MatPL-2025.3/env.sh
```

### Issue: CUDA driver version is insufficient for CUDA runtime version

#### 1. Symptom

When running GPU features or custom CUDA operators in MatPL, the program reports the following error:

```text
CUDA Error:
    File:       /data/home/wuxingxing/pack/pack-2026.3/gpu-install/MatPL-2026.3/MatPL-2026.3/src/op/kernel/calculateNepNeighbor.cu
    Line:       331
    Error code: 35
    Error text: CUDA driver version is insufficient for CUDA runtime version
```

`Error code: 35` indicates that the NVIDIA driver installed on the machine is too old to support the CUDA Runtime used by the program.

#### 2. Cause

Running a CUDA program requires both of the following conditions:

1. The CUDA Runtime loaded in the current environment is compatible with the CUDA version used to compile and package the program.
2. The NVIDIA driver is new enough to support that CUDA Runtime.

If the driver is too old, CUDA kernel startup fails even when the Conda environment, CUDA module, and MatPL environment are loaded correctly.

Use the following command to inspect the current driver:

```bash
nvidia-smi
```

For example, the following older driver supports CUDA only up to version 11.6:

```text
NVIDIA-SMI 510.39.01    Driver Version: 510.39.01    CUDA Version: 11.6
```

If the MatPL offline package or build environment uses CUDA 12.4, this driver is insufficient and triggers the error above.

#### 3. Solution

Upgrade the NVIDIA driver to a version that supports the CUDA Runtime used by the current MatPL environment.

After upgrading, the driver information may look like this:

```text
NVIDIA-SMI 550.100      Driver Version: 550.100      CUDA Version: 12.4
```

After the upgrade, log in to the node again or restart the relevant services, then run:

```bash
nvidia-smi
```

Confirm that `Driver Version` and `CUDA Version` now show compatible versions before rerunning MatPL.

:::caution
Switching Conda environments or reloading the CUDA module alone cannot resolve this issue. `CUDA Version` indicates the compatibility ceiling imposed by the NVIDIA driver. If the driver is too old, a system administrator must upgrade it.
:::

### Shared-Library Loading Error: MKL
``` bash
    exec(code, run_globals)
  File "/the/path/MatPL-2025.3/main.py", line 6, in <module>
    from src.user.dp_work import dp_train, dp_test
  File "/the/path/MatPL-2025.3/src/user/dp_work.py", line 6, in <module>
    from src.PWMLFF.dp_network import dp_network
  File "/the/path/MatPL-2025.3/src/PWMLFF/dp_network.py", line 42, in <module>
    import src.pre_data.dp_mlff as dp_mlff
  File "/the/path/MatPL-2025.3/src/pre_data/dp_mlff.py", line 11, in <module>
    from src.lib.NeighConst import neighconst
ImportError: libmkl_rt.so: cannot open shared object file: No such file or directory 
```

`Solution`: The Intel Math Kernel Library (MKL) has not been loaded. The `intel/2020` module—typically provided by Intel Parallel Studio XE 2020 or the Intel oneAPI Toolkits 2020—usually includes Intel MKL. Loading this module makes MKL available in the build and runtime environments.

``` bash
module load intel/2020
```

### Common LAMMPS Interface Runtime Errors

#### Check Environment Variables

Runtime errors caused by missing or incorrectly loaded environment variables usually appear as a missing `lmp_mpi` command or missing `***.so` shared libraries. Verify that the following environments have been loaded.

``` bash
# 1. Required for the mpirun command
module load intel/2020

# 2. Load the LAMMPS environment variables
source /the/path/of/lammps/env.sh

# 3. Run LAMMPS
# --bind-to numa binds processes to available cores on each socket, avoiding contention on default cores when multiple jobs run
mpirun -np 4 --bind-to numa lmp_mpi -in in.lammps
```

#### LAMMPS NEP Model

After an NEP model has run through the GPU interface for some time, the following error may occur:
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

`Solution`: This error usually occurs after the MD simulation has run for some time and the force-field fit becomes less accurate. The neighbor lists of some atoms then grow beyond the configured maximum. Increase the maximum number of neighbors as follows.
In the NEP force-field file—for example, `nep_to_lmps.txt` shown below:
``` txt
nep4   2 O Si
cutoff 6.0 5.0
n_max  4 4
basis_size 12 12
l_max  4 2 1
......
```
Change the `cutoff` line to
``` txt
cutoff 6.0 5.0 500 400
```
Here, `500` is the maximum neighbor count for the two-body (`radial_cutoff`) cutoff, and `400` is the maximum neighbor count for the many-body (`angular_cutoff`) term.

:::caution
If this error occurs, first check whether the MD trajectory is physically reasonable and whether the simulation itself has become unstable.
:::
