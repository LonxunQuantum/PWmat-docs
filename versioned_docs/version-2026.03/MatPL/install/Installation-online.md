---
sidebar_position: 2
title: 在线安装
---
## 在线安装

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已做预装，[加载即用](./README.md)

在线安装需要您分别编译安装 MatPL-2026.3 和 MatPL-2026.3 lammps 接口。

- MatPL-2026.3 用于模型训练。要求待安装的机器提供 `gcc 编译器(8.n 以及以上)`、`CUDA(11.8及以上)`、`openmpi(4.1.4及以上)` 以及 `nvidia GPU` 硬件支持。对于 Python 环境，要求 python >= 3.11，torch >= 2.2.0+cu118。

- 如果需要使用 NN 和 Linear 模型，还需要加载 intel 相关编译器（ifort icc mkl）。对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mkl库`，如果单独加载，请确保版本不低于它们。

- MatPL-2026.3 lammps 接口 是用于运行 NEP 和 DP 模型的lammps 接口。lammps接口安装和运行需要使用 openmpi，我们推荐 `openmpi/4.1.4` 版本以上。对于 lammps 接口，我们提供了两个版本的安装方式：

  开放源码的接口安装方式，该接口速度与 GPUMD 速度持平；
  
  闭源接口的安装方式，闭源接口的速度是开放源码的接口速度两倍以上。

### MatPL 编译安装

为了编译和运行 MatPL-2026.3，您需要下载源码、安装conda 环境，并在 conda 环境中安装 MatPL-2026.3 依赖的Python环境，之后编译源码。

在以下安装命令中，使用的`sh` 是指`bash`，安装时请注意，如果使用`sh`命令，请确保它是`bash`的链接，有少部分操作系统指向的是`dash`。

#### 下载源码
我们提供了在线拉取代码和下载离线包两种方式编译。

- 通过 github 或 gitee 在线拉取 MatPL 仓库代码
```bash
  git clone https://github.com/LonxunQuantum/MatPL.git MatPL-2026.3
  或
  git clone https://gitee.com/pfsuo/MatPL.git MatPL-2026.3
```

- 或下载 release 离线源码包，您可以直接浏览器输入下面的地址下载，或者加前缀 wget 下载:
``` bash
  wget https://github.com/LonxunQuantum/MatPL/archive/refs/tags/MatPL-2026.3_update2.zip
  或通过gitee下载
  wget https://gitee.com/pfsuo/MatPL/repository/archive/2026.3
```
下载 release 离线源码包后，通过 unzip 命令解压。
``` bash
  ## 解压后您将得到一个名称为 MatPL-MatPL-2026.3_update2 的源码目录
  unzip MatPL-MatPL-2026.3_update2.zip
  mv MatPL-MatPL-2026.3_update2 MatPL-2026.3 # 为了后续手册表述统一，这里将文件名重名为MatPL-2026.3 
