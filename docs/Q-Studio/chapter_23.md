# 二维材料

以 MoS<sub>2</sub> 为例，进行一系列建模：

1. 从数据库导入 MoS<sub>2</sub>体材料结构：在菜单栏中依次点击`文件`→`从数据库导入`→`选择Mo、S元素并搜素`→`选择晶胞并载入`;
2. 构建单层二维材料：在菜单栏中依次点击`建模`→`对称性`→`取消对称性`→ 使用键盘 delete 键删除不需要的部分 →`设置`→`晶格常数`→ 取消勾选`Keep fractional coordinates fixed`，然后手动调整合适的真空层厚度；
3. 晶格变换（**可选**）：如需将晶格转换为其他格子，例如正交晶胞、√3基矢等，在菜单栏中依次点击`建模`→`对称性`→`晶格变换`→`设置变换矩阵参数`（需要计算相对于原基矢的变化）；
4. 扩胞（**可选**）：在菜单栏中依次点击`建模`→`建立超胞`→`设置扩胞方向及大小`；


<table><tr>
    <td> 
        <center>
            <img src={require('./nested/28.png').default} alt="Drawing" />
            <font>导入晶胞</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/29.png').default} alt="Drawing" />
            <font>构建单层二维材料</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/30.png').default} alt="Drawing" />
            <font>晶格变换</font>
        </center>
    </td>
</tr></table>