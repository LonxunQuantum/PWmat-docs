# Appendix I: features Wiki

This section provides a brief introduction on the features used in PWMLFF. The related literature is also listed, for readers' reference.

## What are features?

Features (or descriptors) are quantities that describe the local atomic environment of an atom. They are required preserve the translational, rotational, and permutational symmetries. Features are usually used as the input of various regressors(linear model, NN, .etc), which output atomic energies and forces.

Features are differentiable functions of the spatial coordinates, so that force can be calculated as

$$
    \mathbf{F_i} = - \frac{d E_{tot}}{d \mathbf{R_i}} = - \sum_{j,\alpha} \frac{\partial E_j}{\partial G_{j,\alpha}} \frac{\partial G_{j,\alpha}}{ \partial \mathbf{R_i}}
$$

where :$j$ is the index of neighbor atom within the cutoff radius, and :$\alpha$ the index of feature.

Additionally, features are required to be rotionally, translationally, and permutaionally invariant.

## 2-b and 3-b features with piecewise cosine functions (feature 1 & 2)

Given a center atom, the piecewise cosine functions are used as the basis to describe its local environment. The praph below gives you an idea of how they look like.  
![features](pictures/piecewise_cos.png)

We now define the pieceswise cosine functions, in both 2-body and 3-body feaures. Given the inner and outer cut $R_{inner}$ and $R_{outer}$, the degree of the basis $M$, the width of piecewise function $h$, and the interatomic distance between the center atom $i$ and the neighbor $j$ $R_{ij}$, one defines the basis function as

$$
    \phi_\alpha (R_{ij}) =
    \begin{cases}
        \frac{1}{2}\cos(\frac{R_{ij}-R_{\alpha}}{h}\pi) + \frac{1}{2} &, |R_{ij} - R_{\alpha}| < h \\
                                                                        0 &, \text{otherwise} \\
    \end{cases}
$$

with

$$
    R_{\alpha} = R_{inner} + (\alpha - 1) h,\ \alpha = 1,2,...,M
$$

The expression of **2-b feature** with center atom $i$ is thus

$$
    G_{\alpha,i} = \sum_{m} \phi_{\alpha}(R_{ij})
$$

and **3-b feature**

$$
    G_{\alpha\beta\gamma,i} = \sum_{j,k} \phi_{\alpha}(R_{ij}) \phi_{\beta}(R_{ik})  \phi_{\gamma}(R_{jk})
$$

where $\sum_{m}$ and $\sum_{m,n}$ sum over all atoms within cutoff $R_{outer}$ of atom $i$

In practice, these two features are usually used in pair.

_Reference_:

Huang, Y., Kang, J., Goddard, W. A. & Wang, L.-W. Density functional theory based neural network force fields from energy decompositions. Phys. Rev. B 99, 064103 (2019)

## 2-b and 3-b Gaussian feature (feature 3 & 4)

These two are the features first used in Behler-Parrinello Neural Network. Given the cutoff radius $R_c$, and the interatomic distance $R_{ij}$ with center atom $i$, define cutoff function $f_c$

$$
    f_c(R_{ij}) =
    \begin{cases}
        \frac{1}{2}\cos(\frac{\pi R_{ij}}{R_c}) + \frac{1}{2} &, R_{ij} < R_c \\
                                                                        0 &, \text{otherwise} \\
    \end{cases}
$$

The **2-b Gaussian** feature of atom $i$ is defined as

$$
    G_i = \sum_{j \neq i} e^{(-\eta(R_{ij} - R_s)^2)} f_c (R_{ij})
$$

where $\eta$ and $R_s$ are parameters defined by user.

The **3-b Gaussian** feature of atom $i$ is defined as

$$
    G_i = 2^{1-\zeta} \sum_{j,k \neq i} (1+\lambda \cos \theta_{ijk} )^\zeta\ e^{-\eta(R_{ij}^2 + R_{ik}^2 + R_{jk}^2)} f_c (R_{ij}) f_c (R_{ik}) f_c (R_{jk})
$$

where

$$
    \cos \theta_{ijk} = \frac{\mathbf{R_{ij}} \cdot \mathbf{R_{ik}}}{|\mathbf{R_{ij}}||\mathbf{R_{ik}}|}
$$

and $\eta$, $\zeta$, and $\lambda = \pm1$ are parameters defined by user.

In practice, these two features are usually used in pair.

_Reference_:

J. Behler and M. Parrinello, Generalized Neural-Network Representation of High Dimensional Potential-Energy Surfaces. Phys. Rev. Lett. 98, 146401 (2007)

## Moment Tensor Potential (feature 5)

In MTP, the local environment of the center atom :math:`i` is characterized by

$$
    \mathbf{n_i} = (z_i, z_j, \mathbf{r_{ij}})
$$

where $z_i$ is the atom type of the center atom, $z_j$ atom type of the neighbor $j$, and $\mathbf{r_{ij}}$ the relative coordinates of neighbors. Next, energy contribution of each atom is expanded as

$$
    E_i(\mathbf{n_i}) = \sum_\alpha c_\alpha B_\alpha(\mathbf{n_i})
$$

