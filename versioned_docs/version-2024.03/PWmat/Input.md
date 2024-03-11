---
sidebar_position: 3
---

# Input Files

As a minimal setup, PWmat requires the user to prepare the following input files: 
**etot.input, atom.config, pseudopotential file (for example: Si.SG15.PBE.UPF)**.

If present (in the directory where the calculation runs) the following output files 
of previous runs may be read as restart information **OUT.WG** and/or **OUT.RHO** 

**(Note: you must rename IN.WG and or IN.RHO, and add the tag 
"IN.WG = T" and/or "IN.RHO = T" in etot.input)**.

Some specific features of PWmat require additional output files.