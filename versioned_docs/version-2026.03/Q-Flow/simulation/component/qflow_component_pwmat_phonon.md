---
sidebar_position: 9
---

# 声子模式计算组件
使用PyPWmat生成位移结构，对每个结构执行PWmat程序JOB = SCF计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：非共振拉曼光谱，红外光谱计算，晶格热导率

## 参数设置

### 基础参数

- [加速卡](../parameters/qflow_parameters_gpu.md)
- [加速卡数](../parameters/qflow_parameters_gpu_number.md)
- [k点并行](../parameters/qflow_parameters_kpara.md)
- [赝势](../parameters/qflow_parameters_pp.md)
- [自旋](../parameters/qflow_parameters_spin.md)
- [泛函](../parameters/qflow_parameters_xcfunctional.md)
- [截断能](../parameters/qflow_parameters_ecut.md)
- [计算类型](../parameters/qflow_parameters_phonon.md)
- [超胞大小](../parameters/qflow_parameters_kmesh_supercell.md)
- [k点网格（超胞）](../parameters/qflow_parameters_kmesh_supercell.md)

### 高级参数

- [DFT+U](../parameters/qflow_parameters_dft+u.md)
- [vdW](../parameters/qflow_parameters_vdw.md)
- [费米展宽](../parameters/qflow_parameters_fermide.md)
- [位移量](../parameters/qflow_parameters_phonon.md)
- [特殊q点路径](../parameters/qflow_parameters_phonon.md)
- [迭代步数设置](../parameters/qflow_parameters_iteration.md)

### 结果处理

- 声子谱
  - 默认值：开
- 零点能：
  - 默认值：关
