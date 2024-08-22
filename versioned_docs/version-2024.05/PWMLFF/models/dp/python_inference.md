---
sidebar_position: 19
---

# Python inference
我们提供了两种 python inference 方式，一种是直接对结构做预测，使用`infer`命令，如 [章节-预测结构](#预测结构) 所示，第二种是对大量的 pwmlff/npy、vasp/outcar、pwmat/movement 格式或者它们的混合格式做预测，对于这类需求，我们提供了使用 json 配置文件的方式，使用 `test` 命令，如 [章节-混合数据预测](#预测结构) 所示。

## 预测结构
本章节介绍如何使用训练好的模型对`原子结构`进行性质预测。训练好的模型可以用来预测原子结构的性质，如系统的能量、力和应力等。
在模型训练完成后，我们可以得到模型文件，即 `.ckpt` 文件。
然后我们可以执行以下命令来预测新的原子结构的性质：

```bash
PWMLFF infer dp_model.ckpt atom.config pwmat/config
```

其中 `dp_model.ckpt` 是模型文件，`atom.config` 是原子结构文件，`pwmat/config` 是原子结构文件的格式。

这里也支持 `pwmat/movement`、`vasp/poscar`、`vasp/outcar` 以及 `lammps/lmp`、`lammps/dump` 格式，对于`lammps/dump`需要用户指明文件中的元素类型，例如
```
PWMLFF infer dp_model.ckpt lmps.dump lammps/dump Hf O
```
命令执行结束后，将会在命令行直接输出该结构的预测总能、每个原子能量、力以及维里。

## 混合数据预测
本部分介绍如何使用训练好的 DP 模型对大量的 pwmlff/npy、vasp/outcar、pwmat/movement 格式或者它们的混合格式做预测。

用户需要准备如下例子所示的 json 文件，之后使用 `PWMLFF test jsonfile` 命令即可。

```json
{
    "model_type": "DP",
    "atom_type": [28, 44, 45, 46, 77],
    "model_load_file":"dp_model.ckpt",
    "format": "pwmat/movement",
    "raw_files":[
        "movement_0",
        "movement_1"
    ],
    "datasets_path":[
        "PWdata/mvm_files_11",
        "PWdata/mvm_files_12/train",
        "PWdata/mvm_files_13/valid"
    ]
}

```
`model_load_file` 为 训练好的 `dp模型` 所在路径;

`format` 为 `raw_files` 中的结构文件格式;

用户也可以直接在 `datasets_path` 中使用 `pwmlff/npy` 格式的文件所在目录。

例如对于如下的`pwmlff/npy`文件结构，如果用户设置 "datasets_path":['pathA']，那么`train`和`valid`所在目录下的所有结构都会用于推理；如果用户设置 "datasets_path":['pathA/valid']，那么只使用p`athA/valid`下的结构做推理。

您也可以混合使用 `raw_files`、`datasets_path`。
```txt
pathA
    ├──train
    │   └──ei.npy,forces.npy,...
    └──valid
        └──ei.npy,forces.npy,...
```

命令执行结束后，会在当前目录新建一个名称为 `test_result` 的目录，保存推理结果，包含如下文件。
```txt
test_result
    ├──inference_summary.txt
    ├──image_atom_nums.txt
    ├──dft_total_energy.txt
    ├──dft_atomic_energy.txt
    ├──dft_force.txt
    ├──dft_virial.txt
    ├──inference_total_energy.txt
    ├──inference_atomic_energy.txt
    ├──inference_force.txt
    ├──inference_virial.txt
    └──inference_loss.csv
```

inference_summary.txt
保存推理信息汇总，内容如下例所示
```txt
For 200 images: 
Average RMSE of Etot: 0.34629015882102976 
Average RMSE of Etot per atom: 0.0036071891543857267 
Average RMSE of Ei: 1.3401666387065987 
Average RMSE of RMSE_F: 0.03597006701703569 

More details can be found under the file directory:
/the/path/test_result
```

`image_atom_nums.txt` 顺序存储每个结构对应的原子数。

`dft_total_energy.txt` 顺序存储每个结构的能量标签。

`dft_atomic_energy.txt` 顺序存储每个结构中，每个原子的能量标签（该标签为PWmat 独有），每个结构存储为一行。

`dft_force.txt` 顺序存储每个结构中，每个原子的力标签，每行存储该原子的x、y、z三个方向分力。

`inference_total_energy.txt` 顺序存储每个结构的能量推理结果。

`inference_atomic_energy.txt` 顺序存储每个结构中，每个原子的能量推理结果，每个结构存储为一行。

`inference_force.txt` 顺序存储每个结构中，每个原子的力推理结果，每行存储该原子的x、y、z三个方向分力。

`inference_loss.csv` 保存了每个结构的推理结果与标签之间的RMSE值，每列从左到右对应的值为
`img_idx` 代表结构顺序， `RMSE_Etot`、`RMSE_Etot_per_atom`、`RMSE_Ei`、`RMSE_F` 分别代表总量、每个原子能量、力对应的RMSE。
