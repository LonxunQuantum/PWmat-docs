---
sidebar_position: 10
---

# 弹性常数计算组件
使用ELPWmat生成应变结构，对每个结构执行PWmat程序JOB = RELAX计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：无

## 参数设置

### 基础参数

- [加速卡](../parameters/qflow_parameters_gpu.md)
- [加速卡数](../parameters/qflow_parameters_gpu_number.md)
- [k点并行](../parameters/qflow_parameters_kpara.md)
- [赝势](../parameters/qflow_parameters_pp.md)
- [自旋](../parameters/qflow_parameters_spin.md)
- [泛函](../parameters/qflow_parameters_xcfunctional.md)
- [截断能](../parameters/qflow_parameters_ecut.md)
- [k点网格](../parameters/qflow_parameters_kmesh.md)
- [优化方法](../parameters/qflow_parameters_relax.md)
- [最大优化步数](../parameters/qflow_parameters_relax.md)
- [力收敛标准](../parameters/qflow_parameters_relax.md)

### 高级参数

- [vdW](../parameters/qflow_parameters_vdw.md)
- [费米展宽](../parameters/qflow_parameters_fermide.md)
- [迭代步数设置](../parameters/qflow_parameters_iteration.md)

### 结果处理
- 力学性质
  - 默认值：开
