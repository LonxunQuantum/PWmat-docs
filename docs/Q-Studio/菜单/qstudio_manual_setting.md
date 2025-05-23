---
sidebar_position: 3
---

# 设置菜单

对称性操作、晶格操作、属性设置

![settings](.././nested/qstudio_manual_settings.png)


<!-- <img src="nested/qstudio_manual_settings.png"> -->
<!-- <img src={require('./nested/qstudio_manual_settings.png').default} alt="设置" width="160px" /> -->

- 对称性 
  ![qstudio_manual_settings_symmtry](.././nested/qstudio_manual_settings_symmtry.png)
  - 取消对称性<span id="makep1"></span>：即Make P1操作，会将晶体结构的空间群设为P1 (1)
  - [查找对称性](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_symmtry_findsymmetry.md)
  - [晶格变换](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_symmtry_latticetransform.md)
  - [布里渊区路径](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_symmtry_drawbrillouin.md)
  - 原胞惯胞转换：空间群名称第一位字母为'I', 'F', 'C'的结构，可以在原胞和惯胞之间进行转换，如果是菱方（三角）晶系，还需要满足a=b>c

---
- [建立超胞](../%E5%B7%A5%E5%85%B7/qstudio_build_supercell.md)
- [晶格常数](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_latticeconstant.md)
- [新建晶格](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_newlattice.md)

- 拆除晶格<span id="breaklattice"></span>：拆除现有模型的晶格盒子

---

- [限制原子移动](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_fixatom.md)
- [设置磁矩](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_magmom.md)
- [体积数据](../%E5%B7%A5%E5%85%B7/qstudio_manual_settings_volumedata.md)
  
---

- 恢复分子连续性：计算结构中分子的拓扑关系，将被晶格分开的所属于同一分子的原子移动到晶格同一端

