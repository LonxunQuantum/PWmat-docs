# Installation

## On Mcloud

```bash
module load intel/2020
module load cuda/11.6
module load mkl/2022.0.2
module load mpi/2021.5.1
source /opt/rh/devtoolset-8/enable
```

Install the conda environment first. To install, use the following command. You may choose a new version of Anaconda. 

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh
```    

Then, create a new environment for this module. We recommend using Python 3.8.  

```bash
conda create -n mlff python=3.8
``` 

After mlff has been created, re-enter the current environment.
        
```bash
conda deactivate
conda activate mlff
```

国内用户可以使用清华镜像源，安装速度快。

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --set show_channel_urls yes
```
    
After this, install the following packages. 

```bash
conda install pandas
conda install matplotlib
conda install scikit-learn-intelex
conda install numba         
conda install tensorboard
conda install -c conda-forge/label/cf202003 dpdata
conda install git 
conda install --channel conda-forge pymatgen
pip install horovod==0.27.0
```

**If you wish to use the GNN model**, also clone and install the following package, in accordance with the steps given within 

```bash
git clone https://github.com/mir-group/nequip.git
```
    
Next, check if your CUDA version is **11.3**. If not, update to or install CUDA 11.3. Install pytorch with the following command 

```bash
conda install pytorch==1.11.0 cudatoolkit=11.3 -c pytorch
```

Also, make sure your g++ supports **C++ 14** standard. Use "g++ -v" to check, and version above 7.0 should be fine. Intel compiler is also required. 


Enter **/src** and start building with

```bash
sh build.sh
```
    
If the building is successful, modify the following environment variables

```bash
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

In src/PWMATMLFF, *remove* line 118 in the **makefile**:

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
    