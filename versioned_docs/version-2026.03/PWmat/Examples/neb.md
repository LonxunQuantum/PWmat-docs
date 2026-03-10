# NEB (nudged elastic band) calculation

The diffusion barrier for Li on graphene.

There are three steps, the first step is "**RELAX**" calculation for initial and final states, the second is "**SCF**" calculation, and the third is "**NEB**" calculation.

## First Step: "RELAX" calculation for initial and final states

### Initial state relaxation

#### Input files

atom.config

```dotnetcli
   51
 LATTICE
     12.30000019     0.00000000     0.00000000
     -6.15000010    10.65211263     0.00000000
      0.00000000     0.00000000    20.00000000
 POSITION
   6     0.13302763     0.06631131     0.50001912 1 1 1
   6     0.13244991     0.26622178     0.50007744 1 1 1
   6     0.13302290     0.46671968     0.50002064 1 1 1
   ...
   6     0.86685591     0.73343720     0.50000920 1 1 1
   6     0.86668410     0.93331589     0.49999358 1 1 1
   3     0.39999999     0.39999999     0.58526884 1 1 1
```

etot.input

```dotnetcli
 2  2
 JOB = RELAX
 IN.PSP1 = C.SG15.PBE.UPF
 IN.PSP2 = Li.SG15.PBE.UPF
 IN.ATOM = atom.config
 RELAX_DETAIL = 1 100 0.01
 Ecut = 50
 Ecut2 = 200
 MP_N123 = 3 3 1 0 0 0
 XCFUNCTIONAL = PBE
 SYS_TYPE = 2
```

:::tip
SYS_TYPE: specifies type of the system and automatically adjust the parameter "FERMIDE",

    1: semiconductor or insulator (default, FERMIDE=0.025);

    2: metallic (FERMIDE=0.2).

:::

C.SG15.PBE.UPF, Li.SG15.PBE.UPF

#### Calculations

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

2. Obtain the final.config file, which contains the position of the last ionic step of the relaxation, and can be used for step two "**SCF**" calculation.

### Final state relaxation

#### Input files

atom.config

```dotnetcli
   51
 LATTICE
     12.30000019     0.00000000     0.00000000
     -6.15000010    10.65211263     0.00000000
      0.00000000     0.00000000    20.00000000
 POSITION
   6     0.13330299     0.06669701     0.49998566 1 1 1
   6     0.13316367     0.26655079     0.50000705 1 1 1
   6     0.13316402     0.46660047     0.50000705 1 1 1
   ...
   6     0.86753884     0.73377247     0.50007857 1 1 1
   6     0.86696519     0.93367340     0.50002931 1 1 1
   3     0.60000002     0.60000002     0.58521177 1 1 1
```

etot.input

```dotnetcli
 2  2
 JOB = RELAX
 IN.PSP1 = C.SG15.PBE.UPF
 IN.PSP2 = Li.SG15.PBE.UPF
 IN.ATOM = atom.config
 RELAX_DETAIL = 1 100 0.01
 Ecut = 50
 Ecut2 = 200
 MP_N123 = 3 3 1 0 0 0
 XCFUNCTIONAL = PBE
 SYS_TYPE = 2
```

C.SG15.PBE.UPF, Li.SG15.PBE.UPF

#### Calculations

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

2. Obtain the final.config file, which contains the position of the last ionic step of the relaxation, and can be used for step two "**SCF**" calculation.

## Second Step: "SCF" calculation for initial and finial states

### Initial state scf

#### Input files

atom.config

```dotnetcli
       51 atoms,Iteration =   8, Etot,Ep,Ek =  -0.7946015575E+04  -0.7946015575E+04   0.0000000000E+00, Average Force=  0.15454E-02, Max force=  0.33836E-02
 Lattice vector (Angstrom), stress(eV/natom)
   0.1230000019E+02    0.0000000000E+00    0.0000000000E+00
  -0.6150000100E+01    0.1065211263E+02    0.0000000000E+00
   0.0000000000E+00    0.0000000000E+00    0.2000000000E+02
 Position, move_x, move_y, move_z
   6      0.133312758      0.066687242      0.499990024     1  1  1
   6      0.133149613      0.266557805      0.500008510     1  1  1
   6      0.133149503      0.466579100      0.500008574     1  1  1
   ...
   6      0.867547638      0.733777090      0.500077817     1  1  1
   6      0.866970187      0.933684078      0.500023723     1  1  1
   3      0.600000020      0.600000020      0.585322202     1  1  1
```

