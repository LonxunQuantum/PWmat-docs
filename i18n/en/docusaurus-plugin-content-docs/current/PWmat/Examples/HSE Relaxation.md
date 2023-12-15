# HSE Relaxation calculation

HSE Relaxation calculation for GaAs

## Input files

atom.config

```dotnetcli
    8
 LATTICE
      5.65315000     0.00000000     0.00000000
      0.00000000     5.65315000     0.00000000
      0.00000000     0.00000000     5.65315000
 POSITION
  31     0.01000000     0.00000000     0.00000000 1 1 1
  31     0.00000000     0.50000000     0.50000000 1 1 1
  31     0.50000000     0.00000000     0.50000000 1 1 1
  31     0.50000000     0.50000000     0.00000000 1 1 1
  33     0.25000000     0.25000000     0.25000000 1 1 1
  33     0.75000000     0.75000000     0.25000000 1 1 1
  33     0.75000000     0.25000000     0.75000000 1 1 1
  33     0.25000000     0.75000000     0.75000000 1 1 1
```

etot.input

```dotnetcli
   4 1
   JOB = RELAX
   IN.PSP1 = Ga.SG15.PBE.UPF
   IN.PSP2 = As.SG15.PBE.UPF
   IN.ATOM = atom.config
   RELAX_DETAIL = 1 100 0.03
   Ecut = 60
   Ecut2 = 240
   MP_N123 = 3 3 3 0 0 0
   XCFUNCTIONAL = HSE
```

As.SG15.PBE.UPF, Ga.SG15.PBE.UPF

:::tip
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

2. For HSE RELAXATION calculation, files to watch during relaxations.

> RELAXSTEPS: concisely reports about the atomic relaxation steps. A typical RELAXSTEPS file looks like:

```dotnetcli
   HSE  -1  CORR E= -0.7770750113988E+04 Av_F= 0.16E+00 M_F= 0.64E+00 dE=.8E-05 dRho=.3E-04 SCF=32 dL=0.23-309 p*F= 0.00E+00 p*F0= 0.00E+00 Fch= 0.00E+00
   It=  -1 TRIAL E= -0.7770750113988E+04 Av_F= 0.16E+00 M_F= 0.64E+00 dE=.2E-05 dRho=.2E-03 SCF= 4 dL=0.15E-01 p*F= 0.78E-01 p*F0= 0.79E-01 Fch= 0.14E-01
   It=   0 TRIAL E= -0.7770766077993E+04 Av_F= 0.27E-01 M_F= 0.89E-01 dE=.1E-03 dRho=.1E-02 SCF= 7 dL=-.59E-01 p*F=-0.91E-01 p*F0=-0.78E+00 Fch= 0.97E+00
   It=   1  CORR E= -0.7770766465024E+04 Av_F= 0.23E-01 M_F= 0.64E-01 dE=.1E-03 dRho=.6E-03 SCF= 6 dL=-.67E-01 p*F=-0.98E-02 p*F0=-0.78E+00 Fch= 0.97E+00
   It=   2  CORR E= -0.7770767180235E+04 Av_F= 0.23E-01 M_F= 0.63E-01 dE=.4E-04 dRho=.1E-02 SCF= 3 dL=-.68E-01 p*F= 0.13E-01 p*F0=-0.78E+00 Fch= 0.10E+01
   ...
   HSE  17  CORR E= -0.7770771670159E+04 Av_F= 0.90E-02 M_F= 0.24E-01 dE=.4E-05 dRho=.7E-05 SCF=12 dL=0.86E-02 p*F= 0.17E-01 p*F0=-0.64E-01 Fch= 0.93E-01
   HSE  18 *END E= -0.7770771670159E+04 Av_F= 0.90E-02 M_F= 0.24E-01 dE=.4E-05 dRho=.7E-05 SCF=12 dL=0.86E-02 p*F= 0.17E-01 p*F0=-0.64E-01 Fch= 0.93E-01
```

> REPORT: more detailed information about every electronic and ionic step

3. Other important files.

> final.config: holds the structure of the last ionic step, the structural result (also very important for restarting a relaxation)

> MOVEMENT: holds the structures of every ionic step during relaxations.
