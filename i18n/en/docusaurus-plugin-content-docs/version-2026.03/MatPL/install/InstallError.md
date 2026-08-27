---
sidebar_position: 3
title: Common Installation Errors
---
## Common Installation Errors
### Build Environment
Most installation failures are caused by incompatible build-environment versions or missing environment variables. First, verify that the following compilers and tools are installed correctly and have compatible versions.

We recommend `intel2020`, `cuda/11.8`, `CMake >= 3.21`, and `GCC 8.x`.
MatPL uses `PyTorch >= 2.0` and requires `CUDA 11.8` or later.

The `intel/2020` toolchain provides the `ifort` and `icc` compilers (`19.1.3`), `MPI 2019`, and `MKL 2020`. If you load these components separately, use versions no older than these.

You can check the environment with `src/check/check_env.sh` in the source root. A valid environment produces output similar to the following.
``` txt
1. CUDA version is 11.8.
2. nvcc command exists.
3. ifort version is no less than 19.1, current version is 19.1.
4. MKL library is installed.
5. GCC version is not 8.x, current version is 8.
6. PyTorch is installed.
7. PyTorch version is 2.0 or above, current version is 2.2.
```

### Issue: `cuda_runtime.h` Header Not Found

If `cuda_runtime.h` cannot be found during compilation, replace line `24` of `src/MAKE/Makefile.mpi` with the path to your CUDA installation, such as `/the/path/cuda/cuda-11.8`. The header is located in the `include` subdirectory.

```txt
CUDA_HOME = $(CUDADIR)
Replace with CUDA_HOME = /the/path/cuda/cuda-11.8
```

### Issue: NeighConst.so Compilation Error
#### Error Description
The following error occurs while compiling the Fortran code:

```
ifort -O3 least_squares.f90 counts_atom.f90 scan_title.f90 transform_to_upper.f90 \
        find_neighbore00.f90 find_neighbore.f90 find_feature_deepMD2.f90  \
        gen_deepMD2_feature.f90 \
	-o gen_deepMD2_feature.x -mkl
python3 -m numpy.f2py -c -m NeighConst --fcompiler=intelem --compiler=intelem -L/share/app/intel2020ucompilers_and_libraries_2020.4.304/linux/mkl/lib/intel64/ -lmkl_rt NeighConst.f90
Traceback (most recent call last):
  File "<frozen runpy>", line 198, in _run_module_as_main
  File "<frozen runpy>", line 88, in _run_code
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/f2py/__in__.py", line 5, in <module>
    main()
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/f2py/f22e.py", line 766, in main
    run_compile()
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/f2py/f22e.py", line 594, in run_compile
    build_backend = f2py_build_generator(backend_key)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/f2py/_bkends/__init__.py", line 6, in f2py_build_generator
    from ._distutils import DistutilsBackend
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/f2py/_bkends/_distutils.py", line 3, in <module>
    from numpy.distutils.core import setup, Extension
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/distuti/core.py", line 24, in <module>
    from numpy.distutils.command import config, config_compiler, \
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/distuti/command/config.py", line 19, in <module>
    from numpy.distutils.mingw32ccompiler import generate_manifest
  File "/data/home/wuxingxing/anaconda3/envs/pwmlff-2024.5/lib/python3.11/site-packages/numpy/distuti/mingw32ccompiler.py", line 27, in <module>
    from distutils.msvccompiler import get_build_version as get_build_msvc_version
ModuleNotFoundError: No module named 'distutils.msvccompiler'
make: *** [NeighConst.so] Error 1
make: Leaving directory `/data/home/wuxingxing/codespace/PWMLFF_gpu/src/pre_data/gen_feature'
make: Entering directory `/data/home/wuxingxing/codespace/PWMLFF_gpu/src/pre_data/fit'
```

#### Cause
This error is caused by an incompatible `setuptools` version, usually one that is too recent. Downgrade `setuptools` as follows:
``` bash
# Uninstall setuptools
$ pip uninstall setuptools
# Clear the local cache
$ pip cache purge
# Reinstall setuptools
$ pip install setuptools==68.0.0
# In our tests, version 68.0.0 or earlier works
```


### Issue: `Unknown CUDA Architecture Name 9.0a` When Building the Offline Package

#### 1. Symptom

When compiling custom operators in the MatPL offline package, the PyTorch CMake configuration fails during `cmake ..` with the following error:

```text
-- PyTorch built with CUDA support: TRUE
-- CUDA toolkit found: /share/app/cuda/cuda-12.4/bin/nvcc
-- Enabling GPU compilation: PyTorch has CUDA support AND CUDA toolkit is available
-- Automatic GPU detection failed. Building for common architectures.
-- Autodetected CUDA architecture(s): 3.5;5.0;8.0;8.6;8.9;9.0;9.0a

CMake Error at .../torch/share/cmake/Caffe2/Modules_CUDA_fix/upstream/FindCUDA/select_compute_arch.cmake:225 (message):
  Unknown CUDA Architecture Name 9.0a in CUDA_SELECT_NVCC_ARCH_FLAGS
```

