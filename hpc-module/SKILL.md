---
name: hpc-module
description: >-
  Discover, inspect, and load software with Environment Modules on the HPC 三期
  ACD cluster. Use for module avail, load, unload, switch, purge, show, whatis,
  list, is-loaded, or keyword, and software versions such as CUDA, GCC, Python,
  Anaconda, OpenMPI, NCCL, uv, and FFmpeg.
---

# ACD 软件模块

ACD 使用 Environment Modules，原记录的版本为 4.5.2。已记录的模块树包括 `/data/modulefiles/tools`（编译器、运行时、CUDA、Python、MPI）、`/data/modulefiles/soft`（ANSYS、FFmpeg、VASP 等应用）、`/data/modulefiles/opensource`（Apptainer、Julia、LAMMPS、uv 等开源工具）以及 `/usr/share/Modules/modulefiles`（`dot`、`null`、`use.own` 等系统模块）。在集群上的 shell 中确认实际路径和版本。

```bash
module avail
module avail cuda
module keyword ffmpeg
module whatis cuda/12.8
module show cuda/12.8
module list
module is-loaded cuda/12.8
module load cuda/12.8
```

- 项目需要可复现环境时，优先在作业脚本里写明确的版本。换版本可用 `module switch cuda/12.4 cuda/12.8`，移除用 `module unload cuda/12.8`。需要从干净环境启动时再用 `module purge`。
- 如果批处理环境找不到 `module`，先检查作业 shell 是否加载了站点的 Modules 初始化。涉及 MPI、CUDA 或 NCCL 时，用 `module show` 确认路径变化，并核对程序实际用到的库。
- 查看历史可用版本和原作业环境示例时读 [ACD 模块清单](references/module-versions.md)。选用前以目标环境的 `module avail` 为准。
- 建 Python 虚拟环境见 [hpc-dev](../hpc-dev/SKILL.md)，写作业脚本见 [hpc-slurm](../hpc-slurm/SKILL.md)，多节点 GPU 通信见 [hpc-nccl](../hpc-nccl/SKILL.md)。
