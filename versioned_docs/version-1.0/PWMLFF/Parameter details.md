# Parameter details

This section introduces the user-definable parameters in all models. There are 2 types of parameters: **gloabl** and **local**.


**Global parameters**: Most (but not all) gloabl parameters can either be passed in when creating the trainer class instance, or be altered via memebr function **.set_< name_of_parameter >()**. Example: for parameter called **mypara**, it can be passed in when the trainer class is created, 

```python
my_trainer = trainer(
                        ...
                        mypara = val,
                        ...
                    )
```
or via a member function ( for example, **set_mypara()**):

```python
...
my_trainer.set_mypara(val)
...
```

Unless otherwise noted, all global parameters listed below can be altered in **both ways**. 

**Local parameters**: these parameters are only effective with memeber functions such as train(), evaluate(), .etc.

## Linear Model 

### Global parameters

**max_neigh_num**: size of neighbor buffer, with default value **100**. However, for some systems it is not enough to accommodate all the neighbors, and the feature generation fails. The following warning will pop up: 

```python
Error! maxNeighborNum too small
```

In this case increase the value. 

Usage: **trainer.set_neigh_num(val)** or pass in at the instantiation 

****

**etot_weight**: weight of total energy in fitting. Default value is **0.5**. 

Usage: **trainer.set_etot_weight(val)** or pass in at the instantiation 

*****

**force_weight**: weight of force in fitting. Default value is **0.5**. 

Usage: **trainer.set_force_weight(val)** or pass in at the instantiation 

*****

**ei_weight**: weight of atomic energy in fitting. Default value is **0.0**. 

Usage: **trainer.set_ei_weight(val)** or pass in at the instantiation 

### Local parameters: Training

None. 

### Local parameters: Evaluation

The complete list of parameters in evaluation is 

```dotnetcli
evaluate(num_thread=1)
```

**num_thread**: number of threads for evaluation. Default is 1. 

### Local parameters: Prediction

The complete list of parameters in prediction: 

```dotnetcli
run_md(init_config = "atom.config", md_details = None, num_thread = 1, follow = False)
```

**init_config**: inital configuration file for MD. Default is **atom.config**

*****

**md_details**: md_detail array. Must be passed in by user. 

*****

**num_thread**: number of threads for prediction. Default is 1. 

*****

**follow**: if continue previous MD run. Default is False.

## Deep Neural Network 

### Global parameters

**max_neigh_num**: size of neighbor buffer, with default value **100**. However, for some systems it is not enough to accommodate all the neighbors, and the feature generation fails. The following warning will pop up: 

```python
Error! maxNeighborNum too small
```

In this case increase the value. 

Usage: **my_trainer.set_neigh_num(val)** or pass in at the instantiation 

*****

**nn_layer_config**: dimension of the nueral network. Default is [15,15,1]. 

Usage: pass in at the instantiation **ONLY**

****

**is_trainForce**: if force is used in training. Default is True

Usage: **my_trainer.set_train_force(val)** or pass in at the instantiation  

*******

**is_trainEi**: if atomic energy is used in training. Default is False

Usage: **my_trainer.set_train_Ei(val)** or pass in at the instantiation  

*****

**is_trainEgroup**: if group energy is used in training. Default is False

Usage: **my_trainer.set_train_Egroup(val)** or pass in at the instantiation  

*****

**is_trainEtot**: if total energy is used in training. Default is True

Usage: **my_trainer.set_train_Etot(val)** or pass in at the instantiation  

*****

**kf_prefac_Etot**: KF update prefactor for total energy. Default is 1.0. Can be understood as the "learning rate" for KF. 

Usage: **my_trainer.set_kf_prefac_Etot(val)**

*****

**kf_prefac_Ei**: KF update prefactor for atomic energy. Default is 1.0

Usage: **my_trainer.set_kf_prefac_Ei(val)**

****

**kf_prefac_F**: KF update prefactor for force. Default is 1.0

Usage: **my_trainer.set_kf_prefac_F(val)**

****

**kf_prefac_Egroup**: KF update prefactor for group energy. Default is 1.0

Usage: **my_trainer.set_kf_prefac_Egroup(val)**

****

**session_dir**: name of directory that saves the training log and models. Default is **record**

Usage: **my_trainer.set_session_dir(val)** or pass in at the instantiation  

****

**device**: device for traning. Default is cpu 

Usage: pass in at the instantiation  

****

**recover**: if recover previous training. Default is False. 

Usage: pass in at the instantiation  

****

**n_epoch**: number of epoch. Default is 25

Usage: **my_trainer.set_epoch_num(val)** or pass in at the instantiation  

