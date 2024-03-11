---
sidebar_position: 1
---

# Load and install (In Mcloud)

## PWMLFF
:::tip
PWMLFF 包含 Fortran、Python 和 CUDA 加速等，需要在包含 Python 环境、gcc 编译器、GPU 硬件条件下进行安装
:::

### Mcloud 直接加载

mcloud 已有配置好的 conda 环境，可以直接调用，避免自己安装 anaconda, cudatoolkit, pytorch 等极度耗时的过程，具体步骤如下：

```
module load pwmlff
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
```

### 环境配置

1. 首先加载编译 PWMLFF 所需的编译器(**intel ≥ 2016 , gcc ≥ 7.0**)和 cuda (推荐 **11.8**)

```
module load cuda/11.8-share intel/2020
source /opt/rh/devtoolset-8/enable
```

2. 在用户目录下创建一个新 python 虚拟环境，建议手动下载并使用 Anaconda3 进行环境管理（搜索引擎搜索 Linux 安装 anaconda3 教程）。

可以使用该命令直接下载 Anaconda3 到服务器目录中：

```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
```

conda 安装完成后，创建虚拟环境，环境中需指定安装 python3.11 解释器，其他版本可能会出现依赖冲突或语法不支持等问题，之后的编译工作均在该虚拟环境中进行

```
conda create -n PWMLFF python=3.11
```

3. 虚拟环境安装完成后重新激活该环境

```
conda deactivate
conda activate PWMLFF
```

4. 安装 PWMLFF 所需的第三方依赖包

```python
pip3 install numpy tqdm cmake pyyaml pandas scikit-learn-intelex matplotlib pwdata
```

```python
pip3 install torch --force-reinstall --index-url https://download.pytorch.org/whl/cu118
```

如需安装其他版本请查阅[Pytorch 官网](https://pytorch.org/get-started/previous-versions/)。

5. 完成第三方依赖包安装后进行 PWMLFF 的编译安装。

### 编译安装

<!-- :::tip
* (Mstation用户通过`nvidia-smi`可查看到GPU信息，可以跳过该步骤)。正式编译前使用srun -p GPU节点名(3090或3080ti) --pty /bin/bash 进入含有GPU的节点环境，如没有权限，需向工作人员申请。

    ```bash
    $ srun -p 3090 --pty /bin/bash
    ```

* 进入GPU节点后需要重新加载所需要的环境(`PWMLFF`)以及编译器：
    ```bash
    module load cuda/11.6 intel/2020
    source /opt/rh/devtoolset-8/enable
    ```

* 再次检查torch是否可以读取到GPU信息

    ```python
    python
    >> import torch
    >> torch.cuda.is_available()
    #如果返还True，则表明已有GPU硬件环境
    ```


::: -->

- 在线安装:

  ```bash
  $ git clone https://github.com/LonxunQuantum/PWMLFF.git
  或
  $ git clone https://gitee.com/pfsuo/PWMLFF.git

  $ cd PWMLFF/src
  $ srun -p 3090 --gres=gpu:1 sh build.sh
  ```

  **(Mstation 用户通过`nvidia-smi`可查看到 GPU 信息，将`srun -p 3090 sh build.sh`替换为`sh build.sh`)**。

  - 源码下载:
    - https://github.com/LonxunQuantum/PWMLFF
    - https://gitee.com/pfsuo/PWMLFF

  或者使用以下命令下载源码到用户目录下并解压安装：

  ```bash
  $ wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/heads/master.zip
  或
  $ wget https://gitee.com/pfsuo/PWMLFF/repository/archive/master.zip

  $ unzip master.zip
  $ cd PWMLFF-master/src
  $ srun -p 3090 --gres=gpu:1 sh build.sh
  ```

- 编译完成后环境变量需更新，直接执行以下命令：

```bash
source ~/.bashrc
```

至此完成了 PWMLFF 的全部编译安装，后续使用时也要保证在 PWMLFF 的虚拟环境中，并加载完成 intel 编译器。

## Lammps (Recompiled version for PWMLFF)

:::tip
当前版本 Lammps 适用于 DP model 提取的力场模型

旧版 Linear, NN 和 DP model 提取的力场模型见 [Lammps for PWMLFF](http://doc.lonxun.com/PWMLFF/Installation_v0.0.1#lammps_for_pwmlff%E5%AE%89%E8%A3%85)
:::

### Mcloud 直接加载

```bash
module load lammps4pwmlff
```

### 编译安装

使用 PWMLFF 完成力场模型构建后需使用配套的 Lammps 进行分子动力学模拟，以下是详细的安装步骤：

1. 加载编译所需模块 （以 Mcloud 为例）

```
module load pwmlff lammps4pwmlff
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate PWMLFF
```

:::info

1. 模型导出使用 Libtorch 库，编译软件时确保加载 PWMLFF 所在的虚拟环境
2. 编译和执行程序需要使用到包含在 PWMLFF 软件包中的`op`(自定义算子)库，需要确保在环境变量中
   :::

- 在线安装:

```bash
$ git clone -b libtorch https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
或
$ git clone -b libtorch https://gitee.com/pfsuo/Lammps_for_PWMLFF.git
```

```bash
cd Lammps_for_PWMLFF/src
make yes-PWMLFF
export OP_LIB_PATH=$(dirname $(dirname $(which PWMLFF)))/op/build/lib
make clean-all && make mpi -j4
```

- 源码下载:

  - https://github.com/LonxunQuantum/Lammps_for_PWMLFF/tree/libtorch
  - https://gitee.com/pfsuo/Lammps_for_PWMLFF/tree/libtorch/

    或者使用以下命令下载源码到用户目录下并解压安装：

```bash
$ wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/tags/v2024.03.01.zip
或
$ wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/v2024.03.01.zip

$ unzip v2024.03.01.zip    #解压后进入源码目录，完成上述编译安装步骤
```

2. 将 Lammps 执行文件写入环境变量中

```bash
vim ~/.bashrc
export PATH=absolute/path/to/Lammps_for_PWMLFF/src:$PATH
source ~/.bashrc
```

3. 将 Pytorch 相关库写入环境变量中

```bash
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib" >> ~/.bashrc
```

---

:::caution
在提交训练任务时，注意任务脚本中需要确保加载相关环境，如下所示：

```
module load intel/2020
source /opt/rh/devtoolset-8/enable
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate mlff
export MKL_SERVICE_FORCE_INTEL=1
export MKL_THREADING_LAYER=GNU
export I_MPI_HYDRA_BOOTSTRAP=slurm
export I_MPI_PMI_LIBRARY=/lib64/libpmi.so
```

- 第 5、6 行环境解决 pytorch 与 numpy 版本不匹配的问题
- 最后两行环境解决多 lammps 任务无法同时并行的问题

:::
