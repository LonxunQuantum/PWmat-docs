# Slab and surface adsorption

Take Platinum as an example, a series of modeling is performed:

1. Load file from database: click `File`→ `Load from Online Database` in the menu, click `Pt`→ `Search`→ `Load` in the pop-up window;
2. Build supercell: Click `Modify` → `Build Supercell` in the menu, and set the supercell size in the pop-up window;
3. Cleave surface: click `Build` → `Cleave Surface` in the menu, set the cleave plane and its position and slab thickness in the pop-up window, click `Cleave`, set the vacuum in the pop-up window, click `Apply` to preview (→ Adjust Position) → `Ok`;
4. Fix the atoms away from surface: In the toolbar, click ![Icon 1](nested/qstudio_structtools_select.png) to activate the selection mode, drag to select the layers of atoms which are away from surface → click `Modify`→`Edit Constraints` in the menu → Fix the X/Y/Z Position in the pop-up window;
5. Surface adsorption of single atom: Click `Build`→ `Add Atoms` in the menu, select element and input coordinates of the atom which will be added ( you can also click ![Icon 3](nested/qstudio_structtools_addatom.png) in the toolbar to add atoms)；
6. Surface adsorption of small molecules: Click `Build` → `Sketch Molecule` in the menu, draw a molecule, then click `Optimize` → `Append` to append this molecule into current structure. In the toolbar, click ![drag](./nested/qstudio_structtools_dragmol.png) to activate the molecule dragging mode, drag the molecule to the specified position. You can also click![drag](./nested/qstudio_structtools_trans&rot.png) in the toolbar to fine-tune the position of the molecule.


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
