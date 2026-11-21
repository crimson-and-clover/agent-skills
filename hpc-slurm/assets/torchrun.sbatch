#!/usr/bin/env bash
#SBATCH --partition=acd
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --gres=gpu:4
#SBATCH --time=01:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

set -e
if (( $# == 0 )); then
    echo "Usage: sbatch torchrun.sbatch TRAIN.py [ARGS...]" >&2
    exit 2
fi

module load cuda/12.8
if [[ -n "${NCCL_ENV_FILE:-}" ]]; then
    source "$NCCL_ENV_FILE"
fi

# Keep this in sync with the per-node GPU request above.
workers_per_node=4
hosts=$(scontrol show hostnames "$SLURM_JOB_NODELIST")
master=${hosts%%$'\n'*}
port=${RDZV_PORT:-$((20000 + SLURM_JOB_ID % 20000))}

exec srun --ntasks="$SLURM_NNODES" --ntasks-per-node=1 --kill-on-bad-exit=1 \
    .venv/bin/python -m torch.distributed.run \
    --nnodes="$SLURM_NNODES" --nproc-per-node="$workers_per_node" \
    --rdzv-backend=c10d --rdzv-endpoint="$master:$port" \
    --rdzv-id="$SLURM_JOB_ID" "$@"
