---
name: hpc
description: >-
  Answer questions about the HPC 三期 ACD cluster, including platform overview,
  job limits, and portal navigation. Route cross-cutting questions to the
  dedicated Slurm, environment modules, Python development, and NCCL skills.
---

# HPC 三期 ACD 平台

ACD 使用 Slurm 调度。现有平台资料记录单个作业最长运行 7 天，到期前可通过「科大 Go → IT 工单」申请延长 7 天。具体上限以当前分区、账户策略和平台门户为准。

在门户进入「作业管理 → 作业列表」，可以查看作业详情、输出、数据和运行中的 CPU、内存及 GPU 使用情况。

## 按任务读取

| 任务 | 技能 |
| --- | --- |
| 申请资源、提交、查看状态、取消作业、作业数组、交互式作业 | [hpc-slurm](../hpc-slurm/SKILL.md) |
| 查询或加载 CUDA、编译器、MPI 等软件模块 | [hpc-module](../hpc-module/SKILL.md) |
| 用 uv 搭建 Python 环境、使用离线 wheel、测推理性能 | [hpc-dev](../hpc-dev/SKILL.md) |
| 配置或排查多节点 NCCL、InfiniBand 或 RoCE | [hpc-nccl](../hpc-nccl/SKILL.md) |

涉及多项任务时，按需要组合对应技能。例如部署 PyTorch 多节点训练时，先确认 Python 环境，再使用 Slurm 模板，遇到集群网络配置问题时查 NCCL 资料。
