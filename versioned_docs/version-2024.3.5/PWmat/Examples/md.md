# Ab Initio Molecular Dynamics

Ab Initio Molecular Dynamics calculation for Cu-Au alloy

## Input files

atom.config

```dotnetcli
    32
 LATTICE
      7.68000000     0.00000000     0.00000000
      0.00000000     7.68000000     0.00000000
      0.00000000     0.00000000     7.68000000
 POSITION
  79     0.25000000     0.25000000     0.00000000 1 1 1
  79     0.00000000     0.25000000     0.75000000 1 1 1
  79     0.75000000     0.25000000     0.50000000 1 1 1
  ...
  29     0.25000000     0.50000000     0.75000000 1 1 1
  29     0.00000000     0.50000000     0.50000000 1 1 1
  29     0.75000000     0.50000000     0.75000000 1 1 1

```

etot.input

```dotnetcli
   4  1
   JOB = MD
   IN.PSP1 = Cu.SG15.PBE.UPF
   IN.PSP2 = Au.SG15.PBE.UPF
   IN.ATOM = atom.config
   MD_DETAIL = 1 100 1 300 300 #MD, MSTEP, DT, TEMP1, TEMP2
   MP_N123 = 1 1 1 0 0 0 2

```

:::tip

1.  MD_DETAIL: controls the molecular dynamics details.
2.  MD: the method of MD algorithm, 1: Verlet(NVE).
3.  MSTEP: the number of MD stpes.
4.  DT: the time length for each MD step (fs, 1fs=1.0E-15s).
5.  TEMP1, TEMP2: the beginning and final temperature (in Kelvin).

:::

Cu.SG15.PBE.UPF, Au.SG15.PBE.UPF

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

2. For MD calculation, files to watch during relaxations.

>MDSTEPS: concisely reports about the atomic relaxation steps. A typical RELAXSTEPS file looks like:

```dotnetcli
   Iter(fs)=  0.100000E+01 Etot,Ep,Ek(eV)=   -0.1391631878E+06  -0.1391656624E+06   0.2474566470E+01 Temp(K)=       598.25336 aveTemp(K)=       598.25336 dE= 0.10E-02 dRho= 0.32E-03 SCF=    6 dL= 0.75E-02 Fcheck= 0.973E+00
   Iter(fs)=  0.200000E+01 Etot,Ep,Ek(eV)=   -0.1391631867E+06  -0.1391656490E+06   0.2462251387E+01 Temp(K)=       595.27606 aveTemp(K)=       596.76471 dE= -.82E-03 dRho= 0.23E-03 SCF=    3 dL= 0.75E-02 Fcheck= 0.921E+00
   Iter(fs)=  0.300000E+01 Etot,Ep,Ek(eV)=   -0.1391631839E+06  -0.1391656291E+06   0.2445185018E+01 Temp(K)=       591.15008 aveTemp(K)=       594.89316 dE= -.84E-03 dRho= 0.18E-03 SCF=    3 dL= 0.74E-02 Fcheck= 0.860E+00
   ...
   Iter(fs)=  0.980000E+02 Etot,Ep,Ek(eV)=   -0.1391631836E+06  -0.1391647989E+06   0.1615347915E+01 Temp(K)=       390.52793 aveTemp(K)=       464.12570 dE= -.90E-02 dRho= 0.43E-04 SCF=    2 dL= 0.57E-02 Fcheck= 0.893E+00
   Iter(fs)=  0.990000E+02 Etot,Ep,Ek(eV)=   -0.1391631835E+06  -0.1391648020E+06   0.1618521791E+01 Temp(K)=       391.29525 aveTemp(K)=       463.39004 dE= -.18E-01 dRho= 0.40E-04 SCF=    2 dL= 0.57E-02 Fcheck= 0.102E+01
   Iter(fs)=  0.100000E+03 Etot,Ep,Ek(eV)=   -0.1391631880E+06  -0.1391648061E+06   0.1618121193E+01 Temp(K)=       391.19840 aveTemp(K)=       462.66812 dE= -.26E-01 dRho= 0.33E-04 SCF=    2 dL= 0.57E-02 Fcheck= 0.974E+00
```

>REPORT: more detailed information about every electronic and MD step

3. Other important files.

>final.config: holds the structure of the last MD step.

>MOVEMENT: holds the structures of every MD steps.