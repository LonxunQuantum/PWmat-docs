---
sidebar_position: 2
---

# Two-dimensional materials

Take MoS<sub>2</sub> as an example for a series of modeling:

1. Import MoS<sub>2</sub> crystal structure from database: Click `File` → `Load From Online Database` in the menu, select Mo and S elements and click `search`, select the structure which space group is P6_3/mmc then click `load`;
2. Build a single-layer 2D material: Click `Modify`→ `Symmetry`→ `Make P1` in the menu, select one of the MoS2 fragment then press `Delete` in your keyboard to delete it. Click `Modify` → `Lattice Parameters` in the menu,  uncheck the `keep fractional coordinate fixed` option, and adjust the c length to 20 angstrom to get an sufficient vacuum thickness. (You can also use cleave surface functionality to build 2D materials)
3. Redefine Lattice (**optional**): If you need to convert the lattice to other lattices, such as orthogonal unit cells, √3 primitive vectors, etc., click `Modify`→ `Symmetry`→ `Redefine Lattice` in the menu, set a proper scaling matrix, then click `Load`.
4. Build supercell (**Optional**): Click `Modify` → `Build Supercell` in the menu, and set the supercell size in the pop-up window;


<table><tr>
    <td> 
        <center>
            <img src={require('../nested/qstudio_example_2d1.png').default} alt="Drawing" />
            <font>Import the unit cell</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('../nested/qstudio_example_2d2.png').default} alt="Drawing" />
            <font>Build single-layer two-dimensional materials</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('../nested/qstudio_example_2d3.png').default} alt="Drawing" />
            <font>Lattice transformation</font>
        </center>
    </td>
</tr></table>