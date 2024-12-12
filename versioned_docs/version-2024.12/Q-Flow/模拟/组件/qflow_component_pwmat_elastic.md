---
sidebar_position: 10
---

# 弹性常数计算组件
使用ELPWmat生成应变结构，对每个结构执行PWmat程序JOB = RELAX计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：无

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
- [优化方法](/next/Q-Flow/模拟/计算参数/qflow_parameters_relax/)
- [最大优化步数](/next/Q-Flow/模拟/计算参数/qflow_parameters_relax/)
- [力收敛标准](/next/Q-Flow/模拟/计算参数/qflow_parameters_relax/)

### 高级参数

- [vdW](/next/Q-Flow/模拟/计算参数/qflow_parameters_vdw/)
- [费米展宽](/next/Q-Flow/模拟/计算参数/qflow_parameters_fermide/)
- [迭代步数设置](/next/Q-Flow/模拟/计算参数/qflow_parameters_iteration/)

### 结果处理
- 力学性质
  - 默认值：开
