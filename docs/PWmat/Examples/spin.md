# Spin-polarized calculation

Spin-polarized calculation for Ni

## Input files

atom.config

```dotnetcli
     1
 LATTICE
      0.00000000     1.76200000     1.76200000
      1.76200000     0.00000000     1.76200000
      1.76200000     1.76200000     0.00000000
 POSITION
  28     0.00000000     0.00000000     0.00000000 0 0 0
```

etot.input

```dotnetcli
   1  4
   JOB = SCF
   IN.PSP1 = Ni.SG15.PBE.UPF
   IN.ATOM = atom.config
   SPIN = 2
   Ecut = 50
   MP_N123 = 12 12 12 0 0 0
```

:::tip

1.  Spin: specifies spin polarization, 1:non-spin-polarized calculations, 2:spin-polarized calculations (collinear).

:::

Ni.SG15.PBE.UPF
:::tip

Ni.SG15.PEB.UPF is the pseudopotential file.

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

2. For spin-polarized calculations (collinear), the main output is REPORT file, you can read magnetic moment from it.

```dotnetcli
   grep "spin_up;dn;loc_diff" REPORT | tail -1
```
```
>>> spin_up;dn;loc_diff  =       9.3432875202        8.6567124798        0.7832247298
```
