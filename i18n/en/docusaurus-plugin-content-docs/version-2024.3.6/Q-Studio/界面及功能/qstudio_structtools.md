---
sidebar_position: 1
---

# Shortcut structure tools

![Shortcut Menu](../nested/qstudio_structtools.png)

- ![Shortcut Menu](../nested/qstudio_structtools_addwindow.png)：[New](./菜单/qstudio_manual_file.md)
- ![Shortcut Menu](../nested/qstudio_structtools_import.png)：[Import From Local](./菜单/qstudio_manual_file.md)
- ![Shortcut Menu](../nested/qstudio_structtools_undo.png)：[Undo](./菜单/qstudio_manual_edit.md)
- ![Shortcut Menu](../nested/qstudio_structtools_redo.png)：[Redo](./菜单/qstudio_manual_edit.md)

---

- ![Shortcut Menu](../nested/qstudio_structtools_display.png)：[Display style](./菜单/qstudio_manual_view_display.md)
- ![Shortcut Menu](../nested/qstudio_structtools_select.png)：Selection Mode
- ![Shortcut Menu](../nested/qstudio_structtools_rotate.png)：Rotation Mode
- ![Shortcut Menu](../nested/qstudio_structtools_translate.png)：Translation Mode
- ![Shortcut Menu](../nested/qstudio_structtools_residue.png)：Select residues only takes in the protein structure

---

- ![Shortcut Menu](../nested/qstudio_structtools_symmetry.png)：[Find Symmetry](./菜单/qstudio_manual_settings_symmtry_findsymmetry.md)
- ![Shortcut Menu](../nested/qstudio_structtools_lattice.png)：[Lattice Parameters](./菜单/qstudio_manual_settings_latticeconstant.md)
- ![Shortcut Menu](../nested/qstudio_structtools_unbuild.png)：[Remove lattice](./菜单/qstudio_manual_settings_newlattice.md)
- ![Shortcut Menu](../nested/qstudio_structtools_rebuild.png)：[Build lattice](./菜单/qstudio_manual_settings_newlattice.md)

---

- ![Shortcut Menu](../nested/qstudio_structtools_addatom.png)：[Add Atoms](./菜单/qstudio_manual_build_addatom.md)
- ![Shortcut Menu](../nested/qstudio_structtools_element.png)：[Modify Element](./菜单/qstudio_manual_build.md)
- ![Shortcut Menu](../nested/qstudio_structtools_hydrogen.png)：[Adjust Hydrogen](./菜单/qstudio_manual_build.md)

---

- ![Shortcut Menu](../nested/qstudio_structtools_dragatom.png)：Click to activate the Drag Atom Mode, and hold the left button on the atom to drag the atom to move
- ![Shortcut Menu](../nested/qstudio_structtools_dragmol.png)：Click to activate the Drag Molecule Mode, and hold down the left button on the molecule to drag the molecule to move
- ![Shortcut Menu](../nested/qstudio_structtools_trans&rot.png)：Translation and rotation
  - Translation: Move the selected atom up, down, left, or right along the current viewing angle, based on the set distance
  - Rotation: Rotates the selected atom along or orthogonal to the current viewing angle, depending on the set angle, with the center of mass of the selected atom at the center of the selected atom

 
  ![Shortcut Menu](../nested/qstudio_structtools_trans&rot2.png)

- ![Shortcut Menu](../nested/qstudio_structtools_movegroup.png)：Group Movement
  - Move：The group to be moved and the fiducial point to move, which can be the centroid of the selected group or an atom
  - To：The destination location to move to can be a group's centroid, best-fit line, best-fit plane, or custom fractional or Cartesian coordinates

  ![Shortcut Menu](../nested/qstudio_structtools_movegroup2.png)

- ![Shortcut Menu](../nested/qstudio_structtools_moveup.png)：Moves the selected atoms up from the current viewing angle, based on the set distance
- ![Shortcut Menu](../nested/qstudio_structtools_movedn.png)：Based on the set distance, moves the selected atoms down in the current viewing angle
- ![Shortcut Menu](../nested/qstudio_structtools_moveleft.png)：Moves the selected atoms to the left along the current viewing angle, based on the set distance
- ![Shortcut Menu](../nested/qstudio_structtools_moveright.png)：Depending on the set distance, moves the selected atoms to the right along the current viewing angle


---

- ![Shortcut Menu](../nested/qstudio_structtools_calcbond.png)：calculate cheminal bonds
  
  ![Shortcut Menu](../nested/qstudio_structtools_calcbond2.png)

  - Calculate Bonds: The default option for the tool
  - Bond Option:
    - From：When the distance between atoms is less than the ideal bond length (according to the covalent radius) multiplied by the From coefficient, no chemical bond is formed
    - To：When the distance between atoms is greater than the ideal bond length (according to the covalent radius) multiplied by the To coefficient, no chemical bond is formed
  
    ![Shortcut Menu](../nested/qstudio_structtools_calcbond3.png)

  - Delete bonds: Deletes all chemical bonds between selected atoms; If no atom is selected, all chemical bonds in the structure are deleted
  - Monitor bonding: When checked, it will automatically monitor the formation of chemical bonds after any atomic operation

- ![Shortcut Menu](../nested/qstudio_structtools_calchbond.png)：Calculate hydrogen bonds
- ![Shortcut Menu](../nested/qstudio_structtools_breakbond.png)：Delete all bonds in the structure
- ![Shortcut Menu](../nested/qstudio_structtools_bondorder.png)：Modify the bonding type of the selected atom, which can be single, partial double, double, triple or aromatic

---

- ![Shortcut Menu](../nested/qstudio_structtools_measuredistance.png)：Measure distance
- ![Shortcut Menu](../nested/qstudio_structtools_measureangle.png)：Measure angle
- ![Shortcut Menu](../nested/qstudio_structtools_measuretorsion.png)：Measure torsion
- ![Shortcut Menu](../nested/qstudio_structtools_clearmeasure.png)：Clear the measurements

:::tip NOTE：
Hover over the corresponding icon to display the corresponding function
:::
