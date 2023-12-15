# SCF calculation

SCF calculation for Si

## Input files

atom.config

```dotnetcli
        2
 LATTICE
      0.00000000     2.71535000     2.71535000
      2.71535000     0.00000000     2.71535000
      2.71535000     2.71535000     0.00000000
 POSITION
  14     0.00000000     0.00000000     0.00000000 0 0 0
  14     0.25000000     0.25000000     0.25000000 0 0 0

```

:::tip Note
   1. atom.config file describles the cell box, atomic postitions, etc.
   2. 2 atoms per unit cell.
   3. LATTICE: the header of the lattice vector.
   4. POSITION: the header of the atomic positions. 
:::

etot.input

```dotnetcli
   1 4
   JOB = SCF
   IN.PSP1 = Si.SG15.PBE.UPF
   IN.ATOM = atom.config
   ECUT = 50
   MP_N123 = 9 9 9 0 0 0
```

:::tip Note
   1. The product of the two integers on the first line must equal to the number of GPU to run PWmat.
   2. ECUT is the plane wave cutoff energy of wavefunction (in *Ryd*, note: 1 *Ryd* = 13.6057 *eV*)
   3. MP_N123 is the Monkhorst-Pack grids to generate the reduced k-points, so no additional k-points file is required. 
:::

Si.SG15.PBE.UPF
:::tip Note
   Si.SG15.PEB.UPF is the pseudopotential file.
:::

## Calculations

1.You can submit PWmat tasks in different ways:

```dotnetcli
   mpirun -np 4 PWmat | tee output
```
:::tip Note
   Run the command directly
:::

---

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

2. For SCF calculation, the main output is REPORT file, you can read total energy and calculation time from it.

```dotnetcli
   grep "E_tot(eV)" REPORT | tail -1
   > E_tot(eV)    = -.21456142286654E+03    -.3243E-05
```

```dotnetcli
   grep "total computation time" REPORT 
   > total computation time (sec)=   10.0428440570831
```

## Download

[Si_SCF_Cal](https://github.com/LonxunQuantum/Q-CAD-documentations/blob/master/source/Examples/examples/Si_SCF_Cal.tar.gz)