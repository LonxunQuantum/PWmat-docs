# 表面结构及吸附建模

以 Pt 为例，进行一系列建模：

1. 从数据库导入文件：在菜单栏中依次点击`文件`→`从数据库导入`→`选择元素并搜素`→`选择晶胞并载入`;
2. 扩胞；在菜单栏中依次点击`建模`→`建立超胞`→`设置扩胞方向及大小`；
3. 切表面：在菜单栏中依次点击`建模`→`切表面`→`设置切面及切面位置和厚度`→`设置真空层`→ 点击`确定`进行预览（→ 调整位置）→`接受`；
4. 固定底层原子：点击`选择模式`![图标1](nested/19.png)拖拽选中底下几层原子 →`设置`→`限制原子移动`→`固定方向（X/Y/Z）`；
5. 表面吸附单原子：`选择模式`下选中表面某个原子在其上方添加原子，此时只是为了得到该原子的坐标 →`建模`→`添加原子`→`选择原子及设置坐标`（或直接点击快捷菜单中的`添加原子` ![图标3](nested/23.png)）；
6. 表面吸附小分子：在菜单栏中依次点击`建模`→`合并结构`→`建模导入`（或选择`从文件导入`来导入本地结构）
   
   → 通过`拖拽`功能<img src={require('./nested/26.png').default} alt="图标4" width="110px" />
   
    以及`平移与旋转`功能<img src={require('./nested/27.png').default} alt="图标5" height="10%" />将小分子移动到表面合适的位置。

<table><tr>
    <td> 
        <center>
            <img src={require('./nested/15.png').default} alt="Drawing" />
            <font>导入晶胞</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/16.png').default} alt="Drawing" />
            <font>扩胞</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/18.png').default} alt="Drawing" />
            <font>切表面</font>
        </center>
    </td>
</tr></table>
<table><tr>
    <td> 
        <center>
            <img src={require('./nested/21.png').default} alt="Drawing" />
            <font>固定基矢</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/22.png').default} alt="Drawing" />
            <font>吸附单原子</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/25.png').default} alt="Drawing" />
            <font>吸附小分子</font>
        </center>
    </td>
</tr></table>
