# Crystal Structure Optimization (both atomic position and cell shape)

RELAXATION calculation for graphene, both relax atomic postion and cell shape

## Input files

atom.config

```dotnetcli
     4
 LATTICE
      2.46596583     0.00000000     0.00000000
     -1.23298291     2.13558905     0.00000000
      0.00000000     0.00000000     6.41151115
 POSITION
   6     0.00000000     0.00000000     0.75000000 1 1 1
   6     0.66667000     0.33333000     0.75000000 1 1 1
   6     0.00000000     0.00000000     0.25000000 1 1 1
   6     0.33333000     0.66667000     0.25000000 1 1 1
 STRESS_MASK # optional
 1 1 1
 1 1 1
 1 1 1
```

:::tip

STRESS_MASK: used to multiply to the stress tensor for cell relaxation, so some directions of the cell can be fixed.

:::

etot.input

```dotnetcli
   1  4
   JOB = RELAX
   IN.PSP1 = C.SG15.PBE.UPF
   IN.ATOM = atom.config
   RELAX_DETAIL = 1 100 0.01 1 0.02 #IMTH, NSTEP, FORCE_TOL, ISTRESS, TOL_STRESS
   VDW = DFT-D2
   Ecut = 70
   Ecut2 = 280
   MP_N123 = 12 12 4 0 0 0
```

:::tip

1.  ISTRESS: controls whether to relax the lattice vectors.
2.  TOL_STRESS: is the stress tolerance for the maximal residual stress (eV/Natom).
3.  VDW: used to specfiy the type of Van Der Waals correction.

:::

C.SG15.PBE.UPF

:::tip
   C.SG15.PEB.UPF is the pseudopotential file.
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
   It=   -1  CORR E=  -0.6210369947615E+03  Av_F=  0.40E-03 M_F=  0.60E-03 Av_e=  0.22E+00 dE=   0.2E-05 dRho=   0.1E-03 SCF=    13 dL=  0.00E+00 d_AL=  0.14-320 p*F=  0.00E+00 p*F0=  0.00E+00 Fch=  0.00E+00
   It=    0   NEW E=  -0.6210387518836E+03  Av_F=  0.15E-02 M_F=  0.22E-02 Av_e=  0.14E+00 dE=   0.2E-04 dRho=   0.2E-03 SCF=     4 dL= -0.62E-04 d_AL=  0.21E-01 p*F=  0.51E-02 p*F0= -0.14E-02 Fch= -0.14E+05
   It=    1  CORR E=  -0.6210399476706E+03  Av_F=  0.71E-03 M_F=  0.11E-02 Av_e=  0.23E-01 dE=   0.2E-03 dRho=   0.1E-04 SCF=     2 dL= -0.38E-04 d_AL=  0.83E-02 p*F=  0.25E-02 p*F0= -0.14E-02 Fch= -0.14E+06
   It=    2  CORR E=  -0.6210399448332E+03  Av_F=  0.72E-03 M_F=  0.11E-02 Av_e=  0.23E-01 dE=   0.1E-06 dRho=   0.4E-05 SCF=     2 dL= -0.38E-04 d_AL=  0.73E-04 p*F=  0.25E-02 p*F0= -0.14E-02 Fch= -0.13E+06
   ...
   It=   10  CORR E=  -0.6210403273943E+03  Av_F=  0.21E-02 M_F=  0.32E-02 Av_e=  0.39E-02 dE=   0.4E-04 dRho=   0.5E-05 SCF=     2 dL= -0.11E-02 d_AL=  0.21E-02 p*F=  0.73E-02 p*F0= -0.11E+00 Fch=  0.17E+01
   It=   11  *END E=  -0.6210403273943E+03  Av_F=  0.21E-02 M_F=  0.32E-02 Av_e=  0.39E-02 dE=   0.4E-04 dRho=   0.5E-05 SCF=     2 dL= -0.11E-02 d_AL=  0.21E-02 p*F=  0.73E-02 p*F0= -0.11E+00 Fch=  0.17E+01
```

>REPORT: more detailed information about every electronic and ionic step

>OUT.STRESS: stess tensor (eV/Naom), for cell relaxation, the stress tensor will calculated and written in OUT.STRESS.

3. Other important files.

>final.config: holds the structure of the last ionic step, the structural result (also very important for restarting a relaxation)

>MOVEMENT: holds the structures of every ionic step during relaxations.