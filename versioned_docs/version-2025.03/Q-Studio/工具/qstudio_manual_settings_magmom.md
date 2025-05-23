# 设置磁矩

支持为原子指定共线/非共线初始磁矩并实时可视化显示，可导出至PWmat结构文件

![magmom](.././nested/qstudio_manual_settings_magmom.png)

- 共线磁矩（SPIN=2）
    ![magmom](.././nested/qstudio_manual_settings_magmom_2.png)
- 非共线磁矩（SPIN=222）
    ![magmom](.././nested/qstudio_manual_settings_magmom_222.png)

导出至PWmat结构文件时，共线磁矩输出"magnetic"字段，非共线磁矩输出"magnetic_xyz"字段。全部关闭时，不输出磁矩信息