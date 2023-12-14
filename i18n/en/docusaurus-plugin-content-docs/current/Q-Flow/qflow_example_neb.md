# NEB 计算过渡态

整个计算流程有以下几步：

:::tip Note
step1: 得到稳定的初末态结构;

step2: 自洽计算得到初态能量与末态能量；

step3: 过渡态计算。

**NOTE：** 初末态计算的参数设置要完全一致
:::

以 Li 在 LiF 中的间隙运输为例子。建模准备 LiF 原胞,分别进行晶格优化+原子位置优化，如何进行优化参考[结构优化部分](./qflow_example_relax)。
优化完成后点击结构优化组件查看结果，并导出结构到结构库中。

<center>
    <img src={require("./images/图片35.png").default} />   
</center>

从结构库中找到刚才保存的结构，并点击编辑进行结构操作：因为之前优化时使用的是原胞，需要寻找对称性变成惯用晶胞再进行扩胞。

<center>
    <img src={require("./images/图片36.png").default} /> 
    <img src={require("./images/图片37.png").default} /> 
</center>

然后为 LiF 构建超胞及 Li 间隙的初末态结构。

初末态结构准备后，再次进入 Q-Flow 设置工作流分别进行结构优化及自洽计算，此时只需要进行原子位置优化。即点击`组件`→`系统组件`→ 拖拽`结构优化`、`自洽计算`组件到工作流区域 → 添加从`结构导入`到`结构优化`再到`自洽计算`的连线。同样在优化完成后点击结构优化组件查看结果，并导出结构到结构库中。

最后是过渡态的计算：点击`组件`→`系统组件`→ 拖拽`过渡态计算`组件到工作流区域 → 添加从`结构导入`到`过渡态计算`的连线。其中`结构导入`组件中导入的是初态优化后的结构。

<center>
    <img src={require("./images/图片38.png").default} width='100%'/> 
    <img src={require("./images/图片39.png").default} width='40%' /> 
</center>

过渡态计算可以设置的基础参数除了有常规的 GPU 卡数、是否 k 点并行、赝势类型、泛函类型、截断能、k 点网格、原子优化算法、控制弛豫的步数及收敛条件等参数。还有一些对 NEB 计算的收敛标准、方法设置等。并在该组件中导入优化好的末态结构。其中初末态总能从前面`自洽计算组件`的结果中获取。

<center class="half"> <img width='50%' src={require("./images/图片40.png").default} /><img width='50%' src={require("./images/图片41.png").default} />
</center>

计算进度栏内包含一些图表数据，表格内会给出体系的基本参数。图里给出了平均总能变化、原子受力变化、各 image 总能、各 image 间距及自洽步数等。

<center>
    <img src={require("./images/图片42.png").default} /> 
</center>

计算完成后点击过渡态计算组件查看结果，可以查看过渡态势垒。

<center>
    <img src={require("./images/图片43.png").default} height='50%' /> 
</center>

