---
sidebar_position: 0
---

# Runtime Error
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