****

### Local parameters:Training

Complete list of parameters in member function **set_model()**: 

```dotnetcli
set_model(start_epoch = 1, model_name = None)
```

**start_epcoh**: start epoch number. No need to vary. 

**model_name**: the model name to be load when **recover=True**. Default value is **latest.pt**, which is the latest model. 

### Local parameters: Evaluation

Complete list of parameters in member function **evaluate()**: 

```dotnetcli
evaluate(num_thread=1)
```

**num_thread**: number of threads for evaluation. Default value is 1.

********

Complete list of parameters in member function **extract_model_para()**: 

```dotnetcli
extract_model_para(model_name = "latest.pt")
```

**model_name**: the name of model to be extracted. Default values is  **latest.pt**

### Local parameters: Prediction

The complete list of parameters in prediction: 

```dotnetcli
run_md(init_config = "atom.config", md_details = None, num_thread = 1, follow = False)
```

**init_config**: inital configuration file for MD. Default is **atom.config**

*****

**md_details**: md_detail array. Must be passed in by user. 

*****

**num_thread**: number of threads for prediction. Default is 1. 

*****

**follow**: if continue previous MD run. Default is False.

## DP-torch Network 

### Global parameters

**max_neigh_num**: size of neighbor buffer, with default value **100**. However, for some systems it is not enough to accommodate all the neighbors, and the feature generation fails. The following warning will pop up: 

```dotnetcli
Error! maxNeighborNum too small
```

In this case increase the value. 

Usage: **my_trainer.set_neigh_num(val)** or pass in at the instantiation 

****

**kf_prefac_Etot**: KF update prefactor for total energy. Default is 1.0. Can be understood as the "learning rate" for KF. 

Usage: **my_trainer.set_kf_prefac_Etot(val)**

*****

**kf_prefac_F**: KF update prefactor for force. Default is 1.0

Usage: **my_trainer.set_kf_prefac_F(val)**

*******

**session_dir**: name of directory that saves the training log and models. Default is **record**

Usage: **my_trainer.set_session_dir(val)** or pass in at the instantiation  

****

**device**: device for traning. Default is cpu

Usage: pass in at the instantiation 

****

**recover**: if recover previous training. Default is False. 

Usage: pass in at the instantiation  

****

**n_epoch**: number of epoch. Default is 25

Usage: **my_trainer.set_epoch_num(val)** or pass in at the instantiation  

****

**batch_size**: batch size. Default is 1. 

Usage: **my_trainer.set_batch_size(val)** or pass in at the instantiation  

****

**select_num**: number of selected atoms for force update in KF. Default is 24. 

Usage: **my_trainer.set_select_num(val)** or pass in at the instantiation  

*****

**group_size**: number of groups the selected atoms will be divided into. Default is 6

Usage: **my_trainer.set_group_size(val)** or pass in at the instantiation  


******

**block_size**: block size in layerwise KF. Default is 5120

Usage: **my_trainer.set_block_size(val)** or pass in at the instantiation  

**********

**embedding_net_config**: configuration of the embedding network, i.e. number of nodes in each layer. Default is [25, 25, 25] with KF, and [25, 50, 100] without KF 

Usage: **my_trainer.set_embedding_net_config(val)** or pass in at the instantiation  

********

**fitting_net_config**: configuration of the fitting network, i.e. number of nodes in each layer. Default is [50, 50, 50, 1] with KF, and [240, 240, 240, 1] without KF 

Usage: **my_trainer.set_fitting_net_config(val)** or pass in at the instantiation  

***********

**Rmin**: low cut-offin DP's smoothing function. Default is 3.0

Usage: **my_trainer.set_Rmin(val)** or pass in at the instantiation  

**********

**Rmax**: high cut-off in DP's smoothing function. Default is 5.4

Usage: **my_trainer.set_Rmax(val)** or pass in at the instantiation  

### Local parameters:Training

Complete list of parameters in member function **set_model()**: 

```dotnetcli
set_model(start_epoch = 1, model_name = None)
```

**start_epcoh**: start epoch number. No need to vary. 

**model_name**: the model name to be load when **recover=True**. Default value is **latest.pt**, which is the latest model. 

### Local parameters: Evaluation

Complete list of parameters in member function **evaluate()**: 

```dotnetcli
evaluate(num_thread=1)
```

**num_thread**: number of threads for evaluation. Default value is 1.

### Local parameters: Prediction

The complete list of parameters in prediction: 

```dotnetcli
run_md(init_config = "atom.config", md_details = None, num_thread = 1, follow = False)
```

**init_config**: inital configuration file for MD. Default is **atom.config**

