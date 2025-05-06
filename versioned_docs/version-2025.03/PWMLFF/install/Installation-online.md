---
sidebar_position: 2
---


# 在线安装

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已做预装，[加载即用](./README.md)


在线安装需要您分别编译安装 MatPL 和 lammps 接口。在线安装依赖`intel 编译器`、`CUDA-11.8工具包`、`gcc编译器`以及 `Python 环境`。对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。对于 Python 环境，要求 python >= 3.11，torch >= 2.2.0+cu118。

为了编译和运行 MatPL-2025.3，您需要下载源码、安装conda 环境，并在 conda 环境中安装 MatPL-2025.3 依赖的Python环境，之后编译源码。

`MatPL 和 lammps-MatPL 提供了纯 CPU 版本`。源码相同，GPU 版本除了对 CPU 环境的依赖外，还需要相应的GPU环境（CUDA）。

## MatPL 编译安装

### 1. 下载源码
我们提供了在线拉取代码和下载离线包两种方式编译。

- 通过 github 或 gitee 在线拉取 MatPL 仓库代码
```bash
  git clone https://github.com/LonxunQuantum/MatPL.git MatPL-2025.3
  或
  git clone https://gitee.com/pfsuo/MatPL.git MatPL-2025.3
```

- 或下载 release 离线源码包，您可以直接浏览器输入下面的地址下载，或者加前缀 wget 下载:
``` bash
  wget https://github.com/LonxunQuantum/MatPL/archive/refs/tags/MatPL-2025.3.zip
  或
  wget https://gitee.com/pfsuo/MatPL/repository/archive/2025.3
```
下载 release 离线源码包后，通过 unzip 命令解压。
``` bash
  # 解压后您将得到一个名称为 MatPL-2025.3 的源码目录
  unzip 2025.3.zip
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
conda activate matpl-2025.3
```

#### step3. 安装依赖包
接下来安装 MATPL 所需的第三方依赖包，我们已经把所有依赖的第三方包写在requirement.txt中，只需要在该文件所在目录下执行 pip 命令即可完成所有的依赖包安装。操作过程如下。该步骤会安装pytorch等python环境较耗时，请您耐心等待。

- matpl-2025.3/requirement.txt 是 MatPL GPU 版本的 python 环境

- matpl-2025.3/requirements_cpu.txt 是 MatPL CPU 版本的 python 环境

```bash
# 第一步 激活conda 环境
conda activate matpl-2025.3
# 第二步 进入源码根目录
# 在线下载的源码进入 MatPL-2025.3 目录
cd MatPL-2025.3
# 对于 GPU 版本，请执行
pip install -r requirements.txt
# 对于 CPU 版本，请执行
pip install -r requirements_cpu.txt
```
### 3. 编译安装

#### step1. 检查编译环境
##### GPU 版本
进入 requirement.txt 的同级目录 `src` 目录下。
对于 GPU 版本，
首先检查 `cuda/11.8`，`intel/2020`，`gcc8.n`是否加载；检查 `conda` 虚拟环境是否加载。对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。由于大部分的编译不成功是由编译器版本问题造成的，我们提供了编译环境检测的脚本 `check_env.sh` ，位于 `'/src/check/check_env.sh'` 您可以执行该脚本来检查编译环境已经完成准备。

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

第2行查找 MKL 库是否存在，检测到已安装，满足要求；

第3行输出了 GCC 要求的版本 8.n， 检测到当前的GCC版本是8，满足要求;

第4行检查 python 环境是否已经安装 pytorch，检测到已安装，满足要求；

第5行检查 pytroch 版本是否为2.0 以上，检测到当前版本是2.2，满足要求；

第6行检查 pytroch 版本是否包含 CUDA 支持，检测到包含，满足要求；

第7行检查 CUDA 版本是否不低于11.8，检测到当前的版本是 11.8.89，满足要求；

第8行检查 nvcc 编译器是否存在，检测到存在，满足要求。


##### CPU 版本
对于 CPU 版本，不需要 CUDA 支持，检测脚本为 check_env_cpu.sh，位于 `'/src/check/check_env_cpu.sh'`。命令执行后会列出需要的编译器版本以及当前检测到的版本，如下是一个正确的环境配置检查后的结果：
```
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
```
第1行输出了 ifort 编译器要求的版本不低于19.1，检测到当前的版本是19.1，满足要求；

