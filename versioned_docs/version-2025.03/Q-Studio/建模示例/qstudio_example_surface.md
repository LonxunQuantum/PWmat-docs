---
sidebar_position: 1
---

# 表面结构及吸附建模

以 Pt 为例，进行一系列建模：

1. 从数据库导入文件：在菜单中依次点击`文件`→`从在线数据库导入`,在弹出的窗口中依次点击`Pt`→`Search`→`Load`；
2. 扩胞；在菜单中依次点击`构建`→`建立超胞`，在弹出的窗口中设置扩胞大小；
3. 切表面：在菜单中依次点击`构建`→`切表面`，在弹出的窗口中设置切面及切面位置和厚度，点击`切表面`，在弹出的窗口中设置真空层，点击`确定`进行预览（→ 调整位置）→`接受`；
4. 固定底层原子：点击![图标1](./nested/qstudio_structtools_select.png)激活选择模式，拖拽选中底下几层原子 →`设置`→`限制原子移动`→`固定方向（X/Y/Z）`；
5. 表面吸附单原子：`选择模式`下选中表面某个原子在其上方添加原子，此时只是为了得到该原子的坐标 →`构建`→`添加原子`→`选择原子及设置坐标`（或直接点击![图标3](./nested/qstudio_structtools_addatom.png)）；
6. 表面吸附小分子：在菜单栏中依次点击`构建`→`构建分子`→`合并`，点击![drag](./nested/qstudio_structtools_dragmol.png)激活拖拽分子模式，拖拽分子到指定位置，点击![drag](./nested/qstudio_structtools_trans&rot.png)微调分子位置。


<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_crystal1.png').default} alt="Drawing" />
            <font>导入晶胞</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_crystal2.png').default} alt="Drawing" />
            <font>扩胞</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface1.png').default} alt="Drawing" />
            <font>切表面</font>
        </center>
    </td>
</tr></table>
<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface2.png').default} alt="Drawing" />
            <font>固定基矢</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface3.png').default} alt="Drawing" />
            <font>吸附单原子</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface4.png').default} alt="Drawing" />
            <font>吸附小分子</font>
        </center>
    </td>
</tr></table>
