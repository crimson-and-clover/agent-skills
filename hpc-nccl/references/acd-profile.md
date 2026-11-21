# ACD NCCL 配置记录

以下值来自原 HPC 技能，可用于对照旧作业或与集群管理员核对。实际生效条件取决于节点网络、NCCL 版本和插件。若要生成运行配置，只写入已确认适用的变量。

| 变量 | 历史值 | 核对事项 |
| --- | --- | --- |
| `NCCL_SOCKET_IFNAME` | `vlan0.2135` | 依赖节点网络和站点设置。 |
| `NCCL_NET_GDR_LEVEL` | `PHB` |  |
| `NCCL_IB_DISABLE` | `0` |  |
| `NCCL_IB_HCA` | `mlx5_0,mlx5_1,mlx5_2,mlx5_6,mlx5_7,mlx5_8,mlx5_9,mlx5_10` | 依赖节点网络和站点设置。 |
| `NCCL_IB_GID_INDEX` | `3` | 依赖节点网络和站点设置。 |
| `NCCL_IB_TC` | `138` | 依赖节点网络和站点设置。 |
| `NCCL_NSOCKS_PERTHREAD` | `8` |  |
| `NCCL_SOCKET_NTHREADS` | `4` |  |
| `NCCL_NVLS_ENABLE` | `0` | 核对当前版本、硬件拓扑和插件支持。 |
| `NCCL_NVLS_PLUGIN` | `1` | 核对当前版本、硬件拓扑和插件支持。 |
| `NCCL_NVLS_LANES` | `2` | 核对当前版本、硬件拓扑和插件支持。 |
| `NCCL_IB_QPS_PER_CONNECTION` | `8` |  |
| `NCCL_IB_SPLIT_DATA_ON_QPS` | `1` |  |
| `NCCL_MIN_CTAS` | `32` |  |
| `NCCL_MAX_CTAS` | `128` |  |
| `NCCL_IB_RETRY_CNT` | `7` |  |
| `NCCL_MIN_NCHANNELS` | `64` |  |
| `NCCL_MAX_NCHANNELS` | `256` |  |
| `NCCL_NCHANNELS_PER_NET_PEER` | `32` |  |
| `NCCL_BUFFSIZE` | `33554432` |  |
| `NCCL_LL_BUFFSIZE` | `33554432` |  |
| `NCCL_P2P_NET_CHUNKSIZE` | `2097152` |  |
| `NCCL_P2P_LEVEL` | `nvl` | 核对当前版本、硬件拓扑和插件支持。 |
| `NCCL_ALGO` | `nvlstree,ring` | 核对当前版本、硬件拓扑和插件支持。 |
| `NCCL_LL_MAX_NCHANNELS` | `4` |  |
| `NCCL_CROSS_NIC` | `1` |  |
| `NCCL_IGNORE_CPU_AFFINITY` | `1` |  |
| `NCCL_SHM_DISABLE` | `0` |  |
| `NCCL_COLLNET_ENABLE` | `1` | 核对当前版本、硬件拓扑和插件支持。 |
| `NCCL_DEBUG` | `INFO` | INFO 可用于诊断。 |
| `NCCL_TIMEOUT` | `3600` | 核对当前框架或站点是否读取该变量。 |
| `NCCL_IB_TIMEOUT` | `3600` | 指数参数，3600 不是秒数。按实际版本和站点建议确认。 |


## 原作业环境

原示例的作业名为 `speed_test`，使用 `acd` 分区、2 个节点、每节点 4 张 GPU，并依次加载 `anaconda3`、`cuda/12.8`、`nccl/2.25` 后运行 `train.py`。需要复现时，核对这些模块与项目实际依赖，使用 [Slurm 多节点模板](../../hpc-slurm/assets/torchrun.sbatch) 启动。原日志目录 `/data/user/$USER/project/log/` 如需写在 `#SBATCH` 指令中，用 Slurm 的 `%u` 表示用户名。
