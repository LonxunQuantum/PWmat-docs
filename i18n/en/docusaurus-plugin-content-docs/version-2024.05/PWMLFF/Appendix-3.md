---
sidebar_position: 7
---

# Appendix III: Model Compression Verification

In the model compression scheme, the range of $s_{ij}$ is divided into $L$ intervals, resulting in $L+1$ interpolation points, denoted as $x_1, x_2, \cdots, x_{L+1}$. For each interval $[x_l, x_{l+1})$, a fifth-order polynomial is used to approximate the embedding network:

$$
g^l_m(x)=a^l_mx^5+b^l_mx^4+c^l_mx^3+d^l_mx^2+e^l_mx+f^l_m
$$

Note: The variable $x$ in the polynomial should be $s_{ij} - x_l$. At each grid point, the following three boundary conditions must be satisfied:

1. Function value consistency:

$$
y_l = \mathcal{G}_m(x_l)
$$

2. First-order derivative consistency:

$$
y'_l = \mathcal{G}'_m(x_l)
$$

3. Second-order derivative consistency:

$$
y''_l = \mathcal{G}''_m(x_l)
$$

The coefficients can be computed as follows:

$$
a^l_m = \frac{1}{2\Delta t^5}[12h - 6(y'_{l+1} + y'_l)\Delta t + (y''_{l+1} - y''_l)\Delta t^2]
$$

$$
b^l_m = \frac{1}{2\Delta t^4}[-30h + (14y'_{l+1} + 16y'_l)\Delta t + (-2y''_{l+1} + 3y''_l)\Delta t^2]
$$

$$
c^l_m = \frac{1}{2\Delta t^3}[20h - (8y'_{l+1} + 12y'_l)\Delta t + (y''_{l+1} - 3y''_l)\Delta t^2]
$$

$$
d^l_m = \frac{1}{2}y''_l
$$

$$
e^l_m = y'_l
$$

$$
f^l_m = y_l
$$

where $h = y_{l+1} - y_l$, and $\Delta t = x_{l+1} - x_l$.

## Verification

The conditions to be satisfied are that when $s_{ij} = x_l$ or $x_{l+1}$, the function value, first-order derivative, and second-order derivative values must all match those of the embedding network. The corresponding $x$ values are $0$ and $\Delta t$. The value of the fifth-order polynomial function is:

$$
\begin{aligned}
    g^l_m(x) &= \frac{x^5}{2\Delta t^5}[12h - 6(y'_{l+1} + y'_l)\Delta t + (y''_{l+1} - y''_l)\Delta t^2] \\
    &+ \frac{x^4}{2\Delta t^4}[-30h + (14y'_{l+1} + 16y'_l)\Delta t + (-2y''_{l+1} + 3y''_l)\Delta t^2] \\
    &+ \frac{x^3}{2\Delta t^3}[20h - (8y'_{l+1} + 12y'_l)\Delta t + (y''_{l+1} - 3y''_l)\Delta t^2] \\
    &+ \frac{1}{2}y''_lx^2 + y'_lx + y_l
\end{aligned}
$$

The first-order derivative is:

$$
\begin{aligned}
g^l_m(x) &= \frac{x^4}{2\Delta t^5} \cdot 5[12h - 6(y'_{l+1} + y'_l)\Delta t + (y''_{l+1} - y''_l)\Delta t^2] \\
&+ \frac{x^3}{2\Delta t^4} \cdot 4[-30h + (14y'_{l+1} + 16y'_l)\Delta t + (-2y''_{l+1} + 3y''_l)\Delta t^2] \\
&+ \frac{x^2}{2\Delta t^3} \cdot 3[20h - (8y'_{l+1} + 12y'_l)\Delta t + (y''_{l+1} - 3y''_l)\Delta t^2] \\
&+ y''_lx + y'_l
\end{aligned}
$$

The second-order derivative is:

$$
\begin{aligned}
g^l_m(x) &= \frac{x^3}{2\Delta t^5} \cdot 20[12h - 6(y'_{l+1} + y'_l)\Delta t + (y''_{l+1} - y''_l)\Delta t^2] \\
&+ \frac{x^2}{2\Delta t^4} \cdot 12[-30h + (14y'_{l+1} + 16y'_l)\Delta t + (-2y''_{l+1} + 3y''_l)\Delta t^2] \\
&+ \frac{x}{2\Delta t^3} \cdot 6[20h - (8y'_{l+1} + 12y'_l)\Delta t + (y''_{l+1} - 3y''_l)\Delta t^2] \\
&+ y''_l
\end{aligned}
$$

When $x = 0$, the requirements are obviously satisfied. To verify the result when $x = \Delta t$, the function value is:

$$
\begin{aligned}
g^l_m(\Delta t) &= \frac{1}{2}[12h - 6(y'_{l+1} + y'_l)\Delta t + (y''_{l+1} - y''_l)\Delta t^2] \\
&+ \frac{1}{2}[-30h + (14y'_{l+1} + 16y'_l)\Delta t + (-2y''_{l+1} + 3y''_l)\Delta t^2] \\
&+ \frac{1}{2}[20h - (8y'_{l+1} + 12y'_l)\Delta t + (y''_{l+1} - 3y''_l)\Delta t^2] \\
&+ \frac{1}{2}y''_l\Delta t^2 + y'_l\Delta t + y_l \\
&= h - y'_l\Delta t - \frac{1}{2}y''_l\Delta t^2 + \frac{1}{2}y''_l\Delta t^2 + y'_l\Delta t + y_l \\
&= y_{l+1}
\end{aligned}
$$

The first-order derivative value is:

$$
\begin{aligned}
g^l_m(\Delta t) &= \frac{5}{2\Delta t}[12h - 6(y'_{l+1} + y'_l)\Delta t + (y''_{l+1} - y''_l)\Delta t^2] \\
&+ \frac{4}{2\Delta t}[-30h + (14y'_{l+1} + 16y'_l)\Delta t + (-2y''_{l+1} + 3y''_l)\Delta t^2] \\
&+ \frac{3}{2\Delta t}[20h - (8y'_{l+1} + 12y'_l)\Delta t + (y''_{l+1} - 3y''_l)\Delta t^2] \\
&+ y''_l\Delta t + y'_l \\
&= y'_{l+1} - y'_l - y''_l\Delta t + y''_l\Delta t + y'_l \\
&= y'_{l+1}
\end{aligned}
$$

The second-order derivative value is:

$$
\begin{aligned}
g^l_m(\Delta t) &= \frac{20}{2\Delta t^2}[12h - 6(y'_{l+1} + y'_l)\Delta t + (y''_{l+1} - y''_l)\Delta t^2] \\
&+ \frac{12}{2\Delta t^2}[-30h + (14y'_{l+1} + 16y'_l)\Delta t + (-2y''_{l+1} + 3y''_l)\Delta t^2] \\
&+ \frac{6}{2\Delta t^2}[20h - (8y'_{l+1} + 12y'_l)\Delta t + (y''_{l+1} - 3y''_l)\Delta t^2] \\


&+ y''_l \\
&= y''_{l+1} - y''_l + y''_l \\
&= y''_{l+1}
\end{aligned}
$$