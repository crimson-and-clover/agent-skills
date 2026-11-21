---
name: hpc-nccl
description: >-
  Configure or diagnose NCCL on the HPC 三期 ACD cluster for multi-node GPU
  training. Use for NCCL environment variables such as NCCL_SOCKET_IFNAME,
  NCCL_IB_HCA, NCCL_IB_GID_INDEX, and NCCL_P2P_LEVEL, or InfiniBand and RoCE
  interfaces, transport selection, collective hangs, and all-reduce tuning.
---

# ACD 多节点 NCCL

## 核对通信环境

1. 确认作业分区、节点、GPU 绑定，以及应用实际加载的 NCCL 版本。PyTorch 可用 `python -c 'import torch; print(torch.cuda.nccl.version())'` 查看其 NCCL 版本。加载模块的操作见 [hpc-module](../hpc-module/SKILL.md)。
2. 原流程要求在 ACD 的多节点多 GPU 训练中预设站点的网络参数。使用适配当前节点类型和 NCCL 版本的配置。核对原参数和原作业使用的模块组合时，读 [ACD NCCL 配置记录](references/acd-profile.md)。先确认网络接口、HCA 和传输模式，再考虑 GID 或性能调优项。
3. 通过 [hpc-slurm](../hpc-slurm/SKILL.md) 的多节点模板启动。在分布式 launcher 启动前加载已核对的环境配置，使所有 worker 继承一致的设置。
4. 用小规模多节点 collective 验证。排障时可临时设置 `NCCL_DEBUG=INFO` 和 `NCCL_DEBUG_SUBSYS=INIT,NET`，结合各 rank 日志确认实际传输、节点和报错。检查成功后，再用固定节点数和数据规模比较吞吐。

`NCCL_IB_TIMEOUT` 是 InfiniBand Verbs 超时的指数参数，计算方式为 `4.096 µs × 2^值`。旧记录中的 `3600` 不应作为秒数写入作业。需要调整时，参考实际加载版本的参数说明及站点建议。

参考 [NCCL 2.25.1 环境变量](https://docs.nvidia.com/deeplearning/nccl/archives/nccl_2251/user-guide/docs/env.html)。
