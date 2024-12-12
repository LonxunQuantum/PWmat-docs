---
sidebar_position: 2
---

# 自洽计算组件
执行PWmat程序JOB = SCF计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：结构优化，自洽计算，原子轨道投影，非自洽计算，振子强度计算，过渡态计算，分子动力学，含时密度泛函计算，声子模式计算，弹性常数计算，密度泛函微扰计算

## 参数设置

### 基础参数

- [加速卡](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu/)
- [加速卡数](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu_number/)
- [k点并行](/next/Q-Flow/模拟/计算参数/qflow_parameters_kpara/)
- [赝势](/next/Q-Flow/模拟/计算参数/qflow_parameters_pp/)
- [自旋](/next/Q-Flow/模拟/计算参数/qflow_parameters_spin/)
- [泛函](/next/Q-Flow/模拟/计算参数/qflow_parameters_xcfunctional/)
- [截断能](/next/Q-Flow/模拟/计算参数/qflow_parameters_ecut/)
- [k点网格](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh/)

### 高级参数

- [收敛精度](/next/Q-Flow/模拟/计算参数/qflow_parameters_convergence/)
- [准确度](/next/Q-Flow/模拟/计算参数/qflow_parameters_accuracy/)
- [带电量](/next/Q-Flow/模拟/计算参数/qflow_parameters_net_charge/)
- [DFT+U](/next/Q-Flow/模拟/计算参数/qflow_parameters_dft+u/)
- [vdW](/next/Q-Flow/模拟/计算参数/qflow_parameters_vdw/)
- [费米展宽](/next/Q-Flow/模拟/计算参数/qflow_parameters_fermide/)
- [增加空带](/next/Q-Flow/模拟/计算参数/qflow_parameters_addband/)
- [时间反演对称性](/next/Q-Flow/模拟/计算参数/qflow_parameters_symmetry/)
- [空间对称性](/next/Q-Flow/模拟/计算参数/qflow_parameters_symmetry/)
- [对称性精度](/next/Q-Flow/模拟/计算参数/qflow_parameters_symmetry/)
- [偶极修正](/next/Q-Flow/模拟/计算参数/qflow_parameters_dipole/)
- [迭代步数设置](/next/Q-Flow/模拟/计算参数/qflow_parameters_iteration/)
- [溶剂效应](/next/Q-Flow/模拟/计算参数/qflow_parameters_solvent/)
- [读取数据](/next/Q-Flow/模拟/计算参数/qflow_parameters_read_data/)

### 结果处理
- 可视化电荷密度
  - 默认值：开
- 真空能级
  - 默认值：开
- 电子布居分析
  - 默认值：开
- 电子局域函数
  - 默认值：关
