---
sidebar_position: 2
---

# Parameter details

This section introduces the user-definable parameters in all models. There are 2 types of parameters: `Required` and `Advanced`. In the following parameters, "relative path" refers to a path relative to the current working directory, while "absolute path" refers to the complete path of a file or directory starting from the root directory.

## Required

For any model, the following parameters `require user input`.

### model_type
This parameter is used to specify which model to use for training. You can use `DP` for deep learning, `NN` for neural network, `LINEAR` for linear models, or the `NEP` for NEP model.

### atom_type
This parameter is used to set the element types of the training system. The atomic number of the input elements is specified by the user in any desired order. For example, for a single-element system like copper, it would be set as [29], and for multi-element systems like CH4, it would be set as [1, 6].

### max_neigh_num
size of neighbor buffer, with default value `100`. However, for some systems it is not enough to accommodate all the neighbors, and the feature generation fails. The following warning will pop up:

```python
Error! maxNeighborNum too small
```

In this case increase the value.

:::note
For the `NEP` model, there is no need to set this parameter.
:::

### train_movement_file
This parameter is used to specify the path where the MOVEMENT files for the `train` task are located. You can use relative paths or absolute paths.

### test_movement_file
This parameter is used to specify the path where the MOVEMENT files for the `test` task are located. You can use relative paths or absolute paths. It should be specified along with the `model_load_file` parameter.

### model_load_file
This parameter is used to specify the path where the model used for testing tasks is located. It should be specified along with the `test_movement_file` parameter.

 ### *dvanced`

Users only need to set the required parameters to complete the model training, testing, and related molecular dynamics processes. The corresponding advanced parameters, such as model hyperparameters and optimizer hyperparameters, will be set to default values. These advanced parameters can also be set in the JSON file.

### train_valid_ratio
This parameter specifies the ratio of the training set to the validation set. For example, 0.8 means taking the first 80% of the MOVEMENT images as the training set and the remaining 20% as the validation set. The default value is 0.8.

### recover_train
This parameter is used to resume training from an interrupted DP or NN training task. The default value is `true`.

### work_dir
This parameter is used to set the working directory where training, testing, and other tasks will be executed. It can be set to an absolute or relative path. The default value is a relative path `./work_dir`。

### reserve_work_dir
This parameter is used to specify whether to keep the working directory `work_dir` after the task execution is completed. The default value is `false`, which means the directory will be deleted after the job execution is finished.

:::info

1. Note，`work_dir`，`reserve_work_dir`, `train_movement_file` and `test_movement_file` Parameters are only used in the Linear and NN models in curren version.
2. For DP model:
   - The `raw_files` are used to specify the path of the molecular dynamics trajectory files for the training task. Supported file formats include PWmat, VASP, and CP2K (corresponding to the `format` parameter as `pwmat/movement`, `vasp/outcar`, `cp2k/md`).
   - The `format` parameter is used to specify the format of the original trajectory file. The default value is `None`. When using the `raw_files` parameter, the `format` parameter must be specified.
   - The `datasets_path` parameter is used to specify the path where the datasets for the test task are located. These datasets are preprocessed by [`PWDATA`](./Appendix-2.md), including feature extraction and label generation. It can replace the `raw_files` and `format` parameters.

:::

### type_embedding

Setting `"type_embedding":true` will use the type embedding method to train the DP model. The default value is `false`. (This parameter is only used in the DP model. That is `"model_type":"DP"`)

### model 参数

The complete `DP` model includes three components: `descriptor`, `fitting_net`, and `type_embedding`. The `NN` model does not include `type_embedding`. The `Linear` model does not require specifying the `model` parameter. The parameters for the `NEP` model need to be set separately.

### Linear model

The complete parameters for the Linear model are as follows:

```json
    "model": {
        "descriptor": {
            "Rmax": 6.0,
            "Rmin": 0.5,
            "feature_type": [3,4]
        }
    }
```

#### Rmax
The maximum truncation radius for the features. The default value is $6.0 \text{\AA}$. 

#### Rmin
The minimum truncation radius for the features. The default value is $0.5 \text{\AA}$.

#### feature_type

The parameter is for feature type. The supported options are [1, 2], [3, 4], [5], [6], [7], and [8]. The default value is [3, 4], 2-b and 3-b Gaussian feature. For more detailed information on different feature types, please refer to [Appendix 1](./Appendix-1.md).

### NN model

The complete set of parameters for the NN model is as follows.

```json
    "model": {
        "descriptor": {
            "Rmax": 6.0,
            "Rmin": 0.5,
            "feature_type": [3,4]
        },
        "fitting_net": {
            "network_size": [15,15,1]
        }
    }
```