where $B_\alpha$ are the basis functions of choice and $c_\alpha$ the parameters to be fitted.

We now introduce moment tensors $M_{\mu\nu}$ to define the basis functions

$$
    M_{\mu\nu} (\mathbf{n_i}) = \sum_j f_\mu (|\mathbf{r_{ij}}|,z_i,z_j) \bigotimes_\nu \mathbf{r_{ij}}
$$

These moments contain both radial and angular parts. The radial parts can be expanded as

$$
    f_\mu (|\mathbf{r_{ij}}|,z_i,z_j) = \sum_\beta c^{(\beta)}_{\mu,z_i,z_j} Q^{(\beta)}(|\mathbf{r_{ij}}|)
$$

where $Q^{(\beta)}(|\mathbf{r_{ij}}|)$ are the radial basis funtions. Specifically,

$$
    Q^{(\beta)}(|\mathbf{r_{ij}}|) =
    \begin{cases}
        \phi^{(\beta)}(|\mathbf{r_{ij}}|) (R_{cut} - (|\mathbf{r_{ij}}|))^2 &, (|\mathbf{r_{ij}}|) < R_{cut} \\
        0 &,\text{otherwise}
    \end{cases}
$$

where $\phi^{(\beta)}$ are polynomials (e.g. Chebyshev polynomials) defined on the interval [$R_{min},R_{cut}$]

The angular part $\bigotimes_\nu \mathbf{r_{ij}}$, which means taking tensor product of $\mathbf{r_{ij}}$ $\nu$ times, contains the angular information of the neighborhood $\mathbf{n_i}$. $\nu$ determines the rank of moment tensor. With $\nu=0$ one gets a constant scalar, $\nu=1$ a vector (rank-1 tensor), $\nu=2$ a matrix (rank-2 tensor), .etc.

Define further the _level_ of moments as

$$
    lev(M_{\mu \nu}) = 2 + 4\mu + \nu
$$

This is an empirical formula.

_Reference_

I.S. Novikov, etal, The MLIP package: moment tensor potential with MPI and active learning. Mach. Learn.: Sci. Technol, 2, 025002 (2021)

## Spectral Neighbor Analysis Potential (feature 6)

In SNAP, it does not use Gaussian progression. So it does not calculate the distance and kernel between two charge density maps. It first defines a charge density, then use sphoerical harmonic (or 4D sphere, with rotation matrix) to expand the charge density. It then uses the bispectrum, so it becomes rotational invariant. In a way it is like the MTP, but it uses a special way to contract out the orientational index to make it roatational invariant. It is often used with linear regression.

Consider the density of neighboring atoms around the central atom $i$ at position $\mathbf{r}$ as a sum of $\delta$ functions in a three-dimensional space:

$$
    \rho(\mathbf{r}) = \delta({\mathbf{r}}) + \sum_{\mathbf{r}_{ki}\lt R_C}f_C(\mathbf{r}_{ki})\omega_k\delta(\mathbf{r}-\mathbf{r}_{ki})
$$

where $\mathbf{r}_{ki}$ is the position of the $k$th neighbor of atom $i$, $\omega_k$ is the weight of the $k$th neighbor, and the radial function $f_C(\mathbf{r}_{ki})$ ensures that the contribution of each neighbor will smoothly vary to zero near the cutoff radius $R_C$:

$$
f_C(\mathbf{r}) = 0.5\left[\cos\left(\frac{\pi r}{R_C}\right)+1\right]
$$

