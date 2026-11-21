---
name: hpc-slurm
description: >-
  Prepare, submit, inspect, or manage Slurm workloads on the HPC 三期 ACD
  cluster. Use for sbatch, srun, squeue, sacct, scontrol, scancel, CPU, GPU, and memory resources,
  interactive sessions, job arrays, or multi-node job launch.
---

# ACD Slurm 作业

## 选择资源与入口

- 单进程用 `--ntasks=1 --cpus-per-task=N`，多个 Slurm 任务才增加 `--ntasks`。`--mem` 请求每节点内存，`--gres=gpu:N` 请求每节点 GPU。
- ACD 使用记录中，`acd_u` 每张 GPU 最多分配 12 个 CPU。多节点示例使用 `acd`。提交前按需要用 `sinfo` 或 `scontrol show partition acd_u` 核对可用分区和时限，账户限制以站点实际配置为准。平台最长作业时限、延长申请和门户监控入口见 [hpc 总览](../hpc/SKILL.md)。
- 单 GPU Python 作业使用 [single-gpu.sbatch](assets/single-gpu.sbatch)。环境准备见 [hpc-dev](../hpc-dev/SKILL.md)，模块查询见 [hpc-module](../hpc-module/SKILL.md)。
- 多节点 PyTorch DDP 使用 [torchrun.sbatch](assets/torchrun.sbatch)。每节点启动一个 `torchrun`，由它按 GPU 数启动本地 worker。训练程序需支持 DDP，并按 `LOCAL_RANK` 选择设备。各节点应能访问同一项目目录、运行环境和数据。需要指定网络参数时，按 [hpc-nccl](../hpc-nccl/SKILL.md) 准备配置。

## 提交与交互

把适用模板复制进项目目录，按项目调整分区、时限、资源或 CUDA 模块。在项目目录创建日志目录，再提交。批处理脚本中的 `#SBATCH` 由 Slurm 解析，文件名用 `%j` 表示作业号，`%u` 表示用户名。

```bash
mkdir -p logs
sbatch --parsable single-gpu.sbatch scripts/infer.py
# 多节点示例，首个参数为训练脚本
sbatch --parsable torchrun.sbatch train.py
```

若已有作业脚本，也可直接在提交时指定资源和日志，例如 `sbatch -p acd_u --ntasks=1 --cpus-per-task=8 --gres=gpu:1 -o output_%j.txt -e err_%j.txt job_script.sh`。`-D /apps`（`--chdir=/apps`）可指定作业工作目录，默认沿用提交时的工作目录。若要沿用原多节点日志路径，可写 `-o /data/user/%u/project/log/%j.out`，并在提交前确认该目录已创建。

多节点模板可通过 `RDZV_PORT` 指定站点允许的空闲端口，同一节点若有并行作业，注意避免端口冲突。若管理员要求明确的 NCCL 环境，通过 `NCCL_ENV_FILE` 指定批处理节点可读取的、已核对的 shell 配置文件。配置中的变量需用 `export` 导出。

交互式开发可用 `srun -p acd_u --ntasks=1 --cpus-per-task=12 --mem=32G --gres=gpu:1 --time=04:00:00 --pty bash`。其中 `--time` 设置最长运行时间，`--pty bash` 分配伪终端并启动 Bash。需要指定或排除节点时，分别使用 `--nodelist=ACD1-1,ACD1-2` 或 `--exclude=ACD1-1`。

## 数组作业

以下示例处理索引 1 到 10。原示例使用 `normal`，提交前按站点当前可用的分区调整。`%A` 是主作业 ID，`%a` 是子任务索引。

```bash
#!/usr/bin/env bash
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --array=1-10
#SBATCH --output=output_%A_%a.txt
#SBATCH --error=error_%A_%a.txt

printf 'Running task %s\n' "$SLURM_ARRAY_TASK_ID"
exec python your_script.py "$SLURM_ARRAY_TASK_ID"
```

## 状态和取消

- 相同脚本处理不同参数时，用 `--array=1-10%2` 提交数组，示例最多同时运行两个子作业。也支持 `1,3,5` 和 `1-10:2`。脚本内读 `"$SLURM_ARRAY_TASK_ID"`，日志命名用 `%A_%a`。
- 用 `squeue -u "$USER"` 查看作业，可加 `-t PENDING,RUNNING` 过滤状态。用 `sacct -u "$USER"` 查用户历史，`sacct -u "$USER" --array` 展开数组历史。将提交回执中的数字 ID 赋给 `job_id` 后，用 `scontrol show job "$job_id"` 查看详情和排队原因，用 `sacct -j "$job_id" --format=JobID,State,ExitCode,Elapsed` 查看结束状态。数组可加 `--array`，子作业详情可用 `scontrol show job "$array_task_id"`，其中 `array_task_id` 形如 `作业ID_索引`。
- 用户要求取消时，用 `scancel "$job_id"` 操作指定作业。挂起和恢复可用 `scontrol suspend "$job_id"` 和 `scontrol resume "$job_id"`，权限由站点决定。
- `sbatch` 返回 ID 表示提交已受理。确认成功时同时检查终态、退出码、日志和所需产物。提交回执不确定时，先查现有作业，再决定是否重试。

参考 [Slurm sbatch 文档](https://slurm.schedmd.com/sbatch.html) 和 [PyTorch torchrun 文档](https://docs.pytorch.org/docs/stable/elastic/run)。
