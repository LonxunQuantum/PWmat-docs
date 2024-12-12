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

- [加速卡](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu/)
- [加速卡数](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu_number/)
- [k点并行](/next/Q-Flow/模拟/计算参数/qflow_parameters_kpara/)
- [赝势](/next/Q-Flow/模拟/计算参数/qflow_parameters_pp/)
- [自旋](/next/Q-Flow/模拟/计算参数/qflow_parameters_spin/)
- [泛函](/next/Q-Flow/模拟/计算参数/qflow_parameters_xcfunctional/)
- [截断能](/next/Q-Flow/模拟/计算参数/qflow_parameters_ecut/)
- [k点网格](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh/)
- [系综](/next/Q-Flow/模拟/计算参数/qflow_parameters_md/)
- [模拟步数](/next/Q-Flow/模拟/计算参数/qflow_parameters_md/)
- [时间步长](/next/Q-Flow/模拟/计算参数/qflow_parameters_md/)
- [初态温度](/next/Q-Flow/模拟/计算参数/qflow_parameters_md/)
- [末态温度](/next/Q-Flow/模拟/计算参数/qflow_parameters_md/)

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
- [迭代步数设置](/next/Q-Flow/模拟/计算参数/qflow_parameters_iteration/)
- [读取数据](/next/Q-Flow/模拟/计算参数/qflow_parameters_read_data/)

### 结果处理
- 径向分布函数
  - 默认值：开
- 均方位移
  - 默认值：开