The angular part of this density function can be expanded in the familiar basis of spherial harmonic functions defined for $l = 0, 1, 2, ...$ and $m = -l, -l+1, ..., l-1, l$. The radial distribution is usually represented by a set of radial basis functions. However, here, the radial information $\mathbf{r}$ is mapped into another angle information in a 4D hyper spherical function $U^j_{mm^{'}}(\theta_0,\theta,\phi)$, where all the points (neighboring atoms) fall into a 3D spherical surface (in a 4D space) and  the orientational (angual) information is given by the there angles:

$$
\mathbf{r} \equiv \begin{pmatrix} x \\ y \\ z \end{pmatrix} \rightarrow \begin{matrix} \phi = \arctan(y/x) \\ \theta = \arccos(z/\mathbf{r}) \\ \theta_0 = \frac{3}{4} \pi \mathbf{r} / \mathbf{r}_{c} \end{matrix}
$$

As a result, the above density function can be expanded by these 4D hyper spherical harmonics $U^j_{mm^{'}}(\theta_0,\theta,\phi)$ with an expansion coefficient $u^j_{mm^{'}}$:

$$
    \rho(\mathbf{r}) = \sum_{j=0,\frac{1}{2},1,...}^\infin \sum_{m=-j, -j+1}^j \sum_{m^{'}=-j,-j+1,...}^j u^j_{mm^{'}} U^j_{mm^{'}}(\theta_0,\theta,\phi)
$$

Using he above expression for $\rho(\mathbf{r})$, the $u^j_{mm^{'}}$ can be calculated as:

$$
    u^j_{mm^{'}} = U^j_{mm^{'}}(0,0,0) + \sum_{\mathbf{r}_{ki}\lt R_C}f_C(\mathbf{r}_{ki})\omega_kU^j_{mm^{'}}(\theta_0(k),\theta(k),\phi(k))
$$

Here, $k$ is the neighboring atom index, and $\theta_0(k),\theta(k),\phi(k)$ are the three angles of the position vector $\mathbf{r}_{ki}$ of the $k$th neighbor of atom $i$. Note, $u^j_{mm^{'}}$ is the orientational dependent due to its index $m, m^{'}$. They can be contracted out (using three $u^j_{mm^{'}}$) with the following contraction formula:

$$
    F(j_1,j_2,j) = \sum^j_{m_1,m_1^{'}=-j_1} \sum^j_{m_2,m_2^{'}=-j_2} \sum^j_{m,m^{'}=-j} (u^{j}_{mm^{'}})^{*}u^{j_1}_{m_1m_1^{'}} u^{j_2}_{m_2m_2^{'}} \times C_{j_1 m_1 j_2 m_2}^{jm} C_{j_1 m_1^{'} j_2 m_2^{'}}^{jm}
$$

Here, $C_{j_1 m_1 j_2 m_2}^{jm} C_{j_1 m_1^{'} j_2 m_2^{'}}^{jm}$ is the Clebsch-Gordan coefficient, and the final scalar features are $F(j_1,j_2,j)$. We can produce different features by setting diffrent $j_1,j_2,j$. Note, in these features, there is no radial function index, instead we have three angual momentum indexex. This is because we have converted the radial distance information into the third angle information in a 3D sphere.

## DP-Chebyshev (feature 7)

This feature attempts to mimic the behavior of DP's embedding network. It uses the Chebyshev polynomial as the basis.

First, we define $S(\mathbf{r}_{ij})$ as a weighted inverse distance function as:

$$
    S(\mathbf{r}) = \frac{f_C(\mathbf{r})}{\mathbf{r}}
$$

$$
    f_C(\mathbf{r}) = \Bigg\lbrace{\begin{matrix} 1, \qquad\qquad\qquad \mathbf{r} \lt R_{C_2}\\ \frac{1}{2} \cos(\pi \frac{\mathbf{r} - R_{C_2}}{R_c - R_{C_2}}) + \frac{1}{2}, \quad R_{C_2} \leq \mathbf{r} \lt R_C \\ 0, \qquad\qquad\qquad \mathbf{r} \gt R_C \end{matrix}}
$$

Here, $R_{C_2}$ is a smooth cutoff parameter that allows the components in $\mathbf{r_i}$ to smoothly go to zero at the boundary of the local region definded by $R_C$. This smooth function is a bit more complex than the previous smooth function using a $R_{C_2}$. $S(\mathbf{r}_{ji})$ reduce the weight of the atom further away from the center atom $i$. We then define radial functions $g_M(s)$ as the Chebyshev polynomial $C_M$ in the deep potential-Chebyshev features:

$$
    g_M(s) = C_M(2R_{min} S - 1). 
$$

Here, $R_{min}$ is an input for minimum $\mathbf{r}$.

To construct the DeepMD feature, we next calculate the four components vector as:

$$
    T_M(k) = \sum_{\mathbf{r}_{ji} \lt R_C} \hat{X}_{ji}(k) S(\mathbf{r}_{ji}) g_M(S(\mathbf{r}_{ji})) 
$$

Here, $k = 0,1,2,3$ (four component vector). They are constructed from the usual $x,y,z$ component, plus the $S$ component as:

$$
    \{ x_{ji}, y_{ji}, z_{ji}\} \rightarrow \{ S(\mathbf{r}_{ji}), \hat x_{ji}, \hat y_{ji}, \hat z_{ji} \}
$$

where $\hat x_{ji} = \frac{X_{ji}}{\mathbf{r}_{ji}}, \hat y_{ji} = \frac{Y_{ji}}{\mathbf{r}_{ji}}, \hat z_{ji} = \frac{Z_{ji}}{\mathbf{r}_{ji}}$ are the unit vectors of $\mathbf{r}_{ji}$. 

From these 4D vectors, one can contract the component index to yield a scalar feature as:

$$
    F(M_1,M_2) = \sum_{k=0}^3 T_{M_1}(k) T_{M_2}(k)
$$

Here, $M_1$ also encoded the number of atom types besides the Chebyshev. So, if the max Chebyshev order is $M$, the number of features is $M * n_{type} * (M * n_{type} +1 ) / 2$. We can produce different features by setting different $M$

## DP-Gaussian (feature 8)

This is much like in deep potential-Chebyshev, but we use Gaussian functions instead of using Chebyshev
polynomials, and the position and width parameters are specified by user.

Similar to deep potential-Chebyshev, the 4D vectors are constructed as:

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

The contraction is carried out as:

$$
    F(M_1,M_2) = \sum_{k=0}^3 T_{M_1}(k) T_{M_2}
$$

$M_1$ also encoded the number of atom types besides the Chebyshev. So, if the max Chebyshev order is $M$, the number of features is $M * n_{type} * (M * n_{type} +1 ) / 2$. We can produce different features by setting different $M$.