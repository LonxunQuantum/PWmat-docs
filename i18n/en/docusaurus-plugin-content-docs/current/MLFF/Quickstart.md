# Quickstart

To start training, you should first prepare the AIMD data with either VASP or PWmat. You can use the ultily module **outcar2movement** to convert VASP's OUTCAR output to MOVEMENT format. In the directory that contains the OUTCAR file, run: 

```dotnetcli
outcar2movement
```

:::caution Warning
When using PWmat for AIMD calculation, add the following flags in **etot.input**:
```bash
energy_decomp = T
e_error = 1.0e-6
rho_error = 1.0e-4
```
This enables PWmat to perform atomic energy decomposition with high precision, which is crucial in data preparation. You will find that besides Velocity, Force, and Position blocks, a block called **Atomic Energy** will show up in the MOVEMENT file, which includes the decomposed atomic energy of each atom. 

:::

Code examples for each model are now presented, with all parameters set to be default. A complete introduction on parameters will be given in next section.

## Linear Model 

### Training

All MOVEMENT files must be stored in the directory **/PWdata**. If more than one MOVEMENT files are used for training, create multiple directories within **/PWdata**, with each containing **exactly ONE** MOVEMENT file. You can use **data/MOVEMENT** for a quick test. 

```python
# import module from PWmatMLFF 
from PWmatMLFF.linear_regressor import linear_regressor 

if __name__ == "__main__":

    """
        atom types to be used
        MUST BE SPECIFIED
    """
    atom_type = [29,8]

    """
        feature to be used
        MUST BE SPECIFIED
    """
    feature_type = [1,2]
    
    """
        create a class instance
        MUST BE DONE
    """
    linReg = linear_regressor(atom_type = atom_type, feature_type = feature_type)
    
    """
        generate training data 
        ONLY NEED TO BE DONE ONCE
    """
    linReg.generate_data() 
    
    """
        start training 
        the results are automatically saved in the current directory 
    """
    linReg.train() 
```

Paste the code above in python script (**main.py**, for example). Run the following command to train 

```bash
python main.py 
```

### Evaluation

Before evaluation, create a directory **/MD**,  and put in it another MOVEMENT file obtained from AIMD. **Note that for such a MOVEMENT, energy decomposition is necessary**.

```python
# import module from PWmatMLFF 
from PWmatMLFF.linear_regressor import linear_regressor 

if __name__ == "__main__":
    
    """
        atom types to be used
        MUST BE SPECIFIED
    """
    atom_type = [29,8]

    """
        feature to be used
        MUST BE SPECIFIED
    """
    feature_type = [1,2]
    
    """
        create a class instance
        MUST BE DONE
    """
    linReg = linear_regressor(atom_type = atom_type, feature_type = feature_type)
    
    """
        perform evaulation and plot 
    """ 
    linReg.evaluate() 
    linReg.plot_evaluation() 
```

### Prediction

The code below runs **PWmat-style** MD calculation with the force field just obtained. For MD calculation with LAMMPS, see the section "**LAMMPS MD calculation**". You must prepare an initial configuration in order to proceed. A **md_detail** array is also required, which specifies 1)simulation method, 2) steps, 3) time lentgh of step, 4) initial temperature, and 5) final temperature. Please refer to PWmat manual for more details. 

```python
# import module from PWmatMLFF 
from PWmatMLFF.linear_regressor import linear_regressor 

if __name__ == "__main__":
    
    """
        atom types to be used
        MUST BE SPECIFIED
    """
    atom_type = [29,8]

    """
        feature to be used
        MUST BE SPECIFIED
    """
    feature_type = [1,2]
    
    """
        create a class instance
        MUST BE DONE
    """
    linReg = linear_regressor(atom_type = atom_type, feature_type = feature_type)
    
    """
        PWmat-style md_detail array
        MUST BE SPECIFIED 
    """   
    md_detail = [1,1000,1,500,500]

    """
        run MD
    """
    linReg.linReg.run_md(md_details = md_detail, follow = False)
```

This process generates all information in the current directory as in PWmat MD calculation. 

## Deep Neural Network

### Training

All MOVEMENT files must be stored in the directory **/PWdata**. If more than one MOVEMENT files are used for training, create multiple directories within **/PWdata**, with each containing **exactly ONE** MOVEMENT file. You can use **data/MOVEMENT** for a quick test. Notice that for Deep Neural Network, training with **global Kalman Filter** optimizer on **cpu** is recommended. 

