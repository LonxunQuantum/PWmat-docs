# DFT+U Calculation

DFT+U calculation for NiO

## Input files

atom.config

```dotnetcli
           4
 Lattice vector
       4.1700000000      2.0850000000      2.0850000000
       2.0850000000      4.1700000000      2.0850000000
       2.0850000000      2.0850000000      4.1700000000
 Position, move_x, move_y, move_z
   28    0.000000000000    0.000000000000    0.000000000000  0  0  0
   28    0.500000000000    0.500000000000    0.500000000000  0  0  0
    8    0.250000000000    0.250000000000    0.250000000000  0  0  0
    8    0.750000000000    0.750000000000    0.750000000000  0  0  0
```

etot.input

```dotnetcli
   1  4
   JOB = SCF
   IN.PSP1 = O.SG15.PBE.UPF
   IN.PSP2 = Ni.SG15.PBE.UPF
   IN.ATOM = atom.config
   SPIN = 2
   Ecut = 50
   MP_N123 = 5 5 5 0 0 0
   LDAU_PSP2 = 2 4.3 # LDAU_L, Hubbard_U, (optional Hubbard_U2)
```

:::tip
LDAU_PSP(i): specifies DFT+U method, LDAU_PSP2 means add U for Ni element. LDAU_L: selects l quantum number for which on site interaction is added; Hubbard_U: the strength of the effective on-site Coulomb interactions.
:::

O.SG15.PBE.UPF, Ni.SG15.PBE.UPF

:::tip
O.SG15.PBE.UPF, Ni.SG15.PEB.UPF are the pseudopotential files.
:::


## Calculations
1. You can submit PWmat tasks in different ways:

```dotnetcli
   mpirun -np 4 PWmat | tee output
```

:::tip Note
Run the command directly
:::

```dotnetcli
   #!/bin/bash
   #PBS -N SCF
   #PBS -l nodes=1:ppn=4
   #PBS -q batch
   #PBS -l walltime=100:00:00

   ulimit -s unlimited
   cd $PBS_O_WORKDIR

   mpirun -np 4 PWmat | tee output
```

:::tip Note
Submit the task with a pbs script
::: 

2. For DFT+U calculation, you can read total energy resulting from calculations with DFT+U.

```dotnetcli
grep "E_tot(eV)" REPORT | tail -1
>>> E_tot(eV)    = -.92278062603732E+04    -.4049E-04
```