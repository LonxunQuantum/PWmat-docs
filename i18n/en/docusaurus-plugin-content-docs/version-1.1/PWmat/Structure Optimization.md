# Crystal Structure Optimization (only relax atomic position)

RELAXATION calculation for Si, only relax atomic postion

## Input files

atom.config

```dotnetcli
     2
 LATTICE
      0.00000000     2.73899206     2.73899206
      2.73899206     0.00000000     2.73899206
      2.73899206     2.73899206     0.00000000
 POSITION
  14     0.00000000     0.00000000     0.00000000 0 0 0 #Zatom x1 x2 x3 imv1 imv2 imv3
  14     0.25000000     0.23000000     0.25000000 1 1 1
```

:::tip note

1.  atom.config file describles the cell box, atomic postitions, etc.
2.  2 atoms per unit cell.
3.  LATTICE: the header of the lattice vector.
4.  POSITION: the header of the atomic positions.
5.  Zatom: the atomic number of this atom.
6.  x1, x2, x3 are the fractional coordinate of this atom
7.  imv1, imv2, imv3 indicate whether this atom will move in x, y, z directions, 1 means move; 0 means not move.

:::

## etot.input

```dotnetcli
   1 4
   JOB = RELAX
   IN.PSP1 = Si.SG15.PBE.UPF
   IN.ATOM = atom.config
   RELAX_DETAIL = 1 100 0.005 #IMTH, NSTEP, FORCE_TOL
   ECUT = 50
   ECUT2= 200
   MP_N123 = 9 9 9 0 0 0
```

:::tip

1.  The product of the two integers on the first line must equal to the number of GPU to run PWmat.
2.  ECUT is the plane wave cutoff energy of wavefunction (in _Ryd_, note: 1 _Ryd_ = 13.6057 _eV_)
3.  MP_N123 is the Monkhorst-Pack grids to generate the reduced k-points, so no additional k-points file is required.
4.  RELAX_DETAIL: controls the atomic relaxation details.
5.  IMTH: the method of relaxtion, 1: conjugated gradient.
6.  NSTEP: the maximum number of relaxation stpes.
7.  FORCE_TOL: the force tolenrance for the maximal redidual force (eV/A).

:::
Si.SG15.PBE.UPF

:::tip
Si.SG15.PEB.UPF is the pseudopotential file.
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

2. For RELAXATION calculation, files to watch during relaxations.

> RELAXSTEPS: concisely reports about the atomic relaxation steps. A typical RELAXSTEPS file looks like:

```dotnetcli
   It=   -1 CORR E=  -0.2144796997311E+03  Av_F=  0.58E+00 M_F=  0.71E+00 dE=  0.42E-05 dRho=  0.83E-04 SCF=    13 dL=  0.00E+00 p*F=  0.00E+00 p*F0=  0.00E+00 Fch=  0.00E+00
   It=    0  NEW E=  -0.2145128948737E+03  Av_F=  0.22E+00 M_F=  0.26E+00 dE=  0.20E-05 dRho=  0.30E-04 SCF=     6 dL=  0.92E-01 p*F= -0.37E+00 p*F0= -0.10E+01 Fch=  0.10E+01
   It=    1 CORR E=  -0.2145181062288E+03  Av_F=  0.57E-01 M_F=  0.98E-01 dE=  0.88E-06 dRho=  0.13E-04 SCF=     5 dL=  0.15E+00 p*F=  0.52E-03 p*F0= -0.10E+01 Fch=  0.99E+00
   It=    2  NEW E=  -0.2145184522502E+03  Av_F=  0.18E-01 M_F=  0.31E-01 dE=  0.59E-05 dRho=  0.32E-04 SCF=     4 dL=  0.10E-01 p*F= -0.30E-01 p*F0= -0.98E-01 Fch=  0.10E+01
   ...
   It=    7  NEW E=  -0.2145184866505E+03  Av_F=  0.14E-02 M_F=  0.17E-02 dE=  0.24E-05 dRho=  0.16E-04 SCF=     2 dL= -0.10E-02 p*F= -0.25E-02 p*F0= -0.94E-02 Fch= -0.22E+01
   It=    8 *END E=  -0.2145184866505E+03  Av_F=  0.14E-02 M_F=  0.17E-02 dE=  0.24E-05 dRho=  0.16E-04 SCF=     2 dL= -0.10E-02 p*F= -0.25E-02 p*F0= -0.94E-02 Fch= -0.22E+01
```

> REPORT: more detailed information about every electronic and ionic step

3. Other important files.

>final.config: holds the structure of the last ionic step, the structural result (also very important for restarting a relaxation)

>MOVEMENT: holds the structures of every ionic step during relaxations.