---
sidebar_position: 1
---

# 运行错误记录
本章节整理了 `PWMLFF` 、`Lammps`接口 运行时常见错误。

## PWMLFF 常见运行时错误

### 环境变量检查
由于未正确加载或者未加载相关环境变量，导致的运行时错误，一般表现为找不到 `PWMLFF` 命令 或者 一些 `***.so`的动态库缺失。此时请检查下列环境变量是否都已经加载。
``` bash
# python 环境，是否激活了python 环境
source /the/path/etc/profile.d/conda.sh
conda activate PWMLFF

# intel 和 cuda 工具集是否加载
module load intel cuda/11.8

# PWMLFF 的环境变量是否加载
export PYTHONPATH=/the/path/PWMLFF_feat/src:$PYTHONPATH
export PATH=/the/path/PWMLFF_feat/src/bin:$PATH
```

### 动态库加载错误-mkl库
#### 错误描述

``` bash
    exec(code, run_globals)
  File "/the/path/PWMLFF_nep/pwmlff_main.py", line 6, in <module>
    from src.user.dp_work import dp_train, dp_test
  File "/the/path/PWMLFF_nep/src/user/dp_work.py", line 6, in <module>
    from src.PWMLFF.dp_network import dp_network
  File "/the/path/PWMLFF_nep/src/PWMLFF/dp_network.py", line 42, in <module>
    import src.pre_data.dp_mlff as dp_mlff
  File "/the/path/PWMLFF_nep/src/pre_data/dp_mlff.py", line 11, in <module>
    from src.lib.NeighConst import neighconst
ImportError: libmkl_rt.so: cannot open shared object file: No such file or directory 
```

#### 解决方法
没有加载 Intel Math Kernel Library (MKL)，intel/2020 模块（ Intel Parallel Studio XE 2020 或 Intel oneAPI Toolkits 2020 版本中的一个模块化软件） 通常包含 Intel MKL 库。加载这个模块时，MKL 库将可用于你的编译和运行环境中。

``` bash
module load intel/2020
```

## Lammps 接口常见运行时错误

### 环境变量检查

由于未正确加载或者未加载相关环境变量，导致的运行时错误，一般表现为找不到 `lmp_mpi` 或者 `lmp_mpi_gpu` 命令， 或者 一些 `***.so`的动态库缺失。此时请检查下列环境变量是否都已经加载。

``` bash
#1. 用于mpirun 命令
module load intel/2020

#2. 加载conda环境、激活conda虚拟环境
source /the/path/etc/profile.d/conda.sh
conda activate PWMLFF

#3. 加载PWMLFF 环境变量
export PATH=/the/path/to/PWMLFF2024.5/src/bin:$PATH
export PYTHONPATH=/the/path/to/PWMLFF2024.5/src/:$PYTHONPATH

#4. 导入PWMLFF2024.5 的共享库路径
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib

#5. 加载lammps 环境变量
export PATH=/the/path/to/Lammps_for_PWMLFF-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/Lammps_for_PWMLFF-2024.5/src:$LD_LIBRARY_PATH

#6. 运行 GPU lammps 命令
mpirun -np 4 lmp_mpi_gpu -in in.lammps
# 或者运行 CPU lammps 命令
# mpirun -np 32 lmp_mpi -in in.lammps
```

### Lammps dp 模型
#### 错误描述
启动lammps做dp 模型的 md出现如下错误：
```txt
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
lmp_mpi_gpu: symbol lookup error: lmp_mpi_gpu: undefined symbol: _ZN2at4_ops9to_device4callERKNS_6TensorEN3c106DeviceENS5_10ScalarTypeEbbNS5_8optionalINS5_12MemoryFormatEEE
```

#### 解决方法
该错误一般是由于编译 Lammps 时使用的 PWMLFF 动态库与运行lammps时使用的PWMLFF动态库不一致造成的。如果您有多个版本的PWMLFF，请确定运行lammps时使用的PWMLFF环境变量与编译该lammp用到的是同一个。

### Lammps NEP 模型

#### 错误描述

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

#### 解决方法
该错误一般是 MD 运行一段时间后，力场拟合精度下降，导致部分原子的邻居列表变化较大，超过了初始设置的最大邻居数目，调大最大邻居数设置即可。
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