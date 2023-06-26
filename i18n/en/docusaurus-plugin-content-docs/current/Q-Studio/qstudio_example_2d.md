# Two-dimensional materials

Take MoS<sub>2</sub> as an example for a series of modeling:

1. Import MoS<sub>2</sub> body material structure from database: Click `File` → `Import from online database` in the menu→ `Select Mo and S elements and search for `→ `Select unit cell and load`;
2. To build a single-layer 2D material: Click `Settings`→ `Symmetry`→ `Unsymmetry` in the menu→ Use the keyboard delete key to delete unwanted parts → `Settings` → `Lattice Constants`→ Uncheck `Keep atomic fraction coordinates` and manually adjust the appropriate vacuum layer thickness;
3. Lattice transformation (**optional**): If you need to convert the lattice to other lattices, such as orthogonal unit cells, √3 primitive vectors, etc., click `Settings`→ `Symmetry`→ `Lattice Transformation`→ `Set Transformation Matrix Parameters` in the menu bar (need to calculate the change relative to the primitive vector);
4. Expansion (**Optional**): Click `Modeling`→ `Create Supercell` → `Set Expansion Direction and Size` in the menu bar;


<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_2d1.png').default} alt="Drawing" />
            <font>Import the unit cell</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_2d2.png').default} alt="Drawing" />
            <font>Build single-layer two-dimensional materials</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_2d3.png').default} alt="Drawing" />
            <font>Lattice transformation</font>
        </center>
    </td>
</tr></table>