```python
#import the regressor module
from PWmatMLFF.nn_network import nn_network 

if __name__ == '__main__':

    # atom type to be used. MUST BE SPECIFIED 
    atom_type = [29,8]

    # feature to be used. MUST BE SPECIFIED 
    feature_type = [1,2]

    # create an instance. MUST BE DONE. 
    kfnn_trainer = nn_network(
                                atom_type = atom_type,   
                                feature_type = feature_type, 
                                kalman_type = "global",      # using global Kalman filter
                                device = "cpu",              # run training on cpu 
                                recover = False,             # recover previous training
                                session_dir = "record"       # directory that contains 
                                )
    
    # generate data from MOVEMENT files
    # ONLY NEED TO BE DONE ONCE
    kfnn_trainer.generate_data()

    # transform data
    kfnn_trainer.load_data()

    # initialize the network   
    kfnn_trainer.set_model() 

    # initialize the optimizer and related scheduler
    kfnn_trainer.set_optimizer()

    # set epoch number for training
    kfnn_trainer.set_epoch_num(20)

    # start training 
    kfnn_trainer.train() 
```

Paste the code above in python script (**main.py**, for example). Run the following command to train 

```bash
python main.py 
```

During training, you can monitor the progress by checking the logs in the **session_dir** you specified:  

**epoch_loss.dat**: RMSE_Etot, RMSE_Ei, RMSE_F of training set in each epoch. 

**epoch_loss_valid.dat**: RMSE_Etot, RMSE_Ei, RMSE_F of valid set in each epoch.  

### Evaluation

Before evaluation, create a directory **/MD**,  and put in it another MOVEMENT file obtained from AIMD. **Note that for such a MOVEMENT, energy decomposition is necessary**.

```python
#import the regressor module
from PWmatMLFF.nn_network import nn_network 

if __name__ == '__main__':

    # atom type to be used. MUST BE SPECIFIED 
    atom_type = [29,8]

    # feature to be used. MUST BE SPECIFIED 
    feature_type = [1,2]

    # create an instance. MUST BE DONE. 
    kfnn_trainer = nn_network(   
                                atom_type = atom_type,   
                                feature_type = feature_type, 
                                kalman_type = "global",      # using global Kalman filter
                                device = "cpu",              # run training on cpu 
                                recover = False,             # recover previous training
                                session_dir = "record"       # directory that contains the log & saved models 
                                )

    # extract network parameters for inference module. MUST-HAVE, ONLY ONCE
    kfnn_trainer.extract_model_para()

    # run evaluation
    kfnn_trainer.evaluate() 

    # plot the evaluation result
    kfnn_trainer.plot_evaluation() 
```

### Prediction

The code below runs **PWmat-style** MD calculation with the force field just obtained. For MD calculation with LAMMPS, see the section "**LAMMPS MD calculation**". You must prepare an initial configuration in order to proceed. A **md_detail** array is also required, which specifies 1)simulation method, 2) steps, 3) time lentgh of step, 4) initial temperature, and 5) final temperature. Please refer to PWmat manual for more details. 

```python
#import the regressor module
from PWmatMLFF.nn_network import nn_network 

if __name__ == '__main__':

    # atom type to be used. MUST BE SPECIFIED 
    atom_type = [29,8]

    # feature to be used. MUST BE SPECIFIED 
    feature_type = [1,2]

    # create an instance. MUST BE DONE. 
    kfnn_trainer = nn_network(   
                                atom_type = atom_type,   
                                feature_type = feature_type, 
                                kalman_type = "global",      # using global Kalman filter
                                device = "cpu",              # run training on cpu 
                                recover = False,             # recover previous training
                                session_dir = "record"       # directory that contains the log & saved models 
                                )

    # extract network parameters for inference module. MUST-HAVE. ONLY ONCE 
    kfnn_trainer.extract_model_para()   

    # md_detail array
    md_detail = [1,1000,1,300,300]

    # run MD  
    kfnn_trainer.run_md(md_details = md_detail, follow = False)
```

This process generates all information in the current directory as in PWmat MD calculation. 

## DP-Torch Network

### Training

All MOVEMENT files must be stored in the directory PWdata. If more than one MOVEMENT files are used for training, create multiple directories within PWdata, with each containing exactly ONE
MOVEMENT file.
Names other than “MOVEMENT” are not valid. Layerwise Kalman filter optimizer is recommended, since it is the fastest.