```

#### 创建 conda 虚拟环境
安装 Anaconda3（已安装请跳过）。这里要求您已经装了 Anaconda3 ，然后创建一个新 python 虚拟环境（搜索引擎搜索 Linux 安装 anaconda3 教程）。

您可以使用该命令直接下载 Anaconda3 到服务器目录中：
```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
## 如果下载失败，请在浏览器输入下面的下载地址，下载后上传的服务器
## https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh 
## 您也可以访问网页下载更多版本 https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/
```

#### 创建Python虚拟环境
conda 安装完成后，创建虚拟环境，环境中需指定安装 `python3.11` 解释器，其他版本可能会出现依赖冲突或语法不支持等问题，之后的编译工作均在该虚拟环境中进行

``` bash
conda create -n matpl-2026.3 python=3.11 setuptools=68.0.0
## python 版本我们建议3.11，更高级别的 python 可以在编译时存在一些错误，我们还未兼容。这里需要指定setuptools版本低于75.0.0，避免 numpy 和 fortran 做数据格式转换时的错误。
```
虚拟环境安装完成后激活该环境
``` bash
conda activate matpl-2026.3
```

#### Python虚拟环境安装依赖包
接下来安装 MATPL 所需的第三方依赖包，我们已经把所有依赖的第三方包写在requirement.txt中，只需要在该文件所在目录下执行 pip 命令即可完成所有的依赖包安装。操作过程如下。该步骤会安装pytorch等python环境较耗时，请您耐心等待。

- MatPL-2026.3/requirement.txt 是 MatPL GPU 版本的 python 环境

- MatPL-2026.3/requirements_cpu.txt 是 MatPL CPU 版本的 python 环境

```bash
#第一步 激活conda 环境
conda activate matpl-2026.3
#第二步 进入源码根目录
#在线下载的源码进入 MatPL-2026.3 目录
cd MatPL-2026.3
#对于 GPU 版本，请执行
pip install -r requirements.txt
#对于 CPU 版本，请执行
pip install -r requirements_cpu.txt
```

#### 编译安装-检查编译环境(GPU 版本)
进入 requirement.txt 的同级目录 `src` 目录下。
对于 GPU 版本，
首先检查`gcc 编译器(8.n 以及以上)`、`CUDA(11.8及以上)`、`openmpi(4.1.4及以上)` 以及 `nvidia GPU` 硬件支持。`如果需要使用 NN 和 Linear 模型，还需要加载 intel 相关编译器（ifort icc mkl）。`由于大部分的编译不成功是由编译器版本问题造成的，我们提供了编译环境检测的脚本 `check_env.sh` ，位于 `'/src/check/check_env.sh'` 您可以执行该脚本来检查编译环境已经完成准备。

``` bash
cd src
bash ./check/check_env.sh
```
执行后，将输出您的编译环境信息。
```txt
========================================
      Environment Check Starting
========================================

=== Checking ifort compiler and MKL library ===
✓ ifort version: 19.1 (>= 19.1)
✓ MKL library is installed

=== Checking GCC version ===
✓ GCC version: 8 (>= 8.0)

=== Checking PyTorch installation ===
✓ PyTorch is installed

=== Checking PyTorch version ===
✓ PyTorch version: 2.2.0+cu118 (>= 2.0)

=== Checking PyTorch CUDA support ===
✓ PyTorch is compiled with CUDA 11.8

=== Checking CUDA version ===
✓ CUDA version: 11.8.89 (>= 11.8)

=== Checking nvcc availability ===
✓ nvcc command exists

========================================
        Environment Summary
========================================
✓ Environment check completed. All requirements are satisfied.
========================================
```

#### 编译安装-检查编译环境(CPU 版本)
安装 GPU 版本请跳过该步。对于 CPU 版本，不需要 CUDA 支持，检测脚本为 check_env_cpu.sh，位于 `'/src/check/check_env_cpu.sh'`。命令执行后会列出需要的编译器版本以及当前检测到的版本：
```
========================================
      CPU Environment Check Starting
========================================

=== Checking ifort compiler and MKL library ===
✓ ifort version: 19.1 (>= 19.1)
✓ MKL library is installed

=== Checking GCC version ===
✓ GCC version: 8 (>= 8.0)

=== Checking PyTorch installation ===
✓ PyTorch is installed

=== Checking PyTorch version ===
✓ PyTorch version: 2.2.0+cu118 (>= 2.0)

========================================
        Environment Summary
========================================
✓ Environment check completed. All requirements are satisfied.
========================================
```

#### 编译安装-编译代码

如果您的环境满足上述检测，接下来进行代码编译。
执行如下命令开始编译：
```bash
bash clean.sh
bash build.sh [-jN] [-m nn]
```
- -jN 这里N为并行编译的核数，例如 sh build.sh -j4 将采用4核编译。默认采用单核编译，即 bash build.sh

- -m nn 指定后将 fortran 代码也纳入编译（需要intel编译器支持），用于 linear 和 NN 模型。`默认不编译 fortran 代码`。

:::tip
如果您在编译过程中出错，请在[MATPL 常见安装错误总结](./InstallError.md) 中查询。

如果仍未解决您的问题，请将您的机器环境信息、编译错误日志以及您执行的编译操作过程描述 发送到邮箱 `matpl@pwmat.com`、`wuxingxing@pwmat.com` 或 `support@pwmat.com`，我们将及时联系您处理。
:::
编译完成后，最后输出如下信息：
```
[100%] Linking CXX shared library ../../lib/libCalcOps_bind.so
[100%] Built target CalcOps_bind
Operators built successfully
Creating symbolic links in bin directory...
Created symbolic link for main_MD.x

