---
sidebar_position: 1
---

# 离线安装

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已做预装，[加载即用](./README.md)

- 对于 GPU 版本，MatPL 离线安装包集成了 MatPL 、 Lammps 接口源码和依赖的Python环境。需要待安装机器提供`gcc 编译器`、`intel编译器套件`（包括`ifort`、`icc` 编译器、`mkl`和`mpi`库），以及 `nvidia GPU` 硬件支持。
 
- 对于 CPU 版本，MatPL 需要待安装机器提供`gcc 编译器`、`intel编译器套件`（包括`ifort`、`icc` 编译器、`mkl`和`mpi`库）即可。

## 1. 下载离线安装包
方法一（推荐）邮件获取，建议您发送邮件到 `wuxingxing@pwmat.com` 或 `support@pwmat.com` 获取离线安装包。相比于百度网盘，通过邮件链接下载的速度更快（几十倍以上）。

方法二 请访问百度网盘下载，链接如果失效请邮件联系 `wuxingxing@pwmat.com` 或`support@pwmat.com`：
👉 [离线安装包下载 MatPL-2025.3.sh.tar.gz](https://pan.baidu.com/s/1JgPdSNAIvmc9HBEaCHG3Gw?pwd=pwmt)，如果安装CPU版本，请选择CPU版本下载。

## 2. 解压安装包

离线安装包内容较大，我们拆分成了多个小文件，解压安装方式如下所示：

### GPU 版本
```bash
# 合并4个文件到1个压缩文件
cat matpl-2025.3.sh.tar.gz.part_aa  matpl-2025.3.sh.tar.gz.part_ab  matpl-2025.3.sh.tar.gz.part_ac  matpl-2025.3.sh.tar.gz.part_ad  matpl-2025.3.sh.tar.gz.part_ae > MatPL-2025.3.sh.tar.gz
# 解压文件
tar -xzvf MatPL.2025.3.sh.tar.gz
```
解压后得到如下文件：
`MatPL-2025.3.sh`， `check_offenv.sh`

### CPU 版本
```bash
# 合并文件到1个压缩文件
cat matpl_cpu-2025.3.sh.tar.gz.part_aa matpl_cpu-2025.3.sh.tar.gz.part_ab matpl_cpu-2025.3.sh.tar.gz.part_ac matpl_cpu-2025.3.sh.tar.gz.part_ad matpl_cpu-2025.3.sh.tar.gz.part_ae  >> MatPL_cpu-2025.3.sh.tar.gz

# 解压文件
tar -xzvf MatPL_cpu-2025.3.sh.tar.gz
```

解压后得到如下文件：
`MatPL_cpu-2025.3.sh`， `check_offenv_cpu.sh`

## 3. 检查编译器版本
### GPU 版本
我们推荐使用 `intel2020`版本，`cuda/11.8`，`gcc 版本 8.n`。
这是因为，MatPL 中使用的`pytorch`版本为`2.0`以上，必须使用 `cuda/11.8`或更高版本。对于 `intel/2020`编译套件，使用了它的 `ifort` 和 `icc` 编译器(`19.1.3`)、`mpi(2019)`、`mkl库(2020)`，如果单独加载，请确保版本不低于它们。

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

第2行查找 MKL 库是否存在，检测到已安装，满足要求；

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

第2行查找 MKL 库是否存在，检测到已安装，满足要求；

第3行输出了 GCC 要求的版本 8.n， 检测到当前的GCC版本是8，满足要求。

CPU 版本不需要 CUDA 和 nvcc 编译器支持。

## 4. 执行安装命令
环境检查完毕后，执行如下命令即可完成安装
```bash
sh MatPL-2025.3.sh [-jN]
# 这里N为并行编译的核数，例如 sh MatPL-2025.3.sh -j4 将采用4核编译。默认采用单核编译，即 sh MatPL-2025.3.sh
```

对于CPU版本，执行如下命令：
```bash
sh MatPL_cpu-2025.3.sh [-jN]
# 这里N为并行编译的核数，例如 sh MatPL_cpu-2025.3.sh -j4 将采用4核编译。默认采用单核编译，即 sh MatPL_cpu-2025.3.sh
```

是否安装成功检查：
编译完成后，MatPL_cpu-2025.3 目录下生成如下目录结构：
```txt
MatPL-2025.3 (或MatPL_cpu-2025.3)
    ├── lammps-2025.3/
    ├── lammps-fortran/
    ├── matpl-2025.3/  (或 matpl_cpu-2025.3)
    ├── MatPL-2025.3/  (或 MatPL_cpu-2025.3)
    ├── matpl-env.sh
    └── matpl-fortran-env.sh

```

- MatPL-2025.3 为机器学习力场训练平台
- matpl-2025.3 为python环境
- lammps-2025.3 为支持 DP 和 NEP 力场的lammps力场接口
- lammps-fortran 为支持 NN 和 Linear 力场的lammps力场接口 
- matpl-env.sh 为 MatPL-2025.3 和 lammps-2025.3 的所有环境变量
- matpl-fortran-env.sh 为 MatPL-2025.3 和 lammps-fortran 的所有环境变量

## 5. 加载使用

MatPL 在使用时需要先加载编译时使用的 intel/2020 和 CUDA （对于GPU版本）。之后执行如下命令 即可完成 python 环境、 MatPL-2025.3 和 lammps 的加载。
```bash
source /the/path/of/MatPL-2025.3/matpl-env.sh
# cpu 版本 source /the/path/of/MatPL_cpu-2025.3/matpl-env.sh
# 对于 fortran 版本的lammps接口：
source /the/path/of/MatPL-2025.3/matpl-fortran-env.sh
```

也可分步骤加载：
```bash
# step1. 加载python环境
source /the/path/MatPL-2025.3/matpl-2025.3/bin/activate
# step2. 加载MatPL-2025.3
source /the/path/MatPL-2025.3/MatPL-2025.3/env.sh
# step3. 加载 lammps
source /the/path/MatPL-2025.3/lammps-2025.3/env.sh
```

