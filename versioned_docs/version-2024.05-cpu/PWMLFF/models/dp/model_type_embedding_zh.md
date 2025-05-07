---
sidebar_position: 2
---

# type embedding

由于 DP 模型的 Embedding Net 数目是元素类型数目$N$的$N^2$倍。一方面，当体系中元素类型较多时制约了模型的训练速度，以及推理速度。另一方面，这也制约了 DP 模型在通用大模型方面的潜力。考虑到$N^2$个 Embedding net 其实隐含了对元素类型的编码，因此我们通过调整$S_{ij}$，将元素类型的物理属性信息与$S_{ij}$做拼接，则只需要一个 Embedding net 即可达到与$N^2$相似效果。

对于$S_{ij}$，$i$为中心原子，这里将$j$对应的元素类型的[物理属性](../../Parameter%20details.md#type_physical_property)与$S_{ij}$做拼接，组成一个长度为 1+物理属性数量的 Vector 送入 Embedding Net。在我们[五元合金(钌、铑、铱、钯、镍)数据集](https://github.com/LonxunQuantum/MatPL_library/tree/main/alloy/Ru_Rh_Ir_Pd_Ni)以及[LiGePS 四元数据集(1200K)](https://github.com/LonxunQuantum/MatPL_library/tree/main/LiGePS)的测试中，基于这种 Type embedding 方法的 DP 模型，能够在达到或者超过标准的 DP 模型预测精度的同时，对训练时间减少 27%，详细结果见[性能测试](#type_performance)。

## 使用方法

用户只需要在控制训练的 json 文件中加入$type\_embedding$参数，即可开启模型训练，将使用默认物理属性训练，参见项目案例 **example/LiGePS/ligeps.json**。

```json
{
  "type_embedding": true
}
```

用户也可以在该 Json 文件的 [model 参数](../../Parameter%20details.md#type_physical_property) 中指定所需要的物理属性。

在 Lammps 中的力场调用方式与前述标准的 DP 模型调用方法相同。

## 性能测试{#type_performance}

### 精度

[五元合金混合数据集(9486 个构型)](https://github.com/LonxunQuantum/MatPL_library/tree/main/alloy/Ru_Rh_Ir_Pd_Ni)下，Type embedding 方法相对于标准的 DP 模型在验证集上的预测精度对比:

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/menual_valid_alloy_dp_type_energy_rmse.png").default} alt="menual_valid_alloy_dp_type_energy_rmse" width="400" />
      <p>图1: 五元合金体系验证集上的能量误差下降</p>
    </td>
    <td>
      <img src={require("./picture_wu/manual_train_alloy_dp_type_force_rmse.png").default} alt="manual_train_alloy_dp_type_force_rmse" width="400" />
      <p>图2: 五元合金体系验证集上的力误差下降</p>
    </td>
  </tr>
</table>

[四元 LiGePS 构型的数据集（10000 个构型 1200K）](https://github.com/LonxunQuantum/MatPL_library/tree/main/LiGePS)下 Type embedding 方法相对于标准的 DP 模型在验证集上的预测精度对比:

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/manumal_valid_ligeps_dp_type_energy_rmse.png").default} alt="manumal_valid_ligeps_dp_type_energy_rmse" width="400" />
      <p>图1: 四元LiGePS体系验证集上的能量误差下降</p>
    </td>
    <td>
      <img src={require("./picture_wu/manumal_valid_ligeps_dp_type_force_rmse.png").default} alt="manumal_valid_ligeps_dp_type_force_rmse" width="400" />
      <p>图2: 四元LiGePS体系验证集上的力误差下降</p>
    </td>
  </tr>
</table>

### 训练时间

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/manual_train_alloy_dp_type_time.png").default} alt="manual_train_alloy_dp_type_time" width="400" />
      <p>图1: 五元合金体系训练总时间</p>
    </td>
    <td>
      <img src={require("./picture_wu/manumal_valid_ligeps_dp_type_time.png").default} alt="manumal_valid_ligeps_dp_type_time" width="400" />
      <p>图2: 四元LiGePS体系训练总时间</p>
    </td>
  </tr>
</table>

### 分子动力学时间