=================================
MatPL has been successfully installed.
Please load the MatPL environment variables before use.

Recommended method:
  source /data/home/wuxingxing/codespace/MatPL-2025.12-tmp/env.sh

Or manually set environment variables:
  export PYTHONPATH=/data/home/wuxingxing/codespace/MatPL-2025.12-tmp:$PYTHONPATH
  export PATH=/data/home/wuxingxing/codespace/MatPL-2025.12-tmp/src/bin:$PATH
=================================
```
编译完成后，将在代码的根目录下生成一个env.sh文件，包含 MatPL 的环境变量，执行以下命令即可完成加载
```bash
  source /the/path/of/MatPL-2026.3/env.sh
```

也可以通过如下命令加载
```
  export PYTHONPATH=/the/path/of/MatPL-2026.3:$PYTHONPATH
  export PATH=/the/path/of/MatPL-2026.3/src/bin:$PATH
```

#### 加载使用
使用 MatPL 前需要加载它的依赖环境，加载 python 环境、cuda、MatPL 环境变量（CPU版本不需要加载CUDA）。

```bash
conda activate matpl-2026.3
module load cuda/11.8-share
source /the/path/of/MatPL-2026.3/env.sh
```
之后即可使用 MatPL 命令开始训练，使用教程请参考 [教学案例](../models/README.md)

### MatPL lammps 2026.3 开放源码版本接口编译安装

MatPL-2026.3 lammps 接口支持 NEP（包含 QNEP）、DP 和 D3。对于 NN 和 Linear 力场，提供了 fortran 版本的接口，安装请参考 [lammps-fortran 编译安装](#lammps-matpl-fortran-编译安装)。

MatPL-2026.3 lammps 接口安装过程中，需要您下载 lammps 源码、加载编译器、编译源码，过程如下所示。

#### 下载 MatPL-2026.3 lammps 接口源码

MatPL-2026.3 lammps 开放源码版本接口位于 [GitHub 仓库](https://github.com/LonxunQuantum/lammps-MatPL)，可通过以下命令下载：

```bash
git clone https://github.com/LonxunQuantum/lammps-MatPL.git
cd lammps-MatPL
```

MatPL-2026.3 lammps 力场接口源码目录如下所示：

```txt
├── .gitignore
├── KOKKOS/
├── MATPLD3/
├── MATPLDP/
├── compute_qnep_bec_atom.cpp
├── compute_qnep_bec_atom.h
├── examples/
├── kknep-patch.sh
├── nep_cpu.cpp
├── nep_cpu.h
├── nep_gpu/
├── pair_nep.cpp
├── pair_nep.h
├── test/
├── test_qnep/
└── README.md
```

- `KOKKOS`、`nep_gpu`、`nep_cpu.cpp`、`nep_cpu.h`、`pair_nep.cpp` 和 `pair_nep.h` 是 NEP lammps 接口源码，支持 NEP KOKKOS GPU 加速。`compute_qnep_bec_atom.cpp` 和 `compute_qnep_bec_atom.h` 用于输出 QNEP 的逐原子 Born 有效电荷张量。

- `MATPLDP` 为 DP 接口源码；`MATPLD3` 为 D3 接口源码，D3 需要 CUDA 支持，不能与 `matpl/nep/kk` 同时使用。

- `examples` 为力场 MD 示例，`test` 和 `test_qnep` 分别为 NEP 和 QNEP 测试用例。

- `kknep-patch.sh` 用于将上述接口源码复制到 lammps 源码目录，并修改 `cmake/CMakeLists.txt`，之后使用 cmake 编译。

- 与 MatPL-2025.3 版本相比，NEP KOKKOS 接口将近邻表计算交给 KOKKOS 在 GPU 上执行，能量和力计算则由定制的 C++/CUDA 算子完成，同时减少了显存占用并提高了推理速度。

- 当前仓库支持 LAMMPS 2023、2024 和 2025 发布版，推荐使用 `stable_2Aug2023_update4`、`stable_29Aug2024_update4` 或 `stable_22Jul2025_update4`。

#### 复制 MatPL-2026.3 lammps 接口源码到 LAMMPS 源码目录

`kknep-patch.sh` 位于 `lammps-MatPL` 仓库根目录。在仓库根目录执行以下命令，脚本会自动将接口文件复制到 LAMMPS 源码目录，并修改 `cmake/CMakeLists.txt`：

```bash
bash kknep-patch.sh /the/rootpath/of/lammps
```

复制完成后，会输出如下日志：
```txt
...
Patch process completed successfully!

