#!/usr/bin/env bash
#SBATCH --partition=acd_u
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

set -e
if (( $# == 0 )); then
    echo "Usage: sbatch single-gpu.sbatch SCRIPT.py [ARGS...]" >&2
    exit 2
fi

module load cuda/12.8
exec .venv/bin/python "$@"