:::tip

Copy final.config from previous initial state RELAX calculation, and rename atom.config

:::

etot.input

```dotnetcli
 2  2
 JOB = SCF
 IN.PSP1 = C.SG15.PBE.UPF
 IN.PSP2 = Li.SG15.PBE.UPF
 IN.ATOM = atom.config
 Ecut = 50
 Ecut2 = 200
 MP_N123 = 3 3 1 0 0 0
 XCFUNCTIONAL = PBE
 E_ERROR = 0
 SYS_TYPE = 2
```

C.SG15.PBE.SOC.UPF, Li.SG15.PBE.SOC.UPF

#### Calculations

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

2. Read total energy from REPORT, and as input parameter for next NEB calculation.

```
grep "E_tot(eV)" REPORT | tail -1
>>> E_tot(eV)    = -.79460153820497E+04    -.3343E-03
```

### Final state scf

#### Input files

atom.config

```dotnetcli
       51 atoms,Iteration =   8, Etot,Ep,Ek =  -0.7946015575E+04  -0.7946015575E+04   0.0000000000E+00, Average Force=  0.15454E-02, Max force=  0.33836E-02
 Lattice vector (Angstrom), stress(eV/natom)
   0.1230000019E+02    0.0000000000E+00    0.0000000000E+00
  -0.6150000100E+01    0.1065211263E+02    0.0000000000E+00
   0.0000000000E+00    0.0000000000E+00    0.2000000000E+02
 Position, move_x, move_y, move_z
   6      0.133312758      0.066687242      0.499990024     1  1  1
   6      0.133149613      0.266557805      0.500008510     1  1  1
   6      0.133149503      0.466579100      0.500008574     1  1  1
   ...
   6      0.867547638      0.733777090      0.500077817     1  1  1
   6      0.866970187      0.933684078      0.500023723     1  1  1
   3      0.600000020      0.600000020      0.585322202     1  1  1
```

:::tip Note
Copy final.config from previous final state RELAX calculation, and rename atom.config
:::

etot.input

```dotnetcli
 2  2
 JOB = SCF
 IN.PSP1 = C.SG15.PBE.UPF
 IN.PSP2 = Li.SG15.PBE.UPF
 IN.ATOM = atom.config
 Ecut = 50
 Ecut2 = 200
 MP_N123 = 3 3 1 0 0 0
 XCFUNCTIONAL = PBE
 E_ERROR = 0
 SYS_TYPE = 2
```

C.SG15.PBE.SOC.UPF, Li.SG15.PBE.SOC.UPF

#### Calculations

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

2. Read total energy from REPORT, and as input parameter for next NEB calculation.

```
grep "E_tot(eV)" REPORT | tail -1
>>> E_tot(eV)    = -.79460153754978E+04    -.3548E-03
```

## Third Step: "NEB" calculation

### Input files

atom_initial.config

```dotnetcli
       51 atoms,Iteration =   8, Etot,Ep,Ek =  -0.7946015575E+04  -0.7946015575E+04   0.0000000000E+00, Average Force=  0.15454E-02, Max force=  0.33836E-02
 Lattice vector (Angstrom), stress(eV/natom)
   0.1230000019E+02    0.0000000000E+00    0.0000000000E+00
  -0.6150000100E+01    0.1065211263E+02    0.0000000000E+00
   0.0000000000E+00    0.0000000000E+00    0.2000000000E+02
 Position, move_x, move_y, move_z
   6      0.133312758      0.066687242      0.499990024     1  1  1
   6      0.133149613      0.266557805      0.500008510     1  1  1
   6      0.133149503      0.466579100      0.500008574     1  1  1
   ...
   6      0.867547638      0.733777090      0.500077817     1  1  1
   6      0.866970187      0.933684078      0.500023723     1  1  1
   3      0.600000020      0.600000020      0.585322202     1  1  1
```

:::tip Note
Copy final.config from previous initial state RELAX calculation, and rename atom.config
:::

atom_final.config

