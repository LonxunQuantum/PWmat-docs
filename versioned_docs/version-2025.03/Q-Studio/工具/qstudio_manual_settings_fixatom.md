# 限制原子移动

设置原子的自由度约束，可固定特定坐标方向，约束信息将直接写入输出文件用于后续计算

![qstudio_manual_settings_fixatom](.././nested/qstudio_manual_settings_fixatom.png)

- 固定笛卡尔坐标：
  - PWmat格式结构文件：影响Position部分（5-7）列内容
  - VASP格式结构文件：输出“Selective dynamics”字段，影响Direct部分（4-6）列内容
