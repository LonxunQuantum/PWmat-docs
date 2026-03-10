---
sidebar_position: 8
---

# 含时密度泛函计算组件
执行PWmat程序JOB = TDDFT计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算，分子动力学
- 允许连接的输出组件（successors）：含时密度泛函计算

输入组件连接分子动力学，分子动力学计算结束的最终结构会作为含时密度泛函计算的输入结构，包含速度信息
输入组件连接含时密度泛函计算，暂时无法进行续算。

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
- [模拟步数](../parameters/qflow_parameters_md.md)
- [时间步长](../parameters/qflow_parameters_md.md)
- [初态温度](../parameters/qflow_parameters_md.md)
- [光场](../parameters/qflow_parameters_tddft.md)
- [增加空带](../parameters/qflow_parameters_addband.md)
- [绝热窗口](../parameters/qflow_parameters_tddft.md)
- [含时轨道](../parameters/qflow_parameters_tddft.md)
- [载流子冷却](../parameters/qflow_parameters_tddft.md)

### 高级参数

- [收敛精度](../parameters/qflow_parameters_convergence.md)
- [准确度](../parameters/qflow_parameters_accuracy.md)
- [带电量](../parameters/qflow_parameters_net_charge.md)
- [DFT+U](../parameters/qflow_parameters_dft+u.md)
- [vdW](../parameters/qflow_parameters_vdw.md)
- [费米展宽](../parameters/qflow_parameters_fermide.md)
- [本征值输出间隔](../parameters/qflow_parameters_tddft.md)
- [波函数输出间隔](../parameters/qflow_parameters_tddft.md)
- [迭代步数设置](../parameters/qflow_parameters_iteration.md)
- [读取数据](../parameters/qflow_parameters_read_data.md)