第2行查找 MKL 库是否存在，检测到已安装，满足要求；

第3行输出了 GCC 要求的版本 8.n， 检测到当前的GCC版本是8，满足要求。

#### step2. 编译代码

如果您的环境满足上述检测，接下来进行代码编译。
执行如下命令开始编译：
```bash
sh clean.sh
sh build.sh
```
:::tip
如果您在编译过程中出错，请在[MATPL 常见安装错误总结](./error-record/InstallError.md) 中查询。

如果仍未解决您的问题，请将您的机器环境信息、编译错误日志以及您执行的编译操作过程描述 发送到邮箱 support@pwmat.com 或者 wuxingxing@pwmat.com，我们将及时联系您处理。
:::
编译完成后，最后输出如下信息：
```
=================================
MatPL has been successfully installed. Please load the MatPL environment variables before use.
You can load the environment variables by running (recommended):

  source /the/path/of/MatPL-2025.3/env.sh

Or by executing the following commands:

  export PYTHONPATH=/the/path/of/MatPL-2025.3/src:$PYTHONPATH
  export PATH=/the/path/of/MatPL-2025.3/src/bin:$PATH

==================================
```
编译完成后，将在代码的根目录下生成一个env.sh文件，包含 MatPL 的环境变量，执行以下命令即可完成加载
```bash
  source /the/path/of/MatPL-2025.3/env.sh
```

也可以通过如下命令加载
```
  export PYTHONPATH=/the/path/of/MatPL-2025.3/src:$PYTHONPATH
  export PATH=/the/path/of/MatPL-2025.3/src/bin:$PATH
```

### 4. 加载使用
使用 MatPL 前需要加载它的依赖环境，加载 python 环境、cuda、MatPL 环境变量（CPU版本不需要加载CUDA）。

```bash
conda activate matpl-2025.3
module load cuda/11.8-share
source /the/path/of/MatPL-2025.3/env.sh
```
之后即可使用 MatPL 命令开始训练，使用教程请参考 [教学案例](../models/README.md)

## lammps-MatPL (libtorch) 编译安装 
lammps-MatPL (libtorch 版本) CPU 与 GPU 版本源码相同，区别只在编译上。

