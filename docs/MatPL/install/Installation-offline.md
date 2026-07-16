---
sidebar_position: 1
title: 离线安装
---
## 离线安装

对于 [龙讯超算云](https://mcloud.lonxun.com/)(`Mcloud`) 用户，已做预装，[加载即用](./README.md)。离线包提供了 GPU 版本。

- 离线安装包集成了 MatPL-2026.3 和 MatPL-2026.3 lammps 接口源码和依赖的Python环境。要求待安装的机器提供 `gcc 编译器(8.n 以及以上)`、`CUDA(11.8及以上)`、`openmpi(4.1.4及以上)` 以及 `nvidia GPU` 硬件支持。`如果需要使用 NN 和 Linear 模型，还需要加载 intel 相关编译器（ifort icc mkl）。`

- 由于 MatPL-2026.3 对纯CPU训练或者模拟没有收益，所以不提供 MatPL-2026.3 CPU 版本的在线或者离线安装包支持。纯CPU用户请使用 [MatPL-2025.3](http://doc.lonxun.com/2025.03/MatPL/install/) 即可。

- 离线安装包中的pytorch 版本为2.2，当前离线包最新版本为 `matpl-2026.3-update2`，相比于updata1，对 NEP 模型 新增了 zbl type wise；对lammps NEP kokkos 在NVIDIA 显卡做了加速，并扩展了lammps kokkos 的6分量 virial 为 9分量，以支持热流计算功能。

<!-- - `离线安装补丁包`：如果已经安装过MatPL-2026.3，后续的更新可以通过我们提供的补丁包安装即可（避免安装耗时、庞大的python执行环境）。补丁包中只包含了更新的代码内容，约6MB左右的，只对有更新的模块做编译，因此安装编译耗时更短。 -->

### 下载离线安装包
方法一（推荐）邮件获取，建议您发送邮件到 `matpl@pwmat.com`、`wuxingxing@pwmat.com` 或 `support@pwmat.com` 获取离线安装包。相比于百度网盘，通过邮件链接下载的速度更快（几十倍以上）。

方法二 请访问百度网盘下载，链接如果失效请邮件联系 `matpl@pwmat.com`、`wuxingxing@pwmat.com` 或 `support@pwmat.com`：
👉 [离线安装包下载](https://pan.baidu.com/s/1dyaLxTKbOIu8JRZB3WvOfQ?pwd=pwmt)，提取码: pwmt。

<!-- 👉 [离线补丁包下载 patch-packages](https://pan.baidu.com/s/1veyMqqX5g0Ie5NEL3xU0Zw?pwd=pwmt)，提取码: pwmt。 -->

方法三 请访问 [Github tag MatPL-2026.3_update2](https://github.com/LonxunQuantum/MatPL/releases/tag/MatPL-2026.3_update2) 下载以下文件：
```txt
matpl-2026.3-update2.sh.tar.gz.part_aa  matpl-2026.3-update2.sh.tar.gz.part_ab  matpl-2026.3-update2.sh.tar.gz.part_ac  matpl-2026.3-update2.sh.tar.gz.part_ad  matpl-2026.3-update2.sh.tar.gz.part_ae
```

### 解压安装包

离线安装包内容较大，我们拆分成了多个小文件，解压安装方式如下所示：

```bash
#合并4个文件到1个压缩文件
cat matpl-2026.3-update2.sh.tar.gz.part_aa  matpl-2026.3-update2.sh.tar.gz.part_ab  matpl-2026.3-update2.sh.tar.gz.part_ac  matpl-2026.3-update2.sh.tar.gz.part_ad  matpl-2026.3-update2.sh.tar.gz.part_ae > matpl-2026.3-update2.sh.tar.gz
#解压文件
tar -xzvf matpl-2026.3-update2.sh.tar.gz
```
解压后得到如下文件：
`matpl-2026.3-update2.sh`， `check_offenv.sh`

<!-- 补丁包不需要解压操作，直接bash 命令安装即可。 -->

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
环境检查完毕后，执行如下命令即可完成安装：

```bash
bash matpl-2026.3-update2.sh [-jN] [-m nn] [-a ARCH] [-d] [-u] [-h]
```

<!-- 如果是补丁包，执行如下命令：
```bash
bash 补丁包名称.sh [-jN] [-m nn] [-a ARCH] [-d] [-u] [-h]
``` -->

- `-jN` 这里 `N` 为并行编译的核数，例如 `bash matpl-2026.3-update2.sh -j4` 将采用 4 核编译。默认采用单核编译。

- `-m nn` 指定后将 Fortran 代码也纳入编译，需要 Intel ifort、icc、MKL 支持，用于 Linear 和 NN 模型。默认不编译 Fortran 代码。

- `-a ARCH` 指定编译 `lammps-2026.3` 时使用的 Kokkos CUDA 架构，默认是 `AMPERE86`。例如：
  ```bash
  bash matpl-2026.3-update2.sh -a AMPERE80
  ```
  `ARCH` 是 Kokkos CUDA architecture suffix，例如 `AMPERE80`、`AMPERE86`、`ADA89`、`HOPPER90`。更多架构说明请参考：https://docs.lammps.org/Build_extras.html#kokkos

- `-d` 开启 `lammps-2026.3` 的 64 位精度 NEP 推理编译选项：
  ```bash
  -DPREC_NEPINFER=ON
  ```
  开启后 `lammps-2026.3` 将编译到 `build-64` 目录；默认不开启，默认编译目录为 `build`。

- `-u` 仅用于解压安装包， 以满足部分用户环境限制只能分步编译安装的情形。解压后是一个 `lammps-2026.3` 源码目录、`MatPL-2026.3` 源码目录和 `matpl-2026.3` Python 环境目录。

是否安装成功检查：

编译完成后，`MatPL-2026.3` 目录下生成如下目录结构：

```txt
MatPL-2026.3
    ├── lammps-2026.3/
    ├── matpl-2026.3/
    ├── MatPL-2026.3/
    └── matpl-env.sh
```

- `MatPL-2026.3` 为机器学习力场训练平台。
- `matpl-2026.3` 为 Python 环境。
- `lammps-2026.3` 为支持 DP 和 NEP 力场的 LAMMPS 力场接口。
- `matpl-env.sh` 为 MatPL-2026.3 和 `lammps-2026.3` 的所有环境变量。

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