*****

**md_details**: md_detail array. Must be passed in by user. 

*****

**num_thread**: number of threads for prediction. Default is 1. 

*****

**follow**: if continue previous MD run. Default is False.

## Graphic Neural Network 

### Global parameters

**device**: device to train. Default is **"cuda"**.

Usage: **my_trainer.set_device()** or pass in at the instantiation 

****

**session_dir**: directory that contains training tasks. Default is **"record"**

Usage: **my_trainer.set_session_dir()** or pass in at the instantiation 

****

**task_name**: directory under *session_dir* that stores the inforrmation of each task. Default is **"gnn"**

Usage: **my_trainer.set_task_name()** or pass in at the instantiation 

****

**epoch_num**: number of epoch. Default is 25. 

Usage: **my_trainer.set_epoch_num()** or pass in at the instantiation 

****

**num_train_img**: number of images for training. **YOU MUST SPECIFY THIS BASED ON YOU DATASET**

Usage: **my_trainer.set_num_train_img()** or pass in at the instantiation 

****

**num_valid_img**: number of images for validation. **YOU MUST SPECIFY THIS BASED ON YOU DATASET**

Usage: **my_trainer.set_num_valid_img()** or pass in at the instantiation 

****

**num_train_batch_size**: number of images for training. Default is 5, and **1 to 5 are reasonable choices**.

Usage: **my_trainer.set_train_batch_size()** or pass in at the instantiation 

****

**num_valid_batch_size**: number of images for training. Default is 10. 

Usage: **my_trainer.set_valid_batch_size()** or pass in at the instantiation 

****

**learning_rate**: learning rate. Default is 0.005. 

Usage: **my_trainer.set_learning_rate()** or pass in at the instantiation 

****

**r_max**: cutoff radius in Angstrom. Default is 4.0 

Usage: **my_trainer.set_r_max()** or pass in at the instantiation 

****

**num_layers**: number of interaction blocks. Default is 4 

Usage: **my_trainer.set_num_layers()** or pass in at the instantiation 

****

**l_max**: the maximum irrep order (rotation order) for the network's features. Default is 1, which is good enough for most cases. 

Usage: **my_trainer.set_l_max()** or pass in at the instantiation 

****

**num_features**: number of features. Default is 32, which is good enough for most cases. 

Usage: **my_trainer.set_num_features()** or pass in at the instantiation 

****

**num_basis**: number of features. Default is 32, which is good enough for most cases. 

Usage: **my_trainer.set_num_basis()** or pass in at the instantiation 

****

**num_basis**: number of basis functions used in the radial basis. Default is 8, which is good enough for most cases. 

Usage: **my_trainer.set_num_basis()** or pass in at the instantiation 

****

**PolynomialCutoff_p**: p-exponent used in polynomial cutoff function, smaller p corresponds to stronger decay with distance. Default is 6.

Usage: **my_trainer.set_PolynomialCutoff_p()** or pass in at the instantiation 

****

**invariant_layers**: number of radial layers. Default is 2. 1 to 3 are reasonable. 

Usage: **my_trainer.set_invariant_layers()** or pass in at the instantiation 

### Local parameters:Training

Complete list of parameters in member function **generate_data()**: 

```dotnetcli
generate_data(xyz_output = "./PWdata/training_data.xyz") 
```

**xyz_output**: name of .xyz file after coversion. Default values is  **./PWdata/training_data.xyz**

********

Complete list of parameters in member function **train()**: 

```dotnetcli
train(train_data = r"./PWdata/training_data.xyz")
```

**train_data**: .xyz to be used in training. Default values is  **./PWdata/training_data.xyz**

### Local parameters:Evaluation

Complete list of parameters in member function **evaluate()**:

```python
evaluate(
                train_dir = None,
                model = None,   
                batch_size = 50, 
                device = None, 
                use_deterministic_algorithms = False
        )
```

**train_dir**: path to the data set to be evaluated. Images that are **NOT** used in training and validation will be used

**model**: the model to be evaluated. **MUST BE A DELOPYED MODEL**

**batch_size**: batch size.

**device**: device for evaluation task 

**use_deterministic_algorithms**: if a deterministic method is used in evaluation. Notice that if CUDA is used, algorithms are non-deterministic, and forcing it using deterministic method may induce error. Set **device = cpu** instead. 

*******

Complete list of parameters in member function **deploy()**:

```python
deploy( 
            model = None, 
            train_dir = None, 
            out_file = None
        )
```

**model**: model to be deployed. Default is **best_model.pth** in **train_dir**

**train_dir**: directory that contains the model to be deployed 

**out_file**: name of the output file