Compilation Environment:
Recommended compilation environment: cuda/11.6 (with nvcc compiler) openmpi4.1.4 cmake/3.31.6 gcc8.n

Compilation Process:
cd /data/home/wuxingxing/codespace/suzhou/lmpversions/lammps-23-4-changerowcol/
mkdir build & cd build
cmake -C ../cmake/presets/basic.cmake \
    -DPKG_MESONT=no \
    -DPKG_JPEG=no \
    -DPKG_KOKKOS=yes \
    -DPKG_NEP_KK=yes \
    -DKokkos_ENABLE_CUDA=yes \
    -DKokkos_ENABLE_OPENMP=yes \
    -DKokkos_ENABLE_CUDA_LAMBDA=yes \
    -DFFT_KOKKOS=CUFFT \
    -DKokkos_ARCH_AMPERE86=ON \
    -DTEST_TIME=ON \
    ../cmake

cmake --build . --parallel 4 #(number of parallel compilation cores)


If you also need to compile the DP interface, please import the PyTorch path, import the MKL library, and enable the C++ STD17 standard for compilation.
export Torch_DIR=$(python -c "import torch; print(torch.utils.cmake_prefix_path)")/Torch
Then, add the following option in cmake:
-DTorch_DIR=${Torch_DIR} \
-DCMAKE_CXX_STANDARD=17 \
-DPKG_MATPLDP=yes \


```

<!-- For the D3 interface, please add the following option in cmake. Note that D3 requires CUDA support and cannot be used in combination with matpl/nep/kk.
-DPKG_MATPLD3=yes \ -->

#### 加载编译环境以及编译
文件复制完成后，需要在编译前加载环境。lammps 接口编译，依赖的编译器环境有 `cuda`、`gcc`、`cmake`、`openmpi`，我们推荐 `openmpi/4.1.4` 版本及以上，`cuda-11.6`及以上、`cmake 3.n `及以上，`gcc8.n`及以上 。

之后按照日志中 的提示，进入lammps 根目录，创建build 目录，在下面执行 如下cmake命令即可编译：
```bash
# cd lammps rootdir
mkdir build & cd build
cmake -C ../cmake/presets/basic.cmake \
    -DPKG_MESONT=no \
    -DPKG_JPEG=no \
    -DPKG_KOKKOS=yes \
    -DPKG_NEP_KK=yes \
    -DKokkos_ENABLE_CUDA=yes \
    -DKokkos_ENABLE_OPENMP=yes \
    -DKokkos_ENABLE_CUDA_LAMBDA=yes \
    -DFFT_KOKKOS=CUFFT \
    -DKokkos_ARCH_AMPERE86=ON \
    -DTEST_TIME=ON \
    ../cmake

cmake --build . --parallel 4 #(number of parallel compilation cores)
```

默认只安装了NEP的接口，如果需要安装 DP 接口，需要加载 `MKL 库`、`pytorch 中的libtorch` 路径以及在编译时使用 `C++ STD17标准`。
```bash
export Torch_DIR=$(python -c "import torch; print(torch.utils.cmake_prefix_path)")/Torch

