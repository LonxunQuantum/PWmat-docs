---
sidebar_position: 24
---

# 过渡态计算参数
- 包含该参数的组件：过渡态计算
- 相关PWmat参数：NEB_DETAIL

## 弹性系数
- 默认值：1.0
- 单位：$eV/\AA^2$

用于计算相邻图像（images）之间施加的弹性作用力

## 弹性带类型
- 可选项：
  - original NEB：移除弹性力在垂直于路径方向上的分量，仅保留沿路径切线方向的分量
  - conventional NEB：不对弹性力做任何处理
  - regular NEB：移除弹性力在垂直于路径方向上的分量，仅保留沿路径切线方向的分量；改进路径切线方向估算方法
  - original CINEB：climbing image不受弹性力作用；其余images移除弹性力在垂直于路径方向上的分量，仅保留沿路径切线方向的分量
  - conventional CINEB：climbing image不受弹性力作用；其余images不对弹性力做任何处理
  - regular CINEB：climbing image不受弹性力作用；其余images移除弹性力在垂直于路径方向上的分量，仅保留沿路径切线方向的分量；改进路径切线方向估算方法
- 默认值：original NEB

相邻图像之间的弹性力可以保证图像在路径上均匀分布。
使用改进路径切线方向估算方法，可以使位于势能面变化陡峭或过渡态附近的images找到其在反应路径上的更准确的方向，有助于更高效和精确地找到最低势能路径（Mininum Energy Path，MEP）以及鞍点（saddle point）。
conventional NEB收敛速度快，误差大。因其并未对弹性力做约束，结果可能偏离真实的MEP。在使用original NEB收敛困难时，可先使用conventional NEB进行过渡态计算，再切换为其他方法进行过渡态续算。
当进行CINEB计算时，能量最高的image会被指定为climbing image，其不受虚拟弹性力的作用，只受真实力沿势能梯度反向上的分量，使其可以精准定位到过渡态鞍点。进行CINEB计算前，建议先使用NEB方法进行过渡态计算，结果收敛后再使用CINEB方法进行过渡态续算

## 过渡态续算
- 默认值：否

### 关闭过渡态续算
- 导入末态结构：若输入结构不存在过渡态路径，导入末态结构。
- 插点数：路径上插入的图像数量
  - 默认值：5
- 初态总能：初始NEB计算需要设置
  - 默认值：0
  - 单位：eV
- 末态总能：初始NEB计算需要设置
  - 默认值：0
  - 单位：eV

### 打开过渡态续算
不需要设置参数