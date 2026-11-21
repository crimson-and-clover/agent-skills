---
name: hpc-dev
description: >-
  Set up and test Python projects on the HPC 三期 ACD cluster. Use for uv-managed
  Python and virtual environments, the local wheel or Hugging Face cache,
  CUDA-enabled PyTorch, torch.compile, development and test jobs, inference
  smoke tests, and RTF benchmarks.
---

# ACD Python 开发与推理

## 环境准备

优先沿用项目锁文件或已有环境说明。没有项目约定时，可从 ACD 已用的组合开始，使用 uv 管理 Python 3.12，加载 CUDA 12.8，并从 `"$HOME/wheels"` 安装 PyTorch cu128。这套流程由 uv 管理 Python 和依赖，使用 `uv pip` 安装到虚拟环境。模块版本以 [hpc-module](../hpc-module/SKILL.md) 的查询方式为准。

```bash
module load uv/0.11.6 cuda/12.8
uv python install 3.12
uv venv --python 3.12 .venv
uv pip install --python .venv/bin/python --no-index --find-links "$HOME/wheels" \
    'torch==2.7.1+cu128' 'torchaudio==2.7.1+cu128'
```

这组版本适用于兼容的项目。Python 若未缓存，`uv python install` 可能需要下载。继续安装依赖时，按项目实际使用的文件或锁文件执行。例如项目有 `requirements.txt` 时可用 `uv pip install --python .venv/bin/python --find-links "$HOME/wheels" -r requirements.txt`。允许访问包索引时，`--find-links` 提供额外候选。必须离线安装时加 `--no-index`，先确认所需依赖也有对应 wheel。原流程对 PyTorch 等大包单独使用 `--no-index`，其余依赖可按项目约定在线补齐。项目支持可编辑安装且确实需要时，再执行 `uv pip install --python .venv/bin/python -e .`。

模型先查 `"$HOME/huggingface"`。例如有 VoxCPM2 缓存且项目用该路径时，先确认链接目标目录存在、项目中的同名路径可用，再执行以下命令。

```bash
mkdir -p pretrained_models
ln -s "$HOME/huggingface/openbmb/VoxCPM2" pretrained_models/VoxCPM2
```

## 在计算节点验证

测试时用 [hpc-slurm](../hpc-slurm/SKILL.md) 的单 GPU 模板或交互式作业。将 Slurm、模块加载和环境初始化写在作业脚本里，将推理逻辑留在项目脚本里。单 GPU 推理测试可从原约定的 1 GPU、12 CPU、32 GiB 和 30 分钟起步。训练按模型、数据和并行规模调整。提交前从项目目录创建 `logs/`，新项目沿用原约定，将 `logs/` 加入 `.gitignore`。

交互式作业启动 Bash 后，进入项目目录并初始化环境。

```bash
module load cuda/12.8
source .venv/bin/activate
```

在分配到 GPU 的环境里，先确认 PyTorch 版本和 `torch.cuda.is_available()`，再用已知的小输入验证输出。需要快速排查时，若项目支持 `--no-optimize` 或等价选项，可先跳过 `torch.compile`，并在结果中记录模式。

## 测量推理速度

把模型加载、首次编译和预热单独报告。在同一作业、同一进程里复用模型实例并运行多轮推理，记录每轮耗时和 RTF，即推理耗时除以输出音频时长。固定输入或记录输入长度及输出时长，避免把冷启动和稳态混在一起。稳态多轮测试放在一次 `sbatch` 内，重复提交会重新启动进程。若直接测量异步 GPU 操作，按框架方法同步后计时。

原测试记录中，`torch.compile` 首轮 JIT 约 2–3 分钟，命中 `/tmp/torchinductor_*` 缓存后启动较快。默认 `/tmp` 通常按节点存储，换节点可能重新编译。原记录中 `--no-optimize` 可省去约 2.5 分钟编译时间，但稳态 RTF 会变高。耗时和收益取决于模型、输入形状、软件版本及缓存目录。

推理脚本可用 `argparse` 提供 `--rounds`，默认 3 轮。输出一次 `[Load + warm-up]`，再逐轮输出 `[Generate]` 的耗时和 RTF。

原技能曾记录 VoxCPM2 在 Python 3.12.13、CUDA 12.8、PyTorch 2.7.1+cu128 下稳态 RTF 约 0.18，可作为历史对照。
