# Charge system relaxation calculation

Relaxation for C-doped BN system

## Input files

atom.config

```dotnetcli
    72
 LATTICE
     14.99639988     0.00000000     0.00000000
     -7.49819994    12.98726326     0.00000000
      0.00000000     0.00000000    20.00000000
 POSITION
   5     0.05556000     0.11111000     0.25000000 1 1 1
   5     0.22221999     0.11111000     0.25000000 1 1 1
   5     0.38888998     0.11111000     0.25000000 1 1 1
   ...
   7     0.61111000     0.88889008     0.25000000 1 1 1
   7     0.77777999     0.88889008     0.25000000 1 1 1
   7     0.94444005     0.88889008     0.25000000 1 1 1
   6     0.38888999     0.44444001     0.25000000 1 1 1
```

etot.input

```dotnetcli
 4  1
 JOB = RELAX
 NUM_ELECTRON = 288
 IN.PSP1 = B.SG15.PBE.UPF
 IN.PSP2 = C.SG15.PBE.UPF
 IN.PSP3 = N.SG15.PBE.UPF
 IN.ATOM = atom.config
 RELAX_DETAIL = 1 100 0.01
 Ecut = 50
 Ecut2 = 200
 MP_N123 = 1 1 1 0 0 0
 E_ERROR = 0.0
```

:::tip

1.  NUM_ELECTRON is the total number of occupied valence electron in the system, one can use it to make the system charged.

:::

B.SG15.PBE.UPF, C.SG15.PBE.UPF, N.SG15.PBE.UPF
:::tip

   B.SG15.PEB.UPF, C.SG15.PBE.UPF, and N.SG15.PBE.UPF are the pseudopotential files.

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

>RELAXSTEPS: concisely reports about the atomic relaxation steps. A typical RELAXSTEPS file looks like:

```dotnetcli
   It=   -1 CORR E=  -0.1267760205584E+05  Av_F=  0.61E+00 M_F=  0.41E+01 dE=  0.48E-03 dRho=  0.40E-04 SCF=    33 dL=  0.00E+00 p*F=  0.00E+00 p*F0=  0.00E+00 Fch=  0.00E+00
   It=    0  NEW E=  -0.1267351064854E+05  Av_F=  0.20E+01 M_F=  0.12E+02 dE=  0.21E-03 dRho=  0.38E-04 SCF=    18 dL= -0.37E+00 p*F=  0.29E+02 p*F0= -0.90E+01 Fch=  0.93E+00
   It=    1 CORR E=  -0.1267810094490E+05  Av_F=  0.17E+00 M_F=  0.71E+00 dE=  0.56E-04 dRho=  0.44E-04 SCF=    11 dL= -0.95E-01 p*F=  0.12E+00 p*F0= -0.90E+01 Fch=  0.10E+01
   It=    2  NEW E=  -0.1267804036855E+05  Av_F=  0.31E+00 M_F=  0.17E+01 dE=  0.26E-03 dRho=  0.42E-04 SCF=    12 dL= -0.83E-01 p*F=  0.36E+01 p*F0= -0.24E+01 Fch=  0.92E+00
   ...
   It=   16 CORR E=  -0.1267817922913E+05  Av_F=  0.21E-02 M_F=  0.67E-02 dE=  0.54E-04 dRho=  0.14E-04 SCF=     2 dL= -0.55E-03 p*F= -0.41E-02 p*F0= -0.60E-01 Fch=  0.72E+00
   It=   17 *END E=  -0.1267817922913E+05  Av_F=  0.21E-02 M_F=  0.67E-02 dE=  0.54E-04 dRho=  0.14E-04 SCF=     2 dL= -0.55E-03 p*F= -0.41E-02 p*F0= -0.60E-01 Fch=  0.72E+00
```

>REPORT: more detailed information about every electronic and ionic step

3. Other important files.

>final.config: holds the structure of the last ionic step, the structural result (also very important for restarting a relaxation)

>MOVEMENT: holds the structures of every ionic step during relaxations.