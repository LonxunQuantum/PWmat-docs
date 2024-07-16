---
sidebar_position: 1
---

# Load and install (In Mcloud)

## PWMLFF

:::tip
PWMLFF 包含 Fortran、Python 和 CUDA 加速等，需要在包含 Python 环境、gcc 编译器、GPU 硬件条件下进行安装。我们这里提供了三种方式安装 PWMLFF。
:::

### 一、 Mcloud 直接加载

`mcloud` 已有配置好的 conda 环境和 PWMLFF 软件包，避免自己安装 anaconda, cudatoolkit, pytorch 等极度耗时的过程，使用 `PWMLFF` 请加载以下环境变量即可：

``` bash
# 加载conda 环境
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
# PWMLFF 用于PWMLFF2024.5 或 pwmlff/2024.03.06版本
module load pwmlff/2024.5
```

### 二、 离线安装

对于非联网设备，可以直接下载已经配置好的 conda 环境及程序包：

#### 1. 下载

👉[百度云链接](https://pan.baidu.com/s/1K4TrZuh4WVzSwfu2ZzL5mg?pwd=pwmt) 选择最新的版本下载（当前最新版本为2024.05）。

#### 2. 解压

```bash
gzip -d pwmlff.2024.5.sh.gz
```

解压后得到 `pwmlff.2024.5.sh` 文件，执行该文件即可完成环境的安装。

:::caution
运行 `pwmlff.2024.5.sh` 前，仍然需要加载编译所需要的模块，即 intel, cuda 和 gcc.
对于mcloud用户，直接加载如下环境
module load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable
:::

```bash
./pwmlff.2024.5.sh
# 或 sh pwmlff.2024.5.sh
```

运行完成后，会在运行目录下生成一个名为 `PWMLFF2024.5` 的文件夹，内含所有的环境配置（`pwmlff`）和程序包（`PWMLFF`）。

解压及编译完成后，更新环境变量：

```bash
source ~/.bashrc
```

#### 3. 使用

激活环境

```bash
source /the/path/PWMLFF2024.5/pwmlff/bin/activate
# 这里环境地址需要完整的路径，例如/data/home/wuxingxing/pack/PWMLFF2024.5/pwmlff/bin/activate
```

退出环境

```bash
source /the/path/PWMLFF2024.5/pwmlff/bin/deactivate
# 这里环境地址需要完整的路径，例如/data/home/wuxingxing/pack/PWMLFF2024.5/pwmlff/bin/deactivate
```

### 三、在线安装

在线安装需要您首先配置环境，然后下载和编译源码。

#### 配置环境
为了编译和运行PWMLFF2024.5，您需要安装conda 环境，并在conda 环境中安装 PWMLFF2024.5依赖的安装包，过程如下。

1. 首先加载编译 PWMLFF 所需的编译器
```bash
# mcloud 用户直接加载如下环境
module load cuda/11.8-share intel/2020 cmake/3.21.6
source /opt/rh/devtoolset-8/enable
```
我们推荐使用 `intel2020`版本，`cuda/11.8`，`cmake版本 >= 3.21`，`gcc 版本 8.n` 即可。

2. 在用户目录下创建一个新 python 虚拟环境，建议手动下载并使用 Anaconda3 进行环境管理（搜索引擎搜索 Linux 安装 anaconda3 教程）。

可以使用该命令直接下载 Anaconda3 到服务器目录中：

```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh

# 如果无法下载，请访问网页 https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/ 下载，或者其他方式下载。
```

conda 安装完成后，创建虚拟环境，环境中需指定安装 python3.11 解释器，其他版本可能会出现依赖冲突或语法不支持等问题，之后的编译工作均在该虚拟环境中进行

``` bash
conda create -n pwmlff2024.5 python=3.11
# python 版本我们建议3.11，更高级别的 python 可以在编译时存在一些错误，我们还未兼容。
```

3. 虚拟环境安装完成后重新激活该环境

```
conda deactivate
conda activate pwmlff2024.5
```

4. 安装 PWMLFF 所需的第三方依赖包

```bash
pip3 install numpy tqdm cmake pyyaml pandas scikit-learn-intelex matplotlib pwdata pwact pybind11 
pip3 install charset_normalizer==3.3.2

# charset_normalizer 请安装到最新版本(版本3.3.2或以上)，否则在编译fortran code 会存在编码错误 
#UnicodeDecodeError: 'ascii' codec can't decode byte 0xe4 in position 144: ordinal not in range(128)
```

```python
pip install torch==2.2.0  --index-url https://download.pytorch.org/whl/cu118
# 建议您使用torch2.2.0版本，如果您要使用torch2.3版本或以上，请使用9.0及以上的gcc
```

如需安装其他版本的 `pytorch` 请查阅[Pytorch 官网](https://pytorch.org/get-started/previous-versions/)。

5. 完成第三方依赖包安装后进行 PWMLFF 的 [编译安装](#编译安装)。

#### 编译安装

6. 准备环境完成之后，您需要下载和编译源码。我们提供了在线拉取代码和下载离线包两种方式编译。

- 通过github或gitee 在线拉取PWMLFF仓库代码
```bash
  $ git clone https://github.com/LonxunQuantum/PWMLFF.git
  或
  $ git clone https://gitee.com/pfsuo/PWMLFF.git
```

代码拉取后，进入PWMLFF源码src目录编译源码
``` bash
  $ cd PWMLFF/src
  $ sh build.sh
```

- 或下载release 离线安装包，您可以直接浏览器输入下面的地址下载，或者加前缀 wget 下载:
``` bash
  $ wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/heads/master.zip
  或
  $ wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```
下载releas离线安装包后，通过如下方式解压和编译

``` bash
  $ unzip master.zip
  $ cd PWMLFF-master/src
  $ sh build.sh
```
:::tip
- `编译完成后会自动将 PWMLFF 环境变量加入.bashrc 文件中，如果不需要，请您在.bashrc中手动删除环境变量`。您可以执行以下命令更新环境变量：
```bash
source ~/.bashrc
```
:::

至此完成了 PWMLFF 的全部编译安装，后续使用时也要保证在 PWMLFF 的虚拟环境中，并加载完成 intel 编译器。

## Lammps (Recompiled version for PWMLFF)

:::tip
当前版本 Lammps 适用于 DP 和 NEP model 提取的力场模型

旧版 Linear, NN 和 DP model 提取的力场模型见 [Lammps for PWMLFF](http://doc.lonxun.com/1.1/PWMLFF/Installation_v0.0.1/#lammps_for_pwmlff%E5%AE%89%E8%A3%85)
:::

我们为Lammps 安装提供了两种方案。对于Mcloud用户，可以直接加载和使用已安装的lammps接口。也为用户提供了从源码编译安装方式。

### 一、Mcloud 直接加载

Mcloud 已经为用户安装PWMLFF2024.5对应的lammps接口，使用如下命令加载即可。

```bash
module load lammps4pwmlff/2024.5
```

### 二、通过源码编译安装
源码安装需要经过如下几个步骤。

1. lammps 源码下载，你可以通过github下载源码，或者下载release 包。
- 通过github或gitee clone 源码:
```bash
$ git clone -b libtorch https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
或
$ git clone -b libtorch https://gitee.com/pfsuo/Lammps_for_PWMLFF.git
```

- 或下载release 包:
```bash
$ wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/tags/2024.5.zip
或
$ wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/2024.5

$ unzip 2024.5.zip    #解压源码
```

2. 加载编译环境变量

注意，您需要保持编译 PWMLFF 和 编译 lammps 使用的 python 虚拟环境相同。为了编译lammps，您需要加载以下环境变量。

```bash
# 加载编译器
load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable #此为gcc编译器，您可以加载自己的8.n版本

# PWMLFF 环境加载例子
# 加载conda 环境
source /the/path/anaconda3/etc/profile.d/conda.sh
# 激活conda 环境，注意这里使用的虚拟环境需要和编译PWMLFF2024.5时的环境相同
conda activate pwmlff2024.5 
# 加载 PWMLFF2024.5 环境变量
export PATH=/the/path/codespace/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/codespace/PWMLFF2024.5/src/:$PYTHONPATH
# 加载 共享库文件
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```

:::info

1. 模型导出使用 Libtorch 库，编译软件时确保加载 PWMLFF 所在的虚拟环境
2. 编译和执行程序需要使用到包含在 PWMLFF 软件包中的`op`(自定义算子)库，需要确保在环境变量中
   :::

3. 编译lammps代码

为了使用 NEP模型的 GPU 版本，需要您先将 NEP 的 c++ cuda 代码编译为静态库文件，如下所示。
``` bash
cd src/PWMLFF/NEP_GPU
make clean
make
# 编译完成后您将得到一个src/PWMLFF/NEP_GPU/libnep_gpu.so的静态库文件
```

编译lammps 接口：
```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
make clean-all && make mpi -j4

```
如果编译过程中找不到 `cuda_runtime.h` 头文件，请在 `src/MAKE/Makefile.mpi` 文件的 `第24行` 替换为您自己的 CUDA 路径，`/the/path/cuda/cuda-11.8`，`cuda_runtime.h` 位于该目录下的 `include` 目录下。
```txt
CUDA_HOME = $(CUDADIR)
```

4. 将 Lammps 执行文件写入环境变量中

```bash
vim ~/.bashrc
export PATH=absolute/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
source ~/.bashrc
```

5. 将 Pytorch 相关库写入环境变量中
在执行lammps 时您需要加载下环境变量
```bash
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib" >> ~/.bashrc

```

您也可以执行下述指令将共享库文件路径写入./bashrc，再次使用lammps时不再需要加载该环境变量
```bash
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib" >> ~/.bashrc
```

**加载`pwmlff`和虚拟环境的目的是为了获取`LD_LIBRARY_PATH`。**

**lammps 运行时必须包含`LD_LIBRARY_PATH`环境变量，否则无法调用特定库。**

---

:::caution
在提交训练任务时，注意任务脚本中需要确保加载相关环境，如下所示：

```
module load intel/2020
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF

# 以下是一些针对可能存在的问题的一种解决方式
export MKL_SERVICE_FORCE_INTEL=1
export MKL_THREADING_LAYER=GNU
export I_MPI_HYDRA_BOOTSTRAP=slurm
export I_MPI_PMI_LIBRARY=/lib64/libpmi.so
```

- 第 5、6 行环境解决 pytorch 与 numpy 版本不匹配的问题
- 最后两行环境解决多 lammps 任务无法同时并行的问题

:::

### lammps 加载环境运行md例子

#### 加载 Mcloud 已安装lammps 做MD 

``` bash
module load lammps4pwmlff/2024.5

mpirun -np 1 lmp_mpi_gpu -in in.lammps
# 如果您使用cpu version
# mpirun -np 1 lmp_mpi -in in.lammps

```
#### 加载用户自己的环境做MD

``` bash
# 用于mpirun 命令
module load intel/2020

# 加载conda环境、激活conda虚拟环境
source /data/home/wuxingxing/anaconda3/etc/profile.d/conda.sh
conda activate torch2_feat

# 加载PWMLFF 环境变量
export PATH=/data/home/wuxingxing/codespace/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/data/home/wuxingxing/codespace/PWMLFF2024.5/src/:$PYTHONPATH

# 导入PWMLFF2024.5 的共享库路径
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib

# 加载lammps 环境变量
export PATH=/data/home/wuxingxing/codespace/Lammps_for_PWMLFF-2024.5/src:$PATH

# 如果您需要运行NEP gpu 版本的lammps 接口，请加载
# export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src/PWMLFF/NEP_GPU:$LD_LIBRARY_PATH

# GPU lammps 命令
mpirun -np 1 lmp_mpi_gpu -in in.lammps

# CPU lammps 命令
# mpirun -np 32 lmp_mpi -in in.lammps

```