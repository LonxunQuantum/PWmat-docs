---
sidebar_position: 2
title: Simple examples
slug: /examples
---

# 示例

源码`example`目录下包含了以下示例：

执行程序可用命令如下：

```bash
PWMLFF train <input_file>
PWMLFF test <input_file>
PWMLFF explore <input_file>
```

其中，`train`表示产生数据集并训练模型，`test`表示测试模型，`explore`表示使用 DP 模型进行探索，用于使用力场模型结合 lammps 实现候选结构探索完成主动学习过程。
另外，`<input_file>`为 json 格式的输入文件，用于指定模型的参数、训练数据集的位置、训练模型的超参数等。

1. Linear

   - [bulk SiC](./Linear/Linear_SiC.md)

2. NN

   - [molecure C3H4O3](./NN/NN_EC.md)

3. DP
   - [bulk Cu](./DP/Cu.md)
   - [bulk Si](./DP/Si.md)

:::tip

Linear model 中需指定 feature type 生成 descriptor，针对实际训练选择需要在 optimizer 中写不同训练组分的 weight；

NN model 与 linear model 相似，需要指定 feature type 生成 descriptor，区别在于增加了 fitting net 与具体的 optimizer(如 Adam, LKF)；

DP model 的 fitting net, optimizer 与 NN model 一致，区别在于 descriptor 通过 embedding net 处理，不需要指定 feature type。

软件提供 vasp/OUTCAR 文件转换为 PWmat/MOVEMENT 文件的工具，使用方法为
`outcar2movement <OUTCAR_file> <MOVEMENT_store_path>`，其中`<OUTCAR_file>`为 vasp 的 OUTCAR 文件，`<MOVEMENT_store_path>`为输出的 MOVEMENT 文件的存储路径。直接运行直接读取当前路径下的 OUTCAR 文件，输出到当前路径下的 MOVEMENT 文件。

:::
