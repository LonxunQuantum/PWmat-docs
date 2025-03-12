---
sidebar_position: 2
---


# 在线安装


对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，我们已经做了预装，只需要加载即可使用。

``` bash
# 加载 MatPL
source /share/app/PWMLFF/MatPL2025.3/env.sh
# 或者采用以下方式分步加载
# step1. 加载 python 运行环境
source /share/app/anaconda3/etc/profile.d/conda.sh
module load conda/3-2020.07
conda deactivate
conda activate MatPL2025.3
# step2. 加载MatPL
module load matpl/2025.3
```
```bash
# 加载 lammps
module load lammps4pwmlff/2025.3
# 对于 Linear 和 NN 模型的lammps 接口，我们提供了 cpu 版本的接口，请加载
module load lammps4pwmlff/0.1.0
# lammps 接口已经预装了下列功能 KSPACE、MANYBODY、REAXFF、MOLECULE、QEQ、REPLICA、RIGID、MEAM、MC、MatPL
```

在线安装需要您分别编译安装 MatPL 和 lammps 接口。

为了编译和运行 MatPL-2025.3，您需要下载源码、安装conda 环境，并在 conda 环境中安装 MatPL-2025.3 依赖的Python环境。

编译 Lammps 接口前，需要您已经成功编译安装 MatPL 。

## MatPL 编译安装

### 1. 下载源码
我们提供了在线拉取代码和下载离线包两种方式编译。

- 通过 github 或 gitee 在线拉取PWMLFF仓库代码
```bash
  git clone https://github.com/LonxunQuantum/PWMLFF.git MatPL-2025.3
  或
  git clone https://gitee.com/pfsuo/PWMLFF.git MatPL-2025.3
```

- 或下载 release 离线源码包，您可以直接浏览器输入下面的地址下载，或者加前缀 wget 下载:
``` bash
  wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/tags/2024.5.zip
  或
  wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```
下载releas离线源码包后，通过 unzip 命令解压。
``` bash
  # 解压后您将得到一个名称为 MatPL-2025.3 的源码目录
  unzip 2024.5.zip
```

### 2. 创建 conda 虚拟环境

#### step1. 安装 Anaconda3（已安装请跳过）
这里要求您已经装了 Anaconda3 ，然后创建一个新 python 虚拟环境（搜索引擎搜索 Linux 安装 anaconda3 教程）。

您可以使用该命令直接下载 Anaconda3 到服务器目录中：
```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
# 如果下载失败，请在浏览器输入下面的下载地址，下载后上传的服务器
# https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh 
# 您也可以访问网页下载更多版本 https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/
```

#### step2. 创建Python虚拟环境
conda 安装完成后，创建虚拟环境，环境中需指定安装 `python3.11` 解释器，其他版本可能会出现依赖冲突或语法不支持等问题，之后的编译工作均在该虚拟环境中进行

``` bash
conda create -n matpl-2025.3 python=3.11 setuptools=68.0.0
# python 版本我们建议3.11，更高级别的 python 可以在编译时存在一些错误，我们还未兼容。这里需要指定setuptools版本低于75.0.0，避免 numpy 和 fortran 做数据格式转换时的错误。
```
虚拟环境安装完成后激活该环境
``` bash
conda activate pwmlff2024.5
```

#### step3. 安装依赖包
接下来安装 PWMLFF 所需的第三方依赖包，我们已经把所有依赖的第三方包写在requirement.txt中，只需要在该文件所在目录下执行 pip 命令即可完成所有的依赖包安装。操作过程如下。该步骤会安装pytorch等python环境较耗时，请您耐心等待。

```bash
# 第一步 激活conda 环境
conda activate pwmlff2024.5
# 第二步 进入源码根目录
# 在线下载的源码进入 MatPL-2025.3 目录
cd MatPL-2025.3
# 离线下载的源码包在解压后进入 PWMLFF-master 目录
pip install -r requirements.txt
```
### 3. 编译安装

