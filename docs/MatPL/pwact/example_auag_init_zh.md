---
sidebar_position: 5
---

# Example for AuAg active learning

本案例为金银合金体系的主动学习过程，案例位于 [`pwact/example/auag_pwmat/`](https://github.com/LonxunQuantum/PWact/tree/main/pwact/example/auag_pwmat) 首先通过 `INIT_BULK` 构造初始训练集，之后使用初始训练集训练模型，使用在 INIT_BULK 中使用微扰产生的结构做为初始构型，使用`用户输入的lammp.in`输入控制文件做主动学习采样。
:::tip
使用`用户输入的lammp.in`输入控制文件下做主动学习采样在 `pwact-0.4` 版本中开始支持。
:::

以下案例使用的 DFT 计算软件为 PWMAT，案例也提供了使用 VASP 的对应设置[`pwact/example/auag_vasp/`](https://github.com/LonxunQuantum/PWact/tree/main/pwact/example/auag_vasp)、 CP2K的对应设置[`pwact/example/auag_cp2k/`](https://github.com/LonxunQuantum/PWact/tree/main/pwact/example/auag_cp2k)。对于 Mcloud用户，请访问路径`/share/public/PWMLFF_test_data/pwact_examples/25-pwact-demo`即可。

请注意，案例中提供的DFT设置仅用于程序执行流程测试，不保证计算精度!

# INIT_BULK

## 启动命令

进入 `pwact/example/auag_pwmat/init_bulk` 目录 
```JSON
pwact init_bulk init_param.json resource.json
```

## INIT_BULK 目录结构

INIT_BULK 目录与 [si_pwmat 案例](./example_si_init_zh.md#init_bulk) 目录结构相同。

# 主动学习

执行完毕 init_bulk 命令之后，进入 `examples/auag_pwmat/run_iter_lmps` 目录：
启动命令：
```
pwact run param.json resource.json
```

## 主动学习文件目录

主动学习目录结构与 [si_pwmat 例子](./example_si_init_zh.md#主动学习)目录结构相同。唯一区别是对md的目录名称，如'md.000.sys.000/md.000.sys.000.t.000.p.000' 将变成'md.000.sys.000/md.000.sys.000.lmps.000'，这里`lmps.000`用于标示使用的lammps.in文件编号。

``` txt
example
├──param.json
├──resource.json
├──scf_etot.input
├──iter.0000
│    ├──00.train
│    │   ├──...
...
│    ├──01.explore
│    │   ├──md
│    │   │    ├──md.000.sys.000
│    │   │    │     ├──md.000.sys.000.lmps.000
│    │   │    │     ├──...
│    │   │    │     └──model_devi_distribution.png
│    │   │    ├──md.000.sys.001
│    │   │    ├──md.001.sys.000
│    │   │    └──md.001.sys.003
│    │   └──select
│    │        ├──accurate.csv
│    │        ├──candidate.csv
│    │        ├──candidate_delete.csv
│    │        ├──fail.csv
│    │        ├──error_traj.log
│    │        ├──select_summary.txt
│    │        ├──model_devi_distribution-md.000.sys.000.png
│    │        └──...
│    └──02.label
│    │   ├──scf
│    │   │    ├──md.000.sys.000
│    │   │    │    ├──md.000.sys.000.t.001
│    │   │    │    │    ├──820-scf
│    │   │    │    │    │    ├──820.config
│    │   │    │    │    │    ├──etot.input
│    │   │    │    │    │    ├──REPORT
│    │   │    │    │    │    └──OUT.MLMD
│    │   │    │    │    ├──200-scf
│    │   │    │    │    └──...
│    │   │    │    └──md.000.sys.000.t.000
│    │   │    │         └──...
│    │   │    ├──md.000.sys.001
│    │   │    ├──...
│    │   │    ├──md.001.sys.000
│    │   └──result
│    │        └──train.xyz

├──iter.0001
│    └──...
├──...
```