#### Training with a single device on single node
```python
from PWmatMLFF.dp_network import dp_network

if __name__ == "__main__":

    # atom type to be used. MUST BE SPECIFIED
    atom_type = [3, 14]

    # create an instance. MUST BE DONE.
    dp_trainer = dp_network(atom_type = atom_type,
                            optimizer = "LKF",
                            gpu_id = 0,
                            #is_distributed = True, 
                            session_dir = "record",
                            Rmax = 5.0,
                            Rmin = 0.5,
                            M2 = 16,
                            block_size = 10240,
                            n_epoch = 10,
                            batch_size = 5,
                            # is_resume = True,
                            # model_name = "checkpoint.pth.tar",
                            is_virial = True,
                            is_egroup = False,
                            #is_distributed = True, 
                            pre_fac_force = 1.0,
                            pre_fac_etot = 0.5,
                            pre_fac_virial = 0.5,
                            # pre_fac_egroup = 0.1
                            )
    # pre-process trianing data. ONLY NEED TO BE DONE ONCE
    dp_trainer.generate_data()
    
    # load data and train
    dp_trainer.load_and_train()


    # dp_trainer.extract_force_field()
```

Paste the code above in python script (**main.py**, for example). Run the following command to train 

```bash
python main.py
```

Alternati vely, you can pass in the arguments via comand line. To do so, use:
```bash
python main.py --opt LKF --gpu 0 -s record --epochs 30 -b 32
```
with
```python
from PWmatMLFF.dp_network import dp_network

if __name__ == "__main__":

    # atom type to be used. MUST BE SPECIFIED
    atom_type = [3, 14]

    # create an instance. MUST BE DONE.
    dp_trainer = dp_network(atom_type = atom_type
                            )

    dp_trainer.generate_data()

    dp_trainer.load_and_train()
```

During training, you can monitor the progress by checking the logs in the **session_dir** you specified:  

**epoch_loss.dat**: RMSE_Etot, RMSE_Ei, RMSE_F of training set in each epoch. 

**epoch_loss_valid.dat**: RMSE_Etot, RMSE_Ei, RMSE_F of valid set in each epoch.  

#### Training with multiple devices on single node
Start with a **main.py**
```python
from PWmatMLFF.dp_network import dp_network

if __name__ == "__main__":

    # atom type to be used. MUST BE SPECIFIED
    atom_type = [3]

    # create an instance. MUST BE DONE.
    dp_trainer = dp_network(atom_type = atom_type,
                            optimizer = "LKF",
                            #gpu_id = 0,
                            is_distributed = True,
                            session_dir = "record",
                            rank = 0,
                            world_size = 1,
                            Rmax = 5.0,
                            Rmin = 0.5,
                            M2 = 16,
                            block_size = 10240,
                            n_epoch = 20,
                            batch_size = 5,
                            # is_resume = True,
                            # model_name = "checkpoint.pth.tar",
                            is_virial = True,
                            is_egroup = False,
                            #is_distributed = True, 
                            pre_fac_force = 1.0,
                            pre_fac_etot = 0.5,
                            pre_fac_virial = 0.5,
                            )

    # pre-process trianing data. ONLY NEED TO BE DONE ONCE
    dp_trainer.generate_data()

    # load data and train
    dp_trainer.load_and_train()
```

That's is, you should mark **is_distributed** as true at the instanti ation. You should also set **rank=0** and **world_size = 1**.

Paste the code above in python script (**main.py**, for example). Run the following command to train 

```bash
python main.py
```

Passing arguments through command line is also available:

```bash
python main.py --opt LKF --distributed -s record --world-size 1 --rank 0 -b 5 --epochs 20
```

### Evaluation

Before evaluation, create a directory **/MD**,  and put in it another MOVEMENT file obtained from AIMD. **Note that for such a MOVEMENT, energy decomposition is necessary**.

```python
from PWmatMLFF.dp_network import dp_network

if __name__ == "__main__":

    # atom type to be used. MUST BE SPECIFIED 
    atom_type = [29,8]

    # create an instance. MUST BE DONE. 
    dp_trainer = dp_network(device = "cuda",atom_type = atom_type, session_dir = "kfdp_record")
    
    # extract network parameters for inference. MUST BE DONE
    dp_trainer.extract_model_para()

    # run evaluation 
    dp_trainer.evaluate() 

    # (optinal) plot RMSE graph
    dp_trainer.plot_evaluation() 
```

### Prediction

The code below runs **PWmat-style** MD calculation with the force field just obtained. For MD calculation with LAMMPS, see the section "**LAMMPS MD calculation**". You must prepare an initial configuration in order to proceed. A **md_detail** array is also required, which specifies 1)simulation method, 2) steps, 3) time lentgh of step, 4) initial temperature, and 5) final temperature. Please refer to PWmat manual for more details. 

