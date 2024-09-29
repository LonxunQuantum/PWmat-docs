---
sidebar_position: 5
---

# Appendix I: features Wiki

本节简要介绍 PWMLFF 中使用的特征。同时还列出了相关文献，供读者参考。

## 什么是特征？

特征（或描述符）是描述原子局部环境的量。它们需要保持平移、旋转和置换对称性。特征通常用作各种回归器（线性模型、神经网络等）的输入，这些回归器输出原子能量和力。

特征是空间坐标的可微函数，因此可以计算力：

$$
    \mathbf{F_i} = - \frac{d E_{tot}}{d \mathbf{R_i}} = - \sum_{j,\alpha} \frac{\partial E_j}{\partial G_{j,\alpha}} \frac{\partial G_{j,\alpha}}{ \partial \mathbf{R_i}}
$$

其中，$j$ 是在截断半径内的近邻原子的索引，$\alpha$ 是特征的索引。

注意：特征需要满足旋转、平移和置换不变性。

## 2-b and 3-b features with piecewise cosine functions (feature 1 & 2)

给定一个中心原子，利用分断余弦函数来描述其局部环境。通过下面的图表，可以大致了解它们的原理。

![features](pictures/piecewise_cos.png)

我们首先定义分段余弦函数，分别用于两体和三体特征。给定内部和外部截断 $R_{inner}$ 和 $R_{outer}$，基函数的阶数 $M$，分段函数的宽度 $h$，以及中心原子 $i$ 和近邻原子 $j$ 之间的原子间距 $R_{ij}$，我们定义基函数为

$$
    \phi_\alpha (R_{ij}) =
    \begin{cases}
        \frac{1}{2}\cos(\frac{R_{ij}-R_{\alpha}}{h}\pi) + \frac{1}{2} &, |R_{ij} - R_{\alpha}| < h \\
                                                                        0 &, \text{otherwise} \\
    \end{cases}
$$

其中

$$
    R_{\alpha} = R_{inner} + (\alpha - 1) h,\ \alpha = 1,2,...,M
$$

中心原子 $i$ 的 **两体特征** 表达式为

$$
    G_{\alpha,i} = \sum_{m} \phi_{\alpha}(R_{ij})
$$

而 **三体特征** 表达式为

$$
    G_{\alpha\beta\gamma,i} = \sum_{j,k} \phi_{\alpha}(R_{ij}) \phi_{\beta}(R_{ik})  \phi_{\gamma}(R_{jk})
$$

其中 $\sum_{m}$ 和 $\sum_{m,n}$ 分别表示在中心原子 $i$ 的截断半径 $R_{outer}$ 内的所有原子的求和。

这两个特征通常是成对使用的。

_参考文献_：

Huang, Y., Kang, J., Goddard, W. A. & Wang, L.-W. Density functional theory based neural network force fields from energy decompositions. Phys. Rev. B 99, 064103 (2019)

## 2-b and 3-b Gaussian feature (feature 3 & 4)

这两个特征是 Behler-Parrinello 神经网络中首次使用的特征。给定截断半径 $R_c$ 及中心原子 $i$ 和近邻原子 $j$ 之间的原子间距 $R_{ij}$，定义截断函数 $f_c$

$$
    f_c(R_{ij}) =
    \begin{cases}
        \frac{1}{2}\cos(\frac{\pi R_{ij}}{R_c}) + \frac{1}{2} &, R_{ij} < R_c \\
                                                                        0 &, \text{otherwise} \\
    \end{cases}
$$

中心原子 $i$ 的 **两体高斯** 特征定义为

$$
    G_i = \sum_{j \neq i} e^{(-\eta(R_{ij} - R_s)^2)} f_c (R_{ij})
$$

其中 $\eta$ 和 $R_s$ 是用户定义的参数。

中心原子 $i$ 的 **三体高斯** 特征定义为

$$
    G_i = 2^{1-\zeta} \sum_{j,k \neq i} (1+\lambda \cos \theta_{ijk} )^\zeta\ e^{-\eta(R_{ij}^2 + R_{ik}^2 + R_{jk}^2)} f_c (R_{ij}) f_c (R_{ik}) f_c (R_{jk})
$$

其中

