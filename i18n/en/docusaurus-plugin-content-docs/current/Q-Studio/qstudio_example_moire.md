# Moiré

Take magic angle graphene (bilayer graphene) as an example:

1. Import single-layer graphene structure: you can import from the database, and perform [2D material modeling](./qstudio_example_2d.md), click `File` → `Import from Online Database` in the menu→ `Select the corresponding element and search for `→ `Select unit cell and load`;
2. Lattice transformation: two sets of lattice constants with the same lattice constant and different base vector directions are constructed by lattice transformation. Click `Settings`→ `Symmetry`→ `Lattice Transformation` → `Set Transformation Matrix Parameters` in the menu bar (you need to calculate the change relative to the primitive vector);
3. Structure combination: Click `Modeling`→ `Build Heterostructures` in the menu bar→ `Add Structures in turn`→ `Select C for Heterojunction Direction` (vertical construction)→ Select `Keep thickness constant` for lattice matching method→ Processing method: `Two-dimensional material`→ To separate the layers of the heterostructure from each other, you need to set the vacuum layer thickness, layer 1 is the distance between layers, layer 2 is the distance between unit cells → Select the new lattice constant in the detailed settings.

<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_moire1.png').default} alt="Drawing" />
            <font>Lattice transform one</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_moire2.png').default} alt="Drawing" />
            <font>Lattice transform two</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_moire3.png').default} alt="Drawing" />
            <font>Build heterojunctions and set parameters</font>
        </center>
    </td>
</tr></table>
