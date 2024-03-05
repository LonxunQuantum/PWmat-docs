---
sidebar_position: 2
title: Models
slug: /Models
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

   - [bulk SiC](/PWMLFF/models/linear/examples/Linear_SiC)

2. NN

   - [molecure C3H4O3](/PWMLFF/models/nn/examples/NN_EC)

3. DP
   - [bulk Cu](/PWMLFF/models/dp/examples/Cu)

:::tip

Linear model 中需指定 feature type 生成 descriptor，针对实际训练选择需要在 optimizer 中写不同训练组分的 weight；

NN model 与 linear model 相似，需要指定 feature type 生成 descriptor，区别在于增加了 fitting net 与具体的 optimizer(如 Adam, LKF)；

DP model 的 fitting net, optimizer 与 NN model 一致，区别在于 descriptor 通过 embedding net 处理，不需要指定 feature type。

**除此之外，dp model 产生目前有两种力场导出方式，一种是通过`PWMLFF extract_ff`命令导出(程序默认导出, `*.ff`)，另一种是通过`PWMLFF script`命令导出（手动导出，根据使用 gpu/cpu 版本 lammps，`*.pt`）。前者为旧版力场文件，对应需要编译不同的 lammps 版本，该版本与 Linear/NN model 一致。后者为 libtorch 版本，目前仅适用于 DP model。**

:::
