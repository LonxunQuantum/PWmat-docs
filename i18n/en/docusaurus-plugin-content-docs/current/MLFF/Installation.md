# Installation

## On Mcloud

首先加载编译器(以 mcloud 为例)

```
module load gcc/9.3.0 intel/2020u2
export CUDA_HOME=/opt/cuda-11.2
```

然后利用 conda 创建一个新 python 环境

```
conda create -n PWMLFF python=3.8
```

After PWMLFF has been created, re-enter the current environment

```
conda deactivate
conda activate PWMLFF
```

Install the following packages

```
pip install pymatgen scikit-learn-intelex numba tensorboard
# pip uninstall op    # if op has been installed
```

```
conda install pytorch==1.12.1 cudatoolkit=11.6 -c pytorch -c conda-forge
```

Also, make sure your g++ supports C++ 14 standard. Use "g++ -v" to check, and version above 7.0 should be fine. Intel compiler is also required.

然后进入含 GPU 的节点，并申请到 GPU 资源，可通过如下命令确认是否申请到了 GPU

```
python
>> import torch
>> torch.cuda.is_available()
```

返回值为 `True` 则可开始编译。
在 [github 网站](https://github.com/LonxunQuantum/PWmatMLFF) 下载源码后，进入 .`/src` 文件夹并开始编译

```
sh build.sh
```

If the building is successful, modify the following environment variables

```
vim ~/.bashrc
export PATH=absolute/path/to/PWmatMLFF/src/bin:$PATH
export PYTHONPATH=absolute/path/to/PWmatMLFF/src/:$PYTHONPATH
source ~/.bashrc
```

## Lammps

### Linear Model, KFNN, and KFDP¶

MLFF provides an interface for LAMMPS. You should compile LAMMPS from the source code in order to use it. Intel Fortran and C++ compilers are required.

First, obtain LAMMPS's source code and unzip it. Create a directory called **PWMATMLFF** in LAMMPS's **src** directory, and copy all content under **src/md** into **PWMATMLFF**.

```bash
cd path/to/lammps/src/PWMATMLFF
cp path/to/mlff/src/md . -r
```

In src/PWMATMLFF, _remove_ line 118 in the **makefile**:

```bash
\cp main_MD.x ../../bin/
```

which is a stand-alone PWMat MD program.

Run make to compile

```bash
make
```

Now, go back to LAMMPS's **src/** and run

```bash
make yes-pwmatmlff
```

This step tells LAMMPS to include our interface during compiling. After this, copy **src/PWMATMLFF/Makefile.mpi** into **src/MAKE**

```bash
cp /PWMATMLFF/Makefile.mpi /MAKE
```

and make

```bash
make mpi
```

This will generate an executable called **lmp_mpi** in **/src**. You might need to add an environment variable to make this executable visible elsewhere.

```bash
export PATH=/path/to/your/lammps/src/:$PATH
```

### GNN

**If you wish to use GNN for in LAMMPS**, see the page below for guidance.

```bash
https://github.com/mir-group/pair_nequip
```
