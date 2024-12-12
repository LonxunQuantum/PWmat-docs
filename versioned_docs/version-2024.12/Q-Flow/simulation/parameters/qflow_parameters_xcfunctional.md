---
sidebar_position: 6
---

# 泛函

- 包含该参数的组件：结构优化，自洽计算，过渡态计算，分子动力学，含时密度泛函计算，声子模式计算，弹性常数计算，密度泛函微扰计算
- 可选项：
  - LDA（CA-PZ）
  - GGA
    - 可选项：PBE，PW91，PBESOL，RPBE
  - HSE
    - 可选项：HSE06，HSE03，PBE0，自定义
    - HSE泛函参数
      - α
        - 默认值：0.25
        短程Fock exchange部分的混合参数
      - β
        - 默认值：0.00
        长程Fock exchange部分的混合参数
      - ω
        - 默认值：0.2
        - 单位：$\AA^{-1}$
        区分短程和长程区域的截断系数
  - TPSS
  - SCAN
  - B3LYP
- 默认值：
  - 密度泛函微扰计算：LDA（CA-PZ）
  - 其他组件：GGA -> PBE
- 相关PWmat参数：XCFUNCTIONAL

计算使用的交换关联泛函。当使用HSE泛函时，不支持使用k点并行