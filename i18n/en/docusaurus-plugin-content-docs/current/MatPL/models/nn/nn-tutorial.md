---
sidebar_position: 1
---
# NN 操作演示

这里，我们以 MatPL [[源码根目录/example/Cu/nn_demo]](https://github.com/LonxunQuantum/MatPL/blob/master/example/Cu/nn_demo/) 为例，演示 NN 模型的训练、测试、lammps 模拟以及其他功能。案例目录结构如下所示。

``` txt
Cu/nn_demo
    ├── nn_test.json
    ├── nn_train.json
    ├── train.job
    └── nn_lmps/
        ├── in.lammps
        ├── lmp.config
        ├── forcefield.ff 
        └── runcpu.job
```
- nn_train.json 是训练 NN 力场输入参数文件
- nn_test.json 是测试 NN 力场输入参数文件
- train.job 是slurm 提交训练任务例子
- nn_lmps 目录下 为 NN 力场的 lammps md例子
  - 力场文件 forcefield.ff
  - 初始结构 lmp.config 
  - 控制文件 in.lammps
  - runcpu.job slurm 脚本例子

## train 训练
在 nn_demo 目录下使用如下命令即可开始训练：
``` bash
MatPL train nn_train.json
# 或修改环境变量之后通过slurm 提交训练任务 sbatch train.job
```
#### 输入文件解释
nn_train.json 中的内容如下所示，关于 NN 的参数解释，请参考 [NN 参数手册](../../Parameter%20details.md#nn-model)：
```json
{   
    "format":"pwmat/movement",
    "train_data":["0_300_MOVEMENT", "1_500_MOVEMENT"],
    "valid_data":["valid_movement"],
    "model_type": "NN",
    "atom_type":[29]
}
```
训练结束后的力场文件目录请参考 [model_record 详解](../../matpl-cmd.md#train-文件目录)

## test 测试 
``` bash
MatPL test nn_test.json
```
test.json 中的内容如下所示，参数解释请参考 [参数手册](../../Parameter%20details.md)
``` json
{   
    "format":"pwmat/movement",
    "test_data":["0_300_MOVEMENT", "1_500_MOVEMENT"],
    "model_type": "NN",
    "model_load_file":"./model_record/nn_model.ckpt"
}
```
测试结束后的力场文件目录请参考 [test_result 详解](../../matpl-cmd.md#test-文件目录)

## extract_ff
在训练结束后的 model_record 目录下，提取 nn_model.ckpt 文件
```bash
# 提取nn力场模型
MatPL extract_ff nn_model.ckpt
```
力场提取后，将得到一个 forcefield 目录，目录结构如下所示，该目录下的其他文件为描述符相关信息。
``` txt 
forcefield
  ├──fread_dfeat/
  ├──input/
  ├──output/
  └──forcefield.ff
```

## lammps MD

NN 模型的 lammps 接口请参考 [lammps-fortran](https://github.com/LonxunQuantum/lammps-MatPL/blob/fortran/README.md) 安装和使用。

将训练完成后生成的`*.ff`力场文件用于 lammps 模拟。 lammps 的输入文件中设置以下内容：

```bash
pair_style      matpl
pair_coeff      * * 3 1 forcefield.ff 29
```

其中`3`表示使用 NN 模型产生的力场，`1`表示读取 1 个力场文件，`forcefield.ff`为 MatPL 生成的力场文件名称，`29` 为 铜 原子序数
