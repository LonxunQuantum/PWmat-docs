---
sidebar_position: 11
---

# 非共振拉曼光谱组件
使用Raman模块生成位移结构，对每个结构执行PWmat程序JOB = SCF，JOB = MOMENT，（JOB = DOS）计算

- 允许连接的输入组件（predessors）：声子模式计算
- 允许连接的输出组件（successors）：无

## 参数设置

### 基础参数

- [加速卡](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu/)
- [加速卡数](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu_number/)
- [k点并行](/next/Q-Flow/模拟/计算参数/qflow_parameters_kpara/)
- [超胞大小](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh_supercell/)
- [k点网格（超胞）](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh_supercell/)

### 高级参数
- [k点插值](/next/Q-Flow/模拟/计算参数/qflow_parameters_interpolation/)
- [能量点数](/next/Q-Flow/模拟/计算参数/qflow_parameters_raman/)
- [拉曼光谱展宽](/next/Q-Flow/模拟/计算参数/qflow_parameters_raman/)
- [迭代步数设置](/next/Q-Flow/模拟/计算参数/qflow_parameters_iteration/)