```dotnetcli
       51 atoms,Iteration =   8, Etot,Ep,Ek =  -0.7946015575E+04  -0.7946015575E+04   0.0000000000E+00, Average Force=  0.15454E-02, Max force=  0.33836E-02
 Lattice vector (Angstrom), stress(eV/natom)
   0.1230000019E+02    0.0000000000E+00    0.0000000000E+00
  -0.6150000100E+01    0.1065211263E+02    0.0000000000E+00
   0.0000000000E+00    0.0000000000E+00    0.2000000000E+02
 Position, move_x, move_y, move_z
   6      0.133312758      0.066687242      0.499990024     1  1  1
   6      0.133149613      0.266557805      0.500008510     1  1  1
   6      0.133149503      0.466579100      0.500008574     1  1  1
   ...
   6      0.867547638      0.733777090      0.500077817     1  1  1
   6      0.866970187      0.933684078      0.500023723     1  1  1
   3      0.600000020      0.600000020      0.585322202     1  1  1
```

:::tip Note
Copy final.config from previous initial state RELAX calculation, and rename atom.config
:::

etot.input

```dotnetcli
 2  2
 JOB = NEB
 IN.PSP1 = C.SG15.PBE.UPF
 IN.PSP2 = Li.SG15.PBE.UPF
 IN.ATOM = atom_initial.config
 NEB_DETAIL = 5, 100, 0.02, 5, 0.1, 1, -.79460153820497E+04, -.79460153754978E+04, 1, atom_final.config #IMTH, NSTEP, FORCE_TOL, NIMAGE, AK, TYPE_SPRING, E0, EN, ITYPE_AT2, ATOM2.CONFIG
 Ecut = 50
 Ecut2 = 200
 MP_N123 = 3 3 1 0 0 0 2
 XCFUNCTIONAL = PBE
 SYS_TYPE = 2
```

:::tip Note

1. JOB = NEB: specifies NEB or CI-NEB calculation.
2. IMTH: the algorithm used for atomic relaxation..
3. NSTEP: the maximum number of line-minimization steps in the relaxation process.
4. FORCE_TOL: the atomic force tolerance ($$eV/\text{\AA}$$) to stop the relaxation.
5. NIMAGE: the number of images in the NEB.
6. AK: the spring constant for the image string ($$eV/\text{\AA}^2$$) .
7. TYPE_SPRING: the type of string used in NEB algorithm.
8. E0,EN: the precalculated energy of initial and final configurations.
9. ITYPE_AT2: the type of ATOM2.CONFIG
10. ATOM2.CONFIG: if ITYPE_AT2=1, ATOM2.CONFIG is the configuraton of final state; if ITYPE_AT2=2, ATOM2.CONFIG should contain all the NIMAGE, initial and final images. It can copy from MOVEMENT.

:::

C.SG15.PBE.SOC.UPF, Li.SG15.PBE.SOC.UPF

#### Calculations

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

2. For NEB calculation, the main report file is NEB.BARRIER, which concisely report the energies along the images for different relaxation interation steps. A typical NEB.BARRIER file looks like:

```dotnetcli
iter=           0  Etot(eV),dist(Bohr),angle(cos(th))
    0      -0.79460153820497E+04    0.775127E+00   0.000000E+00
    1      -0.79458967676866E+04    0.775511E+00   0.999799E+00
    2      -0.79456608594139E+04    0.775152E+00   0.999772E+00
    3      -0.79455479350017E+04    0.775153E+00   0.999044E+00
    4      -0.79456646396218E+04    0.775533E+00   0.999760E+00
    5      -0.79458997436463E+04    0.775116E+00   0.999770E+00
    6      -0.79460153754978E+04    0.000000E+00   0.000000E+00
--------------------------------------
...
...
...
iter=          46  Etot(eV),dist(Bohr),angle(cos(th))
    0      -0.79460153820497E+04    0.872956E+00   0.000000E+00
    1      -0.79459501924940E+04    0.880202E+00   0.460050E+00
    2      -0.79458020191154E+04    0.876583E+00   0.843128E+00
    3      -0.79457334923844E+04    0.876550E+00   0.978611E+00
    4      -0.79458018757778E+04    0.883367E+00   0.838971E+00
    5      -0.79459501006750E+04    0.876284E+00   0.451718E+00
    6      -0.79460153754978E+04    0.000000E+00   0.000000E+00
--------------------------------------
```

:::tip Note

1.  Etot(eV)(second column): the total energy of the image.

2.  dist(Bohr)(third column): the distance between the neighboring images.

3.  angle(cos(th))(fourth column): the $$\cos{\theta}$$ of the angle theta between two R(image + 1) - R(image), and R(image) - R(image - 1).

:::
