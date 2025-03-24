---
sidebar_position: 1
---
# LINEAR 操作演示

这里，我们以 MatPL [[源码根目录/example/SiC]](https://github.com/LonxunQuantum/MatPL/blob/master/example/SiC/) 为例，演示 Linear 模型的训练、测试、lammps模拟以及其他功能。案例目录结构如下所示。

```txt
SiC
  ├── 1_300_MOVEMENT
  ├── 2_300_MOVEMENT
  ├── atom.config
  ├── linear_test.json
  ├── linear_train.json
  ├── train.job
  ├── linear_lmps
  └── MD
      └── MOVEMENT
```
- linear_train.json 是训练 linear 力场输入参数文件
- linear_train.json 是测试 linear 力场输入参数文件
- train.job 是slurm 提交训练任务例子
- linear_lmps 目录下 为 linear 力场的 lammps md例子
  - 力场文件 forcefield.ff
  - 初始结构 lmp.config 
  - 控制文件 in.lammps
  - runcpu.job slurm 脚本例子

## train 训练

在 SiC 目录下使用如下命令即可开始训练：
**etot.input**输入文件示例：

``` bash
MatPL train linear_train.json
# 或修改环境变量之后通过slurm 提交训练任务 sbatch train.job
```

#### 输入文件解释
nn_train.json 中的内容如下所示，关于 NN 的参数解释，请参考 [NN 参数手册](../../Parameter%20details.md#nn-model)：
```json
{   
    "train_data":["./1_300_MOVEMENT", "./2_300_MOVEMENT"],
    "valid_data":["./1_300_MOVEMENT"],
    "format":"pwmat/movement",
    "model_type": "Linear",
    "atom_type":[14, 6]
}
```
程序运行后，会在程序执行目录下生成`forcefield`目录:

```txt
forcefield
├── forcefield.ff
├── fread_dfeat            
│   ├── energyL*           
│   ├── forceL*            
│   ├── linear*            
│   ├── weight_feat.*      
│   ├── energyL*           
│   ├── ...           
│   ├── feat*          
│   ├── weight_feat.*          
│   └── linear_fitB.ntype     
├── input          
│   └── *feature.in     
└── (output)                     
    └── grid*   # feature 1, 2时使用

```

## test 测试 
``` bash
MatPL test linear_test.json
```
test.json 中的内容如下所示，参数解释请参考 [参数手册](../../Parameter%20details.md)

```json
{   
    "test_movement_file":["./MD/MOVEMENT"],
    "format": "pwmat/movement",
    "model_type": "Linear",
    "atom_type":[14, 6]
}
```
注意，这里MOVEMENT文件必须放在名为 `MD`的目录下面，否则无法识别。
测试结束后的力场文件目录test_result 内容如下：

## lammps MD

Linear 模型的 lammps 接口请参考 [lammps-fortran](https://github.com/LonxunQuantum/lammps-MatPL/blob/fortran/README.md) 安装和使用。

将训练完成后生成的`*.ff`力场文件用于 lammps 模拟。 lammps 的输入文件中设置以下内容：

```bash
pair_style      matpl
pair_coeff      * * 1 1 forcefield.ff 14 6
```

其中`1`表示使用 Linear 模型产生的力场，`1`表示读取 1 个力场文件，`forcefield.ff`为 PWMLFF 生成的力场文件名称，`14` 和 `6` 分别为 Si 和 C 的原子序数
