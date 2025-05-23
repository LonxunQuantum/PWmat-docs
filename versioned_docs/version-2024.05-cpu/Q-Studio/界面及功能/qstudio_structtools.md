---
sidebar_position: 1
---

# 快捷结构工具

![快捷菜单](../nested/qstudio_structtools.png)

- ![快捷菜单](../nested/qstudio_structtools_addwindow.png)：[新建窗口](./%E8%8F%9C%E5%8D%95/qstudio_manual_file)
- ![快捷菜单](../nested/qstudio_structtools_import.png)：[导入结构](./%E8%8F%9C%E5%8D%95/qstudio_manual_file)
- ![快捷菜单](../nested/qstudio_structtools_undo.png)：[撤销](./%E8%8F%9C%E5%8D%95/qstudio_manual_edit)
- ![快捷菜单](../nested/qstudio_structtools_redo.png)：[重做](./%E8%8F%9C%E5%8D%95/qstudio_manual_edit)

---

- ![快捷菜单](../nested/qstudio_structtools_display.png)：[显示样式](./%E8%8F%9C%E5%8D%95/qstudio_manual_view_display)
- ![快捷菜单](../nested/qstudio_structtools_select.png)：选择模式
- ![快捷菜单](../nested/qstudio_structtools_rotate.png)：观察模式
- ![快捷菜单](../nested/qstudio_structtools_translate.png)：平移模式
- ![快捷菜单](../nested/qstudio_structtools_residue.png)：选择残基，仅在蛋白质结构生效

---

- ![快捷菜单](../nested/qstudio_structtools_symmetry.png)：[查找对称性](./%E8%8F%9C%E5%8D%95/qstudio_manual_settings_symmtry_findsymmetry)
- ![快捷菜单](../nested/qstudio_structtools_lattice.png)：[晶格常数](./%E8%8F%9C%E5%8D%95/qstudio_manual_settings_latticeconstant)
- ![快捷菜单](../nested/qstudio_structtools_unbuild.png)：[拆除晶格](./%E8%8F%9C%E5%8D%95/qstudio_manual_settings_newlattice)
- ![快捷菜单](../nested/qstudio_structtools_rebuild.png)：[新建晶格](./%E8%8F%9C%E5%8D%95/qstudio_manual_settings_newlattice)

---

- ![快捷菜单](../nested/qstudio_structtools_addatom.png)：[添加原子](./%E8%8F%9C%E5%8D%95/qstudio_manual_build_addatom)
- ![快捷菜单](../nested/qstudio_structtools_element.png)：[修改元素](./%E8%8F%9C%E5%8D%95/qstudio_manual_build)
- ![快捷菜单](../nested/qstudio_structtools_hydrogen.png)：[自动加氢](./%E8%8F%9C%E5%8D%95/qstudio_manual_build)

---

- ![快捷菜单](../nested/qstudio_structtools_dragatom.png)：点击进入拖拽原子模式，在原子上按住左键不放可拖拽原子移动
- ![快捷菜单](../nested/qstudio_structtools_dragmol.png)：点击进入拖拽分子模式，在分子上按住左键不放可拖拽分子移动
- ![快捷菜单](../nested/qstudio_structtools_trans&rot.png)：平移与旋转
![快捷菜单](../nested/qstudio_structtools_trans&rot2.png)
  - 平移：依据所设置距离，沿当前视角上下左右平移所选原子
  - 旋转：依据所设置角度，以沿当前视角或与当前视角正交的旋转轴旋转所选原子，旋转中心为所选原子的质心
- ![快捷菜单](../nested/qstudio_structtools_movegroup.png)：整组移动
![快捷菜单](../nested/qstudio_structtools_movegroup2.png)
  - Move：需要移动的组和移动的基准点，基准点可以为选中组的质心或某一原子
  - To：要移动到的位置，可以是某个组的质心、最佳拟合线、最佳拟合面，也可以是自定义的分数坐标或笛卡尔坐标
- ![快捷菜单](../nested/qstudio_structtools_moveup.png)：依据所设置距离，沿当前视角向上平移所选原子
- ![快捷菜单](../nested/qstudio_structtools_movedn.png)：依据所设置距离，沿当前视角向下平移所选原子
- ![快捷菜单](../nested/qstudio_structtools_moveleft.png)：依据所设置距离，沿当前视角向左平移所选原子
- ![快捷菜单](../nested/qstudio_structtools_moveright.png)：依据所设置距离，沿当前视角向右平移所选原子

---

- ![快捷菜单](../nested/qstudio_structtools_calcbond.png)：
![快捷菜单](../nested/qstudio_structtools_calcbond2.png)
  - 计算化学键：该工具默认选项
  - 化学键选项：
![快捷菜单](../nested/qstudio_structtools_calcbond3.png)
    - From：原子间的距离小于理想键长（依据共价半径）乘From系数时，不会形成化学键
    - To：原子间的距离大于理想键长（依据共价半径）乘To系数时，不会形成化学键
  - 删除化学键：删除所选原子间的所有化学键；若未选中原子，则删除结构中所有化学键
  - 监测成键：勾选时在进行任何原子的操作后会自动监测是否形成化学键
- ![快捷菜单](../nested/qstudio_structtools_calchbond.png)：计算氢键
- ![快捷菜单](../nested/qstudio_structtools_breakbond.png)：删除结构中所有键
- ![快捷菜单](../nested/qstudio_structtools_bondorder.png)：修改所选原子的成键类型，可以为单键、部分双键、双键、三键

---

- ![快捷菜单](../nested/qstudio_structtools_measuredistance.png)：测量距离
- ![快捷菜单](../nested/qstudio_structtools_measureangle.png)：测量角度
- ![快捷菜单](../nested/qstudio_structtools_measuretorsion.png)：测量二面角
- ![快捷菜单](../nested/qstudio_structtools_clearmeasure.png)：清除测量值

:::tip NOTE：
将鼠标悬浮在对应的图标上以显示对应功能
:::
