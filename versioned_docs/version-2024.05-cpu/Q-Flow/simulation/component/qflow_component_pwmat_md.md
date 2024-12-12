---
sidebar_position: 7
---

# 分子动力学组件
执行PWmat程序JOB = MD计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算，分子动力学
- 允许连接的输出组件（successors）：分子动力学，含时密度泛函计算

输入组件连接分子动力学时可以进行分子动力学续算

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
- [系综](../parameters/qflow_parameters_md.md)
- [模拟步数](../parameters/qflow_parameters_md.md)
- [时间步长](../parameters/qflow_parameters_md.md)
- [初态温度](../parameters/qflow_parameters_md.md)
- [末态温度](../parameters/qflow_parameters_md.md)

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
- [迭代步数设置](../parameters/qflow_parameters_iteration.md)
- [读取数据](../parameters//qflow_parameters_read_data.md)

### 结果处理
- 径向分布函数
  - 默认值：开
- 均方位移
  - 默认值：开