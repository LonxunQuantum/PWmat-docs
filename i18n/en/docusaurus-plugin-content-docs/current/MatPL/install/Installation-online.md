---
sidebar_position: 2
title: 在线安装
---
## 在线安装

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已做预装，[加载即用](./README.md)

在线安装需要您分别编译安装 MatPL-2026.3 和 MatPL-2026.3 lammps 接口。

- MatPL-2026.3 用于模型训练。要求待安装的机器提供 `gcc 编译器(8.n 以及以上)`、`CUDA(11.8及以上)`、`openmpi(4.1.4及以上)` 以及 `nvidia GPU` 硬件支持。对于 Python 环境，要求 python >= 3.11，torch >= 2.2.0+cu118。

- 如果需要使用 NN 和 Linear 模型，还需要加载 intel 相关编译器（ifort icc mkl）。对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mkl库`，如果单独加载，请确保版本不低于它们。

- MatPL-2026.3 lammps 接口 是用于运行 NEP 和 DP 模型的lammps 接口。lammps接口安装和运行需要使用 openmpi，我们推荐 `openmpi/4.1.4` 版本以上。

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
  wget https://github.com/LonxunQuantum/MatPL/archive/refs/tags/MatPL-2026.3.zip
  或
  wget https://gitee.com/pfsuo/MatPL/repository/archive/2026.3
```
下载 release 离线源码包后，通过 unzip 命令解压。
``` bash
  ## 解压后您将得到一个名称为 MatPL-2026.3 的源码目录
  unzip 2026.3.zip
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

- matpl-2026.3/requirement.txt 是 MatPL GPU 版本的 python 环境

- matpl-2026.3/requirements_cpu.txt 是 MatPL CPU 版本的 python 环境

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

### MatPL lammps 2026.3 接口编译安装 

MatPL-2026.3 lammps 接口用于 MatPL 的DP 和 NEP 力场。对于 NN 和 Linear 力场，提供了 fortran 版本的 接口，安装请参考 [lammps-fortran 编译安装](#lammps-matpl-fortran-编译安装)。

MatPL-2026.3 lammps 接口安装过程中，需要您下载 lammps 源码、加载编译器、编译源码，过程如下所示。

#### 下载 MatPL-2026.3 lammps 接口源码

MatPL-2026.3 lammps 接口源码位于 MatPL 源码目录 `MatPL-2026.3/lmps/lammps-2026.3` 下。您也可以通过 [github 仓库](https://github.com/LonxunQuantum/lammps-MatPL) 下载源码，或下载 release 包。
- 通过 github 或 gitee clone 源码:
```bash
git clone https://github.com/LonxunQuantum/lammps-MatPL.git
或
git clone https://gitee.com/pfsuo/lammps-MatPL.git
```

- 或下载release 包:
```bash
wget https://github.com/LonxunQuantum/lammps-MatPL/archive/refs/tags/2026.3.zip
或
wget https://gitee.com/pfsuo/lammps-MatPL/repository/archive/2026.3

unzip 2026.3.zip    #解压源码
```
MatPL-2026.3 lammps力场接口源码目录如下所示
```txt
├── dp_lmps_demo/
├── LICENSE
├── lmp_for_cmake/
├── lmp_nepkokkos_cmake/
├── Makefile.mpi
├── MATPL/
├── nep_lmps_demo/
└── README.md
```
- `lmp_nepkokkos_cmake` 为MatPL-2026.3 的 lammps 力场接口，支持 NEP KOKKOS GPU 加速、NEP CPU版本、DP（CPU和GPU 加速）。使用 cmake 编译。

- `MATPL`、`Makefile.mpi` 为MatPL-2025.3 的 lammps 力场接口，支持 NEP (CPU和GPU加速)、DP(CPU和GPU加速)。使用 make 编译。`nep_lmps_demo` 和 `dp_lmps_demo` 分别是 MatPL-2025.3 的 NEP、DP 的力场 MD 测试例子。

- 2025.3 版本的 NEP GPU 加速相比于2026.3 NEP KOKKOS GPU加速的核心区别是，NEP KOKKOS 将近邻的构建也卸载到了GPU上，让速度提了一个量级以上。并且2026.3对推理的核函数也做了更细致的优化。

- MatPL-2026.3 lammps 接口要求 lammps 源码的版本不能超过2024。

#### 复制MatPL-2026.3 lammps 接口源码到 Lammps 源码下

lmp_nepkokkos_cmake 目录下，存在一个 `kknep-patch.sh` 脚本，用于自动将接口文件复制到lammmps目录下，以及修改lammps源码/cmake/CMakeLists.txt文件，通过如下命令执行。
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

For the D3 interface, please add the following option in cmake. Note that D3 requires CUDA support and cannot be used in combination with matpl/nep/kk.
-DPKG_MATPLD3=yes \

```

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

`-DPKG_MATPLD3=yes` 是来自[github SevenNet](https://github.com/MDIL-SNU/SevenNet/tree/main/sevenn/pair_e3gnn) 下的代码。这里 D3 不能与 matpl/nep/kk 混合使用。

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

详细的使用请参考 
- [MatPL 操作演示：NEP lammps](../models/nep/nep-tutorial.md#lammps-md)
- [MatPL 操作演示：DP lammps](../models/dp/dp-tutorial.md#3-lammps-模拟)

### Lammps-MatPL (fortran) 编译安装 

lammps-MatPL (fortran 版本) 用于 MatPL 的 NN 和 Linear 力场，未提供 GPU 加速。

lammps-MatPL (fortran 版本) 力场接口源码位于 MatPL 源码目录 `lmps/lammps-fortran` 下，您也可以通过 [github fortran 分支下载](https://github.com/LonxunQuantum/lammps-MatPL/tree/fortran) 下载 lammps-MatPL (fortran 版本) 源码，或下载 release 包。

安装过程请参考 [2025.3 fortran lammps 接口安装](http://doc.lonxun.com/MatPL/install/Installation-online/#lammps-matpl-fortran-%E7%BC%96%E8%AF%91%E5%AE%89%E8%A3%85)

详细的使用，请参考 
- [MatPL 操作演示：Linear lammps](../models/linear/linear-tutorial.md#lammps-md)
- [MatPL 操作演示：NN lammps](../models/nn/nn-tutorial.md#lammps-md)


<!-- MatPL 相关软件的常见 [安装错误](./InstallError.md) 和 [运行时错误](./RuntimeError.md)   -->