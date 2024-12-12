---
sidebar_position: 9
---

# 声子模式计算组件
使用PyPWmat生成位移结构，对每个结构执行PWmat程序JOB = SCF计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：非共振拉曼光谱，红外光谱计算，晶格热导率

## 参数设置

### 基础参数

- [加速卡](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu/)
- [加速卡数](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu_number/)
- [k点并行](/next/Q-Flow/模拟/计算参数/qflow_parameters_kpara/)
- [赝势](/next/Q-Flow/模拟/计算参数/qflow_parameters_pp/)
- [自旋](/next/Q-Flow/模拟/计算参数/qflow_parameters_spin/)
- [泛函](/next/Q-Flow/模拟/计算参数/qflow_parameters_xcfunctional/)
- [截断能](/next/Q-Flow/模拟/计算参数/qflow_parameters_ecut/)
- [计算类型](/next/Q-Flow/模拟/计算参数/qflow_parameters_phonon/)
- [超胞大小](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh_supercell/)
- [k点网格（超胞）](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh_supercell/)

### 高级参数

- [DFT+U](/next/Q-Flow/模拟/计算参数/qflow_parameters_dft+u/)
- [vdW](/next/Q-Flow/模拟/计算参数/qflow_parameters_vdw/)
- [费米展宽](/next/Q-Flow/模拟/计算参数/qflow_parameters_fermide/)
- [位移量](/next/Q-Flow/模拟/计算参数/qflow_parameters_phonon/)
- [特殊q点路径](/next/Q-Flow/模拟/计算参数/qflow_parameters_phonon/)
- [迭代步数设置](/next/Q-Flow/模拟/计算参数/qflow_parameters_iteration/)

### 结果处理

- 声子谱
  - 默认值：开
- 零点能：
  - 默认值：关