```python
from PWmatMLFF.dp_network import dp_network

if __name__ == "__main__":

    # atom type to be used. MUST BE SPECIFIED 
    atom_type = [29,8]

    # create an instance. MUST BE DONE. 
    dp_trainer = dp_network(device = "cuda",atom_type = atom_type, session_dir = "kfdp_record")
    
    # extract network parameters for inference. MUST BE DONE
    dp_trainer.extract_model_para()

    # md_detail array. MUST-HAVE

    # run MD 
    dp_trainer.run_md(md_details = md_detail, num_thread = 4, follow = False)
```

This process generates all information in the current directory as in PWmat MD calculation. 

## Graphic Neural Network

### Training

All MOVEMENT files must be stored in the directory **/PWdata**. If more than one MOVEMENT files are used for training, create multiple directories within **/PWdata**, with each containing **exactly ONE** MOVEMENT file. You can use **data/MOVEMENT** for a quick test. **Notice that you have to manually specify the size of training set and validation set**. 

```python
from PWmatMLFF.gnn_network import gnn_network

if __name__ == "__main__":
    
    # atomic symbols. MUST-HAVE 
    atom_type = ["Cu","O"]
    
    # creating class instance. MUST-HAVE
    gnn_trainer = gnn_network(  device = "cuda", # choose the device for training 
                                chemical_symbols = atom_type
                                    )
    gnn_trainer.set_epoch_num(20)

    # set number of image in training and validation
    # Notice that nequip picks up training and validation set randomly. 
    gnn_trainer.set_num_train_img(400)
    gnn_trainer.set_num_valid_img(400)
    
    # create directory for current session 
    gnn_trainer.set_session_dir("record")

    # specify task name
    gnn_trainer.set_task_name("20220902-test")
        
    # generate data 
    # ONLY NEED TO BE DONE ONCE! 
    gnn_trainer.generate_data() 

    # lanuch training 
    gnn_trainer.train() 
```

### Evaluation

You must specify the directory used for training when running evaluation. Images that are used in neither training nor validation are to be evaluated. 

```python
from PWmatMLFF.gnn_network import gnn_network

if __name__ == "__main__":
        
    # atomic symbols. MUST-HAVE 
    atom_type = ["Cu","O"]
    
    # creating class instance. MUST-HAVE. 
    gnn_trainer = gnn_network(  device = "cuda", # choose the device for training 
                                    chemical_symbols = atom_type
                                ) 
        
    # lanuch evaluation 
    # Notice that train_dir MUST BE SPECIFIED. 
    gnn_trainer.evaluate(device = "cpu",train_dir = "record/20220902-test")
```

### Prediction

GNN force field can only be used in LAMMPS. First, you should deploy the model. 

```python
from PWmatMLFF.gnn_network import gnn_network

if __name__ == "__main__":
        
    # atomic symbols. MUST-HAVE 
    atom_type = ["Cu","O"]
    
    # creating class instance. MUST-HAVE. 
    gnn_trainer = gnn_network(  device = "cuda", # choose the device for training 
                                    chemical_symbols = atom_type
                                ) 
    
    # lanuch evaluation 
    # Notice that train_dir MUST BE SPECIFIED. 
    gnn_trainer.evaluate(device = "cpu",train_dir = "record/20220902-test")
```

You also need to compile LAMMPS manually to support the GNN pair style. See section **""LAMMPS MD calculation""**. 

## LAMMPS MD calculation

### Linear Model,KFNN, and KFDP

To use LAMMPS for MD calculation, you should add these lines in LAMMPS's input file:

```bash
pair_style pwmatmlff
pair_coeff  * * 1 5 29
```

The first line specify pair style. In the second line, the first 2 stars are place holders which need not to be changed. "1" stands for the **method index** you want to use, 5 means calculating neighbors in every 5 steps. 29 is the first type of atom (in this case, Cu) in the system. Notice that for system with more than 1 type of element, all elements should listed. For example, if the system is CuO, the second line should be: 

```bash
pair_coeff  * * 1 5 8 29
```

:::info NOTE
Method indices for each model are:

**Linear Model**: 1 

**KFNN**: 3

**KFDP**: 5

:::

You should also make sure that Intel MKL library is loaded. On MCloud, use the following command: 

```bash
module load mkl
```

Remember that in **NN and DP-torch**, you still need to extract the network parameters before launching LAMMPS

```python
my_trainer.extract_model_para() 
```

Now, run LAMMPS with 

```bash
mpirun -n myNodeNum /path/to/lammps/src/lmp_mpi -in lammps.in
```

### GNN

To use LAMMPS with **GNN** model, see 

    https://github.com/mir-group/nequip
    https://github.com/mir-group/pair_nequip

for more details. 
