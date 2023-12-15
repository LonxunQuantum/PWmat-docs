# Heterostructures

It is made of two or more different materials, divided into vertical and transverse heterojunctions, and the lattice mismatch between different materials is required to be$<$ 5%.

- Take GaAs/AlAs as (**Lattice constants are similar**):

  1. Import GaAs and AlAs crystal structures from the database respectively: click `File`→ `Load From Online Database` in the menu, select Ga and As elements and click `search`, select the structure which space group is F-43m then click `load`; Open it again, select Al and As elements and click `search`, select the structure which space group is F-43m then click `load`
  2. Build heterostructure: Click `Build`→ `Build Heterostructure` in the menu. Add the GaAs and AlAs structures, select the new lattice constant in the detailed settings.

<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_hetero1.png').default} alt="Drawing" />
            <font>Build heterojunctions</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_hetero2.png').default} alt="Drawing" />
            <font>Parameter settings</font>
        </center>
    </td>
</tr></table>

- Take the Fe/TiC colattice interface as an example (**Lattice constants differ greatly**):

  1. Import Fe and TiC body material structures from the database respectively: click `File`→ `Load From Online Database` in the menu, select Fe element and click `search`, select the structure which space group is Im-3m then click `load`; Open it again, select Ti and C elements and click `search`, select the structure which space group is Fm-3m then click `load`
  2. Calculate the lattice mismatch: read the lattice constant of the structure separately, in the example, Fe is a=b=c=2.840, TiC is a=b=c=4.336, and the lattice mismatch is (4.336-2.840)/4.336 ≈ 35%;
  3. Build supercell: Due to the large difference in lattice constants, higher mismatch can be treated by cell expansion to find the smallest common multiple of the lattice constant. Click `Modify`→ `Build Supercell`, and set the supercell size in the pop-up window;

  | supercell size | Fe supercell lattice constant                | TiC supercell lattice constant               |
  | -------- | ------------------------------ | ------------------------------ |
  | 1×1×1    | 2.840                          | 4.336                          |
  | 2×2×2    | 5.680                          | <font color='red'>8.671</font> |
  | 3×3×3    | <font color='red'>8.520</font> | 13.008                         |
  | 4×4×4    | 11.360                         | 17.344                         |
  | 5×5×5    | 14.200                         | 21.680                         |

  4. Calculate the lattice mismatch: the cell expansion found that the lattice constant of 3×3×3 supercells of Fe and 2×2×2 supercells of TiC were similar, and the lattice mismatch was (8.671-8.520)/8.671 ≈ 1.7%;
  5. Build heterostructure: Click `Build`→ `Build Heterostructure` in the menu. Add the Fe and TiC supercell structures, select C for stacking direction, select the new lattice constant in the detailed settings.

<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_hetero3.png').default} alt="Drawing" />
            <font>Build heterojunctions</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_hetero4.png').default} alt="Drawing" />
            <font>Parameter settings</font>
        </center>
    </td>
</tr></table>

- Take the example of a two-dimensional heterojunction between MoS<sub>2</sub>/graphene layers (**Large difference in lattice constants**):

  1. Import single-layer graphene and MoS<sub>2</sub> structures respectively: you can import from the online database, and perform [Two-dimensional materials](./qstudio_example_2d.md) modeling
  2. Calculate the lattice mismatch: read the lattice constant of the structure separately, in the example, graphene is a=b=2.468, MoS<sub>2</sub> is a=b=3.19, and the lattice mismatch is (3.19-2.468)/3.19 ≈ 23%;
  3. Build supercell: Due to the large difference in lattice constants, higher mismatch can be treated by cell expansion to find the smallest common multiple of the lattice constant. Click `Modify`→ `Build Supercell`, and set the supercell size in the pop-up window;

  | supercell size | Graphene supercell lattice constant             | MoS<sub>2</sub> supercell lattice constant   |
  | -------- | ------------------------------ | ----------------------------- |
  | 1×1×1    | 2.468                          | 3.19                          |
  | 2×2×1    | 4.936                          | 6.38                          |
  | 3×3×1    | 7.404                          | <font color='red'>9.57</font> |
  | 4×4×1    | <font color='red'>9.872</font> | 12.76                         |
  | 5×5×1    | 12.340                         | 15.95                         |

  4. Calculate the lattice mismatch: the 4×4×1 supercell of graphene and the 3×3×1 supercell of MoS<sub>2</sub> were similar, and the lattice mismatch was (9.872-9.57)/9.872 ≈ 3%;
  5. Build heterostructure: Click `Build`→ `Build Heterostructure` in the menu. Add the graphene and MoS<sub>2</sub> monolayer supercell structures, select C for stacking direction, select `Keep thickness constant` for lattice matching method. To separate the layers of the heterostructure from each other, you need to set the buffer thickness in the detailed settings.

<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_hetero5.png').default} alt="Drawing" />
            <font>Build heterojunctions</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_hetero6.png').default} alt="Drawing" />
            <font>Parameter settings</font>
        </center>
    </td>
</tr></table>