#### step1. 检查编译环境
进入 requirement.txt 的同级目录 `src` 目录下。
首先检查 `cuda/11.8`，`intel/2020`，`gcc8.n`是否加载；检查 `conda` 虚拟环境是否加载。

对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。

由于大部分的编译不成功是由编译器版本问题造成的，我们提供了编译环境检测的脚本 `check_env.sh` ，位于 `'/src/check/check_env.sh'` 您可以执行该脚本来检查编译环境已经完成准备。

``` bash
cd src
sh ./check/check_env.sh
```
执行后，将输出您的编译环境信息，一个正确的环境如下所示。
```txt
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
PyTorch is installed.
PyTorch version is 2.0 or above, current version is 2.2.
PyTorch is compiled with CUDA 11.8.
CUDA version is 11.8 or higher, current version is 11.8.89.
nvcc command exists.
```

第1行输出了 ifort 编译器要求的版本不低于19.1，检测到当前的版本是19.1，满足要求；

第2行查找 MKF 库是否存在，检测到已安装，满足要求；

第3行输出了 GCC 要求的版本 8.n， 检测到当前的GCC版本是8，满足要求;

第4行检查 python 环境是否已经安装 pytorch，检测到已安装，满足要求；

第5行检查 pytroch 版本是否为2.0 以上，检测到当前版本是2.2，满足要求；

第6行检查 pytroch 版本是否包含 CUDA 支持，检测到包含，满足要求；

第7行检查 CUDA 版本是否不低于11.8，检测到当前的版本是 11.8.89，满足要求；

第8行检查 nvcc 编译器是否存在，检测到存在，满足要求。

#### step2. 编译代码

如果您的环境满足上述检测，接下来进行代码编译。
执行如下命令开始编译：
```bash
sh clean.sh
sh build.sh
```

如果您在编译过程中出错，请在[PWMLFF常见安装错误总结](./Error%20Record/InstallError.md) 中查询。

:::tip
如果仍未解决您的问题，请将您的机器环境信息、编译错误日志以及您执行的编译操作过程描述 发送到邮箱 support@pwmat.com 或者 wuxingxing@pwmat.com，我们将及时联系您处理。

- `编译完成后会自动将 PWMLFF 环境变量加入.bashrc 文件中，如果不需要，请您在.bashrc中手动删除环境变量`。
```txt
export PATH=/the/path/MatPL-2025.3/src/bin:$PATH
export PYTHONPATH=/the/path/MatPL-2025.3/src/:$PYTHONPATH
```
:::

至此完成了 PWMLFF 的全部编译安装。

## Lammps-MatPL 编译安装

:::tip
当前版本 Lammps 适用于 DP 和 NEP model 提取的力场模型

