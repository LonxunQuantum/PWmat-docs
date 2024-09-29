---
sidebar_position: 1
---


# Install and load

CPU 版本 PWMLFF 离线安装包集成了 PWMLFF 和 Lammps 接口，包含 `Fortran`、`Python (Pytorch2.0)` 、 `C++`代码，需要 `Python 环境`、`gcc 编译器`、`intel编译器套件`（包括`ifort`、`icc` 编译器、`mkl`和`mpi`库。由于不采用 GPU 计算，所以不需要 `NVIDIA GPU` 支持。

由于 conda 环境配置较为耗时，且部分用户设备无法联网。我们在离线安装包中配置好了conda 环境，用户只需要下载离线包，安装后即可使用。

## 一、离线安装

### 1. 下载离线安装包

请访问百度网盘下载，链接如果失效请邮件联系 `wuxingxing@pwmat.com` 或`support@pwmat.com`：

👉[CPU 版本离线安装包下载 pwmlff_cpu-2024.5.sh.tar.gz](https://pan.baidu.com/s/1-MQBicDKaeudUhjmJRJrZA?pwd=pwmt)

### 2. 解压安装包

```bash
tar -xzvf pwmlff_cpu-2024.5.sh.tar.gz
```

解压后得到如下文件：
`pwmlff_cpu-2024.5.sh`， `check_offenv_cpu.sh`

### 3. 检查编译器版本

CPU 离线安装包解压后会得到安装包`pwmlff_cpu-2024.5.sh` 以及`check_offenv_cpu.sh`，执行如下命令
```bash
sh check_offenv_cpu.sh
```
命令执行后会列出需要的编译器版本以及当前检测到的版本，如下是一个正确的环境配置检查后的结果：
```
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
```
第1行输出了 ifort 编译器要求的版本不低于19.1，检测到当前的版本是19.1，满足要求；

第2行查找 MKF 库是否存在，检测到已安装，满足要求；

第3行输出了 GCC 要求的版本 8.n， 检测到当前的GCC版本是8，满足要求。

CPU 版本不需要 CUDA 和 nvcc 编译器支持。

### 4. 执行安装命令
环境检查完毕后，执行如下命令即可完成安装
```bash
sh pwmlff_cpu-2024.5.sh
```

安装窗口最后出现如下日志输出，则安装成功。
```
mpicxx -g -O3 -std=c++17 -L/the/path/to/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/lib -lpython3.11 -static-libstdc++ -static-libgcc -L/the/path/to/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/lib/python3.11/site-packages/torch/lib/ -ltorch -lc10 -ltorch_cpu -L/the/path/to/PWMLFF_cpu-2024.5/PWMLFF/src/op/build/lib -lCalcOps_bind_cpu main.o      -L. -llammps_mpi      -ldl  -o ../lmp_mpi
size ../lmp_mpi
   text	   data	    bss	    dec	    hex	filename
11924907	  37816	  22640	11985363	 b6e1d3	../lmp_mpi
make[1]: Leaving directory `/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src/Obj_mpi'
PyTorch is not a CUDA version. Disabling CUDA support...
make[1]: Entering directory `/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src/Obj_mpi'
Skipping GPU version since CUDA is not enabled.
make[1]: Leaving directory `/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src/Obj_mpi'
Added Lammps PATH to .bashrc
Installation completed successfully!
Added torch lib LD_LIBRARY_PATH to .bashrc
```
:::tip

安装完成之后，会默认将 PWMLFF_cpu-2024.5 环境变量（如下所示）写入 .bashrc 中，如果不需要，请您手动到.bashrc中删除即可。删除后，需要您在每次运行 PWMLFF 前手动导入该环境变量。
```bash
# PWMLFF 环境变量
export PATH=/the/path/to/PWMLFF_cpu-2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF_cpu-2024.5/PWMLFF/src/:$PYTHONPATH
# lammps 接口环境变量
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
export PATH=/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/to/PWMLFF_cpu-2024.5/lammps-2024.5/src:$LD_LIBRARY_PATH

这里 `/the/path/to/`为您自己的安装目录。
```
:::

### 5. 加载使用

离线安装包安装成功后，在使用时需要您首先激活已安装的conda环境，以及编译时使用的 intel/2020 。之后，如果需要使用 PWMLFF 训练，则加载PWMLFF 环境变量；如果需要使用 Lammps 接口，则在加载 PWMLFF 环境变量之后继续加载 Lammps 接口环境变量。

#### step1. 激活已安装的conda环境
```bash
# 这里环境地址需要完整的路径，例如/data/home/wuxingxing/pack/PWMLFF-2024.5/pwmlff/bin/activate
source /the/path/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/bin/activate
```

#### step2. 加载您在编译时使用的 intel编译包以及CUDA
```bash
module load intel/2020
```

#### step3. 加载 PWMLFF 环境变量

如果您的 ./bashrc (离线安装后会自动写入) 不包含下面的环境变量，请导入该环境变量：
```bash
export PATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/:$PYTHONPATH
```

#### step4. 加载 Lammps 接口
如果您的 ./bashrc (离线安装后会自动写入) 不包含下面的环境变量，请导入该环境变量：
```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
export PATH=/the/path/PWMLFF_cpu-2024.5/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/PWMLFF_cpu-2024.5/lammps-2024.5/src:$LD_LIBRARY_PATH
```

### 6. 退出 conda 虚拟环境
您可以通过如下命令退出虚拟环境，也可以直接关闭当前 shell 窗口
```bash
source /the/path/PWMLFF_cpu-2024.5/pwmlff_cpu-2024.5/bin/deactivate
```


## 二、在线安装

在线安装需要您分别编译安装 PWMLFF 和 lammps 接口。

为了编译和运行PWMLFF-2024.5，您需要下载源码、安装conda 环境，并在 conda 环境中安装 PWMLFF-2024.5 依赖的安装包。

Lammps 接口的编译安装要求用户已经成功安装 PWMLFF。

过程如下所示。

### PWMLFF 编译安装

CPU 版本的 PWMLFF 和 Lammps 接口源码与 GPU 版本相同，区别是 GPU 版本启用了GPU 加速的代码。编译过程与GPU版本相似，只是安装的 pytorch 依赖包不含 CUDA 支持，编译过程也不需要 CUDA。

### 1. 下载源码
我们提供了在线拉取代码和下载离线包两种方式编译。
- 通过 github 或 gitee 在线拉取PWMLFF仓库代码
```bash
  git clone https://github.com/LonxunQuantum/PWMLFF.git PWMLFF-2024.5
  或
  git clone https://gitee.com/pfsuo/PWMLFF.git PWMLFF-2024.5
```

- 或下载 release 离线源码包，您可以直接浏览器输入下面的地址下载，或者加前缀 wget 下载:
``` bash
  wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/tags/2024.5.zip
  或
  wget https://gitee.com/pfsuo/PWMLFF/repository/archive/2024.5
```
下载releas离线源码包后，通过 unzip 命令解压。
``` bash
  # 解压后您将得到一个名称为 PWMLFF-2024.5 的源码目录
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

#### step2. 创建虚拟环境
conda 安装完成后，创建虚拟环境，环境中需指定安装 `python3.11` 解释器，其他版本可能会出现依赖冲突或语法不支持等问题，之后的编译工作均在该虚拟环境中进行

``` bash
conda create -n pwmlff-2024.5 python=3.11 setuptools=68.0.0
# python 版本我们建议3.11，更高级别的 python 可以在编译时存在一些错误，我们还未兼容。这里需要指定setuptools版本低于75.0.0，避免 numpy 和 fortran 做数据格式转换时的错误。
```
虚拟环境安装完成后激活该环境
``` bash
conda activate pwmlff2024.5
```

#### step3. 安装依赖包
接下来安装 PWMLFF 所需的第三方依赖包，我们已经把所有依赖的第三方包写在`'requirement_cpu.txt'` 中，只需要在该文件所在目录下执行 pip 命令即可完成所有的依赖包安装。操作过程如下。该步骤会安装pytorch等python环境较耗时，请您耐心等待。

```bash
# 第一步 激活conda 环境
conda activate pwmlff2024.5
# 第二步 进入源码根目录
# 在线下载的源码进入 PWMLFF-2024.5 目录
cd PWMLFF-2024.5
# 离线下载的源码包在解压后进入 PWMLFF-2024.5 目录
pip install -r requirement_cpu.txt
```
### 3. 编译安装

#### step1. 检查编译环境
进入 requirement_cpu.txt 的同级目录 `src` 目录下。
首先检查`intel/2020`，`gcc8.n`是否加载；检查 `conda` 虚拟环境是否加载。

对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。

由于大部分的编译不成功是由编译器版本问题造成的，我们提供了编译环境检测的脚本 `check_env_cpu.sh` ，位于 `'/src/check/check_env_cpu.sh'` 您可以执行该脚本来检查编译环境已经完成准备。

``` bash
cd src
sh ./check/check_env_cpu.sh
```
执行后，将输出您的编译环境信息，一个正确的环境如下所示。
```txt
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
PyTorch is installed.
PyTorch version is 2.0 or above, current version is 2.2.
```
第1行输出了 ifort 编译器要求的版本不低于19.1，检测到当前的版本是19.1，满足要求；

第2行查找 MKF 库是否存在，检测到已安装，满足要求；

第3行输出了 GCC 要求的版本 8.n， 检测到当前的GCC版本是8，满足要求;

第4行检查 python 环境是否已经安装 pytorch，检测到已安装，满足要求；

第5行检查 pytroch 版本是否为2.0 以上，检测到当前版本是2.2，满足要求。

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
export PATH=/the/path/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF-2024.5/src/:$PYTHONPATH
```
:::

至此完成了 PWMLFF 的全部编译安装。

### Lammps for PWMLFF编译安装

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
load intel/2020
source /opt/rh/devtoolset-8/enable #此为gcc编译器，您可以加载自己的8.n版本

# PWMLFF 环境加载例子
# 加载conda 环境
source /the/path/anaconda3/etc/profile.d/conda.sh
# 激活conda 环境，注意这里使用的虚拟环境需要和编译PWMLFF-2024.5时的环境相同
conda activate pwmlff2024.5 
# 加载 PWMLFF-2024.5 环境变量
export PATH=/the/path/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF-2024.5/src/:$PYTHONPATH
# 加载 共享库文件
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
```

:::info

1. 模型导出使用 Libtorch 库，编译软件时确保加载 PWMLFF 所在的虚拟环境
2. 编译和执行程序需要使用到包含在 PWMLFF 软件包中的`op`(自定义算子)库，需要确保在环境变量中
:::

### 3. 编译lammps代码
相比于 GPU 版本的编译，在CPU中不使用 NEP 模型的 GPU 加速，您直接编译lammps接口即可。

```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
make clean-all && make mpi -j4
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
export PATH=/the/path/to/PWMLFF-2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF-2024.5/src/:$PYTHONPATH
#4. 导入PWMLFF-2024.5 的共享库路径
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
#5. 加载lammps 环境变量
export PATH=/the/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$LD_LIBRARY_PATH
#6. 运行 CPU lammps 命令
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