#在 cmake 命令中开启 DP 的编译：
-DTorch_DIR=${Torch_DIR} \
-DCMAKE_CXX_STANDARD=17 \
-DPKG_MATPLDP=yes \
```

<!-- `-DPKG_MATPLD3=yes` 是来自[github SevenNet](https://github.com/MDIL-SNU/SevenNet/tree/main/sevenn/pair_e3gnn) 下的代码。这里 D3 不能与 matpl/nep/kk 混合使用。 -->

编译完成将在窗口输出如下信息，并在lammps源码根目录生成一个env.sh文件，使用lammps前加载该文件即可。

``` txt
[ 98%] Building CUDA object CMakeFiles/lammps.dir/data/home/wuxingxing/codespace/suzhou/lmpversions/lammps-23-4-opt/src/nep_gpu/utilities/gpu_vector.cu.o
[100%] Linking CXX static library liblammps.a
[100%] Built target lammps
[100%] Building CXX object CMakeFiles/lmp.dir/data/home/wuxingxing/codespace/suzhou/lmpversions/lammps-23-4-opt/src/main.cpp.o
[100%] Linking CXX executable lmp
[100%] Built target lmp
```

#### lammps 加载使用
使用 MatPL-2026.3 lammps时， 需要加载它的依赖环境，加载 opnmpi、cuda、lammps环境变量。
```bash
module load cuda/11.8 openmpi/4.1.6
# lammps 环境变量,用于指定 lmp 位置
export PATH=/the/path/of/lammpsroot/dir/build:$PATH
```

<!-- 详细的使用请参考 
- [MatPL 操作演示：NEP lammps](../models/nep/nep-tutorial.md#lammps-md)
- [MatPL 操作演示：DP lammps](../models/dp/dp-tutorial.md#3-lammps-模拟) -->

### MatPL lammps 2026.3 闭源版本接口编译安装

MatPL lammps 2026.3 闭源版本将 lammps 接口代码与 NEP GPU 推理核函数分离：`pair_nep.cpp`、KOKKOS 包装层和 `nep_gpu_loader.h` 等 C++ 接口代码会编译到 lammps 中，优化后的 NEP GPU 推理核函数则以预编译共享库 `libnep_gpu.so` 的形式提供。运行时，接口通过 `dlopen` 动态加载共享库，并验证 License 文件。

因此，使用闭源版本时不需要编译 NEP GPU 推理库，只需下载 lammps 接口源码、与 CUDA 版本匹配的预编译共享库以及有效的 License，然后编译 C++ 接口代码即可。

#### 下载闭源版本接口文件

闭源版本的接口源码、预编译共享库和评估 License 可从 [MatPL-pro-v2026.6 Release](https://github.com/LonxunQuantum/lammps-MatPL/releases/tag/MatPL-pro-v2026.6) 下载。

| 文件 | CUDA / 精度 |
| --- | --- |
| [`libnep_gpu_cu118.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu118.so) | CUDA 11.8，默认混合精度 |
| [`libnep_gpu_cu118_fp64.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu118_fp64.so) | CUDA 11.8，FP64 |
| [`libnep_gpu_cu128.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu128.so) | CUDA 12.8，默认混合精度 |
| [`libnep_gpu_cu128_fp64.so`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/libnep_gpu_cu128_fp64.so) | CUDA 12.8，FP64 |
| [`summer_holiday.lic 或 2026.lic`](https://github.com/LonxunQuantum/lammps-MatPL/releases/download/MatPL-pro-v2026.6/summer_holiday.lic) |  License |
| [Source code (zip)](https://github.com/LonxunQuantum/lammps-MatPL/archive/refs/tags/MatPL-pro-v2026.6.zip) | lammps 接口源码 |
| [Source code (tar.gz)](https://github.com/LonxunQuantum/lammps-MatPL/archive/refs/tags/MatPL-pro-v2026.6.tar.gz) | lammps 接口源码 |

根据运行环境选择一个共享库即可：

- `cu118` 共享库需要 CUDA 11.x 运行时（`libcudart.so.11.0`）。
- `cu128` 共享库需要 CUDA 12.x 运行时（`libcudart.so.12`）。
- 不带 `_fp64` 后缀的共享库为默认混合精度版本；使用 `_fp64` 共享库时，lammps 接口也必须使用 `-DPREC_NEPINFER=ON` 编译。

> **注意**：共享库的 CUDA 主版本必须与运行时的 `libcudart` 主版本一致。CUDA 11.x 和 CUDA 12.x 共享库不能交叉使用。

#### 闭源版本接口源码目录

Source code 压缩包解压后，根目录结构如下：

```txt
├── .gitignore
├── examples/
├── kknep-patch-cpu.sh
├── kknep-patch.sh
├── KOKKOS/
├── matpl-patch.sh
├── MATPLD3/
├── MATPLDP/
├── MatPLPackages.cmake
├── nep_cpu.cpp
├── nep_cpu.h
├── nep_gpu/
│   ├── cuda-11.8/
│   ├── cuda-12.8/
│   └── 2026.lic # 2026年底到期
│   └── summer_holiday.lic # 2026年8月底到期
├── nep_gpu_loader.h
├── pair_nep.cpp
├── pair_nep.h
├── README.md
└── test/
```

其中：

- `kknep-patch.sh` 用于备份并修改 lammps 的 `cmake/CMakeLists.txt`，同时复制 NEP CPU 接口、`nep_gpu_loader.h`、KOKKOS 包装层以及 MatPL 热流接口文件。
- `nep_gpu_loader.h` 负责在运行时加载 `libnep_gpu.so`，因此编译 lammps 时不需要将闭源共享库直接链接到 lammps。
- `KOKKOS` 目录包含 NEP KOKKOS 接口、MatPL 热流 compute 和时间平均 fix。
- `examples` 和 `test` 分别包含使用示例和测试脚本。

#### 编译环境

推荐使用以下软件环境：

| 组件 | 推荐版本 | 说明 |
| --- | --- | --- |
| lammps | `stable_2Aug2023_update4`、`stable_29Aug2024_update4` 或 `stable_22Jul2025_update4` | `kknep-patch.sh` 支持 2023—2025 发布版 |
| CUDA Toolkit | 11.8 或 12.8 | 必须与下载的共享库主版本匹配 |
| GCC | 8.3 及以上 | 需要 C++17 支持 |
| OpenMPI | 4.1.x | 用于多进程和多节点并行 |
| CMake | 3.18 及以上 | lammps 编译系统 |

以 CUDA 11.8 和 CUDA 12.8 为例，加载编译环境：

```bash
# CUDA 11.8，对应 libnep_gpu_cu118*.so
module --ignore-cache load openmpi/4.1.6 cuda/11.8-share gcc/8.3.1 cmake/3.31.6

# CUDA 12.8，对应 libnep_gpu_cu128*.so
module --ignore-cache load openmpi/4.1.6 cuda/12.8-share gcc/11.2.1 cmake/3.31.6
```

> 上述 `module` 名称是集群环境中的使用示例，请根据实际软件环境调整。

#### 复制接口文件到 lammps 源码

进入 Source code 解压后的根目录，执行：

```bash
cd /the/path/of/lammps-MatPL-MatPL-pro-v2026.6
bash kknep-patch.sh /the/path/of/lammps
```

脚本会将接口文件复制到 lammps 源码的 `src` 目录，并在 `cmake/CMakeLists.txt` 中增加 `PKG_NEP_KK` 编译选项。脚本结束时输出 `Patch process completed successfully!` 表示复制成功。

#### 使用 cmake 编译 lammps

进入 lammps 源码目录，创建独立的构建目录：

```bash
cd /the/path/of/lammps
mkdir build && cd build

cmake -C ../cmake/presets/basic.cmake \
    -DPKG_MESONT=no \
    -DPKG_JPEG=no \
    -DPKG_KOKKOS=yes \
    -DPKG_NEP_KK=yes \
    -DKokkos_ENABLE_CUDA=yes \
    -DKokkos_ENABLE_OPENMP=yes \
    -DKokkos_ENABLE_CUDA_LAMBDA=yes \
    -DFFT_KOKKOS=CUFFT \
    -DKokkos_ARCH_AMPERE86=ON \
    ../cmake

cmake --build . --parallel 8
```

`-DKokkos_ARCH_AMPERE86=ON` 只是 A6000、RTX 3090 等 SM 8.6 GPU 的示例。请根据 GPU 型号替换 KOKKOS 架构选项，例如 A100 使用 `-DKokkos_ARCH_AMPERE80=ON`，RTX 4090 使用 `-DKokkos_ARCH_ADA89=ON`，H100 使用 `-DKokkos_ARCH_HOPPER90=ON`。

如果使用 `_fp64.so` 共享库，需要在上述 cmake 命令中另外加入：

```bash
-DPREC_NEPINFER=ON \
```

#### 配置共享库和 License

编译完成后，使用 `NEP_GPU_LIB_PATH` 指定预编译共享库的完整路径，使用 `NEP_LICENSE_PATH` 指定 License 文件路径：

```bash
# lammps 可执行文件
export PATH=/the/path/of/lammps/build:$PATH

# CUDA 11.8 默认混合精度版本示例
export NEP_GPU_LIB_PATH=/the/path/of/libnep_gpu_cu118.so
export NEP_LICENSE_PATH=/the/path/of/summer_holiday.lic
```

也可以将共享库所在目录加入 `LD_LIBRARY_PATH`，并将共享库重命名为 `libnep_gpu.so`：

```bash
export LD_LIBRARY_PATH=/the/path/of/libnep_gpu_dir:$LD_LIBRARY_PATH
```

`NEP_GPU_LIB_PATH` 的优先级高于系统共享库搜索路径，因此推荐直接指定 `.so` 文件。`NEP_LICENSE_PATH` 也建议直接指向下载的 `summer_holiday.lic`。

> **License 说明**：Release 中的 `summer_holiday.lic` 为最多支持 16 块 GPU 的非商业评估 License，有效期至 2026 年 8 月 31 日。商业使用或 License 续期请联系 `matpl@pwmat.com`。

### 运行 lammps

#### 运行命令

在运行 lammps 前，请确保已设置 `NEP_GPU_LIB_PATH` 和 `NEP_LICENSE_PATH`，并且输入文件、原子结构文件和 NEP 力场文件均已准备完成。

```bash
# 单 GPU
mpirun -np 1 --bind-to numa lmp -k on g 1 -sf kk -pk kokkos -in input.in

# 单节点多 GPU（4 卡）
mpirun -np 4 --bind-to numa lmp -k on g 4 -sf kk -pk kokkos -in input.in

# 多节点（2 节点，每节点 4 卡）
mpirun -np 8 --bind-to numa --map-by ppr:4:node lmp -k on g 4 -sf kk -pk kokkos -in input.in
```

多节点运行时，必须在每个计算节点设置相同的 `NEP_GPU_LIB_PATH` 和 `NEP_LICENSE_PATH`，并确保所有节点都能访问共享库、License、输入文件和力场文件。

#### lammps 输入脚本

NEP KOKKOS 接口需要使用 half 近邻表并开启 Newton 通信：

```lammps
package kokkos neigh half comm device
newton on
```

单模型推理的 `pair_style` 设置如下：

```lammps
pair_style   matpl/nep/kk nep.txt
pair_coeff   * * Hf O
```

`pair_coeff * *` 后的元素名与 data 文件中的原子类型一一对应，并映射到 NEP 力场文件中的元素顺序。

#### 多模型偏差计算

在主动学习流程中，可同时加载多个 NEP 力场文件并输出模型偏差：

```lammps
pair_style   matpl/nep/kk nep1.txt nep2.txt nep3.txt out_freq 10 out_file explr.error
pair_coeff   * * Hf O
```

- 多个 `nep*.txt` 文件用于启用模型偏差计算。
- `out_freq N` 表示每 `N` 步输出一次偏差，默认值为 `1`。
- `out_file name` 用于指定偏差输出文件，默认文件名为 `explr.error`。

#### NPT 运行示例

以 HfO2 NEP 力场为例，完整的 NPT 输入脚本如下：

```lammps
package kokkos neigh half comm device
newton on

units           metal
boundary        p p p
atom_style      atomic
neighbor        1.0 bin
neigh_modify    delay 10

read_data       structure.lmp
replicate       10 10 10

mass            1 178.49
mass            2 15.999

pair_style      matpl/nep/kk nep.txt
pair_coeff      * * Hf O

velocity        all create 300.0 12345
fix             1 all npt/kk temp 300 300 0.1 iso 0.0 0.0 0.5

thermo_style    custom step temp pe ke etotal press vol
thermo          10
timestep        0.002

run             1000
```

#### MatPL 热流计算

> **接口区别**：开放源码版本只支持 `matpl/heatflux`；闭源版本支持 KOKKOS GPU 热流接口 `matpl/heatflux/kk`。下面的命令仅适用于闭源版本。

`matpl/heatflux/kk` 直接在 GPU 上计算 MatPL 热流，无需使用传统的 `ke/atom + pe/atom + centroid/stress/atom + heat/flux` 后处理链：

```lammps
package kokkos neigh half comm device
newton on

pair_style   matpl/nep/kk nep.txt
pair_coeff   * * C

compute      flux all matpl/heatflux/kk
fix          fluxout all matpl/heatflux/ave/kk 10 100 1000 flux file compute_HeatFlux.out
```

`compute matpl/heatflux/kk` 输出包含 6 个分量的全局向量，依次为：

1. `Jx`：x 方向总热流。
2. `Jy`：y 方向总热流。
3. `Jz`：z 方向总热流。
4. `Jconv,x`：x 方向对流热流。
5. `Jconv,y`：y 方向对流热流。
6. `Jconv,z`：z 方向对流热流。

因此，virial 热流贡献可由总热流减去对流热流得到，即 `(1-4, 2-5, 3-6)`。`fix matpl/heatflux/ave/kk` 用于对热流向量进行时间平均，并将结果写入 `compute_HeatFlux.out`。

#### 更多运行示例

- [H2O 多节点多 GPU 示例](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/H2O)
- [HfO2 多节点多 GPU 示例](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/HfO2)
- [石墨烯热流计算与验证示例](https://github.com/LonxunQuantum/lammps-MatPL/tree/MatPL-pro-v2026.6/examples/Heat_flux)

#### 常见问题

| 错误信息或现象 | 原因 | 处理方法 |
| --- | --- | --- |
| `Failed to load NEP GPU library` | 找不到共享库 | 检查 `NEP_GPU_LIB_PATH`，或将共享库目录加入 `LD_LIBRARY_PATH` |
| `Symbol not found: nep_*` | 接口代码与共享库版本不匹配 | 使用同一 Release 中的 Source code 和 `libnep_gpu*.so` |
| `NEP GPU license check failed` 或 `License file not found` | License 不存在、路径错误或已过期 | 检查 `NEP_LICENSE_PATH`、文件权限和有效期 |
| 加载 `.so` 时报 `libcudart` 错误 | CUDA 主版本不匹配 | CUDA 11.x 使用 `cu118` 库，CUDA 12.x 使用 `cu128` 库 |
| GPU 与 License 绑定不匹配或 GPU 数量超限 | 当前硬件不在 License 授权范围内 | 使用 `nvidia-smi --query-gpu=uuid` 检查 GPU，必要时限制 `CUDA_VISIBLE_DEVICES` 或更新 License |


<!-- ### Lammps-MatPL (fortran) 编译安装 

lammps-MatPL (fortran 版本) 用于 MatPL 的 NN 和 Linear 力场，未提供 GPU 加速。

lammps-MatPL (fortran 版本) 力场接口源码位于 MatPL 源码目录 `lmps/lammps-fortran` 下，您也可以通过 [github fortran 分支下载](https://github.com/LonxunQuantum/lammps-MatPL/tree/fortran) 下载 lammps-MatPL (fortran 版本) 源码，或下载 release 包。

安装过程请参考 [2025.3 fortran lammps 接口安装](http://doc.lonxun.com/2025.03/MatPL/install/Installation-online/#lammps-matpl-fortran-%E7%BC%96%E8%AF%91%E5%AE%89%E8%A3%85)

详细的使用，请参考 
- [MatPL 操作演示：Linear lammps](../models/linear/linear-tutorial.md#lammps-md)
- [MatPL 操作演示：NN lammps](../models/nn/nn-tutorial.md#lammps-md)


MatPL 相关软件的常见 [安装错误](./InstallError.md) 和 [运行时错误](./RuntimeError.md)   -->
