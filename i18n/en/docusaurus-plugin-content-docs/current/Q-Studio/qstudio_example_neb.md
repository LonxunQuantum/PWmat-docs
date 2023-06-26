# Modeling of transition state structures

Take the migration of lithium atoms at the hollow position on graphene as an example:

1. The initial and final structure of the completed structure optimization will be imported.
   
<table><tr>
    <td> 
        <center>
            <img src={require('./nested/qstudio_example_neb1.png').default} alt="Drawing" />
        </center>
    </td>
        <td> 
        <center>
            <img src={require('./nested/qstudio_example_neb2.png').default} alt="Drawing" />
        </center>
        </td>
</tr></table>

1. Click `Modeling` → `Transition State Structure Modeling`, select the initial and final state structure in the pop-up window, click `Auto Match`, set the number of interpolation points to 5, and click `Preview`.
   
![neb1](nested/qstudio_manual_build_neb1.png)

2. Click `Play` to observe the path, confirm that it is correct, and then click `Load`.

![neb2](nested/qstudio_manual_build_neb2.png)

3. Fine-tune the position of lithium atoms frame by frame within the new window
   
![neb1](nested/qstudio_example_neb3.png)
