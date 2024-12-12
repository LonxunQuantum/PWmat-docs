---
sidebar_position: 21
---

# 优化参数

## 最大优化步数
- 包含该参数的组件：结构优化，过渡态计算，弹性常数
- 默认值：100
- 相关PWmat参数：RELAX_DETAIL

设置计算的最大离子步数，达到该步数时计算将会停止

## 力收敛标准
- 包含该参数的组件：结构优化，过渡态计算，弹性常数
- 默认值：
  - 结构优化，弹性常数：0.01
  - 过渡态计算：0.03
- 单位：$eV/\AA$
- 相关PWmat参数：RELAX_DETAIL

设置力收敛标准，若所有原子受力均小于该值，则已达到力收敛标准
  
## 优化方法
- 包含该参数的组件：结构优化，过渡态计算，弹性常数
- 可选项：
  - CG，BFGS，steepest decent，PCG，LBFGS，FIRE
- 默认值：
  - 结构优化，弹性常数：CG
  - 过渡态计算：LBFGS
- 相关PWmat参数：RELAX_DETAIL

### 每离子步原子最大移动距离
- 包含该参数的优化方法：CG，LBFGS，FIRE
- 默认值：1.0
- 单位：Bohr
- 相关PWmat参数：IN.RELAXOPT，RELAX_MAXMOVE

每次迭代中原子移动的最大步幅

### 初始时间步长
- 包含该参数的优化方法：FIRE
- 默认值：1.0
- 单位：fs
- 相关PWmat参数：IN.RELAXOPT，FIRE_DT

时间步长用于在FIRE优化算法中更新原子速度信息，在优化过程中时间步长会动态调整

## 优化晶格
- 包含该参数的组件：结构优化
- 默认值：开启
  - 优化方式
    - 可选项
      - 自由优化
      - 固定方向优化：至少需要固定1个方向，最多固定2个方向
      - 固定晶轴夹角
      - 固定晶格形状
    - 默认值：自由优化
- 相关PWmat参数：RELAX_DETAIL，IN.RELAXOPT，CELL_FIX

在结构优化组件中，仅当优化方法为CG，LBFGS，FIRE时可开启优化晶格功能

### 晶格应力收敛标准
- 包含该参数的组件：结构优化
- 默认值：0.01
- 单位：eV/Natom
- 相关PWmat参数：RELAX_DETAIL
  
### 施加外部压力
- 包含该参数的组件：结构优化
- 默认值：关闭
  - 静水压力
    - 默认值：0
    - 单位：GPa
    - 相关PWmat参数：IN.RELAXOPT，PSTRESS_EXTERNAL
  - 各向异性压力
    - 默认值：0
    - 单位：GPa
    - 相关PWmat参数：PTENSOR_EXTERNAL
