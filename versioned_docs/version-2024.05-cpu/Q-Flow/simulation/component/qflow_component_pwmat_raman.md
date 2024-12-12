---
sidebar_position: 11
---

# 非共振拉曼光谱组件
使用Raman模块生成位移结构，对每个结构执行PWmat程序JOB = SCF，JOB = MOMENT，（JOB = DOS）计算

- 允许连接的输入组件（predessors）：声子模式计算
- 允许连接的输出组件（successors）：无

## 参数设置

### 基础参数

- [加速卡](../parameters/qflow_parameters_gpu.md)
- [加速卡数](../parameters/qflow_parameters_gpu_number.md)
- [k点并行](../parameters/qflow_parameters_kpara.md)
- [超胞大小](../parameters/qflow_parameters_kmesh_supercell.md)
- [k点网格（超胞）](../parameters/qflow_parameters_kmesh_supercell.md)

### 高级参数
- [k点插值](../parameters/qflow_parameters_interpolation.md)
- [能量点数](../parameters/qflow_parameters_raman.md)
- [拉曼光谱展宽](../parameters/qflow_parameters_raman.md)
- [迭代步数设置](../parameters/qflow_parameters_iteration.md)