旧版 Linear, NN 和 DP model 提取的力场模型lammps接口见 [Lammps for PWMLFF](http://doc.lonxun.com/1.1/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85) 或者[源码仓库](https://github.com/LonxunQuantum/Lammps_for_PWMLFF/blob/master/README.md)
:::

lammps 源码安装需要您下载 lammps 源码、加载 PWMLFF 环境变量、编译源码，过程如下所示。

### 1. 源码下载
您可以通过 github 下载源码，或者下载 release 包。
- 通过 github 或 gitee clone 源码:
```bash
git clone -b libtorch_nep https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
或
git clone -b libtorch_nep https://gitee.com/pfsuo/Lammps_for_PWMLFF.git
```

- 或下载release 包:
```bash
wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/tags/2024.5.zip
或
wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/2024.5

unzip 2024.5.zip    #解压源码
```

### 2. 加载编译环境变量

注意，您需要保持编译 PWMLFF 和 编译 lammps 使用的 python 虚拟环境相同。为了编译lammps，您需要加载以下环境变量。

```bash
# 加载编译器
load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable #此为gcc编译器，您可以加载自己的8.n版本

# PWMLFF 环境加载例子
# 加载conda 环境
source /the/path/anaconda3/etc/profile.d/conda.sh
# 激活conda 环境，注意这里使用的虚拟环境需要和编译MatPL-2025.3时的环境相同
conda activate pwmlff2024.5 
# 加载 MatPL-2025.3 环境变量
export PATH=/the/path/MatPL-2025.3/src/bin:$PATH
export PYTHONPATH=/the/path/MatPL-2025.3/src/:$PYTHONPATH
# 加载 共享库文件
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```

:::info

1. 模型导出使用 Libtorch 库，编译软件时确保加载 PWMLFF 所在的虚拟环境
2. 编译和执行程序需要使用到包含在 PWMLFF 软件包中的`op`(自定义算子)库，需要确保在环境变量中
   :::

### 3. 编译lammps代码

#### step1. 为了使用 NEP模型的 GPU 版本，需要您先将 NEP 的 c++ cuda 代码编译为共享库文件
``` bash
cd lammps-2024.5/src/PWMLFF/NEP_GPU
make clean
make
# 编译完成后您将得到一个/lammps-2024.5/src/libnep_gpu.so的共享库文件
```
#### step2. 编译lammps 接口

```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
make clean-all && make mpi -j4
```

如果编译过程中找不到 `cuda_runtime.h` 头文件，请在 `src/MAKE/Makefile.mpi` 文件的 `第24行` 替换为您自己的 CUDA 路径，`/the/path/cuda/cuda-11.8`，`cuda_runtime.h` 位于该目录下的 `include` 目录下。

```txt
CUDA_HOME = $(CUDADIR)
替换为CUDA_HOME = /the/path/cuda/cuda-11.8
```

:::tip
这里列举了 lammps 中常用的软件，您可以在安装 PWMLFF 时顺带安装
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
对于 Linear 和 NN 模型的lammps 接口请参考 [`lammps4pwmlff/0.1.0 安装`](http://doc.lonxun.com/en/1.0/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85)
:::

### 4. lammps 加载环境运行md例子
``` bash
#1. 用于mpirun 命令
module load intel/2020
#2. 加载conda环境、激活conda虚拟环境
source /the/path/to/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
#3. 加载PWMLFF 环境变量
export PATH=/the/path/to/MatPL-2025.3/src/bin:$PATH
export PYTHONPATH=/the/path/to/MatPL-2025.3/src/:$PYTHONPATH
#4. 导入MatPL-2025.3 的共享库路径
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
#5. 加载lammps 环境变量
export PATH=/the/path/to/Lammps_for_MatPL-2025.3/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_MatPL-2025.3/src:$LD_LIBRARY_PATH
#6. 运行 GPU lammps 命令
mpirun -np 4 lmp_mpi_gpu -in in.lammps
# 或者运行 CPU lammps 命令
# mpirun -np 32 lmp_mpi -in in.lammps
```
:::caution
在提交训练任务时，注意任务脚本中需要确保加载相关环境，如下所示：

```
source /share/app/anaconda3/etc/profile.d/conda.sh
module load conda/3-2020.07
conda deactivate
conda activate PWMLFF
module load pwmlff/2024.5

```
<!-- # 以下是一些针对可能存在的问题的一种解决方式
export MKL_SERVICE_FORCE_INTEL=1
export MKL_THREADING_LAYER=GNU
export I_MPI_HYDRA_BOOTSTRAP=slurm
export I_MPI_PMI_LIBRARY=/lib64/libmpi.so -->
<!-- 
- 第 5、6 行环境解决 pytorch 与 numpy 版本不匹配的问题
- 最后两行环境解决多 lammps 任务无法同时并行的问题 -->
**加载`pwmlff`和虚拟环境的目的是为了获取`LD_LIBRARY_PATH`。**
**lammps 运行时必须包含`LD_LIBRARY_PATH`环境变量，否则无法调用特定库。**
:::
