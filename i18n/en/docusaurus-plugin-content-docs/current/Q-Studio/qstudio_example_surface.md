# Surface structure and adsorption modeling

Take Pt as an example, a series of modeling is performed:

1. Import a file from a database: click `File`→ `Import from Online Database` in the menu, click `Pt`→ `Search`→ `Load` in the pop-up window;
2. cell dilation; Click `Modeling` → `Establish Supercells` in the menu, and set the expansion size in the pop-up window;
3. Cut the surface: click `Modeling` → `Cut Surface` in the menu, set the slice and slice position and thickness in the pop-up window, click `Cut Surface`, set the vacuum layer in the pop-up window, click `OK` to preview (→ Adjust Position) → `Accept`;
4. Fix the underlying atom: Click![Icon 1](nested/qstudio_structtools_select.png) Activate the selection mode, drag and drop the lower layers of atoms →`Settings`→`Restrict Atom Movement`→ `Fixed Direction (X/Y/Z)`;
5. Surface adsorption of single atoms: Select an atom on the surface to add atoms above it in `Select Mode`, just to get the coordinates of the atom → `Modeling`→ `Add Atoms`→ `Select Atoms and Set Coordinates` (or click directly![Icon 3](nested/qstudio_structtools_addatom.png))；
6. Surface adsorption of small molecules: Click `Modeling`→ `Build molecules`→ `Merge` in the menu bar, click![drag](./nested/qstudio_structtools_dragmol.png) Activate the drag molecule mode, drag the molecule to the specified position, click![drag](./nested/qstudio_structtools_trans&rot.png) fine-tune the molecular position.


<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_crystal1.png').default} alt="Drawing" />
            <font>Import the unit cell</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_crystal2.png').default} alt="Drawing" />
            <font>Dilation</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface1.png').default} alt="Drawing" />
            <font>Cut the surface</font>
        </center>
    </td>
</tr></table>
<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface2.png').default} alt="Drawing" />
            <font>Fixed base vector</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface3.png').default} alt="Drawing" />
            <font>Adsorption of single atoms</font>
        </center>
    </td>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_surface4.png').default} alt="Drawing" />
            <font>Adsorbs small molecules</font>
        </center>
    </td>
</tr></table>
