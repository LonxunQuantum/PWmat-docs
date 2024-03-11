---
sidebar_position: 2
---

# type embedding

Since the Embedding Net of the DP model is $N^2$ times the number of element types $N$, it poses limitations on both the training and inference speed when there are a large number of element types in the system. Additionally, this also restricts the potential of the DP model in terms of scalability to larger models. Considering that the $N^2$ Embedding nets implicitly encode information about the element types, we can achieve similar effects by adjusting $S_{ij}$ and concatenating the physical property information of the element types with $S_{ij}$. This way, we only need a single Embedding Net instead of $N^2$.

For $S_{ij}$, where $i$ represents the central atom, we concatenate the [physical properties](/en/next/PWMLFF/Parameter%20details#type_physical_property) of the element type corresponding to $j$ with $S_{ij}$ to form a vector of length 1 plus the number of physical properties. This vector is then fed into the Embedding Net. In our testing on the [quinary alloy(Ru, Rh, Ir, Pd, Ni) dataset](https://github.com/LonxunQuantum/PWMLFF_library/tree/main/alloy/Ru_Rh_Ir_Pd_Ni) and the [LiGePS quaternary dataset](https://github.com/LonxunQuantum/PWMLFF_library/tree/main/LiGePS), the DP model based on this type embedding method achieved or exceeded the standard DP model's prediction accuracy while reducing training time by 27%. For detailed results, please refer to the [performance test](#type_performance).

## 使用方法

To initiate model training with the default physical properties, the user can include the $type\_embedding$ parameter in the JSON file used for training. Please refer to the project example **example/LiGePS/ligeps.json** for more details.

```json
{
  "type_embedding": true
}
```

You can also specify the desired [physical properties](/en/next/PWMLFF/Parameter%20details#type_physical_property) in the **model parameter** of the JSON file.

The force field calling method in Lammps is the same as the standard DP model calling method mentioned earlier.

## Performance test{#type_performance}

### Accuracy

Comparison of prediction accuracy between Type embedding method and the standard DP model on the validation set of a [quinary alloy mixed dataset](https://github.com/LonxunQuantum/PWMLFF_library/tree/main/alloy/Ru_Rh_Ir_Pd_Ni) (containing 9486 configurations with different atom types)

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/menual_valid_alloy_dp_type_energy_rmse.png").default} alt="menual_valid_alloy_dp_type_energy_rmse" width="400" />
      <p>Fig 1. Energy error reduction on the validation set of the five element alloy system </p>
    </td>
    <td>
      <img src={require("./picture_wu/manual_train_alloy_dp_type_force_rmse.png").default} alt="manual_train_alloy_dp_type_force_rmse" width="400" />
      <p>Fig 2. Force error reduction on the validation set of the five element alloy system</p>
    </td>
  </tr>
</table>

Comparison of prediction accuracy between Type embedding method and the standard DP model on the validation set of a quaternary [LiGePS configurations](https://github.com/LonxunQuantum/PWMLFF_library/tree/main/LiGePS) (consisting of 10,000 configurations at 1200K)

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/manumal_valid_ligeps_dp_type_energy_rmse.png").default} alt="manumal_valid_ligeps_dp_type_energy_rmse" width="400" />
      <p>Fig 1. Energy error reduction on the validation set of the five element alloy system</p>
    </td>
    <td>
      <img src={require("./picture_wu/manumal_valid_ligeps_dp_type_force_rmse.png").default} alt="manumal_valid_ligeps_dp_type_force_rmse" width="400" />
      <p>Fig 2. Force error reduction on the validation set of the quaternary LiGePS system</p>
    </td>
  </tr>
</table>

### Training time

<table>
  <tr>
    <td>
      <img src={require("./picture_wu/manual_train_alloy_dp_type_time.png").default} alt="manual_train_alloy_dp_type_time" width="400" />
      <p>Fig 1. Total training time for the five element alloy system</p>
    </td>
    <td>
      <img src={require("./picture_wu/manumal_valid_ligeps_dp_type_time.png").default} alt="manumal_valid_ligeps_dp_type_time" width="400" />
      <p>Fig 2. Total training time for the quaternary LiGePS system</p>
    </td>
  </tr>
</table>

### Molecular dynamics time

(To be supplemented...)