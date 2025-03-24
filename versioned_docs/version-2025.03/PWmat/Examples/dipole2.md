# Transition dipole moment calculation include local field

Transition dipole moment calculaton in CsPbI3.

There are four steps, the first step is "**SCF**" calculation, the second is "**NONSCF**" calculation, the third is "**MOMENT**" calculation, and the fourth step is to process the data with TDM.x tool.

## First Step: "SCF" calculation

### Input files

atom.config

```dotnetcli
     5
 LATTICE
      6.39011884     0.00000000     0.00000000
      0.00000000     6.39011884     0.00000000
      0.00000000     0.00000000     6.39011884
 POSITION
  55     0.50000000     0.50000000     0.50000000 1 1 1
  82     0.00000000     0.00000000     0.00000000 1 1 1
  53     0.00000000     0.00000000     0.50000000 1 1 1
  53     0.50000000     0.00000000     0.00000000 1 1 1
  53     0.00000000     0.50000000     0.00000000 1 1 1
```

etot.input

```dotnetcli
 4  1
 JOB = SCF
 IN.PSP1 = Cs.SG15.PBE.UPF
 IN.PSP2 = Pb-d.SG15.PBE.UPF
 IN.PSP3 = I.SG15.PBE.UPF
 IN.ATOM = atom.config
 CONVERGENCE = difficult
 Ecut = 50
 Ecut2 = 100
 MP_N123 = 5 5 5 0 0 0
```

Cs.SG15.PBE.UPF, Pb-d.SG15.PBE.UPF, I.SG15.PBE.UPF

### Calculations

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

## Second Step: "NONSCF" calculation

### Input files

atom.config

```dotnetcli
     5
 LATTICE
      6.39011884     0.00000000     0.00000000
      0.00000000     6.39011884     0.00000000
      0.00000000     0.00000000     6.39011884
 POSITION
  55     0.50000000     0.50000000     0.50000000 1 1 1
  82     0.00000000     0.00000000     0.00000000 1 1 1
  53     0.00000000     0.00000000     0.50000000 1 1 1
  53     0.50000000     0.00000000     0.00000000 1 1 1
  53     0.00000000     0.50000000     0.00000000 1 1 1

```

etot.input

```dotnetcli
 4  1
 JOB = NONSCF
 IN.PSP1 = Cs.SG15.PBE.UPF
 IN.PSP2 = Pb-d.SG15.PBE.UPF
 IN.PSP3 = I.SG15.PBE.UPF
 IN.ATOM = atom.config
 Ecut = 50
 Ecut2 = 100
 IN.VR = T
 IN.KPT = T
```

:::tip

1. How to get IN.VR and IN.KPT, please refer to the example [Bandstructure calculation](/next/PWmat/Examples/Bandsctructure).
2. The file gen.kpt:

```dotnetcli
BAND                      # COMMENT line
20                      # number of k-points between X and R
0.000  0.500  0.000  X  # reciprocal coordinates; label 'X' for X point
0.500  0.500  0.500  R
20
0.500  0.500  0.500  R
0.500  0.500  0.000  M
20
0.500  0.500  0.000  M
0.000  0.000  0.000  G
20
0.000  0.000  0.000  G
0.500  0.500  0.500  R
```

:::

Cs.SG15.PBE.SOC.UPF, Pb-d.SG15.PBE.SOC.UPF, I.SG15.PBE.UPF

### Calculations

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

## Third Step: "MOMENT" calculation

### Input files

atom.config

```dotnetcli
     5
 LATTICE
      6.39011884     0.00000000     0.00000000
      0.00000000     6.39011884     0.00000000
      0.00000000     0.00000000     6.39011884
 POSITION
  55     0.50000000     0.50000000     0.50000000 1 1 1
  82     0.00000000     0.00000000     0.00000000 1 1 1
  53     0.00000000     0.00000000     0.50000000 1 1 1
  53     0.50000000     0.00000000     0.00000000 1 1 1
  53     0.00000000     0.50000000     0.00000000 1 1 1

```

etot.input

```dotnetcli
 4  1
 JOB = MOMENT
 IN.PSP1 = Cs.SG15.PBE.UPF
 IN.PSP2 = Pb-d.SG15.PBE.UPF
 IN.PSP3 = I.SG15.PBE.UPF
 IN.ATOM = atom.config
 Ecut = 50
 Ecut2 = 100
 IN.WG = T
 IN.KPT = T
```

:::tip

1. Read IN.WG from previous NONSCF calculation OUT.WG.
2. IN.KPT is the same as previous NONSCF calculation.

:::

Cs.SG15.PBE.SOC.UPF, Pb-d.SG15.PBE.SOC.UPF, I.SG15.PBE.UPF

### Calculations

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

## Fourth Step: run TDM.x

### Input files

1. TDM.input

```dotnetcli
   1           #flag: possible values 0, 1. 0: no nonlocal potential; 1: nonlocal potential is taken into account
   37 38       #i,j: TDM between j and j state.
```

:::tip

1.  flag 0: TDM.x will read TDM.input, OUT.WG and OUT.GKK.
2.  flag 1: TDM.x will read TDM.input OUT.EIGEN (from NONSCF calculation) and OUT.momentK._ (_ represents multiple files)

:::

2. After run TDM.x, you will get transition_moment file:

```dotnetcli
   ikpt  X-component  Y-component  Z-component   Total(e^2*bohr^2)       X-real       X-imag       Y-real       Y-imag       Z-real       Z-imag
    1   0.1124E-10   0.4523E+02   0.5442E-11          0.4523E+02   0.2364E-05   0.2377E-05   0.6271E+01  -0.2429E+01   0.2119E-05   0.9759E-06
    2   0.3188E-11   0.4526E+02   0.6448E-11          0.4526E+02   0.1636E-05   0.7138E-06  -0.6213E+01  -0.2581E+01   0.2401E-05  -0.8256E-06
    3   0.1467E-10   0.4540E+02   0.5686E-11          0.4540E+02  -0.2051E-05  -0.3234E-05  -0.1739E+01   0.6510E+01  -0.2089E-05  -0.1150E-05
    ...
    ...
    ...
    83   0.2256E+02   0.1981E+01   0.1117E+02          0.3571E+02  -0.4708E+01  -0.6294E+00   0.1398E+01   0.1604E+00   0.3310E+01   0.4689E+00
    84   0.3497E+02   0.8254E+01   0.1196E+02          0.5519E+02   0.3534E+01  -0.4742E+01  -0.6782E+00   0.2792E+01  -0.2856E+01   0.1950E+01
    85   0.5507E+02   0.6404E+01   0.4207E+01          0.6568E+02  -0.2326E+01   0.7047E+01   0.1363E+01  -0.2132E+01   0.1990E+01  -0.4951E+00
```
