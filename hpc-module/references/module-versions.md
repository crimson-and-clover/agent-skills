# ACD 模块清单

以下是原技能记录的版本快照。模块版本和默认项以目标环境中的 `module avail` 为准。

| 类别 | 模块 | 可用版本 |
|------|------|----------|
| **Python** | anaconda3 | (default) |
| | miniconda3 | (default) |
| | python | 3.12 |
| **CUDA** | cuda | 11.3, 11.7, 11.8, 12.1, 12.2, 12.4, 12.6, 12.8, 13.0, 13.1 |
| **GCC** | gcc | 4.8.5, 10.5, 11.5, 12.5, 13.3 |
| **Intel** | intel | 2018u4, 2019u5, 2020u4, 2021u4, 2024u2 |
| **NVHPC** | nvhpc | 22.11, 24.11, 26.3 |
| **OpenMPI** | openmpi | 4.1.5, 4.1.6, 5.0.6 |
| | openmpi/4.1.5-cuda | (GPU-aware) |
| **MPICH** | mpich | 4.1.1 |
| **NCCL** | nccl | 2.25 |
| **CMake** | cmake | 3.17.5, 3.27.0, 3.27.9 |
| **GLibc** | glibc | 2.29, 2.32, 2.34, 2.35 |
| **Go** | go | 1.19, 1.22, 1.25 |
| **JDK** | jdk / openjdk | 1.8.0_202, 21.0.7 |
| **容器** | apptainer | 1.3.6, 1.4.5 |
| | singularity | 4.1.5, 4.4.1 |
| **Julia** | julia | 1.10.2, 1.10.9, 1.11.3 |
| **应用** | ffmpeg | 4.4.1, 5.1.1, 5.1.7, 6.0.1, 7.0.2 |
| | vasp | 6.5.1 |
| | ansys | 2024R1 |
| | lammps | 2020, 2023, 2024 |
| | orca | 6.0.1 |
| **工具** | rclone | 1.59.2, 1.73.5 |
| | uv | 0.9.5, 0.9.13, 0.11.6 |


## 原作业模块组合

原示例在 `acd` 分区申请每节点 4 张 GPU。以下是 Slurm 指令之后、应用启动之前的模块设置。按项目决定是否清理已有环境，以及是否需要 NCCL 或 GPU-aware MPI。

```bash
module purge
module load anaconda3
module load cuda/12.8
# 需要站点 NCCL 模块时
module load nccl/2.25
# 需要 GPU-aware MPI 时
module load openmpi/4.1.5-cuda
```

原示例在加载后运行 `python train.py`。多节点作业使用 [Slurm 多节点模板](../../hpc-slurm/assets/torchrun.sbatch) 启动各节点的进程。
