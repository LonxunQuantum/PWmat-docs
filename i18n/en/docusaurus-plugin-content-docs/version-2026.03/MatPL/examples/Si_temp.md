---
sidebar_position: 9
title: 非晶硅力场计算热导率
---

## 非晶硅机器学习力场计算非晶硅热导率

Yufeng Huang et al. Phys. Rev. B 99, 064103 (2019)

**训练集精度**

![proportion_time](./pictures/si_temp4.png)

**测试集精度**

![proportion_time](./pictures/si_temp3.png)

**Green-Kubo 公式**
$$
\kappa_{\mu\nu}(t)=\frac{1}{k_B T^2 V} \int_{0}^{t} dt' \langle J_\mu(0) J_\nu(t') \rangle
$$

$$
\mathbf{J} = \sum_{i} \mathbf{v}_i E_i + \sum_{i} \mathbf{r}_i \frac{d}{dt} E_i
$$

$$
= \sum_{i} \mathbf{v}_i (K_i + U_i) + \sum_{i} \mathbf{W}_i \cdot \mathbf{v}_i
$$
**热导率**

![proportion_time](./pictures/si_temp1.png)
