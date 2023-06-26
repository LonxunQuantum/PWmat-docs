# Shortcut structure tools

![Shortcut Menu](nested/qstudio_structtools.png)

- ![Shortcut Menu](nested/qstudio_structtools_addwindow.png)：[New window](./qstudio_manual_file.md)
- ![Shortcut Menu](nested/qstudio_structtools_import.png)：[Import the structure](./qstudio_manual_file.md)
- ![Shortcut Menu](nested/qstudio_structtools_undo.png)：[Undo](./qstudio_manual_edit.md)
- ![Shortcut Menu](nested/qstudio_structtools_redo.png)：[Redo](./qstudio_manual_edit.md)

---

- ![Shortcut Menu](nested/qstudio_structtools_display.png)：[Display style](./qstudio_manual_view_display.md)
- ![Shortcut Menu](nested/qstudio_structtools_select.png)：Select Mode
- ![Shortcut Menu](nested/qstudio_structtools_rotate.png)：View Mode
- ![Shortcut Menu](nested/qstudio_structtools_translate.png)：Translate Mode
- ![Shortcut Menu](nested/qstudio_structtools_residue.png)：Select residues only takes in the protein structure

---

- ![Shortcut Menu](nested/qstudio_structtools_symmetry.png)：[Search for Symmetry](./qstudio_manual_settings_symmtry_findsymmetry.md)
- ![Shortcut Menu](nested/qstudio_structtools_lattice.png)：[Lattice Constant](./qstudio_manual_settings_latticeconstant.md)
- ![Shortcut Menu](nested/qstudio_structtools_unbuild.png)：[Removal of the lattice](./qstudio_manual_settings_newlattice.md)
- ![Shortcut Menu](nested/qstudio_structtools_rebuild.png)：[Create a new lattice](./qstudio_manual_settings_newlattice.md)

---

- ![Shortcut Menu](nested/qstudio_structtools_addatom.png)：[Add Atoms](./qstudio_manual_build_addatom.md)
- ![Shortcut Menu](nested/qstudio_structtools_element.png)：[Modify Atoms](./qstudio_manual_build.md)
- ![Shortcut Menu](nested/qstudio_structtools_hydrogen.png)：[Automatic hydrogenation](./qstudio_manual_build.md)

---

- ![Shortcut Menu](nested/qstudio_structtools_dragatom.png)：Click to enter the drag-and-drop atom mode, and hold the left button on the atom to drag the atom to move
- ![Shortcut Menu](nested/qstudio_structtools_dragmol.png)：Click to enter the drag molecule mode, and hold down the left button on the molecule to drag the molecule to move
- ![Shortcut Menu](nested/qstudio_structtools_trans&rot.png)：Translation and rotation
![Shortcut Menu](nested/qstudio_structtools_trans&rot2.png)
  - Translate: Move the selected atom up, down, left, or right along the current viewing angle, based on the set distance
  - Rotation: Rotates the selected atom along or orthogonal to the current viewing angle, depending on the set angle, with the center of mass of the selected atom at the center of the selected atom
- ![Shortcut Menu](nested/qstudio_structtools_movegroup.png)：Move the entire group
![Shortcut Menu](nested/qstudio_structtools_movegroup2.png)
  - Move：The group to be moved and the fiducial point to move, which can be the centroid of the selected group or an atom
  - To：The destination location to move to can be a group's centroid, best-fit line, best-fit surface, or custom fractional or Cartesian coordinates
- ![Shortcut Menu](nested/qstudio_structtools_moveup.png)：Moves the selected atoms up from the current viewing angle, based on the set distance
- ![Shortcut Menu](nested/qstudio_structtools_movedn.png)：Based on the set distance, moves the selected atoms down in the current viewing angle
- ![Shortcut Menu](nested/qstudio_structtools_moveleft.png)：Moves the selected atoms to the left along the current viewing angle, based on the set distance
- ![Shortcut Menu](nested/qstudio_structtools_moveright.png)：Depending on the set distance, moves the selected atoms to the right along the current viewing angle


---

- ![Shortcut Menu](nested/qstudio_structtools_calcbond.png)：
![Shortcut Menu](nested/qstudio_structtools_calcbond2.png)
  - Calculate Chemical Bonds: The default option for the tool
  - Chemical bond options:
![Shortcut Menu](nested/qstudio_structtools_calcbond3.png)
    - From：When the distance between atoms is less than the ideal bond length (according to the covalent radius) multiplied by the From coefficient, no chemical bond is formed
    - To：When the distance between atoms is greater than the ideal bond length (according to the covalent radius) multiplied by the To coefficient, no chemical bond is formed
  - Delete chemical bonds: Deletes all chemical bonds between selected atoms; If no atom is selected, all chemical bonds in the structure are deleted
  - Monitor bonding: When checked, it will automatically monitor the formation of chemical bonds after any atomic operation
- ![Shortcut Menu](nested/qstudio_structtools_calchbond.png)：Calculate hydrogen bonds
- ![Shortcut Menu](nested/qstudio_structtools_breakbond.png)：Delete all bonds in the structure
- ![Shortcut Menu](nested/qstudio_structtools_bondorder.png)：Modify the bonding type of the selected atom, which can be single, partially double, double, or triple

---

- ![Shortcut Menu](nested/qstudio_structtools_measuredistance.png)：Measure distance
- ![Shortcut Menu](nested/qstudio_structtools_measureangle.png)：Measure angle
- ![Shortcut Menu](nested/qstudio_structtools_measuretorsion.png)：Measure the dihedral angle
- ![Shortcut Menu](nested/qstudio_structtools_clearmeasure.png)：Clear the measurements

:::tip NOTE：
Hover over the corresponding icon to display the corresponding function
:::