#### Rmax
The maximum truncation radius for the features. The default value is $6.0 \text{\AA}$.

#### Rmin
The minimum truncation radius for the features. The default value is $0.5 \text{\AA}$.

#### feature_type

The parameter is for feature type. The supported options are [1, 2], [3, 4], [5], [6], [7], and [8]. The default value is [3, 4], 2-b and 3-b Gaussian feature. For more detailed information on different feature types, please refer to [Appendix 1](./Appendix-1.md).

#### network_size

The parameter is for the structure of the `fitting_net`. The defult value are [15, 15, 1], its structure is as:
Input layer (Input data dimensions) ➡ Hidden layer 1 (15 neurons) ➡ Hidden layer 2 (15 neurons) ➡ Output layer (1 neuron)

### DP model

The complete set of parameters for the DP model is as follows.

```json
    "model": {
        "type_embedding":{
            "physical_property":["atomic_number", "atom_mass", "atom_radius", "molar_vol", "melting_point", "boiling_point", "electron_affin", "pauling"]
        },
        "descriptor": {
            "Rmax": 6.0,
            "Rmin": 0.5,
            "M2": 16,
            "network_size": [25,25,25]
        },
        "fitting_net": {
            "network_size": [50,50,50,1]
        }
    }
```

#### physical_property

This parameter is used to specify the required parameters for type embedding training in the DP model. We provide eight physical properties for users to choose.

    atomic_number: Atomic number
    atom_mass: Atomic mass
    atom_radius: Atomic radius
    molar_vol: Molar volume
    melting_point: Melting point
    boiling_point: Boiling point
    electron_affin: Electron affinity
    pauling: Pauling electronegativity

    The default value of "physical_property" is ["atomic_number", "atom_radius", "atom_mass", "electron_affin", "pauling"]

#### Rmax
The maximum truncation radius for the features. The default value is $6.0 \text{\AA}$.

#### Rmin
The minimum truncation radius for the features. The default value is $0.5 \text{\AA}$.

#### M2
The parameter is for the DP model network, determining the output size of the embedding network and the input size of the fitting network. In the example, the embedding network output size is (25 * 16), and the fitting network input size is (25 * 16 = 400). The default value is 16.

#### network_size

The parameter is for the structure of the `embedding_net` and the `fitting_net`. The defult value are [25, 25, 25] and [50, 50, 50, 1], respectively. The corresponding network structure is described as follows.
structure of the `embedding_net` is:
Input layer (Input data dimensions) ➡ Hidden layer 1 (25 neurons) ➡ Hidden layer 2 (25 neurons) ➡ output layer (25 neurons)
structure of the `fitting_net` is:
Input layer (`M2` X 25) ➡ Hidden layer 1 (50 neurons) ➡ Hidden layer 2 (50 neurons) ➡ Hidden layer 3 (50 neurons) ➡  Output layer (1 neuron)

### NEP model

The complete parameter settings for the NEP model are as follows.

```json
{
    "model_type": "NEP",
    "atom_type": [8,72],
    "max_neigh_num": 100,
    "model": {
        "descriptor": {
            "cutoff": [6.0,6.0],
            "n_max": [4,4],
            "basis_size": [12,12],
            "l_max": [4,2,1],
            "zbl": 2.0
        },
        "fitting_net": {
            "network_size": [100,1]
        }
    }
}
```
#### model_type
This parameter specifies the type of `NEP` training.

#### cutoff
This parameter sets the cutoff energies for `radial` and `angular` components. In the implementation of PWMLFF, only the radial cutoff energy is used, and the angular cutoff energy is the same as the radial cutoff energy. The default value is `[6.0, 6.0]`.

#### n_max
This parameter sets the number of features for the distances and angles corresponding to `radial` and `angular` components, respectively. The default value is `[4, 4]`.

#### basis_size
This parameter sets the number of basis functions for the distances and angles corresponding to `radial` and `angular` components, respectively. The default value is `[12, 12]`.

#### l_max
This parameter sets the expansion order for angular components and also controls whether four-body and five-body features are used. The default value is `[4, 2, 1]`, corresponding to the orders for three-body, four-body, and five-body features, respectively. Here, `2` indicates the use of four-body features, and `1` indicates the use of five-body features. If you only use three-body features, set this to `[4, 0, 0]`; if you only use three-body and four-body features, set this to `[4, 2, 0]`.

