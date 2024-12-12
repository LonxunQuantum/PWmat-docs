---
sidebar_position: 2
---

# 自洽计算组件
执行PWmat程序JOB = SCF计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：结构优化，自洽计算，原子轨道投影，非自洽计算，振子强度计算，过渡态计算，分子动力学，含时密度泛函计算，声子模式计算，弹性常数计算，密度泛函微扰计算

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

### 高级参数

- [收敛精度](../parameters/qflow_parameters_convergence.md)
- [准确度](../parameters/qflow_parameters_accuracy.md)
- [带电量](../parameters/qflow_parameters_net_charge.md)
- [DFT+U](../parameters/qflow_parameters_dft+u.md)
- [vdW](../parameters/qflow_parameters_vdw.md)
- [费米展宽](../parameters/qflow_parameters_fermide.md)
- [增加空带](../parameters/qflow_parameters_addband.md)
- [时间反演对称性](../parameters/qflow_parameters_symmetry.md)
- [空间对称性](../parameters/qflow_parameters_symmetry.md)
- [对称性精度](../parameters/qflow_parameters_symmetry.md)
- [偶极修正](../parameters/qflow_parameters_dipole.md)
- [迭代步数设置](../parameters/qflow_parameters_iteration.md)
- [溶剂效应](../parameters/qflow_parameters_solvent.md)
- [读取数据](../parameters/qflow_parameters_read_data.md)

### 结果处理
- 可视化电荷密度
  - 默认值：开
- 真空能级
  - 默认值：开
- 电子布居分析
  - 默认值：开
- 电子局域函数
  - 默认值：关
