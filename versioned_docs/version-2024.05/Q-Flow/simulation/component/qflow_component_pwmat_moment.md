---
sidebar_position: 5
---

# 振子强度计算组件
执行PWmat程序JOB = MOMENT计算

- 允许连接的输入组件（predessors）：自洽计算，原子轨道投影，非自洽计算
- 允许连接的输出组件（successors）：晶格热导率

## 参数设置

### 结果处理
- 吸收谱（RPA方法）
  - 默认值：关
  - 参数
    - 高斯展宽
      - 默认值：0.05
      - 单位：eV
    - 能量点数
      - 默认值：8000
    - [插值点数](../parameters/qflow_parameters_interpolation.md)
- 二次谐波产生（SHG）
  - 默认值：关
  - 参数
    - 高斯展宽
      - 默认值：0.05
      - 单位：eV
    - 能量点数
      - 默认值：8000
    - 剪刀算符
      - 默认值：0
      - 单位：eV
      - 描述：用于修正带隙
    - 能量范围
      - 默认值：0 - 10
      - 单位：eV
      - 描述：输出结果的范围
    - 带间贡献能量判据
      - 默认值：0.0001
      - 单位：eV
      - 描述：为防止产生奇点，在计算带间贡献时，舍弃本征值之差小于该能量的点
    - SHG极化率张量
      - 默认值：xyz
      - 描述：需要计算SHG极化率的方向
- 反常霍尔电导
  - 默认值：关
  - 参数
    - 高斯展宽
      - 默认值：0.05
      - 单位：eV
    - [插值点数](../parameters/qflow_parameters_interpolation.md)
    - 细化阈值
      - 默认值：0.2
      - 单位：eV
      - 描述：当费米面穿过某个自旋轨道耦合劈裂，且劈裂能量小于该阈值，则对该点进行更细化的k点插值
    - 自适应细化网格
      - 默认值：5
      - 描述：当满足细化阈值要求时的k点插值网格
  - 描述：需要使用SOC赝势，自旋轨道耦合+非贡献磁矩计算；输入组件使用原子轨道投影组件，且必须使用二阶插值
- 跃迁偶极矩
  - 默认值：关