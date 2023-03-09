# PWkit

## 简介

PWkit 主要包含三个模块：Generator、Module、Utility。

- Generator: 根据可选参数（任务类型、泛函设置、赝势设置、特殊设置）, 为 PWmat 生成输入文件。
- Module: 在 PWmat 的基础功能上, 我们针对用户的使用需求开发了一些顶层模块(MODULE)。此部分提供了对各个 Module 的介绍。
- Utility: 为了方便用户进行计算的前、后处理, PWmat 安装包内附带了一系列实用程序。通过这些程序, 我们可以实现 PWmat 结构文件和其他常见晶体结构文件之间的相互转换、处理数据得到可视化电荷密度、能带结构图、投影态密度、真空能级等操作。

## 下载

You can download PWkit from [LongXun github account](https://github.com/LonxunQuantum/).

1. Clone **PWkit** from github

```
$ git clone git@github.com:LonxunQuantum/pwkit.git
```

2. Download a conda environment (**pwkit_env.tar.gz**) for PWkit

```dotnetcli
百度网盘链接：https://pan.baidu.com/s/14JEInTL9WSbLVP3LUqCK-A
提取码：lxkt
```

## 在 MStation 上安装 Pwkit 的方法

We will display how to install `PWkit` on your own PC.

1. Python 的 conda 环境配置

```dotnetcli
# 1. 解压 pwkit_env 的conda环境
   $ mkdir -p pwkit_env
   $ tar -xzf pwkit_env.tar.gz -C pwkit_env

   # 2. 激活 pwkit_env 环境
   $ source pwkit_env/bin/activate
```

2. PWkit 环境变量设置

```dotnetcli
 # 1. 设置环境变量
   (pwkit_env)$ export PWKIT_ROOT=<Your_pwkit_folder_path>
   (pwkit_env)$ PATH=${PWKIT_ROOT}/bin:$PATH

   # 2. 设置Python环境 -- 修改 PYTHON_PATH (自己安装不需要指定 CONDA_PATH)
   (pwkit_env)$ vim pwkit.cfg    # PYTHON_PATH=<your_path>/pwkit_env/bin/python3
```

3. 卸载

```dotnetcli
   # 1. 删除 PWkit 文件夹
   $ rm -rf ${PWKIT_ROOT}

   # 2. 删除 PWkit 的配置文件
   $ rm -rf $HOME/.local/pwkit
```

## 在 MCloud 上使用 PWkit 的方法

```dotnetcli
   # 1. 加载环境
   $ module load pwkit/1.0
   # 2. 运行 PWkit
   $ pwkit
   _ ____      ___ __ ___   __ _| |_
   | '_ \ \ /\ / / '_ ` _ \ / _` | __|  website: http://www.lonxun.com
   | |_) \ V  V /| | | | | | (_| | |_   v1.0.0
   | .__/ \_/\_/ |_| |_| |_|\__,_|\__|  pwmat kit Usage: pwkit -h
   |_|
```

## 使用示例 -- Generator

任务设置：

- 任务类型：自洽计算
- 泛函设置：PBE
- 赝势设置：SG15
- 特殊设置：溶剂效应、自旋极化

Step 1. 加载模块 pwkit/1.0

```dotnetcli
   $ module load pwkit/1.0
```

Step 2. 输入 g 进入 Generator 模块

Step 3. 输入 scpesgspse (不用区分大小写)

Step 4. 输入 KMesh-Resolved value: 0.04

```dotnetcli
   # 1. 输入 g 进入 Generator 模块
   # 2. 输入 scpesgspse (不用区分大小写)
   # 3. 输入 KMesh-Resolved value: 0.04
   $ pwkit
                               _
   _ ____      ___ __ ___   __ _| |_
   | '_ \ \ /\ / / '_ ` _ \ / _` | __|  website: http://www.lonxun.com
   | |_) \ V  V /| | | | | | (_| | |_   v1.0.0
   | .__/ \_/\_/ |_| |_| |_|\__,_|\__|  pwmat kit Usage: pwkit -h
   |_|

   ================================== Generator ===================================
   g) 进入 Input Generator 模块
   为 PWmat 生成输入文件。

   ==================================== Module ====================================
   m) 进入 Module
   在PWmat的基础功能上, 我们针对用户的使用需求开发了一些顶层模块(MODULE)。
   这些MODULE中的一部分是与已有的优秀工具的接口, 一部分是以PWmat的计算结果为基础得
   到实际需要的物理量, 一部分则是为特定的计算需求而设计的计算流程。这些MODULE涵盖了
   物质结构, 基础性质, 针对大体系的计算以及机器学习力场等, 功能全面。

   =================================== Utility ====================================
   u) 进入 Utility
   为了方便用户进行计算的前、后处理, PWmat安装包内附带了一系列实用程序。通过这些程
   序, 我们可以实现PWmat结构文件和其他常见晶体结构文件之间的相互转换、处理数据得到
   可视化电荷密度、能带结构图、投影态密度、真空能级等操作。

   q)  退出
   ------------>>
   g
   ---------------------------------- 任务类型 -----------------------------------
   SC) 自洽计算              CR) 晶格+原子位置优化      AR) 固定晶格优化原子位置
   NS) 非自洽计算            DS) 原子轨道投影（态密度）

   ---------------------------------- 泛函设置 -----------------------------------
   PE) PBE(默认)    91) PW91     PS) PBEsol      LD) CA-PZ       H6) HSE06
   H3) HSE03        P0) PBE0     B3) B3LYP       TP) TPSS        SC) SCAN

   ---------------------------------- 赝势设置 -----------------------------------
   SG) SG15(默认)   PD) PD04      FH) FHI        PW) PWM         UD) 自定义

   ---------------------------------- 特殊设置 -----------------------------------

   SP) 自旋极化    SO) 自旋轨道耦合   SN) 非共线磁矩+自旋轨道耦合    CS) 带电体系
   PU) DFT+U       D3) DFT-D3         FF) 固定电势计算               SE) 溶剂效应

   ---------------------------------- 输入示例 -----------------------------------
   SCH6        CRSPCS


   bb) 返回上一级目录
   q)  退出

   ------------>>
   scpesgspse
   ************************************* 任务设置 *************************************
         1. 任务类型: 自洽计算
         2. 泛函设置: PBE
         3. 赝势设置: SG15
         4. 特殊设置: 溶剂效应、自旋极化
   ************************************************************************************

   当前目录下共有 9 个文件。搜索当前目录是否含有 atom.config 格式的文件...

   +-----------------------------Warm Tips------------------------------+
         * Accuracy Levels: Gamma-Only: 0;
                              Low:        0.06~0.04;
                              Medium:     0.04~0.03
                              Fine:       0.02~0.01
         * 0.03~0.04 is Generally Precise Enough!
   +--------------------------------------------------------------------+
   Input Kmesh-Resolved Value (in Units of 2*PI/Angstrom):
   ------------>>
   0.04
   Part I. 任务类型设置成功...
   Part II. 泛函类型设置成功...
   Part III. 赝势类型设置成功...
   Part IV. 特殊设置成功...
   +-----------------------------Warm Tips------------------------------+
         * 额外需要输出文件IN.SOLVENT (自动生成)
   +--------------------------------------------------------------------+
   Part IV. 特殊设置成功...
```

产生文件 etot.input:

```dotnetcli
   1  4   # 并行设置: 波函数并行设置、K点并行设置，两者之积必须等于GPU总数

   ### 基础设置
   JOB = SCF
   XCFUNCTIONAL = PBE
   ACCURACY = NORMAL
   CONVERGENCE = EASY
   PRECISION = AUTO


   ### 电子自洽设置
   Ecut = 50
   MP_N123 = 2 5 1 0 0 0 0
   SCF_ITER0_1 = 6 4 3 0.0 0.025 1
   SCF_ITER0_2 = 94 4 3 1.0 0.025 1


   ### 特殊设置
   SPIN = 2   # 自旋极化


   ### 其他设置
   #CHARGE_DECOMP = T
   #NUM_BAND = XX
   #SYMM_PREC = 1E-5


   ### 输入输出设置
   IN.ATOM = atom.pwmat
   IN.PSP1 = Ni.SG15.PBE.UPF
   IN.PSP2 = O.SG15.PBE.UPF
   IN.PSP3 = Fe.SG15.PBE.UPF
   IN.PSP4 = Na.SG15.PBE.UPF
   IN.PSP5 = Mn.SG15.PBE.UPF
   IN.PSP6 = Zn.SG15.PBE.UPF
   IN.WG = F
   IN.RHO = F
   IN.VR = F
   IN.KPT = F
   OUT.WG = T
   OUT.RHO = T
   OUT.VR = T
   OUT.VATOM = T
   IN.SOLVENT = T     # 溶剂效应
   OUT.SOLVENT_CHARGE = T     # 溶剂效应
```

## 使用示例 -- Module

查看声子计算的 electron-phonon coupling 模块

Step 1. 加载模块 pwkit/1.0

```dotnetcli
   $ module load pwkit/1.0
```

Step 2. 输入 m 进入 Module 模块

Step 3. 输入 6 （声子计算模块）

Step 4. 输入 4 （electron-phonon coupling (EPC) 模块）

```dotnetcli
   $ pwkit
                               _
   _ ____      ___ __ ___   __ _| |_
   | '_ \ \ /\ / / '_ ` _ \ / _` | __|  website: http://www.lonxun.com
   | |_) \ V  V /| | | | | | (_| | |_   v1.0.0
   | .__/ \_/\_/ |_| |_| |_|\__,_|\__|  pwmat kit Usage: pwkit -h
   |_|

   ================================== Generator ===================================
   g) 进入 Input Generator 模块
   为 PWmat 生成输入文件。

   ==================================== Module ====================================
   m) 进入 Module
   在PWmat的基础功能上, 我们针对用户的使用需求开发了一些顶层模块(MODULE)。
   这些MODULE中的一部分是与已有的优秀工具的接口, 一部分是以PWmat的计算结果为基础得
   到实际需要的物理量, 一部分则是为特定的计算需求而设计的计算流程。这些MODULE涵盖了
   物质结构, 基础性质, 针对大体系的计算以及机器学习力场等, 功能全面。

   =================================== Utility ====================================
   u) 进入 Utility
   为了方便用户进行计算的前、后处理, PWmat安装包内附带了一系列实用程序。通过这些程
   序, 我们可以实现PWmat结构文件和其他常见晶体结构文件之间的相互转换、处理数据得到
   可视化电荷密度、能带结构图、投影态密度、真空能级等操作。

   q)  退出
   ------------>>
   m
   --------------------------- 物质结构 ---------------------------
   1) 结构搜索                2) 无序结构
   3) 分子动力学数据处理      4) CIF 文件转换与结构处理

   ---------------------- 电子结构及声子计算 ----------------------
   5) 电子结构                6) 声子计算

   -------------------- 光、磁、力学和极化性质 --------------------
   7) 光学性质                8) 磁学性质
   9) 力学性质                a) 极化性质

   --------------------------- 其他模块 ---------------------------
   b) 缺陷性质                c) 电化学性质
   d) 输运性质                e) 超快动力学过程
   f) Beyond DFT              g) 电子束辐照分解
   h) 大体系计算              i) 机器学习力场
   j) 其它


   bb) 返回上一级目录
   q)  退出

   ------------>>
   6
   ============================== PWmat 模块 --> 声子计算 ===============================
   1) PyPWmat
   2) High temperature phonon calculation
   3) PWphono3py
   4) electron-phonon coupling (EPC)

   bb) 返回上一级目录
   q)  退出

   ------------>>
   4
   ==================================================================== Module --> electron-phonon coupling (EPC) =====================================================================
   1.模块简介
   ----------
   使用瓦尼尔函数（wannier functions, WFs）计算电声耦合矩阵。

   2.使用手册
   ----------
   http://www.pwmat.com:3389/pwmat-resource/module-download7/pdf/guide_EPC.pdf

   bb) 返回上一级目录
   q)  退出
   ------------>>
```

## 使用示例 -- Utility

查看数据可视化的 plot_DOS.py 工具

Step 1. 加载模块 pwkit/1.0

```dotnetcli
   $ module load pwkit/1.0
```

Step 2. 输入 u 进入 Utility 模块

Step 3. 输入 2 （plot_DOS.py）

```dotnetcli
   $ pwkit
                               _
   _ ____      ___ __ ___   __ _| |_
   | '_ \ \ /\ / / '_ ` _ \ / _` | __|  website: http://www.lonxun.com
   | |_) \ V  V /| | | | | | (_| | |_   v1.0.0
   | .__/ \_/\_/ |_| |_| |_|\__,_|\__|  pwmat kit Usage: pwkit -h
   |_|

   ================================== Generator ===================================
   g) 进入 Input Generator 模块
   为 PWmat 生成输入文件。

   ==================================== Module ====================================
   m) 进入 Module
   在PWmat的基础功能上, 我们针对用户的使用需求开发了一些顶层模块(MODULE)。
   这些MODULE中的一部分是与已有的优秀工具的接口, 一部分是以PWmat的计算结果为基础得
   到实际需要的物理量, 一部分则是为特定的计算需求而设计的计算流程。这些MODULE涵盖了
   物质结构, 基础性质, 针对大体系的计算以及机器学习力场等, 功能全面。

   =================================== Utility ====================================
   u) 进入 Utility 
   为了方便用户进行计算的前、后处理, PWmat安装包内附带了一系列实用程序。通过这些程
   序, 我们可以实现PWmat结构文件和其他常见晶体结构文件之间的相互转换、处理数据得到
   可视化电荷密度、能带结构图、投影态密度、真空能级等操作。

   q)  退出
   ------------>> 
   u
   --------------------- Utility---------------------
   1) 格式转换      2) 数据可视化      
   3) 数据后处理    4) 其它

   bb) 返回上一级目录
   q)  退出
   ------------>>
   2
   -------------------------- 数据可视化 ---------------------------
   1) plot_band_structure.x            2) plot_DOS.py
   3) absorption_spec_K2step.x         4) plot_wg.x
   5) plot_DOS_interp.x                6) plot_ABSORB_interp.x
   7) plot_TDDFT.x                     8) plot_fatband_structure.x
   9) plot_electrical_conductivity.x   a) plot_TDDFT_allk.x
   b) plot_TDDFT_rho.x

   bb) 返回上一级目录
   q)  退出
   ------------>>  
   2
   ============================================================================= Utility --> plot_DOS.py ==============================================================================
   1.工具简介
   ----------
   用于画态密度

   2.使用手册
   ----------
   http://www.pwmat.com:8080/upload/utility/pdf/plot_DOS.pdf

   bb) 返回上一级目录
   q)  退出
   ------------>>  
```
