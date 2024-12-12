---
sidebar_position: 4
---

# 非自洽计算组件
执行PWmat程序JOB = NONSCF计算

- 允许连接的输入组件（predessors）：自洽计算
- 允许连接的输出组件（successors）：原子轨道投影，振子强度计算

## 参数设置

### 基础参数

- [高对称点路径](/next/Q-Flow/模拟/计算参数/qflow_parameters_kpath/)
- [k点网格](/next/Q-Flow/模拟/计算参数/qflow_parameters_kmesh/)

### 高级参数

- [收敛精度](/next/Q-Flow/模拟/计算参数/qflow_parameters_convergence/)
- [增加空带](/next/Q-Flow/模拟/计算参数/qflow_parameters_addband/)
- [对称性精度](/next/Q-Flow/模拟/计算参数/qflow_parameters_symmetry/)
- [最大非自洽电子步数](/next/Q-Flow/模拟/计算参数/qflow_parameters_iteration/)

### 结果处理
- 能带结构
  - 描述：k点需选择高对称点路径
  - 默认值：开
- 有效质量
  - 描述：k点需选择高对称点路径
  - 默认值：关
  - 参数
    - k点坐标
      - 描述：计算有效质量的k点坐标
      - 默认值：0.000 0.000 0.000
    - 步长
      - 描述：使用有限差分法计算，生成k点的步长
      - 默认值：0.01
      - 单位：$bohr^{-1}$
    - 能带序号
      - 描述：计算有效质量的能带序号
      - 默认值：1