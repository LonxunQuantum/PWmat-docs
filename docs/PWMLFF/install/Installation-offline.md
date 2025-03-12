---
sidebar_position: 1
---

# 离线安装



MatPL 离线安装包集成了 MatPL 和 Lammps 接口源码和依赖的Python环境。需要待安装机器提供`gcc 编译器`、`intel编译器套件`（包括`ifort`、`icc` 编译器、`mkl`和`mpi`库，以及 `nvidia GPU` 硬件支持。

## 1. 下载离线安装包
方法一（推荐）邮件获取，建议您发送邮件到 `wuxingxing@pwmat.com` 或 `support@pwmat.com` 获取离线安装包。相比于百度网盘，通过邮件链接下载的速度更快（几十倍以上）。

方法二 请访问百度网盘下载，链接如果失效请邮件联系 `wuxingxing@pwmat.com` 或`support@pwmat.com`：
👉 [离线安装包下载 MatPL-2025.3.sh.tar.gz](https://pan.baidu.com/s/1sPB9gBEFJd3q9A__O_wpBQ?pwd=pwmt)

## 2. 解压安装包
离线安装包内容较大，我们拆分成了4个文件，解压安装方式如下所示：
```bash
# 合并4个文件到1个压缩文件
cat MatPL-2025.3.sh.tar.gz.part_aa MatPL-2025.3.sh.tar.gz.part_ab MatPL-2025.3.sh.tar.gz.part_ac MatPL-2025.3.sh.tar.gz.part_ad > MatPL-2025.3.sh.tar.gz
# 解压文件
tar -xzvf MatPL.2025.3.sh.tar.gz
```
解压后得到如下文件：
`MatPL-2025.3.sh`， `check_offenv.sh`

## 3. 检查编译器版本

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

## 4. 执行安装命令
环境检查完毕后，执行如下命令即可完成安装
```bash
sh MatPL-2024.5.sh
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
安装完成之后，会默认将 MatPL-2025.3 环境变量（如下所示）写入 .bashrc 中，如果不需要，请您手动到.bashrc中删除即可。删除后，需要您在每次运行 PWMLFF 前手动导入该环境变量。
```bash
# PWMLFF 环境变量
export PATH=/the/path/to/MatPL-2025.3/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/to/MatPL-2025.3/PWMLFF/src/:$PYTHONPATH
# lammps 接口环境变量
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
export PATH=/the/path/to/MatPL-2025.3/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/to/MatPL-2025.3/lammps-2024.5/src:$LD_LIBRARY_PATH
```

这里 `/the/path/to/`为您自己的安装目录。
:::

## 5. 加载使用

离线包安装成功后，在使用时需要首先激活已安装的conda环境，以及编译时使用的 intel/2020 和 CUDA。之后，如果需要使用 PWMLFF 训练，则加载 PWMLFF 环境变量；如果需要使用 Lammps 接口，则在加载 PWMLFF 环境变量之后继续加载 Lammps 接口环境变量。

### step1. 激活已安装的conda环境
```bash
# 这里环境地址需要完整的路径，例如/data/home/wuxingxing/pack/MatPL-2025.3/pwmlff/bin/activate
source /the/path/MatPL-2025.3/matpl-2025.3/bin/activate
```

### step2. 加载您在编译时使用的 intel编译包以及CUDA
```bash
# 对于 GPU 版本：
module load intel/2020 cuda/11.8-share
```

### step3. 加载 PWMLFF 环境变量

如果您的 ./bashrc (离线安装后会自动写入) 不包含下面的环境变量，请导入该环境变量：
```bash
export PATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/bin:$PATH
export PYTHONPATH=/the/path/PWMLFF_cpu-2024.5/PWMLFF/src/:$PYTHONPATH
```

### step4. 加载 Lammps 接口
如果您的 ./bashrc (离线安装后会自动写入) 不包含下面的环境变量，请导入该环境变量：
```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(python3 -c "import torch; print(torch.__path__[0])")/lib:$(dirname $(dirname $(which python3)))/lib:$(dirname $(dirname $(which PWMLFF)))/op/build/lib
# 对于 GPU 版本 lammps 接口
export PATH=/the/path/MatPL-2025.3/lammps-2024.5/src:$PATH
export LD_LIBRARY_PATH=/the/path/MatPL-2025.3/lammps-2024.5/src:$LD_LIBRARY_PATH
```

### 5. 退出 conda 虚拟环境
您可以直接关闭当前 shell 窗口退出，或者通过如下命令退出虚拟环境
```bash
# 对于 GPU 版本：
source /the/path/MatPL-2025.3/matpl-2025.3/bin/deactivate
```