#### network_size
This parameter sets the number of neurons in the hidden layer of the `NEP` model. The NEP model has only one hidden layer by default, with the default value being `[100]`. Although multi-layer neural networks are supported (e.g., you can set it to `[50, 50, 50, 1]`), we recommend using the default value. In our tests, adding more network layers did not significantly improve model fitting accuracy and instead increased inference burden, reducing inference speed.

#### zbl
This parameter is used to set the Ziegler-Biersack-Littmark (ZBL) potential, which handles situations where atomic distances are extremely close. By default, it is not set. The allowed range for this value is 1.0 $\le$ zbl $\le$ 2.5.

## optimizer

The optimizers available for training DP, NRP, NN models are the `KF(Kalman Filter) Optimizer` and `ADAM optimizer`.

### KF optimizer

KF optimizer's complete parameter settings are as follows:

```json
    "optimizer": {
        "optimizer": "LKF",
        "epochs": 30,
        "batch_size": 1,
        "print_freq": 10,
        "block_size": 5120,
        "p0_weight": 0.01,
        "kalman_lambda": 0.98,
        "kalman_nue": 0.9987,
        "train_energy": true,
        "train_force": true,
        "train_ei": false,
        "train_virial": false,
        "train_egroup": false,
        "pre_fac_force": 2.0,
        "pre_fac_etot": 1.0,
        "pre_fac_ei": 1.0,
        "pre_fac_virial": 1.0,
        "pre_fac_egroup": 0.1
    }
```

#### optimizer

