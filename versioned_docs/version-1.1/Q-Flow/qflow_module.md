# 模板

模板是由相应组件组成针对特定计算的大组件。

<img src={require("./images/图片55.png").default} width='40%' />


## 能带结构

能带结构模板由自洽计算组件->非自洽计算组件构成，各组件参数的设置参考[组件部分](/1.1/Q-Flow/qflow_component_pwmat_nonscf)。

<img src={require("./images/图片56.png").default} width='50%'/>

## 态密度

态密度模板由自洽计算组件->原子轨道投影组件构成，各组件参数的设置参考[组件部分](/1.1/Q-Flow/qflow_component_pwmat_dos)。

<img src={require("./images/图片57.png").default} width='50%'/>

## 投影能带

投影能带模板由自洽计算组件->非自洽计算组件->原子轨道投影组件构成，各组件参数的设置参考[组件部分](/1.1/Q-Flow/qflow_component_pwmat_dos)。

<img src={require("./images/图片65.png").default} width='50%'/>

## 高频介电函数

高频介电函数模板由自洽计算组件->原子轨道投影组件 ( -> 振子强度组件) 构成，各组件参数的设置参考[组件部分](/1.1/Q-Flow/qflow_component_pwmat_dos)。

<img src={require("./images/图片58.png").default} width='50%'/><img src={require("./images/图片59.png").default} width='50%'/>

## 离子钳位极化

离子钳位极化模板由自洽计算组件->原子轨道投影组件构成，各组件参数的设置参考[组件部分](/1.1/Q-Flow/qflow_component_pwmat_dos)。

<img src={require("./images/图片60.png").default} width='50%'/>

## 有效质量

有效质量模板由自洽计算组件->非自洽计算组件构成，各组件参数的设置参考[组件部分](/1.1/Q-Flow/qflow_component_pwmat_nonscf)。

<img src={require("./images/图片61.png").default} width='50%'/>

## 声子谱

声子谱模板由结构优化组件->声子模式组件，各组件参数的设置参考[组件部分](/1.1/Q-Flow/qflow_component_pwmat_phonon)。

<img src={require("./images/图片62.png").default} width='50%'/>