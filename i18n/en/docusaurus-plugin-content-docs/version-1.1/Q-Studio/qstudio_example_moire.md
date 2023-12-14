# Moiré superlattice structures

Take Moiré bilayer graphene as an example:

1. Import single-layer graphene structure: you can import from the database, and perform [Two-dimensional materials](./qstudio_example_2d.md) modeling
2. Redefine lattice: two sets of lattice constants with the same lattice constant and different base vector directions are constructed by lattice transformation. Click `Modify`→ `Symmetry`→ `Redefine Lattice`, set scaling matrix Parameters in the pop-up window (you need to calculate the change relative to the primitive vector);
3. Structure combination: Click `Build`→ `Build Heterostructure` in the menu bar, add structures in turn and select C for stacking direction. Select `Keep constant thickness` for lattice matching method and `2D materials` for stacking style. Set a proper buffer region distance between layers and select the new lattice constant in the detail settings.

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
