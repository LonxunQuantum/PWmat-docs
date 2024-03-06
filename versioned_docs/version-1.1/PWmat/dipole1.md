# Transition dipole moment calculation exclude local field

Transition dipole moment calculaton in CsPbI3.

There are four steps, the first step is "**SCF**" calculation, the second is "**NONSCF**" calculation, the third is "**DOS**" calculation, and the fourth step is to process the data with TDM.x tool.

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

1.  How to get IN.VR and IN.KPT, please refer to the example [Bandstructure calculation](/1.1/PWmat/Bandsctructure).
2.  The file gen.kpt:

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

## Third Step: "DOS" calculation

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
 JOB = DOS
 IN.PSP1 = Cs.SG15.PBE.UPF
 IN.PSP2 = Pb-d.SG15.PBE.UPF
 IN.PSP3 = I.SG15.PBE.UPF
 IN.ATOM = atom.config
 Ecut = 50
 Ecut2 = 100
 Ecutp = 100
 IN.WG = T
 IN.KPT = T
```

:::tip

1. Read IN.WG from previous NONSCF calculation OUT.WG.
2. You also need copy OUT.EIGEN and OUT.FERMI from previous NONSCF calculation.
3. IN.KPT is the same as previous NONSCF calculation.

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

TDM.input

```dotnetcli
   0           #flag: possible values 0, 1. 0: no nonlocal potential; 1: nonlocal potential is taken into account
   37 38       #i,j: TDM between j and j state.
```

:::tip

1.  flag 0: TDM.x will read TDM.input, OUT.WG, OUT.EIGEN and OUT.GKK.
2.  flag 1: TDM.x will read TDM.input and OUT.momentK._ (_ represents multiple files)

:::

2. After run TDM.x, you will get transition_moment file:
```dotnetcli
    ikpt  X-component  Y-component  Z-component   Total(e^2*bohr^2)       X-real       X-imag       Y-real       Y-imag       Z-real       Z-imag
    1   0.7198E-11   0.2949E+02   0.4606E-11          0.2949E+02  -0.1739E-05   0.2043E-05   0.1961E+01   0.5064E+01  -0.6900E-06   0.2032E-05
    2   0.6357E-12   0.2951E+02   0.3241E-11          0.2951E+02  -0.5834E-06   0.5435E-06   0.2084E+01  -0.5017E+01   0.6696E-06   0.1671E-05
    3   0.1115E-10   0.2962E+02   0.4501E-11          0.2962E+02   0.2978E-05  -0.1510E-05  -0.5258E+01  -0.1404E+01   0.9306E-06  -0.1907E-05
    ...
    ...
    ...
    83   0.1498E+02   0.1315E+01   0.7419E+01          0.2371E+02   0.5129E+00  -0.3836E+01  -0.1307E+00   0.1139E+01  -0.3821E+00   0.2697E+01
    84   0.2322E+02   0.5479E+01   0.7938E+01          0.3663E+02   0.3863E+01   0.2879E+01  -0.2275E+01  -0.5526E+00  -0.1589E+01  -0.2327E+01
    85   0.3655E+02   0.4251E+01   0.2792E+01          0.4359E+02  -0.5741E+01  -0.1895E+01   0.1737E+01   0.1111E+01   0.4033E+00   0.1622E+01
```