lammps-MatPL (libtorch 版本) 用于 MatPL 的DP 和 NEP 力场。对于 NN 和 Linear 力场，提供了 fortran 版本的 接口，安装请参考 [lammps-fortran 编译安装](#lammps-matpl-fortran-编译安装)。

lammps-MatPL (libtorch 版本) 由于用到了 libtorch 加速，因此 编译 Lammps 接口前，需要您已经成功编译安装 MatPL。安装过程中，需要您下载 lammps 源码、加载编译器、编译源码，过程如下所示。

### 1. 准备源码

#### lammps-MatPL (libtorch 版本) 源码
lammps-MatPL (libtorch 版本) 力场接口源码位于 MatPL 源码目录 `lmps/lammps-libtorch` 下，您也可以通过 [github 下载](https://github.com/LonxunQuantum/lammps-MatPL) 下载 lammps-MatPL (libtorch 版本) 源码，或下载 release 包。
- 通过 github 或 gitee clone 源码:
```bash
git clone https://github.com/LonxunQuantum/lammps-MatPL.git
或
git clone https://gitee.com/pfsuo/lammps-MatPL.git
```

- 或下载release 包:
```bash
wget https://github.com/LonxunQuantum/lammps-MatPL/archive/refs/tags/2025.3.zip
或
wget https://gitee.com/pfsuo/lammps-MatPL/repository/archive/2025.3

unzip 2025.3.zip    #解压源码
```
MatPL 力场接口源码目录如下所示
```
├── README.md
├── LICENSE
├── Makefile.mpi
├── MATPL/
│   ├── dftd3para.h
│   ├── nep_cpu.cpp
│   ├── nep_cpu.h
│   ├── NEP_GPU
│   ├── pair_matpl.cpp
│   └── pair_matpl.h
├── dp_lmps_demo/
│   ├── in.lammps
│   ├── jit_dp.pt
│   ├── lmp.config
│   ├── runcpu.job
│   └── rungpu.job
└── nep_lmps_demo/
    ├── nep_lmps/
    └── nep_lmps_deviation/
```
MATPL 为力场接口源码，Makefile.mpi 为编译配置文件，dp_lmps_demo 和 nep_lmps_demo 分别是 DP 和 NEP 的力场 MD 测试例子。

#### Lammps 源码

lammps 源码请访问 [lammps github 仓库](https://github.com/lammps/lammps/tree/stable#) 下载，这里推荐下载 `stable 版本`。

#### 文件复制

- 复制 Makefile.mpi 文件到 lammps/src/MAKE/目录下

- 复制 MATPL 目录到 lammps/src/目录下

### 2. 加载编译环境
lammps-MatPL (libtorch 版本) 的 lammps 接口编译，依赖的编译器环境与 [MatPL 相同](#step1-检查编译环境)。如果安装 CPU 版本，则不用加载 CUDA。

```bash
# 加载编译器
module load cuda/11.8-share intel/2020
#此为gcc编译器，您可以加载自己的8.n版本
source /opt/rh/devtoolset-8/enable 
# 加载 python 环境
source /the/path/anaconda3/etc/profile.d/conda.sh
conda activate matpl-2025.3
```

### 3. 编译lammps代码

#### step1. 为了使用 NEP模型的 GPU 版本，需要您先将 NEP 的 c++ cuda 代码编译为共享库文件

如果安装 CPU 版本，则跳过该步即可。
``` bash
cd lammps/src/MATPL/NEP_GPU
make clean
make
# 编译完成后您将得到一个/lammps/src/libnep_gpu.so的共享库文件
```
#### step2. 编译 lammps 接口

```bash
cd lammps/src
make yes-MATPL
# 以下lammps 中常用软件，推荐在安装时顺带安装
make yes-KSPACE
make yes-MANYBODY
make yes-REAXFF
make yes-MOLECULE
make yes-QEQ
make yes-REPLICA
make yes-RIGID
make yes-MEAM
make yes-MC
make yes-SHOCK
# 开始编译
make clean-all && make mpi
```

如果编译过程中找不到 `cuda_runtime.h` 头文件，请在 `src/MAKE/Makefile.mpi` 文件的 `第24行` 替换为您自己的 CUDA 路径，`/the/path/cuda/cuda-11.8`，`cuda_runtime.h` 位于该目录下的 `include` 目录下。CPU 版本不存在该问题。

```txt
CUDA_HOME = $(CUDADIR)
替换为CUDA_HOME = /the/path/cuda/cuda-11.8
```

编译完成将在窗口输出如下信息，并在lammps源码根目录生成一个env.sh文件，使用lammps前加载该文件即可。

``` txt
mpicxx -g -O3 -std=c++17 -L/the/path/of/lammps/src/Obj_shared_mpi/.. -lnep_gpu -L/share/app/cuda/cuda-11.8/lib64 -lcudart -L/share/app/cuda/cuda-11.8/lib64 -lcudart main.o      -L. -llammps_mpi      -ldl  -o ../lmp_mpi
size ../lmp_mpi
   text	   data	    bss	    dec	    hex	filename
   5042	   1032	      8	   6082	   17c2	../lmp_mpi
===========================
LAMMPS has been successfully compiled. Please load the LAMMPS environment variables before use.
You can load the environment variables by running (recommended):

    source /the/path/of/lammps/env.sh

Or by executing the following commands:
    export PATH=/the/path/of/lammps/src:$PATH
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/the/path/of/lammps/src
===========================
make[1]: Leaving directory `/the/path/of/lammps/src/Obj_shared_mpi'
```

### 4. lammps 加载使用
使用 lammps 需要加载它的依赖环境，加载 intel(mpi)、cuda、lammps环境变量。CPU 版本不需要加载CUDA。
```bash
module load intel/2020 cuda/11.8-share
source /the/path/of/lammps/env.sh
```

之后即可使用如下命令启动 lammps 模拟
```bash
mpirun -np 4 lmp_mpi -in in.lammps
```

更详细的使用，请参考 
- [MatPL 操作演示：NEP lammps](../models/nep/nep-tutorial.md#lammps-md)
- [MatPL 操作演示：DP lammps](../models/dp/dp-tutorial.md#3-lammps-模拟)


## Lammps-MatPL (fortran) 编译安装 

lammps-MatPL (fortran 版本) 用于 MatPL 的 NN 和 Linear 力场，未提供 GPU 加速。安装过程中，需要您下载 lammps 源码、加载编译器、编译源码，过程如下所示。

### 1. 准备源码

#### lammps-MatPL (fortran 版本) 源码
lammps-MatPL (fortran 版本) 力场接口源码位于 MatPL 源码目录 `lmps/lammps-libtorch` 下，您也可以通过 [github 下载](https://github.com/LonxunQuantum/lammps-MatPL/tree/fortran) 下载 lammps-MatPL (fortran 版本) 源码，或下载 release 包。
- 通过 github 或 gitee clone 源码:
```bash
git clone -b fortran https://github.com/LonxunQuantum/lammps-MatPL.git
或
git clone -b fortran https://gitee.com/pfsuo/lammps-MatPL.git
```

- 或下载release 包:
```bash
wget https://github.com/LonxunQuantum/lammps-MatPL/archive/refs/tags/matpl-fortran-2025.3.zip
或
wget https://gitee.com/pfsuo/lammps-MatPL/repository/archive/2025.3

unzip 2025.3.zip    #解压源码
```
MatPL 力场接口源码目录如下所示
```
├── lmps-examples/
│   ├── linear_lmps/
│   └── nn_lmps/
├── MATPL/
├── Makefile.mpi
└── README.md
```
README.md 是安装说明，MATPL 为力场接口源码，Makefile.mpi 为编译配置文件，nn_lmps 和 linear_lmps 分别是 NN 和 Linear 的力场 MD 测试例子。

#### Lammps 源码

lammps 源码请访问 [lammps github 仓库](https://github.com/lammps/lammps/tree/stable#) 下载，这里推荐下载 `stable 版本`。

#### 文件复制

- 复制 Makefile.mpi 文件到 lammps/src/MAKE/目录下

- 复制 MATPL 目录到 lammps/src/目录下

### 2. 加载编译环境
首先检查 `intel/2020`，`gcc8.n`是否加载；

- 对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。

```bash
# 加载编译器
module load intel/2020
#此为gcc编译器，您可以加载自己的8.n版本
source /opt/rh/devtoolset-8/enable 
```

### 3. 编译lammps代码

#### step1. 编译fortran 力场库文件
``` bash
cd lammps/src/MATPL/fortran_code
make clean
make
# 编译完成后您将得到一个/lammps/src/MATPL/f2c_calc_energy_force.a 文件
```
#### step2. 编译lammps 接口

```bash
cd lammps/src
make yes-MATPL
# 以下lammps 中常用软件，推荐在安装时顺带安装
make yes-KSPACE
make yes-MANYBODY
make yes-REAXFF
make yes-MOLECULE
make yes-QEQ
make yes-REPLICA
make yes-RIGID
make yes-MEAM
make yes-MC
make yes-SHOCK
# 开始编译
make clean-all
make mpi -j4 mode=shared # 这里4为并行编译数量，shared为编译出一个共享库文件，可以用于python相关操作中
```

编译完成将在窗口输出如下信息，并在lammps源码根目录生成一个env.sh文件，使用lammps前加载该文件即可。

``` txt
===========================
LAMMPS has been successfully compiled. Please load the LAMMPS environment variables before use.
You can load the environment variables by running (recommended):

    source the/path/of/lammps/env.sh

Or by executing the following commands:
    export PATH=the/path/of/lammps/src:$PATH
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:the/path/of/lammps/src
    export LAMMPS_POTENTIALS=the/path/of/lammps/potentials
===========================
make[1]: Leaving directory `the/path/of/lammps/src/Obj_shared_mpi'

```

### 4. lammps 加载使用
使用 lammps 需要加载它的依赖环境，加载 intel(mpi)、lammps环境变量。
``` bash
module load intel/2020
source /the/path/of/lammps/env.sh
```
之后即可使用如下命令启动 lammps 模拟
```
mpirun -np 4 lmp_mpi -in in.lammps
```

更详细的使用，请参考 
- [MatPL 操作演示：Linear lammps](../models/linear/linear-tutorial.md#lammps-md)
- [MatPL 操作演示：NN lammps](../models/nn/nn-tutorial.md#lammps-md)

