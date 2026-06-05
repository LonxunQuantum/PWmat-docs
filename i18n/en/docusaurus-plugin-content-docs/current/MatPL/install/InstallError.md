---
sidebar_position: 3
title: 常见安装错误
---
## 常见安装错误
### 关于编译环境
大部分的安装失败问题，都来源于编译安装环境版本不匹配，或找不到相关环境变量。请先检查下列编译器是否已正确安装，并且版本适配。

我们推荐使用 `intel2020`版本，`cuda/11.8`，`cmake版本 >= 3.21`，`gcc 版本 8.n`。
MatPL 中使用的`pytorch`版本为`2.0`以上，必须使用 `cuda/11.8`或更高版本。

对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。

您可以通过位于源码根目录的src/check/check_env.sh 脚本检查环境。一个正确的环境如下所示。
``` txt
1. CUDA version is 11.8.
2. nvcc command exists.
3. ifort version is no less than 19.1, current version is 19.1.
4. MKL library is installed.
5. GCC version is not 8.x, current version is 8.
6. PyTorch is installed.
7. PyTorch version is 2.0 or above, current version is 2.2.
```

### 问题：找不到 `cuda_runtime.h` 头文件

如果编译过程中找不到 `cuda_runtime.h` 头文件，请在 `src/MAKE/Makefile.mpi` 文件的 `第24行` 替换为您自己的 CUDA 路径，`/the/path/cuda/cuda-11.8`，`cuda_runtime.h` 位于该目录下的 `include` 目录下。

```txt
CUDA_HOME = $(CUDADIR)
替换为CUDA_HOME = /the/path/cuda/cuda-11.8
```

### 问题：NeighConst.so 编译错误
#### 错误描述
在编译 fortran 代码过程中出现如下错误

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

#### 错误原因
该错误出自 setuptools 版本不匹配，一般是版本过高造成的，您需要降低 setuptools，执行如下命令：
``` bash
#卸载 setuptools
$ pip uninstall setuptools
#清除本地缓存
$ pip cache purge
#重新安装 setuptools
$ pip install setuptools==68.0.0
#在我们的测试中不高于 68.0.0 即可
```


### 问题：V100安装时 PyTorch Caffe2 报 `Unknown CUDA Architecture Name 9.0a`

#### 1. 错误现象

在 CMake 配置阶段，触发 PyTorch 内部脚本报错：

```text
CMake Error at .../torch/share/cmake/Caffe2/Modules_CUDA_fix/upstream/FindCUDA/select_compute_arch.cmake:225 (message):
  Unknown CUDA Architecture Name 9.0a in CUDA_SELECT_NVCC_ARCH_FLAGS

```

#### 2. 原因分析

* **自动检测失败：** 日志中出现 `-- Automatic GPU detection failed. Building for common architectures.`，表明 PyTorch 没能直接读取到当前显卡的架构（V100 应为 `7.0`），转而使用系统默认的“通用架构列表”。
* **HPC SDK 引入新架构：** 环境中的 NVIDIA HPC SDK 23.9 默认的通用架构列表包含了 Hopper 架构演进版 `9.0a`。
* **脚本解析 Bug：** 旧版本 PyTorch 的 `select_compute_arch.cmake` 脚本只能解析纯数字架构（如 `9.0`, `8.9`），碰到带字母的 `9.0a` 时无法识别，导致解析崩溃。

#### 3. 解决方案

在 `find_package(Torch REQUIRED)` 执行之前，通过变量显式锁死需要编译的 CUDA 架构列表，阻止 PyTorch 启动自动检测。

**修改 `./cmake/gpu/CMakeLists.txt`：**

```cmake
# =================================================================
# 强制指定 PyTorch 编译的 CUDA 架构，阻止其自动检测和使用默认列表
# =================================================================
set(TORCH_CUDA_ARCH_LIST "6.0;6.1;7.0;7.5;8.0")

# 随后再引入 Torch
find_package(Torch REQUIRED)
enable_language(CUDA)

```

### 问题：NVCC 编译时报 `fatal error: math.h: 没有那个文件或目录`

#### 1. 错误现象

在 `make` 编译 `.cu` 文件阶段，抛出标准库找不到的底层错误：

```text
/usr/include/c++/11/cmath:45:15: fatal error: math.h: 没有那个文件或目录
   45 | #include_next <math.h>
      |                ^~~~~~~~

```

#### 2. 原因分析

* **本质原因（路径污染）：** CMake 在检测或配置环境时，将系统的 `/usr/include` 作为一个显式路径（通过 `-isystem /usr/include` 或 `-I`）传给了 `nvcc`。
* **`#include_next` 机制失效：** GCC 在处理 `cmath` 时使用 `#include_next <math.h>` 指令，意思是“跳过当前目录，去后面的系统搜索路径中寻找下一个 `math.h`”。当 `/usr/include` 被显式指定后，GCC 误以为自己已经越过了该目录，导致在后续路径中死活找不到真正的 C 语言 `math.h`。
* **引发情况 A（自定义算子）：** 混用了系统旧版 CUDA 11.5 与 GCC 11，触发了低版本 NVCC 无法识别 GCC 11 参数包的 Bug。
* **引发情况 B（LAMMPS 编译）：** 自定义 Package 内部使用了 `find_package(CUDAToolkit)`，其返回的 `CUDAToolkit_INCLUDE_DIRS` 被解析为了 `/usr/include`，从而污染了全局目标的包含路径。

#### 3. 解决方案

修改 LAMMPS 根目录的 **`CMakeLists.txt`**，在 `project(lammps CXX CUDA)` 正下方注入防护盾代码：

```cmake
project(lammps CXX CUDA)

# ================= 强制修复 math.h 找不到的 Bug =================
list(APPEND CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES "/usr/include")
string(APPEND CMAKE_CUDA_FLAGS " -Xcompiler -idirafter,/usr/include")
# ===============================================================

```

如果当前环境存在多个CUDA编译器，需要显式指定 CUDA 编译器及 Toolkit 根目录。
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

# VOLTA70 是V100显卡选项，其他显卡选项参考https://docs.lammps.org/Build_extras.html#available-architecture-settings
```