$$
    \cos \theta_{ijk} = \frac{\mathbf{R_{ij}} \cdot \mathbf{R_{ik}}}{|\mathbf{R_{ij}}||\mathbf{R_{ik}}|}
$$

$\eta$、$\zeta$ 和 $\lambda = \pm1$ 是用户定义的参数。

这两个特征通常是成对使用的。

_参考文献_：

J. Behler and M. Parrinello, Generalized Neural-Network Representation of High Dimensional Potential-Energy Surfaces. Phys. Rev. Lett. 98, 146401 (2007)

## Moment Tensor Potential (feature 5) 

在 MTP 中，中心原子 $i$ 的局部环境由

$$
    \mathbf{n_i} = (z_i, z_j, \mathbf{r_{ij}})
$$

定义，其中 $z_i$ 是中心原子的原子类型，$z_j$ 是近邻原子的原子类型，$\mathbf{r_{ij}}$ 是近邻原子的相对坐标。接下来，每个原子的能量贡献被展开为

$$
    E_i(\mathbf{n_i}) = \sum_\alpha c_\alpha B_\alpha(\mathbf{n_i})
$$

其中 $B_\alpha$ 是用户选择的基函数，$c_\alpha$ 是待拟合的参数。

为了构造基函数，我们引入矩张量 $M_{\mu\nu}$ 来定义基函数

$$
    M_{\mu\nu} (\mathbf{n_i}) = \sum_j f_\mu (|\mathbf{r_{ij}}|,z_i,z_j) \bigotimes_\nu \mathbf{r_{ij}}
$$

这些矩张量包含径向和角度部分。径向部分可以展开为

$$
    f_\mu (|\mathbf{r_{ij}}|,z_i,z_j) = \sum_\beta c^{(\beta)}_{\mu,z_i,z_j} Q^{(\beta)}(|\mathbf{r_{ij}}|)
$$

其中 $Q^{(\beta)}(|\mathbf{r_{ij}}|)$ 是径向基函数。具体地，

$$
    Q^{(\beta)}(|\mathbf{r_{ij}}|) =
    \begin{cases}
        \phi^{(\beta)}(|\mathbf{r_{ij}}|) (R_{cut} - (|\mathbf{r_{ij}}|))^2 &, (|\mathbf{r_{ij}}|) < R_{cut} \\
        0 &,\text{otherwise}
    \end{cases}
$$

其中 $\phi^{(\beta)}$ 是定义在区间 [$R_{min},R_{cut}$] 上的多项式（例如切比雪夫多项式）。

角度部分由 $\bigotimes_\nu \mathbf{r_{ij}}$ 给出，它表示对 $\mathbf{r_{ij}}$ 进行 $\nu$ 次张量积，包含了近邻 $\mathbf{n_i}$ 的角度信息。$\nu$ 决定了矩张量的秩。当 $\nu=0$ 时，得到一个常数标量；当 $\nu=1$ 时，得到一个向量（秩-1 张量）；当 $\nu=2$ 时，得到一个矩阵（秩-2 张量）；以此类推。

最后，我们定义矩张量的级数为

$$
    lev(M_{\mu \nu}) = 2 + 4\mu + \nu
$$

这是一个经验公式。

_参考文献_：

I.S. Novikov, etal, The MLIP package: moment tensor potential with MPI and active learning. Mach. Learn.: Sci. Technol, 2, 025002 (2021)

## Spectral Neighbor Analysis Potential (feature 6)

在 SNAP 中，不使用高斯基函数。因此不计算两个电荷密度图之间的距离和核函数。它首先定义一个电荷密度，然后使用球谐函数（或 4D 球，带有旋转矩阵）来展开电荷密度。然后使用双谱，使其具有旋转不变性。从某种意义上说，它类似于 MTP，但它使用一种特殊的方法来缩并方向指数，使其具有旋转不变性。它通常与线性回归一起使用。

首先，它定义位于 $\mathbf{r}$ 处的中心原子 $i$ 的邻近原子周围的电荷密度为三维空间中的 $\delta$ 函数之和：

$$
    \rho(\mathbf{r}) = \delta({\mathbf{r}}) + \sum_{\mathbf{r}_{ki}\lt R_C}f_C(\mathbf{r}_{ki})\omega_k\delta(\mathbf{r}-\mathbf{r}_{ki})
