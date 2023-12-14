# Bulk materials

Take Platinum as an example, a series of modeling is performed:

1. Load file from database: click `File`→ `Load from Online Database` in the menu, click `Pt`→ `Search`→ `Load` in the pop-up window;
2. Convert between primitive cell and conventional cell: Click `Modify`→ `Symmetry` → `Primitive/Conventional Cell` in the menu, this example will use conventional cell;
3. Build supercell: Click `Modify` → `Build Supercell` in the menu, and set the supercell size in the pop-up window;
4. Build Doped Structures: In the toobar, click![Icon 1](nested/qstudio_structtools_select.png) to activate the selection mode, select the atom to be replaced → then in the toobar, click ![Icon 2](nested/qstudio_structtools_element.png) to replace it with other elements.

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
            <img src={require('./nested/qstudio_example_crystal3.png').default} alt="Drawing" />
            <font>Replace atoms</font>
        </center>
    </td>
</tr></table>