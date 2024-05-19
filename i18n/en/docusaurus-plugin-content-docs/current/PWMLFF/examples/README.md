---
sidebar_position: 4
title: PWMLFF Examples
---

In this chapter, we compile some test work done using PWMLFF, as well as published papers using PWMLFF, to provide references for users.

### [1. Comparison of Features](./features.md)

In this example, we compare the differences in the ability of `feature types in PWMLFF` to describe physical systems. These feature types include `cosine features`, `Gaussian features`, `moment tensor potential (MTP) features`, `spectral neighbor analysis potential (SNAP) features`, `simplified smooth deep potential with Chebyshev polynomial features` and `Gaussian polynomial features`, and `atomic cluster expansion features`. The article uses a `linear regression model` to evaluate the `atomic group energy`, `total energy`, and `force` training root mean square error (RMSE) against density functional theory results under `amorphous sulfur systems` and `carbon systems`. For a detailed introduction to the features, please refer to [Feature Wiki](../Appendix-1.md).

More test details can also be found in the [Longxin WeChat article](https://mp.weixin.qq.com/s/JjkivADrvUdOE_C9qCuA9g) and the [[paper Accuracy evaluation of different machine learning force field features]](https://iopscience.iop.org/article/10.1088/1367-2630/acf2bb).

### [2. LKF And ADAM](./LKF%20vs%20Adam.md)

PWMLFF implements the [[Reconfigured Layer Extended Kalman Filter (RLEKF) optimizer]](https://arxiv.org/abs/2212.06989), aimed at accelerating the training of neural network force fields. RLEKF is an improved version of the global extended Kalman filter (GEKF), reducing computational costs by segmenting large layers and aggregating small layers. This strategy uses sparse diagonal block matrices to approximate the dense weight error covariance matrix, thereby enhancing computational efficiency. The authors conducted numerical experiments on `13` common systems and compared the results with the ADAM optimizer.

### [3. Active Learning](./Active%20Learning.md)
[PWact](../active%20learning/README.md) (Active learning based on PWMLFF) is an open-source automated active learning platform we developed based on PWMLFF for efficient data sampling. PWact implements commonly used active learning strategies based on committee query, as well as our uncertainty measurement algorithm based on the Kalman filter algorithm (Kalman Prediction Uncertainty, KPU). Active learning based on KPU is still in the testing phase and not yet open for user access. In this example, we compare two active learning sampling methods.

### [4. General Models (Large Models)](./GNN.md)
Various general models based on GNN are rapidly emerging. These general models can be "out of the box" or serve as "base models" that can be quickly applied to various specialized fields through fine-tuning, distillation, active learning, and other methods, significantly reducing the cost of force field construction. We conducted some fine-tuning tests on the recently open-sourced [MACE (Paper Link)](https://arxiv.org/abs/2401.00096).

### [5. Simulating Liquid to Crystal Silicon Growth Using Machine Learning Force Fields (Case Study)](./Si.md)
[[Paper Liquid to crystal Si growth simulation using machine learning force field]](https://pubs.aip.org/aip/jcp/article/153/7/074501/1064762/Liquid-to-crystal-Si-growth-simulation-using)

[[This case study]](https://pubs.aip.org/aip/jcp/article/153/7/074501/1064762/Liquid-to-crystal-Si-growth-simulation-using) uses PMLFF to simulate the growth process of silicon melt far from equilibrium and finds that the MLFF constructed based on atomic energy decomposition from first-principles (`PWmat characteristics`) can accurately reproduce the growth process simulated by first-principles. A method to correct the systematic bias existing in ML-FF training is proposed, which is crucial for accurately simulating key results such as phase transition temperatures. The results show that ML-FF can accurately simulate the silicon melt growth process, providing evidence for using ML-FF for far-from-equilibrium simulations.

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/si.gif").default} alt="cu_ffc_333" width="300" />
  </div>
</div>

### [6. Studying the Role of Hydrogen in α-Fe Crack Propagation Using Machine Learning Force Field (Case Study)](./Fe.md)
[[Paper Revealing Morphology Evolution of Lithium Dendrites by Large-Scale Simulation Based on Machine Learning Force Field]](https://onlinelibrary.wiley.com/doi/abs/10.1002/aenm.202202892)

This case mainly introduces the study of the impact of hydrogen on the crack propagation in α-iron using machine learning force fields. Specific content includes: 1. Based on density functional theory calculation results, a machine learning force field for the iron-hydrogen system was constructed. This force field uses a neural network model and trains atomic energy. The force field exhibits good statistical and dynamic properties. 2. Using molecular dynamics simulation, the impact of hydrogen concentration on crack propagation in an α-iron model sample with cracks was studied. The study found that the higher the hydrogen concentration at the crack tip, the faster the crack propagation, indicating that hydrogen promotes crack propagation. 3. In samples with grain boundaries, microvoids were observed at the crack tip, helping to release the tensile stress at the crack tip and promote crack propagation. However, the formation of microvoids seemed to be unrelated to the presence of hydrogen. 4. The study also found that in structures with shorter periodicity in the x direction, crack propagation speed was faster, possibly due to synergistic effects in the x direction. 5. Compared with the results of the embedded atomic force field, the machine learning force field showed a significant impact of hydrogen on crack propagation, indicating the importance of accurately describing the force field of hydrogen-metal interactions. 6. The results show that hydrogen aggregation at the crack tip plays a key role in hydrogen embrittlement crack propagation, requiring further in-depth study of hydrogen embrittlement behavior under different conditions.

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/fe1.gif").default} alt="cu_ffc_333" width="251" />
  </div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/fe2.gif").default} alt="si_diamond_222" width="251" />
  </div>
</div>

### [7. Revealing Morphology Evolution of Lithium Dendrites by Large-Scale Simulation Based on Machine Learning Force Field (Case Study)](./Li.md)

[[Longxin WeChat article]](https://mp.weixin.qq.com/s/kapzIrPvL2AcGTUzdHgglg) and the [[Accuracy evaluation of different machine learning force field features]](https://iopscience.iop.org/article/10.1088/1367-2630/acf2bb).

This case uses machine learning force fields combined with a self-consistent continuous solvent model to simulate the morphology evolution of lithium dendrites in working electrolyte environments. The results show that dendrite morphology evolution can be divided into two stages. The first stage is driven by the reduction of surface atomic energy, leading to local orientation rearrangement of the initially single-crystal dendrites, forming multiple crystalline domains. The second stage is driven by the reduction of internal atomic energy, promoting crystalline domain slip along grain boundaries and reducing grain boundary energy. The article also discusses the impact of different exposed surface orientations on dendrite morphology changes. Overall, the reduction of surface energy and grain boundary energy drives dendrite morphology evolution.

<div>
  <div style={{ display: 'inline-block', marginRight: '10px' }}>
    <img src={require("./pictures/li.gif").default} alt="cu_ffc_333" width="400" />
  </div>
</div>