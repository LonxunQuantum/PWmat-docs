---
sidebar_position: 4
title: 常见运行错误
---
## 常见运行错误
### 环境变量检查
由于未正确加载或者未加载相关环境变量，导致的运行时错误，一般表现为找不到 `MatPL` 命令 或者 一些 `***.so`的动态库缺失。此时请检查下列环境变量是否都已经加载。
``` bash
#python 环境，是否激活了python 环境
source /the/path/etc/profile.d/conda.sh
conda activate matpl-2025.3

#intel 和 cuda 工具集是否加载
module load intel/2020 cuda/11.8

#MatPL 的环境变量是否加载
source /the/path/MatPL-2025.3/env.sh
```

### 问题：CUDA driver version is insufficient for CUDA runtime version

#### 1. 错误现象

在运行 MatPL GPU 相关功能或自定义 CUDA 算子时，程序报如下错误：

```text
CUDA Error:
    File:       /data/home/wuxingxing/pack/pack-2026.3/gpu-install/MatPL-2026.3/MatPL-2026.3/src/op/kernel/calculateNepNeighbor.cu
    Line:       331
    Error code: 35
    Error text: CUDA driver version is insufficient for CUDA runtime version
```

其中 `Error code: 35` 表示当前机器上的 NVIDIA 显卡驱动版本过低，不能支持程序运行时使用的 CUDA Runtime 版本。

#### 2. 原因分析

CUDA 程序运行时需要同时满足两个条件：

1. 当前环境中加载的 CUDA Runtime 版本与程序编译、打包时使用的 CUDA 版本兼容；
2. 机器上的 NVIDIA Driver 版本足够新，能够支持该 CUDA Runtime。

如果显卡驱动版本过低，即使已经正确加载 conda 环境、CUDA module 和 MatPL 环境，也会在程序启动 CUDA kernel 时失败。

可以使用下面命令查看当前驱动信息：

```bash
nvidia-smi
```

例如，下面的驱动版本较旧，只支持到 CUDA 11.6：

```text
NVIDIA-SMI 510.39.01    Driver Version: 510.39.01    CUDA Version: 11.6
```

如果当前 MatPL 离线包或编译环境使用的是 CUDA 12.4，则该驱动版本不足，会触发上述错误。

#### 3. 解决方案

请升级 NVIDIA 显卡驱动，使其支持当前 MatPL 环境使用的 CUDA Runtime 版本。

例如，升级后驱动信息可以为：

```text
NVIDIA-SMI 550.100      Driver Version: 550.100      CUDA Version: 12.4
```

升级完成后，重新登录节点或重启相关服务，再执行：

```bash
nvidia-smi
```

确认 `Driver Version` 和 `CUDA Version` 已更新到兼容版本后，再重新运行 MatPL。

:::caution
该问题不能通过只切换 conda 环境或重新加载 CUDA module 解决。`CUDA Version` 是由 NVIDIA 驱动决定的兼容能力上限，如果驱动版本过低，需要由系统管理员升级显卡驱动。
:::

### 动态库加载错误-mkl库
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

`解决方法` 没有加载 Intel Math Kernel Library (MKL)，intel/2020 模块（ Intel Parallel Studio XE 2020 或 Intel oneAPI Toolkits 2020 版本中的一个模块化软件） 通常包含 Intel MKL 库。加载这个模块时，MKL 库将可用于你的编译和运行环境中。

``` bash
module load intel/2020
```

### Lammps 接口常见运行时错误

#### 环境变量检查

由于未正确加载或者未加载相关环境变量，导致的运行时错误，一般表现为找不到 `lmp_mpi` 命令，或者 一些 `***.so`的动态库缺失。此时请检查下列环境变量是否都已经加载。

``` bash
#1. 用于mpirun 命令
module load intel/2020

#2. 加载lammps 环境变量
source /the/path/of/lammps/env.sh

#3. 运行 lammps 命令
# --bind-to numa 把进程绑定到socket中空闲的core中，避免绑定到默认core中，导致多任务提交后运行速度下降
mpirun -np 4 --bind-to numa lmp_mpi -in in.lammps
```

#### Lammps NEP 模型

nep 模型在GPU接口中运行一段时间后，出现如下错误：
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

`解决方法` 该错误一般是 MD 运行一段时间后，力场拟合精度下降，导致部分原子的邻居列表变化较大，超过了初始设置的最大邻居数目，调大最大邻居数设置即可。
调整方法：
在nep的力场文件，如下所示的nep_to_lmps.txt：
``` txt
nep4   2 O Si
cutoff 6.0 5.0
n_max  4 4
basis_size 12 12
l_max  4 2 1
......
```
在 `cutoff` 所在行，修改为如下
``` txt
cutoff 6.0 5.0 500 400
```
这里 `500` 是 两体 (radial_cutoff) cutoff 对应的最大邻居数，`400` 是多体（angular_cutoff）项对应的最大邻居数。

:::caution
请注意，如果出现该错误，请先检查 md 轨迹文件是否正常，是否 md 本身跑蹦了。
:::