This issue commonly occurs with the following environment:

```bash
module load cuda/12.4-share openmpi/4.1.6 cmake/3.31.6
source /opt/rh/devtoolset-8/enable
source /path/to/MatPL-2026.3/matpl-2026.3/bin/activate
```

Here, the PyTorch version is `2.2` and the CUDA Toolkit version is `12.4`.

#### 2. Cause

This is not a compilation error in the MatPL operator source. It occurs because the CMake CUDA architecture-selection script bundled with PyTorch fails during configuration.

When PyTorch cannot automatically identify the current GPU architecture, it falls back to a list of common CUDA architectures. Under CUDA 12.4, that list may include:

```text
9.0a
```

However, the `select_compute_arch.cmake` script bundled with PyTorch 2.2 cannot recognize the letter-suffixed architecture `9.0a`, so configuration fails at `find_package(Torch REQUIRED)`.

#### 3. Solution

Before running `cmake ..`, explicitly specify the GPU architectures to compile and bypass PyTorch's automatic detection.

For an NVIDIA RTX 4090, use:

```bash
export TORCH_CUDA_ARCH_LIST="8.9"
cmake ..
```

To support common GPUs such as the A100, RTX 3090, and RTX 4090 in the same offline package, use:

```bash
export TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9"
cmake ..
```

To support the H100, use:

```bash
export TORCH_CUDA_ARCH_LIST="9.0"
cmake ..
```

Do not set the value to `9.0a`.

You can also specify it directly in the CMake command:

```bash
cmake .. -DTORCH_CUDA_ARCH_LIST="8.0;8.6;8.9"
```
<!-- 
To enforce this behavior in the source, add the following before `find_package(Torch REQUIRED)`:

```cmake
set(TORCH_CUDA_ARCH_LIST "8.0;8.6;8.9")
find_package(Torch REQUIRED)
```

This bypasses PyTorch's automatic CUDA architecture detection and prevents generation of a list containing `9.0a`. -->

### Issue: NVCC Reports `fatal error: math.h: No such file or directory`

#### 1. Symptom

While `make` is compiling `.cu` files, it reports a low-level error indicating that a standard-library header cannot be found:

```text
/usr/include/c++/11/cmath:45:15: fatal error: math.h: No such file or directory
   45 | #include_next <math.h>
      |                ^~~~~~~~

```

#### 2. Cause

* **Root cause (path contamination):** While detecting or configuring the environment, CMake passes the system `/usr/include` directory explicitly to `nvcc`, through either `-isystem /usr/include` or `-I`.
* **Broken `#include_next` behavior:** When processing `cmath`, GCC uses `#include_next <math.h>`, meaning “skip the current directory and search later system paths for the next `math.h`.” Once `/usr/include` is supplied explicitly, GCC incorrectly treats that directory as already traversed and cannot find the actual C `math.h` in subsequent paths.
* **Trigger A (custom operators):** An older system CUDA 11.5 installation is mixed with GCC 11, exposing a bug in which the older NVCC cannot interpret the GCC 11 option set.
* **Trigger B (LAMMPS build):** A custom package calls `find_package(CUDAToolkit)`, and the returned `CUDAToolkit_INCLUDE_DIRS` resolves to `/usr/include`, contaminating the include paths of global targets.

#### 3. Solution

Edit **`CMakeLists.txt`** in the LAMMPS root and add the following workaround immediately after `project(lammps CXX CUDA)`:

```cmake
project(lammps CXX CUDA)

# ================ Work around the missing math.h issue ================
list(APPEND CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES "/usr/include")
string(APPEND CMAKE_CUDA_FLAGS " -Xcompiler -idirafter,/usr/include")
# ===============================================================

```

If multiple CUDA compilers are present, explicitly specify the CUDA compiler and Toolkit root.
```bash
cmake -C ../cmake/presets/basic.cmake \
   -DCMAKE_CUDA_COMPILER=/opt/nvidia/hpc_sdk/Linux_x86_64/23.9/compilers/bin/nvcc \
   -DCUDAToolkit_ROOT=/opt/nvidia/hpc_sdk/Linux_x86_64/23.9/cuda/12.2 \
   -DPKG_KOKKOS=yes \
   -DPKG_NEP_KK=yes \
   -DKokkos_ENABLE_CUDA=yes \
   -DKokkos_ARCH_VOLTA70=ON \ 
   ../cmake
make -j4

# VOLTA70 targets V100 GPUs; for other GPUs, see https://docs.lammps.org/Build_extras.html#available-architecture-settings
```
