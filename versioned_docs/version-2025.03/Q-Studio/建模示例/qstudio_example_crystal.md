---
sidebar_position: 0
---

# 体材料基本建模

以 Pt 为例，进行一系列建模：

1. 从数据库导入文件：在菜单中依次点击`文件`→`从在线数据库导入`,在弹出的窗口中依次点击`Pt`→`Search`→`Load`；
2. 原胞惯胞转换：在菜单中依次点击`设置`→`对称性`→`转换为原胞/惯胞`，例子使用惯胞演示;
3. 扩胞；在菜单中依次点击`设置`→`建立超胞`，在弹出的窗口中设置扩胞大小；
4. 构建掺杂结构：点击![图标1](../nested/qstudio_structtools_select.png)激活选择模式，选中需要替换的原子 → 点击`修改元素`![图标2](../nested/qstudio_structtools_element.png)将其替换为其他元素。

<table><tr>
    <td> 
        <center>
            <img src={require('.../nested/qstudio_example_crystal1.png').default} alt="Drawing" />
            <font>导入晶胞</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('.../nested/qstudio_example_crystal2.png').default} alt="Drawing" />
            <font>扩胞</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('.../nested/qstudio_example_crystal3.png').default} alt="Drawing" />
            <font>替换原子</font>
        </center>
    </td>
</tr></table>