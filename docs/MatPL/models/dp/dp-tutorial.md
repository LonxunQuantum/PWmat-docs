---
sidebar_position: 1
---
# DP 操作演示

这里，我们以 MatPL [[源码根目录/example/HfO2/dp_demo]](https://github.com/LonxunQuantum/MatPL/blob/master/example/HfO2/dp_demo/) 为例（[HfO2 训练集来源](https://www.aissquare.com/datasets/detail?pageType=datasets&name=HfO2-dpgen&id=6)），演示 DP 模型的训练、测试、lammps模拟以及其他功能。案例目录结构如下所示。

``` txt
HfO2/
├── atom.config
├── pwdata/
└── dp_demo/
    ├── dp_test.json
    ├── dp_train.json
    ├── train.job
    └── dp_lmps/
        ├── in.lammps
        ├── lmp.config
        ├── jit_dp.pt
        ├── runcpu.job
        └── rungpu.job
```
- pwdata 目录为训练数据目录
- dp_train.json 是训练 DP 力场输入参数文件
- dp_train.json 是测试 DP 力场输入参数文件
- train.job 是slurm 提交训练任务例子
- dp_lmps 目录下 为 DP 力场的 lammps md例子
  - 力场文件 jit_dp.pt
  - 初始结构 lmp.config 
  - 控制文件 in.lammps
  - runcpu.job 和 rungpu.job 是 slurm 脚本例子

## train 训练
在 dp_demo 目录下使用如下命令即可开始训练：
``` bash
MatPL train dp_train.json
# 或修改环境变量之后通过slurm 提交训练任务 sbatch train.job
```
#### 输入文件解释
dp_train.json 中的内容如下所示，关于 DP 的参数解释，请参考 [DP 参数手册](../../Parameter%20details.md#dp-model)：

```json
{
    "model_type": "DP",
    "atom_type": [
        8, 72
    ],
    "format": "pwmlff/npy",
    "train_data": [
        "../pwdata/init_000_50/", "../pwdata/init_002_50/", 
        "../pwdata/init_004_50/", "../pwdata/init_006_50/", 
        "../pwdata/init_008_50/", "../pwdata/init_010_50/", 
        "../pwdata/init_012_50/", "../pwdata/init_014_50/", 
        "../pwdata/init_016_50/", "../pwdata/init_018_50/", 
        "../pwdata/init_020_20/", "../pwdata/init_022_20/", 
        "../pwdata/init_024_20/", "../pwdata/init_026_20/", 
        "../pwdata/init_001_50/", "../pwdata/init_003_50/", 
        "../pwdata/init_005_50/", "../pwdata/init_007_50/", 
        "../pwdata/init_009_50/", "../pwdata/init_011_50/", 
        "../pwdata/init_013_50/", "../pwdata/init_015_30/", 
        "../pwdata/init_017_50/", "../pwdata/init_019_50/", 
        "../pwdata/init_021_20/", "../pwdata/init_023_20/", 
        "../pwdata/init_025_20/", "../pwdata/init_027_20/"
    ],
    "valid_data":[
        "../pwdata/init_000_50/", "../pwdata/init_004_50/", 
        "../pwdata/init_008_50/"       
    ]
}
```

训练结束后的力场文件目录请参考 [model_record 详解](../../matpl-cmd.md#train-文件目录)


## test 测试 
``` bash
MatPL test dp_test.json
```
test.json 中的内容如下所示，参数解释请参考 [参数手册](../../Parameter%20details.md)
``` json
{
    "model_type": "DP",
    "format": "pwmlff/npy",
    "model_load_file": "./model_record/dp_model.ckpt",
    "test_data": [
        "../init_000_50", "../init_004_50", "../init_008_50", 
        "../init_012_50", "../init_016_50", "../init_020_20", 
        "../init_024_20", "../init_001_50", "../init_005_50", 
        "../init_009_50", "../init_013_50", "../init_017_50", 
        "../init_021_20", "../init_025_20", "../init_002_50", 
        "../init_006_50", "../init_010_50", "../init_014_50", 
        "../init_018_50", "../init_022_20", "../init_026_20", 
        "../init_003_50", "../init_007_50", "../init_011_50", 
        "../init_015_30", "../init_019_50", "../init_023_20", 
        "../init_027_20"
    ]
}
```
测试结束后的力场文件目录请参考 [test_result 详解](../../matpl-cmd.md#test-文件目录)

## infer 推理单结构
``` bash
MatPL infer dp_model.ckpt atom.config pwmat/config
MatPL infer dp_model.ckpt 0.lammpstrj lammps/dump Hf O
# Hf O 为 lammps/dump格式的结构中的元素名称，Hf为结构中1号元素类型，O为元素中2号元素类型
```
推理成功后，将在窗口输出推理的总能、每原子能量、每原子受力和维里

## compress 模型压缩
对于一个训练后 DP 力场做模型压缩，完整的模型压缩指令如下：

```json
MatPL compress dp_model.ckpt -d 0.01 -o 3 -s cmp_dp_model
```
- compress 是压缩命令
- dp_model.ckpt为待压缩模型文件名称，为必须要提供的参数
- -d 为S_ij 的网格划分大小，默认值为0.01
- -o 为模型压缩阶数，3为三阶模型压缩，5为五阶模型压缩，默认值为3
- -s 为压缩后的模型名称，默认名称为“cmp_dp_model”

压缩后，将在当前目录得到一个名称为`cmp_dp_model.ckpt`的力场文件。

## script 转 MD 力场
本命令用于将 dp_model.ckpt 文件转换为 lammps中可识别的 libtorch 格式。
```bash
MatPL script dp_model.ckpt
# 或转换经过模型压缩后的力场
MatPL script cmp_dp_model.ckpt
```
转换后将在当前目录下生成一个 `jit_dp.pt`文件，改文件可用于后续的 lammps md。

## lammps MD

### step1. 准备力场文件
将训练完成后生成的`dp_model.ckpt`力场文件用于 lammps 模拟，您需要
提取力场文件，您只需要输入如下命令
```
MatPL script dp_model.ckpt
```
转换成功之后，将得到一个力场文件`jit_dp.pt`。

### step2. 准备输入控制文件
您需要在lammps的输入控制文件中设置如下力场，这里以HfO2为例（[`HfO2/dp_demo/dp_lmps`](https://github.com/LonxunQuantum/MatPL/blob/master/example/HfO2/dp_demo/dp_lmps)

``` bash
pair_style   matpl   jit_dp.pt 
pair_coeff   * *     8 72
```

其中：
- pair_style 设置力场文件路径，这里 `matpl` 为固定格式，代表使用MatPL中力场，`jit_dp.pt`为力场文件路径

  这里也支持多模型的偏差值输出，该功能一般用于主动学习采用中。您可以指定多个模型，在模拟中将使用第1个模型做MD，其他模型参与偏差值计算，例如例子中所示，此时pair_style设置为如下:
  ```txt
  pair_style   matpl   0_jit_dp.pt 1_jit_dp.pt 2_jit_dp.pt 3_jit_dp.pt  out_freq ${DUMP_FREQ} out_file model_devi.out 
  pair_coeff   * *     8 72
  ```

- pair_coeff 指定待模拟结构中的原子类型对应的原子序号。例如，如果您的结构中 `1` 为 `O` 元素，`2` 为 `Hf` 元素，设置 `pair_coeff * * 8 72`即可。

### step3 启动lammps模拟

``` bash
# 加载 lammps 环境变量env.sh 文件，正确安装后，该文件位于 lammps 源码根目录下
source /the/path/of/lammps/env.sh
# 执行lammps命令
mpirun -np N lmp_mpi -in in.lammps
```
这里 N 为md中的使用的 CPU 核数，如果您的设备中存在可用的GPU资源（例如 M 张GPU卡）,则在运行中，N个lammps线程将平均分配到这M张卡上。我们建议您使用的 CPU 核数与您设置的 GPU 数量相同，多个线程在单个 GPU 上会由于资源竞争导致运行速度降低。

此外，lammps 接口允许跨节点以及跨节点GPU卡并行，只需要指定节点数、GPU卡数即可。

## ASE 接口
DP 模型提供了 ase 接口，使用方式如下脚本例子所示[gitee](https://gitee.com/pfsuo/MatPL/tree/main/example/ase_calculator/test_dp) 或 [github](https://github.com/LonxunQuantum/MatPL/tree/main/example/ase_calculator/test_dp)。 

```python
from src.ase.calculate import MatPL_calculator
calc = MatPL(model_file='dp_model.ckpt')
atoms = ..... # create ase.atoms.Atoms
atoms.calc = calc # or atoms.set_calculator(calc)
energy = atoms.get_potential_energy()
forces = atoms.get_forces()
stress = atoms.get_stress()
```
注意，在使用本ase接口时确保已经导入了[MatPL的环境变量](../../install/README.md)。