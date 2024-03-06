---
sidebar_position: 7
---

# Transition state structure

Take the transition of lithium atoms at the hollow position on graphene as an example:

1. The initial and final structure of the completed structure optimization will be imported.
   
<table><tr>
    <td> 
        <center>
            <img src={require('../nested/qstudio_example_neb1.png').default} alt="Drawing" />
        </center>
    </td>
        <td> 
        <center>
            <img src={require('../nested/qstudio_example_neb2.png').default} alt="Drawing" />
        </center>
        </td>
</tr></table>

2. Click `Build` → `Build Transition State Structure`, select the initial and final state structure in the pop-up window, click `Auto Find`, set the `Images` to 5, and click `preview`.
   
![neb1](../nested/qstudio_manual_build_neb1.png)

3. Play the path to observe, confirm that it is correct, and then click `Load`.

![neb2](../nested/qstudio_manual_build_neb2.png)

4. Fine-tune the position of lithium atoms frame by frame within the new window
   
![neb1](../nested/qstudio_example_neb3.png)
