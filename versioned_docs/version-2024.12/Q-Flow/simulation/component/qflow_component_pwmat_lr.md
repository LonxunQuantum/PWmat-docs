---
sidebar_position: 12
---

# 密度泛函微扰计算组件
执行PWmat程序JOB = LR计算

- 允许连接的输入组件（predessors）：结构导入，结构优化，自洽计算
- 允许连接的输出组件（successors）：红外光谱计算，晶格热导率
    
## 参数设置

### 基础参数

- [加速卡](../parameters/qflow_parameters_gpu.md)
- [加速卡数](../parameters/qflow_parameters_gpu_number.md)
- [k点并行](../parameters/qflow_parameters_kpara.md)
- [赝势](../parameters/qflow_parameters_pp.md)
- [泛函](../parameters/qflow_parameters_xcfunctional.md)
- [截断能](../parameters/qflow_parameters_ecut.md)
- [k点网格](../parameters/qflow_parameters_kmesh.md)

### 高级参数
- [准确度](../parameters/qflow_parameters_accuracy.md)
- [费米展宽](../parameters/qflow_parameters_fermide.md)
- [时间反演对称性](../parameters/qflow_parameters_symmetry.md)
- [空间对称性](../parameters/qflow_parameters_symmetry.md)
- [对称性精度](../parameters/qflow_parameters_symmetry.md)
- [迭代步数设置](../parameters/qflow_parameters_iteration.md)
- [读取数据](../parameters/qflow_parameters_read_data.md)

### 结果处理
- 波恩有效电荷
  - 默认值：开
