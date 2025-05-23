---
sidebar_position: 4
---

# 摩尔纹

以魔角石墨烯（双层石墨烯）为例：

1. 导入单层石墨烯结构：可以从数据库中导入，并进行[二维材料建模](qstudio_example_2d.md)，在菜单中依次点击`文件`→`从在线数据库导入`→`选择对应元素并搜素`→`选择晶胞并载入`;
2. 晶格变换：通过晶格变换构造两组晶格常数相同，基矢方向不同的新晶胞。在菜单栏中依次点击`设置`→`对称性`→`晶格变换`→`设置变换矩阵参数`（需要计算相对于原基矢的变化）；
3. 结构组合：在菜单栏中依次点击`建模`→`构建异质结构`→`依次添加结构`→`异质结方向选c`（垂直搭建）→ 晶格匹配方式选择`保持厚度不变`→ 处理方式选择`二维材料`→ 将异质结构层间分开，需要设置真空层厚度，第 1 层为层间距离设置，第 2 层为晶胞间的距离 → 详细设置中选择新的晶格常数。

<table><tr>
    <td> 
        <center>
            <img src={require('../nested/qstudio_example_moire1.png').default} alt="Drawing" />
            <font>晶格变换一</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('../nested/qstudio_example_moire2.png').default} alt="Drawing" />
            <font>晶格变换二</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('../nested/qstudio_example_moire3.png').default} alt="Drawing" />
            <font>构建异质结及设置参数</font>
        </center>
    </td>
</tr></table>
