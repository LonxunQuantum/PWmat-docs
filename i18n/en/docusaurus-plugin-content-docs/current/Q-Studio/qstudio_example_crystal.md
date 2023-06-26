# Basic modeling of bulk materials

Take Pt as an example, a series of modeling is performed:

1. Import a file from a database: click `File`→ `Import from Online Database` in the menu, click `Pt`→ `Search`→ `Load` in the pop-up window;
2. Protocell inertial cell conversion: Click `Settings`→ `Symmetry` → `Convert to Protocell/Inertial Cell` in the menu, the example uses inertial cell demonstration;
3. cell dilation; Click `Modeling` → `Establish Supercells` in the menu, and set the expansion size in the pop-up window;
4. Build Doped Structures: Click![Icon 1](nested/qstudio_structtools_select.png) Activate the selection mode, select the atom to be replaced → Click `Element`![Icon 2](nested/qstudio_structtools_element.png) Replace it with other elements.

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