$$

其中 $\mathbf{r}_{ki}$ 是原子 $i$ 的第 $k$ 个近邻的位置，$\omega_k$ 是第 $k$ 个近邻的权重，径向函数 $f_C(\mathbf{r}_{ki})$ 确保每个近邻的贡献在截断半径 $R_C$ 附近平滑地变为零：

$$
f_C(\mathbf{r}) = 0.5\left[\cos\left(\frac{\pi r}{R_C}\right)+1\right]
$$

这个电荷密度函数的角部分可以用球谐函数展开，球谐函数定义在 $l = 0, 1, 2, ...$ 和 $m = -l, -l+1, ..., l-1, l$ 的基础上。径向分布通常由一组径向基函数表示。然而，在这里，径向信息 $\mathbf{r}$ 被映射到 4D 超球面函数 $U^j_{mm^{'}}(\theta_0,\theta,\phi)$ 中，其中所有点（邻近原子）落入 3D 球面（在 4D 空间中），定向（角度）信息由三个角度给出：

$$
\mathbf{r} \equiv \begin{pmatrix} x \\ y \\ z \end{pmatrix} \rightarrow \begin{matrix} \phi = \arctan(y/x) \\ \theta = \arccos(z/\mathbf{r}) \\ \theta_0 = \frac{3}{4} \pi \mathbf{r} / \mathbf{r}_{c} \end{matrix}
$$

因此，上述电荷密度函数可以用这些 4D 超球面函数 $U^j_{mm^{'}}(\theta_0,\theta,\phi)$ 展开，展开系数为 $u^j_{mm^{'}}$：

$$
    \rho(\mathbf{r}) = \sum_{j=0,\frac{1}{2},1,...}^\infin \sum_{m=-j, -j+1}^j \sum_{m^{'}=-j,-j+1,...}^j u^j_{mm^{'}} U^j_{mm^{'}}(\theta_0,\theta,\phi)
$$

使用上述电荷密度函数，可以计算 $u^j_{mm^{'}}$：

$$
    u^j_{mm^{'}} = U^j_{mm^{'}}(0,0,0) + \sum_{\mathbf{r}_{ki}\lt R_C}f_C(\mathbf{r}_{ki})\omega_kU^j_{mm^{'}}(\theta_0(k),\theta(k),\phi(k))
$$

其中，$k$ 是邻近原子的索引，$\theta_0(k),\theta(k),\phi(k)$ 是原子 $i$ 的第 $k$ 个近邻的位置矢量的三个角度。注意，$u^j_{mm^{'}}$ 是由于其指数 $m, m^{'}$ 而具有方向依赖性。它们可以与下面的缩并公式（使用三个 $u^j_{mm^{'}}$）缩并：

$$
    F(j_1,j_2,j) = \sum^j_{m_1,m_1^{'}=-j_1} \sum^j_{m_2,m_2^{'}=-j_2} \sum^j_{m,m^{'}=-j} (u^{j}_{mm^{'}})^{*}u^{j_1}_{m_1m_1^{'}} u^{j_2}_{m_2m_2^{'}} \times C_{j_1 m_1 j_2 m_2}^{jm} C_{j_1 m_1^{'} j_2 m_2^{'}}^{jm}
$$

这里，$C_{j_1 m_1 j_2 m_2}^{jm} C_{j_1 m_1^{'} j_2 m_2^{'}}^{jm}$ 是 Clebsch-Gordan 系数，最终的标量特征是 $F(j_1,j_2,j)$。通过设置不同的 $j_1,j_2,j$，可以产生不同的特征。注意，在这些特征中，没有径向函数索引，而是有三个角动量索引。这是因为我们已经将径向距离信息转换为 3D 球面中的第三个角度信息。

## DP-Chebyshev (feature 7)

这个特征类似于 DP 的嵌入网络。它使用切比雪夫多项式作为基础。

首先，我们将 $S(\mathbf{r}_{ij})$ 定义为加权的距离的倒数函数：

$$
    S(\mathbf{r}) = \frac{f_C(\mathbf{r})}{\mathbf{r}}
$$

$$
    f_C(\mathbf{r}) = \Bigg\lbrace{\begin{matrix} 1, \qquad\qquad\qquad \mathbf{r} \lt R_{C_2}\\ \frac{1}{2} \cos(\pi \frac{\mathbf{r} - R_{C_2}}{R_c - R_{C_2}}) + \frac{1}{2}, \quad R_{C_2} \leq \mathbf{r} \lt R_C \\ 0, \qquad\qquad\qquad \mathbf{r} \gt R_C \end{matrix}}
$$

这里，$R_{C_2}$ 是一个平滑的截断参数，它允许在由 $R_C$ 定义的局部区域的边界上平滑地将 $\mathbf{r_i}$ 的分量减小到零。这个平滑函数比之前使用的 $R_{C_2}$ 更复杂一些。$S(\mathbf{r}_{ji})$ 减小了远离中心原子 $i$ 的原子的权重。然后，我们定义径向函数 $g_M(s)$ 为*深度势能切比雪夫特征*中的切比雪夫多项式 $C_M$：

$$
    g_M(s) = C_M(2R_{min} S - 1).
$$

这里，$R_{min}$ 是最小 $\mathbf{r}$ 的输入。

为了构造这样的特征，我们首先计算四个分量的向量：

$$
    T_M(k) = \sum_{\mathbf{r}_{ji} \lt R_C} \hat{X}_{ji}(k) S(\mathbf{r}_{ji}) g_M(S(\mathbf{r}_{ji}))
$$

这里，$k = 0,1,2,3$（四分量向量）。它们是由通常的 $x,y,z$ 分量构成的，再加上 $S$ 分量：

$$
    \{ x_{ji}, y_{ji}, z_{ji}\} \rightarrow \{ S(\mathbf{r}_{ji}), \hat x_{ji}, \hat y_{ji}, \hat z_{ji} \}
$$

其中 $\hat x_{ji} = \frac{X_{ji}}{\mathbf{r}_{ji}}, \hat y_{ji} = \frac{Y_{ji}}{\mathbf{r}_{ji}}, \hat z_{ji} = \frac{Z_{ji}}{\mathbf{r}_{ji}}$ 是 $\mathbf{r}_{ji}$ 的单位向量。

从这些 4D 向量中，我们可以缩并分量索引以得到标量特征：

$$
    F(M_1,M_2) = \sum_{k=0}^3 T_{M_1}(k) T_{M_2}(k)
$$

这里，$M_1$ 也编码了除切比雪夫外的原子类型的数量。因此，如果最大切比雪夫阶数是 $M$，特征的数量是 $M \cdot n_{type} \cdot (M \cdot n_{type} +1 ) / 2$。我们可以通过设置不同的 $M$ 来产生不同的特征。

## DP-Gaussian (feature 8)

这个特征类似于 DP-Chebyshev，但我们使用高斯函数代替切比雪夫多项式，并且位置和宽度参数由用户指定。

类似于 DP-Chebyshev，4D 向量构造如下：

$$
    T_M(k) = \sum_{\mathbf{r}_{ji} \lt R_C} \hat {X}_{ji}(k) g_M(\mathbf{r}_{ji})
$$

$$
    \hat X(0) = S(\mathbf{r}^{'}), \hat X(1) = \frac{x}{\mathbf{r}}, \hat X(2) = \frac{y}{\mathbf{r}}, \hat X(3) = \frac{z}{\mathbf{r}}
$$

$$
    g_M(\mathbf{r}) = f_C(\mathbf{r}) \ · \exp(-\frac{(\mathbf{r} - r_M)}{\omega M})
$$

$$
    f_C(\mathbf{r}) = \frac{1}{2} \cos(\frac{\pi \mathbf{r}}{R_C}) + \frac{1}{2}
$$

缩并过程如下：

$$
    F(M_1,M_2) = \sum_{k=0}^3 T_{M_1}(k) T_{M_2}
$$

这里，$M_1$ 也编码了除切比雪夫外的原子类型的数量。因此，如果最大切比雪夫阶数是 $M$，特征的数量是 $M \cdot n_{type} \cdot (M \cdot n_{type} +1 ) / 2$。我们可以通过设置不同的 $M$ 来产生不同的特征。