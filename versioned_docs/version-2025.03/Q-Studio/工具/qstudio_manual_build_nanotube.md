# 构建纳米管

![build_crystal](.././nested/qstudio_manual_build_nanotube.png)

- 卷曲矢量：以碳纳米管为例，其结构为由石墨烯卷成的圆柱体，通过定义手性卷曲矢量来表征：*Ch*=*N*·*a* + *M*·*b*，矢量*a*和*b*是石墨烯的晶格矢量。下图中，矢量OA对应(N, M)=(5,2)时的卷曲矢量，矩形OAO'A是纳米管的重复单元，将其卷成圆柱体形成纳米管。
![build_crystal](.././nested/qstudio_manual_build_nanotube2.png)

- 键长：定义了C-C键长或B-N键长
- 真空：纳米管将会被放置在周期性晶格中，相邻纳米管的间距将被设置为真空大小
- 类型：可以为graphene或boron nitride
- 直径：根据卷曲矢量和键长，计算展示出纳米管的直径，单位为埃。