---
name: deepseek-delegate
description: Dispatch clearly specified research execution tasks to DeepSeek through OpenCode and independently verify the deliverables. Use when the user asks to outsource baseline runs, seed sweeps, log aggregation, known bug fixes, or specified evaluation code to DeepSeek.
---

# Delegate research execution to DeepSeek

Codex owns task selection, dispatch, verification, and the answer to the user. Use the configured OpenCode provider and run the delegate yourself.

## Choose work by how cheaply it can be verified

- **Delegate as specified**. Run known baselines, fixed seed or configuration sweeps, and smoke tests. Extract metrics from raw logs and build tables from structured results. Check the commands and the evidence directly.
- **Define the test first**. For known bugs, regression tests, and evaluation functions, give the exact entry point, a minimal reproducer, expected outputs, and edge cases. For a fix, require tests that exercise the actual entry point and reproduce the failure before the change.
- **Keep scientific judgment with Codex**. This includes close reading of papers, hypothesis selection, consequential controls, unexplained metric anomalies, and interpretation. Delegate discrete checks after deciding what each check would establish.

An apparently reasonable wrong answer must be cheap to detect. Split ambiguous work into smaller hypotheses or keep it with Codex when verification would cost more than doing the job.

## Dispatch and verify

1. Define a narrow task with inputs, an executable command, expected artifacts, and acceptance checks. For an experiment, specify the dataset and split, checkpoint or baseline, seeds, environment, and resource budget when relevant. Use a scratch directory or separate worktree when isolated writes would protect existing work.
2. Follow [the OpenCode runbook](references/opencode.md) for model selection, non-interactive dispatch, and scoped tool permissions. Run it from the task workspace. Keep session events and diagnostics to distinguish a launcher failure from an agent failure.
3. Wait for the actual run. Verify tool results, process or job exit status, and expected output files. Inspect the diff or entry point and recompute decision-relevant metrics from raw outputs. If a regression test duplicates the fixed logic, test the exported function or CLI directly before accepting it.
4. Report what DeepSeek actually ran, what Codex checked or fixed, and what remains unverified. For repeated tasks, compare the handoff, verification, and correction time with doing the work directly.

For `hpc3` tasks, consult the local `hpc` and `hpc-slurm` skills as applicable. This delegate has been verified on local CPU work. Before relying on it for remote execution, verify SSH and a small authorized Slurm job end to end. Capture the job ID, accounting status and exit code, and raw logs. Investigate an existing job ID before retrying submission.

