---
sidebar_position: 1
---

# Installation

## PWMLFF 安装 (以Mcloud为例)
:::tip
PWMLFF包含Fortran、Python和CUDA加速等，需要在包含Python环境、gcc编译器、GPU硬件条件下进行安装
:::

### 方式一：使用Mcloud现有环境
mcloud已有配置好的conda环境，可以直接调用，避免自己安装anaconda, cudatoolkit, pytorch等极度耗时的过程，具体步骤如下：

1. 加载环境
```
module load intel/2020
source /opt/rh/devtoolset-8/enable
source /share/app/anaconda3/etc/profile.d/conda.sh
conda activate mlff
export CUDA_HOME=/share/app/cuda/cuda-11.3
```

2. [下载及编译安装](#%E4%B8%8B%E8%BD%BD%E5%8F%8A%E7%BC%96%E8%AF%91%E5%AE%89%E8%A3%85)

### 方式二：重新创建虚拟环境
1. 首先加载编译PWMLFF所需的编译器(**intel ≥ 2016 , gcc ≥ 7.0**)和cuda (推荐**11.6**) 
```
module load cuda/11.6 intel/2020
source /opt/rh/devtoolset-8/enable
```

2. 在用户目录下创建一个新 python 虚拟环境，建议手动下载并使用Anaconda3进行环境管理（搜索引擎搜索Linux安装anaconda3教程）。

可以使用该命令直接下载Anaconda3到服务器目录中：

```bash
curl https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -o Anaconda3-2023.07-1-Linux-x86_64.sh
```

conda安装完成后，创建虚拟环境，环境中需指定安装python3.8解释器，其它版本可能会出现包依赖冲突，之后的编译工作均在该虚拟环境中进行
```
conda create -n PWMLFF python=3.8
```

3. 虚拟环境安装完成后重新激活该环境
```
conda deactivate
conda activate PWMLFF
```

4. 安装PWMLFF所需的第三方依赖包
```python
pip install pymatgen scikit-learn-intelex numba horovod
```
```python
conda install pytorch==1.12.1 cudatoolkit=11.6 -c pytorch -c conda-forge 
```
  或
```python
conda install pytorch==1.13.1 pytorch-cuda=11.6 -c pytorch -c nvidia
```

如需安装其他版本请查阅[Pytorch官网](https://pytorch.org/get-started/previous-versions/)。

5. 完成第三方依赖包安装后进行PWMLFF的编译安装。
   
### 下载及编译安装



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
    
   * 在线安装:

    ```bash
    $ git clone https://github.com/LonxunQuantum/PWMLFF.git
    或
    $ git clone https://gitee.com/pfsuo/PWMLFF.git

    $ cd PWMLFF/src
    $ srun -p 3090 --gres=gpu:1 sh build.sh
    ```
    
    **(Mstation用户通过`nvidia-smi`可查看到GPU信息，将`srun -p 3090 sh build.sh`替换为`sh build.sh`)**。

    * 源码下载:
      * https://github.com/LonxunQuantum/PWMLFF
      * https://gitee.com/pfsuo/PWMLFF

    或者使用以下命令下载源码到用户目录下并解压安装：
    
    ```bash
    $ wget https://github.com/LonxunQuantum/PWMLFF/archive/refs/heads/master.zip
    或
    $ wget https://gitee.com/pfsuo/PWMLFF/repository/archive/master.zip

    $ unzip master.zip
    $ cd PWMLFF-master/src
    $ srun -p 3090 --gres=gpu:1 sh build.sh
    ```
  
* 编译完成后环境变量需更新，直接执行以下命令：

```bash
source ~/.bashrc
```
至此完成了PWMLFF的全部编译安装，后续使用时也要保证在PWMLFF的虚拟环境中，并加载完成intel编译器。

## Lammps_for_PWMLFF安装

使用PWMLFF完成力场模型构建后需使用配套的Lammps_for_PWMLFF进行分子动力学模拟，以下是Lammps_for_PWMLFF的详细安装步骤：

1. 加载编译所需模块 （以Mcloud为例）
```
module load intel/2020
```

   * 在线安装:

```bash
$ git clone https://github.com/LonxunQuantum/Lammps_for_PWMLFF.git
或
$ git clone https://gitee.com/pfsuo/Lammps_for_PWMLFF.git

$ cd Lammps_for_PWMLFF/lammps_neigh_mlff_20230508/src/PWMATMLFF/fortran_code
$ make clean | make  # 执行编译
$ cd Lammps_for_PWMLFF/lammps_neigh_mlff_20230508/src
$ make clean-all | make mpi -j 6 # 这里如果报编译错误重新执行该指令编译即可
```
    
   * 源码下载:
     * https://github.com/LonxunQuantum/Lammps_for_PWMLFF
     * https://gitee.com/pfsuo/Lammps_for_PWMLFF

    或者使用以下命令下载源码到用户目录下并解压安装：
    
```bash
$ wget https://github.com/LonxunQuantum/Lammps_for_PWMLFF/archive/refs/heads/master.zip
或
$ wget https://gitee.com/pfsuo/Lammps_for_PWMLFF/repository/archive/master.zip

$ unzip master.zip
$ cd Lammps_for_PWMLFF/lammps_neigh_mlff_20230508/src/PWMATMLFF/fortran_code
$ make clean | make  # 执行编译
$ cd Lammps_for_PWMLFF/lammps_neigh_mlff_20230508/src
$ make clean-all | make mpi -j 6 # 这里如果报编译错误重新执行该指令编译即可
```

1. 将Lammps_for_PWMLFF写入环境变量中

```bash
vim ~/.bashrc   
export PATH=absolute/path/to/Lammps_for_PWMLFF/lammps_neigh_mlff_20230508/src:$PATH
source ~/.bashrc
```

以上完成Lammps_for_PWMLFF的全部编译安装工作，后续PWMLFF的使用中会自动调用该版本Lammps包进行分子动力学模拟


----

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
* 第5、6行环境解决 pytorch 与 numpy 版本不匹配的问题
* 最后两行环境解决多lammps任务无法同时并行的问题
  
:::