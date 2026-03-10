---
sidebar_position: 14
---

# 晶格热导率组件
使用Thirdorder模块生成位移结构，对每个结构执行PWmat程序JOB = SCF计算

- 允许连接的输入组件（predessors）：振子强度计算，声子模式计算，密度泛函微扰计算
- 允许连接的输出组件（successors）：无

## 参数设置

### 基础参数

- [加速卡](../parameters/qflow_parameters_gpu.md)
- [加速卡数](../parameters/qflow_parameters_gpu_number.md)
- [k点并行](../parameters/qflow_parameters_kpara.md)
- [超胞大小](../parameters/qflow_parameters_kmesh_supercell.md)
- [最大近邻数](../parameters/qflow_parameters_shengbte.md)
- [k点网格（超胞）](../parameters/qflow_parameters_kmesh_supercell.md)

### 高级参数

- [迭代步数设置](../parameters/qflow_parameters_iteration.md)

### 结果处理
- ShengBTE参数设置
  - 计算网格
    - 默认值：15 15 15
    - 描述：ngrid
  - 高斯展宽
    - 默认值：1.0
    - 描述：scalebroad
  - 温度计算区间
    - 描述：T_min，T_max，T_step
    - 参数：
      - 最小值
        - 默认值：300.0
        - 单位：K
      - 最大值      
        - 默认值：300.0
        - 单位：K
      - 间隔 
        - 默认值：50.0
        - 单位：K
  - NAC修正
    - 默认值：开
    - 描述：计算并使用动态矩阵的非解析部分；需要输入组件连接密度泛函微扰计算
  - 介电常数
    - 可选项：读取输入组件结果，手动设置
    - 默认值：读取输入组件结果
    - 描述：读取输入组件结果需要输入组件连接振子强度计算，并存在吸收谱计算结果
