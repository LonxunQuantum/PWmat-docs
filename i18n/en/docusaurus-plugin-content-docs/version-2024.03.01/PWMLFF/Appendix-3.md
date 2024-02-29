---
sidebar_position: 6
---

# Appendix Ⅲ: model compression verification

model compress 方案，将$s_{ij}$取值范围分成$L$等份，则共有$l+1$个插值点，分别记为$x_1,x_2,\cdots,x_{l+1}$。对于每个$[x_l,x_{l+1})$区间，采用如下的五阶多项式替代 embedding network:
$$g^l_m(x)=a^l_mx^5+b^l_mx^4+c^l_mx^3+d^l_mx^2+e^l_mx+f^l_m$$
注意：此时多项式的自变量$x$值应为$s_{ij}-x_l$。在每个网格点上，都需要满足如下三个边界条件：

函数值一致

$$y_l=\mathcal{G}_m(x_l)$$

函数一阶导数一致

$$y'_l=\mathcal{G}'_m(x_l)$$

函数二阶导数一致

$$y''_l=\mathcal{G}''_m(x_l)$$

由此可得六个系数值分别为

$$a^l_m=\frac{1}{2\Delta t^5}[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]$$

$$b^l_m=\frac{1}{2\Delta t^4}[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]$$

$$c^l_m=\frac{1}{2\Delta t^3}[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]$$

$$d^l_m=\frac{1}{2}y''_l$$

$$e^l_m=y'_l$$

$$f^l_m=y_l$$

其中 $h=y_{l+1}-y_l$，$\Delta t=x_{l+1}-x_l$

## 验证

需满足的条件是当$s_{ij}=x_l,\,x_{l+1}$时，函数值、一阶导数、二阶导数值均与 embedding network 的值相等，此时对应的$x$值分别为$0,\,\Delta t$。五阶多项式函数值为

$$
g^l_m(x)=\frac{x^5}{2\Delta t^5}[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]\\
+\frac{x^4}{2\Delta t^4}[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]\\
+\frac{x^3}{2\Delta t^3}[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]\\
+\frac{1}{2}y''_lx^2+y'_lx+y_l
$$

一阶导数为

$$
g^l_m(x)=\frac{x^4}{2\Delta t^5}5[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]\\
+\frac{x^3}{2\Delta t^4}4[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]\\
+\frac{x^2}{2\Delta t^3}3[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]\\
+y''_lx+y'_l
$$

二阶导数为

$$
g^l_m(x)=\frac{x^3}{2\Delta t^5}20[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]\\
+\frac{x^2}{2\Delta t^4}12[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]\\
+\frac{x}{2\Delta t^3}6[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]\\+y''_l
$$

当 $x=0$ 时，显然满足需求；下面验证当 $x=\Delta t$ 时的结果，函数值为

$$
g^l_m(\Delta t)=\frac{1}{2}[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]\\
+\frac{1}{2}[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]\\
+\frac{1}{2}[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]\\
+\frac{1}{2}y''_l\Delta t^2+y'_l\Delta t+y_l\\
=h-y'_l\Delta t-\frac{1}{2}y''_l\Delta t^2+\frac{1}{2}y''_l\Delta t^2+y'_l\Delta t+y_l\\
=y_{l+1}
$$

一阶导数值为

$$
g^l_m(\Delta t)=\frac{5}{2\Delta t}[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]\\
+\frac{4}{2\Delta t}[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]\\
+\frac{3}{2\Delta t}[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]\\
+y''_l\Delta t+y'_l\\
=y'_{l+1}-y'_l-y''_l\Delta t+y''_l\Delta t+y'_l\\
=y'_{l+1}
$$

二阶导数值为

$$
g^l_m(\Delta t)=\frac{20}{2\Delta t^2}[12h-6(y'_{l+1}+y'_l)\Delta t+(y''_{l+1}-y''_l)\Delta t^2]\\
+\frac{12}{2\Delta t^2}[-30h+(14y'_{l+1}+16y'_l)\Delta t+(-2y''_{l+1}+3y''_l)\Delta t^2]\\
+\frac{6}{2\Delta t^2}[20h-(8y'_{l+1}+12y'_l)\Delta t+(y''_{l+1}-3y''_l)\Delta t^2]\\+y''_l\\
=y''_{l+1}-y''_l+y''_l\\
=y''_{l+1}
$$
