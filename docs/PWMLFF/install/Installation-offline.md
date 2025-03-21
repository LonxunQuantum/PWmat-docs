---
sidebar_position: 1
---

# 离线安装

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已做预装，[加载即用](./README.md)


MatPL 离线安装包集成了 MatPL 、 Lammps 接口源码和依赖的Python环境。需要待安装机器提供`gcc 编译器`、`intel编译器套件`（包括`ifort`、`icc` 编译器、`mkl`和`mpi`库），以及 `nvidia GPU` 硬件支持。
 
## 1. 下载离线安装包
方法一（推荐）邮件获取，建议您发送邮件到 `wuxingxing@pwmat.com` 或 `support@pwmat.com` 获取离线安装包。相比于百度网盘，通过邮件链接下载的速度更快（几十倍以上）。

方法二 请访问百度网盘下载，链接如果失效请邮件联系 `wuxingxing@pwmat.com` 或`support@pwmat.com`：
👉 [离线安装包下载 MatPL-2025.3.sh.tar.gz](https://pan.baidu.com/s/1JgPdSNAIvmc9HBEaCHG3Gw?pwd=pwmt)，如果安装CPU版本，请选择CPU版本下载。

## 2. 解压安装包

离线安装包内容较大，我们拆分成了4个文件，解压安装方式如下所示：

### GPU 版本
```bash
# 合并4个文件到1个压缩文件
cat MatPL-2025.3.sh.tar.gz.part_aa MatPL-2025.3.sh.tar.gz.part_ab MatPL-2025.3.sh.tar.gz.part_ac MatPL-2025.3.sh.tar.gz.part_ad > MatPL-2025.3.sh.tar.gz
# 解压文件
tar -xzvf MatPL.2025.3.sh.tar.gz
```
解压后得到如下文件：
`MatPL-2025.3.sh`， `check_offenv.sh`

### CPU 版本
```bash
# 合并4个文件到1个压缩文件
cat MatPL_cpu-2025.3.sh.tar.gz.part_aa MatPL_cpu-2025.3.sh.tar.gz.part_ab MatPL_cpu-2025.3.sh.tar.gz.part_ac MatPL_cpu-2025.3.sh.tar.gz.part_ad > MatPL_cpu-2025.3.sh.tar.gz
# 解压文件
tar -xzvf MatPL_cpu-2025.3.sh.tar.gz
```

解压后得到如下文件：
`MatPL_cpu-2024.5.sh`， `check_offenv_cpu.sh`

## 3. 检查编译器版本
### GPU 版本
我们推荐使用 `intel2020`版本，`cuda/11.8`，`gcc 版本 8.n`。
这是因为，PWMLFF中使用的`pytorch`版本为`2.0`以上，必须使用 `cuda/11.8`或更高版本。对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。

大部分的安装失败问题都源于编译器的版本不匹配，我们提供了检查编译器版本的脚本`check_offenv.sh` 供用户检查环境，执行如下命令

```bash
sh check_offenv.sh
```

命令执行后会列出需要的编译器版本以及当前检测到的版本，如下是一个正确的环境配置检查结果：

```txt
ifort version is no less than 19.1, current version is 19.1.
MKL library is installed.
GCC version is exactly 8, current version is 8.
CUDA version is 11.8 or higher, current version is 11.8.89.
nvcc command exists.
```

第1行输出了 ifort 编译器要求的版本不低于19.1，检测到当前的版本是19.1，满足要求；

第2行查找 MKF 库是否存在，检测到已安装，满足要求；

第3行输出了 GCC 要求的版本 8.n， 检测到当前的GCC版本是8，满足要求;

第4行检查 CUDA 版本是否不低于11.8，检测到当前的版本是 11.8.89，满足要求；

第5行检查 nvcc 编译器是否存在，检测到存在，满足要求。

### CPU 版本
CPU 离线安装包解压后会得到 `check_offenv_cpu.sh`，执行如下命令
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

## 4. 执行安装命令
环境检查完毕后，执行如下命令即可完成安装
```bash
sh MatPL-2025.3.sh
```

对于CPU版本，执行如下命令：
```bash
sh MatPL_cpu-2025.3.sh
```

安装窗口最后出现如下日志输出，则安装成功。
``` txt
mpicxx -g -O3 -std=c++17 -L/the/path/to/MatPL-2025.3/matpl-2025.3/lib -lpython3.11 -static-libstdc++ -static-libgcc -L/the/path/to/MatPL-2025.3/matpl-2025.3/lib/python3.11/site-packages/torch/lib/ -ltorch -lc10 -ltorch_cpu -L/the/path/to/MatPL-2025.3/lammps-2024.5/src/Obj_mpi/.. -lnep_gpu -L/share/app/cuda/cuda-11.8/lib64 -lcudart -L/the/path/to/MatPL-2025.3/PWMLFF/src/op/build/lib -lCalcOps_bind_cpu main.o      -L. -llammps_mpi      -ldl  -o ../lmp_mpi
size ../lmp_mpi
   text    data     bss     dec     hex filename
11935009          37912   22640 11995561         b709a9 ../lmp_mpi
make[1]: Leaving directory `/the/path/to/MatPL-2025.3/lammps-2024.5/src/Obj_mpi'
CUDA support enabled...
make[1]: Entering directory `/the/path/to/MatPL-2025.3/lammps-2024.5/src/Obj_mpi'
mpicxx -g -O3 -std=c++17 -L/the/path/to/MatPL-2025.3/matpl-2025.3/lib -lpython3.11 -static-libstdc++ -static-libgcc -L/the/path/to/MatPL-2025.3/matpl-2025.3/lib/python3.11/site-packages/torch/lib/ -ltorch -lc10 -ltorch_cpu -L/the/path/to/MatPL-2025.3/lammps-2024.5/src/Obj_mpi/.. -lnep_gpu -L/share/app/cuda/cuda-11.8/lib64 -lcudart -L/the/path/to/MatPL-2025.3/PWMLFF/src/op/build/lib -lCalcOps_bind -L/share/app/cuda/cuda-11.8/lib64 -lcudart main.o      -L. -llammps_mpi      -ldl  -o ../lmp_mpi_gpu
size ../lmp_mpi_gpu
   text    data     bss     dec     hex filename
11936348          37912   22640 11996900         b70ee4 ../lmp_mpi_gpu
make[1]: Leaving directory `/the/path/to/MatPL-2025.3/lammps-2024.5/src/Obj_mpi'
Added Lammps PATH to .bashrc
Added Lammps LD_LIBRARY_PATH to .bashrc
Added torch lib LD_LIBRARY_PATH to .bashrc
Installation completed successfully!
```
:::tip
编译完成后，将在代码的根目录下生成一个env.sh文件，包含 MatPL 和 lammps 接口的环境变量，执行以下命令即可完成对 MatPL 和 lammps 加载
```bash
  source /the/path/of/MatPL-2025.3/env.sh
```
这里 `/the/path/to/`为您自己的安装目录。
:::

## 5. 加载使用

MatPL 在使用时需要先加载编译时使用的 intel/2020 和 CUDA。之后，之后执行如下命令 即可完成 python 环境、 MatPL 和 lammps的加载。
```bash
  source /the/path/of/MatPL-2025.3/env.sh
```

如果需要退出加载的python环境，可以直接关闭当前 shell 窗口，或者通过如下命令退出虚拟环境
```bash
# 对于 GPU 版本：
source /the/path/MatPL-2025.3/matpl-2025.3/bin/deactivate
```
