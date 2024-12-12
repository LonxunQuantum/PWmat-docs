---
sidebar_position: 12
---

# 密度泛函微扰计算组件
执行PWmat程序JOB = LR计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：红外光谱计算，晶格热导率
    
## 参数设置

### 基础参数

- [加速卡](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu/)
- [加速卡数](/next/Q-Flow/模拟/计算参数/qflow_parameters_gpu_number/)
- [k点并行](/next/Q-Flow/模拟/计算参数/qflow_parameters_kpara/)
- [赝势](/next/Q-Flow/模拟/计算参数/qflow_parameters_pp/)
- [泛函](/next/Q-Flow/模拟/计算参数/qflow_parameters_xcfunctional/)
- [截断能](/next/Q-Flow/模拟/计算参数/qflow_parameters_ecut/)
- [k点网格](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh/)

### 高级参数
- [准确度](/next/Q-Flow/模拟/计算参数/qflow_parameters_accuracy/)
- [费米展宽](/next/Q-Flow/模拟/计算参数/qflow_parameters_fermide/)
- [时间反演对称性](/next/Q-Flow/模拟/计算参数/qflow_parameters_symmetry/)
- [空间对称性](/next/Q-Flow/模拟/计算参数/qflow_parameters_symmetry/)
- [对称性精度](/next/Q-Flow/模拟/计算参数/qflow_parameters_symmetry/)
- [迭代步数设置](/next/Q-Flow/模拟/计算参数/qflow_parameters_iteration/)
- [读取数据](/next/Q-Flow/模拟/计算参数/qflow_parameters_read_data/)

### 结果处理
- 波恩有效电荷
  - 默认值：开