This parameter is used to specify the optimizer name, and the available options are `LKF` or `GKF`. For more detailed information on the optimizer, please refer to the [article](https://doi.org/10.1609/aaai.v37i7.25957), which provides more in-depth details about the implementation and characteristics of the optimizer.

#### epochs
This parameter is used to specify the number of training epochs. In machine learning, one epoch refers to a complete pass of the entire training dataset through the neural network, including both forward propagation and backward propagation. During each epoch, the training dataset is divided into `mini-batches` of samples, and each batch is input to the neural network for forward propagation, loss calculation, and parameter updates through backward propagation. The number of epochs determines how many times the entire training dataset will be processed during the training process. The dedault value is `30.`

Choosing the appropriate number of epochs is typically done through debugging and evaluation during the training process. If the number of epochs is too small, the model may not learn the patterns and features of the dataset sufficiently, resulting in underfitting. On the other hand, if the number of epochs is too large, the model may overfit the training data, leading to a decrease in generalization performance on new data. Therefore, selecting an appropriate number of epochs is crucial for training an effective neural network model.

#### batch_size
The parameter of batch size determines the number of training samples included in each `mini-batch` during an `epoch`. The dedault value is `1`.

#### print_freq
The parameter for specifying how often to print the training error after a certain number of mini-batch iterations. The default value is `10`.

#### block_size
The parameter is a hyperparameter for the `LKF optimizer`, which specifies the block size of the covariance matrix P. A larger block size increases memory and GPU memory consumption, leading to slower training, while a smaller block size affects convergence speed and accuracy. The default value is `5120`. If using high-end graphics cards such as A100 or H100, it is recommended to set it to `10240`.

#### p0_weight
This parameter is a hyperparameter for the LKF and GKF optimizers, used for regularization. `By default, it is 0.01`, meaning regularization is applied. Setting a regularization term helps reduce model overfitting. The value for this parameter must be less than 1.0, with `0.01` being found as a suitable value through testing.If set to `1`, it means regularization is not applicable.

#### kalman_lambda
The parameter is a hyperparameter for the `LKF and GKF optimizer`. it is called memory factor. The greater it is, the more weight, or say attention, is paid to previous data. The default value is `0.98`.

#### kalman_nue
The parameter is a hyperparameter for the `LKF and GKF optimizer`. kalman_nue is forgetting rate, a hyperparameter describing the varying rate of kalman_lambda. The default value is `0.9987`.

#### train_energy
The parameter is used to specify whether to train the total energy, The default value is `true`.

#### train_force
The parameter is used to specify whether to train the total energy, The default value is `true`.

#### train_ei
The parameter is used to specify whether to train the atomic energy, The default value is `false`.

#### train_virial
The parameter is used to specify whether to train the virial, The default value is `false`.

#### train_egroup
The parameter is used to specify whether to train the total energy, The default value is `false`.

#### pre_fac_etot
This parameter is used to specify the weight or contribution of the total energy to the loss. The default value is `1.0`.

#### pre_fac_force
This parameter is used to specify the weight or contribution of the force to the loss. The default value is `2.0`.

#### pre_fac_ei
This parameter is used to specify the weight or contribution of the atomic energy to the loss. The default value is `1.0`.

#### pre_fac_virial
This parameter is used to specify the weight or contribution of the virial to the loss. The default value is `1.0`.

#### pre_fac_egroup
This parameter is used to specify the weight or contribution of the egroup to the loss. The default value is `0.1`.

### ADAM optimizer

The complete set of parameters for the `ADAM optimizer` is as follows.

```json
    "optimizer": {
        "optimizer": "ADAM",
        "epochs": 30,
        "batch_size": 1,
        "print_freq": 10,
        "lambda_2": 0.1,
        "learning_rate": 0.001,
        "stop_lr": 3.51e-08,
        "stop_step": 1000000,
        "decay_step": 5000,
        "train_energy": true,
        "train_force": true,
        "train_ei": false,
        "train_virial": false,
        "train_egroup": false,
        "start_pre_fac_force": 1000,
        "start_pre_fac_etot": 0.02,
        "start_pre_fac_ei": 0.1,
        "start_pre_fac_virial": 50.0,
        "start_pre_fac_egroup": 0.02,
        "end_pre_fac_force": 1.0,
        "end_pre_fac_etot": 1.0,
        "end_pre_fac_ei": 2.0,
        "end_pre_fac_virial": 1.0,
        "end_pre_fac_egroup": 1.0
    }
```

`optimizer`, `epochs`, `batch_size`, `print_freq`, `train_energy`, `train_force`, `train_ei`, `train_virial`, `train_egroup`. These parameters have the same functionality in the KF optimizer.

#### lambda_2
This parameter is used to set the` L2 regularization` term for the Adam optimizer. By default, it is not set. Setting a regularization term helps reduce model overfitting.

#### learning_rate
The parameter is the initial learning rate for the Adam optimizer. The default value is `0.001`.

#### stop_lr
The parameter refers to the stopping learning rate, indicating that the training process will stop when the learning rate decreases to that value. The default value is `3.51e-08`.

#### stop_step
The parameter refers to the stopping step, indicating that the training process will stop when reaching that step. The default value is `1000000`.

#### decay_step
This parameter represents the decay step, which indicates the interval at which the learning rate is decayed. After each decay step, the learning rate is updated according to a certain decay rate. The default value is `5000`.

`learning_rate`, `stop_lr`, `stop_step`, `decay_step` These four variables are used to update the learning rate, and the computation process is shown below in the following Python code or mathematical formula:

```python
decay_rate = np.exp(np.log(stop_lr/learning_rate) / (stop_step/decay_step))
real_lr = learning_rate * np.power(decay_rate, (iter_num//decay_step))
```

The calculation formula for the decay_rate.：

$$
\text{decay\_rate} = \exp\left(\frac{\log(\text{stop\_lr}/\text{start\_lr})}{\text{stop\_step}/\text{decay\_step}}\right)
$$

The calculation formula for the real learning rate：

$$
\text{real\_lr} = \text{start\_lr} \cdot \left(\mathrm{decay\_rate}\right)^{\left(\left\lfloor\frac{\text{iter\_num}}{\text{decay\_step}}\right\rfloor\right)}
$$

Where iter_num represents the number of iterations in the training process.

#### start_pre_fac_force
The prefactor of force loss at the start of the training, should be larger than or equal to 0. The default value is `1000`.

#### start_pre_fac_etot
The prefactor of total energy loss at the start of the training, should be larger than or equal to 0. The default value is `0.02`.

#### start_pre_fac_ei
The prefactor of atomic energy loss at the start of the training. Should be larger than or equal to 0. The default value is `0.1`.

#### start_pre_fac_virial
The prefactor of virial loss at the start of the training. Should be larger than or equal to 0. The default value is `50.0`.

#### start_pre_fac_egroup
The prefactor of egroup loss at the start of the training, Should be larger than or equal to 0. The default value is `0.02`.

#### end_pre_fac_force
The prefactor of force loss at the end of the training, Should be larger than or equal to 0. The default value is `1.0`.

#### end_pre_fac_etot
The prefactor of total energy loss at the end of the training, should be larger than or equal to 0. The default value is `1.0`.

#### end_pre_fac_ei
The prefactor of atomic energy loss at the end of the training, Should be larger than or equal to 0. The default value is `2.0`.

#### end_pre_fac_virial
The prefactor of virial loss at the end of the training, Should be larger than or equal to 0. The default value is `1.0`.

#### end_pre_fac_egroup
The prefactor of egroup loss at the end of the training, Should be larger than or equal to 0. The default value is `1.0`.