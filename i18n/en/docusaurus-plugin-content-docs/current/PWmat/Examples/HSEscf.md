# HSE SCF calculation

HSE SCF calculation for GaAs

## Input files

atom.config

```dotnetcli
    8
 LATTICE
      5.65315000     0.00000000     0.00000000
      0.00000000     5.65315000     0.00000000
      0.00000000     0.00000000     5.65315000
 POSITION
  31     0.00000000     0.00000000     0.00000000 0 0 0
  31     0.00000000     0.50000000     0.50000000 0 0 0
  31     0.50000000     0.00000000     0.50000000 0 0 0
  31     0.50000000     0.50000000     0.00000000 0 0 0
  33     0.25000000     0.25000000     0.25000000 0 0 0
  33     0.75000000     0.75000000     0.25000000 0 0 0
  33     0.75000000     0.25000000     0.75000000 0 0 0
  33     0.25000000     0.75000000     0.75000000 0 0 0
```

:::tip Note

1.  atom.config file describles the cell box, atomic postitions, etc.
2.  8 atoms per unit cell.
3.  LATTICE: the header of the lattice vector.
4.  POSITION: the header of the atomic positions.

:::

etot.input

```dotnetcli
   4 1
   JOB = SCF
   IN.PSP1 = Ga.SG15.PBE.UPF
   IN.PSP2 = As.SG15.PBE.UPF
   IN.ATOM = atom.config
   MP_N123 = 4 4 4 0 0 0
   XCFUNCTIONAL = HSE
```

:::tip Note

1.  The product of the two integers on the first line must equal to the number of GPU to run PWmat.
2.  MP_N123 is the Monkhorst-Pack grids to generate the reduced k-points, so no additional k-points file is required.
3.  XCFUNCTONAL is used to control the exchange-correlation functinal, default value is PBE. If XCFUNCTIONAL = HSE, PWmat will do HSE calculation.

:::

As.SG15.PBE.UPF, Ga.SG15.PBE.UPF

:::tip Note
As.SG15.PEB.UPF and Ga.SG15.PBE.UPF are the pseudopotential files.
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

2. For HSE SCF calculation, the main output is REPORT file, you can read total energy and calculation time from it.

```dotnetcli
   grep "E_tot(eV)" REPORT | tail -1
   > E_tot(eV)    = -.77693865319460E+04    -.2797E-04
```

```dotnetcli
   grep "total computation time" REPORT
   > total computation time (sec)=   140.374799013138
```
