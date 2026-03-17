---
sidebar_position: 1
title: 离线安装
---
## 离线安装

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已做预装，[加载即用](./README.md)。离线包提供了 GPU 版本。

- 离线安装包集成了 MatPL-2026.3 和 MatPL-2026.3 lammps 接口源码和依赖的Python环境。要求待安装的机器提供 `gcc 编译器(8.n 以及以上)`、`CUDA(11.8及以上)`、`openmpi(4.1.4及以上)` 以及 `nvidia GPU` 硬件支持。`如果需要使用 NN 和 Linear 模型，还需要加载 intel 相关编译器（ifort icc mkl）。`

- 由于 MatPL-2026.3 对纯CPU训练或者模拟没有收益，所以不提供 MatPL-2026.3 CPU 版本的在线或者离线安装包支持。纯CPU用户请使用 [MatPL-2025.3](http://doc.lonxun.com/2025.3/) 即可。


### 下载离线安装包
方法一（推荐）邮件获取，建议您发送邮件到 `matpl@pwmat.com`、`wuxingxing@pwmat.com` 或 `support@pwmat.com` 获取离线安装包。相比于百度网盘，通过邮件链接下载的速度更快（几十倍以上）。

方法二 请访问百度网盘下载，链接如果失效请邮件联系 `matpl@pwmat.com`、`wuxingxing@pwmat.com` 或 `support@pwmat.com`：
👉 [离线安装包下载 MatPL-2026.3.sh.tar.gz](https://pan.baidu.com/s/1dyaLxTKbOIu8JRZB3WvOfQ?pwd=pwmt)，提取码: pwmt。

### 解压安装包

离线安装包内容较大，我们拆分成了多个小文件，解压安装方式如下所示：

```bash
#合并4个文件到1个压缩文件
cat matpl-2026.3.sh.tar.gz.part_aa  matpl-2026.3.sh.tar.gz.part_ab  matpl-2026.3.sh.tar.gz.part_ac  matpl-2026.3.sh.tar.gz.part_ad  matpl-2026.3.sh.tar.gz.part_ae > MatPL-2026.3.sh.tar.gz
#解压文件
tar -xzvf MatPL-2026.3.sh.tar.gz
```
解压后得到如下文件：
`MatPL-2026.3.sh`， `check_offenv.sh`

### 检查编译器版本

大部分的安装失败问题都源于编译器的版本不匹配，我们提供了检查编译器版本的脚本`check_offenv.sh` 供用户检查环境，执行如下命令

```bash
bash check_offenv.sh
```

命令执行后会列出需要的编译器版本以及当前检测到的版本，如下是一个正确的环境配置检查结果：

```txt
========================================
      Environment Check Starting
========================================

=== Checking ifort compiler and MKL library ===
✓ ifort version: 19.1 (>= 19.1)
✓ MKL library is installed

=== Checking GCC version ===
✓ GCC version: 8 (>= 8.0)

=== Checking CUDA version ===
✓ CUDA version: 11.8.89 (>= 11.8)

=== Checking nvcc availability ===
✓ nvcc command exists

=== Checking OpenMPI ===
✓ OpenMPI found (via ompi_info), version: 4.1.6
✓ OpenMPI version meets requirement (>= 4.0)

========================================
        Environment Summary
========================================
✓ Environment check completed. All requirements are satisfied.
========================================
```

### 执行安装命令
环境检查完毕后，执行如下命令即可完成安装
```bash
bash matpl-2026.3.sh [-jN] [-m nn] [-u] [-h]
```

- -jN 这里N为并行编译的核数，例如 bash build.sh -j4 将采用4核编译。默认采用单核编译，即 bash build.sh

- -m nn 指定后将 fortran 代码也纳入编译（需要intel ifort icc mkl 支持），用于 linear 和 NN 模型。默认不编译 fortran 代码

- -u 用于解压安装包，解压后是一个lammps的源码目录、MatPL-2026.3源码目录和matpl-2026.3 python环境目录

是否安装成功检查：
编译完成后，MatPL-2026.3 目录下生成如下目录结构：
```txt
MatPL-2026.3
    ├── lammps-2026.3/
    ├── lammps-fortran/
    ├── matpl-2026.3/
    ├── MatPL-2026.3/
    ├── matpl-env.sh
    └── matpl-fortran-env.sh
```

- MatPL-2026.3 为机器学习力场训练平台
- matpl-2026.3 为python环境
- lammps-2026.3 为支持 DP 和 NEP 力场的lammps力场接口
- lammps-fortran 为支持 NN 和 Linear 力场的lammps力场接口 
- matpl-env.sh 为 MatPL-2026.3 和 lammps-2026.3 的所有环境变量
- matpl-fortran-env.sh 为 MatPL-2026.3 和 lammps-fortran 的所有环境变量

### 加载使用

MatPL 在使用时需要先加载编译时使用的 CUDA （对于GPU版本），如果训练 NN 或 Linear 还需要加载 mkl库。之后执行如下命令 即可完成 python 环境、 MatPL-2026.3 和 lammps 的加载。
```bash
source /the/path/of/MatPL-2026.3/matpl-env.sh

#对于 fortran 版本的lammps接口：
source /the/path/of/MatPL-2026.3/matpl-fortran-env.sh
```

也可分步骤加载：
```bash
## step1. 加载python环境
source /the/path/MatPL-2026.3/matpl-2026.3/bin/activate
## step2. 加载MatPL-2026.3
source /the/path/MatPL-2026.3/MatPL-2026.3/env.sh
## step3. 加载 lammps
source /the/path/MatPL-2026.3/lammps-2026.3/env.sh
```

<!-- MatPL 相关软件的常见 [安装错误](./InstallError.md) 和 [运行时错误](./RuntimeError.md)  -->