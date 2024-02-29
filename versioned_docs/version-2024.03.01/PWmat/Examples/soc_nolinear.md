# Spin-orbit coupling with noncollinear magnetization calculation

Spin-orbit coupling with noncollinear magnetization scf calculation for Fe

## Input files

atom.config

```dotnetcli
     1
 LATTICE
      1.43407025     1.43407025     1.43407025
     -1.43407025     1.43407025     1.43407025
     -1.43407025    -1.43407025     1.43407025
 POSITION
  26     0.00000000     0.00000000     0.00000000 0 0 0
 MAGNETIC_XYZ
  26  0 0 6
```

:::tip

MAGNETIC_XYZ: specifies the initial magnetic moment in atom.config

:::

etot.input

```dotnetcli
 1  4
 JOB = SCF
 CONVERGENCE = difficult
 IN.PSP1 = Fe.SG15.PBE.SOC.UPF
 IN.ATOM = atom.config
 SPIN = 222
 Ecut = 50
 MP_N123 = 8 8 8 0 0 0 2 #NK1, NK2, NK3, SK1, SK2, SK3, FLAG_SYMM
 XCFUNCTIONAL = PBE
```

:::tip

1.Spin: specifies spin polarization, 222:Spin-orbit coupling with noncollinear magnetization.
2.FLAG_SYMM: controls the symmetry operation, possible values:0, 1, 2, 3. 2 means: generate kpoints without any symmetry.

:::

Cd.SG15.PBE.SOC.UPF, Se.SG15.PBE.SOC.UPF

:::tip

Spin-orbit pseudopotential files need to be used.

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

2. After SCF calculation, you can read the final megnetic moment from REPORT or OUT.ATOMSPIN file.

```dotnetcli
grep "spin_xyz" REPORT | tail -1
```

```
>>>spin_xyz      = 0.49661188020102E-05  -.48919186091819E-05  0.24426253634560E+01
```

OUT.ATOMSPIN:

```dotnetcli
     magnetization

 # of ion     x       y      z      tot_charge
 --------------------------------
  1         0.000  -0.000   2.443   16.000
 --------------------------------
 tot_cell    0.000  -0.000   2.443  16.000
```
