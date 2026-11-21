---
name: antigravity-delegate
description: Delegate bounded research engineering tasks to Google Antigravity using its native Sidecar and agentapi, then verify the returned code, experiment logs, and metrics. Use when the user asks Codex to dispatch and collect Antigravity work without per-task manual launches.
---

# Delegate research work to Antigravity

Use the Google Antigravity desktop app's native Sidecar to dispatch self-contained tasks under the user's existing Antigravity account. Codex writes the task, monitors the resulting conversation and files, and independently verifies the results.

## Choose what to delegate

- Start with a fixed baseline, scripted evaluation, regression test, known configuration sweep, or metric aggregation. Give the agent a clear input, an isolated workspace, a completion condition, and the exact evidence to return.
- Specify the variant, seeds, data split, dependency environment, permitted changes, and resource budget when they matter. Use a small public or synthetic task to validate an untested execution environment.
- Keep decisions about paper interpretation, experimental design, leakage risk, and scientific conclusions under Codex review. Evaluate the cost of checking and repairing an output when deciding whether similar work is worth delegating.
- For an authorized ACD Slurm task, read the HPC skills in the same skills collection as needed. Confirm the SSH host identity and login, and require the Job ID, terminal accounting status, exit code, raw logs and metric source. A local Sidecar run establishes none of those remote results.

## Dispatch and verify

1. For the native desktop setup, read [references/sidecar.md](references/sidecar.md). Google's FAQ limits wrapping subscription-authenticated agy headless calls inside third-party coding agents. Use the documented Antigravity-managed process for consumer-account dispatch. Use separate Gemini API credentials only when the user chooses API billing.
2. Write the task and input files into a dedicated workspace. For a single job, create a one-shot Sidecar with a unique ID and use native agentapi new-conversation. Capture the conversation ID and the receipt. For an existing supported standing Sidecar, use its established inbox instead.
3. Treat accepted dispatch, file creation, and experiment success as separate observations. Monitor the job's conversation and expected artifact paths. If a terminal step is blocked, capture the concrete error and check the permitted command and working directory before retrying. Avoid duplicate Slurm submissions when a Job ID already exists.
4. Inspect generated code before a Codex-side rerun. Independently recompute metrics from raw records and verify essential experiment invariants. Record which checks the delegated agent actually ran and disclose any Codex-side fixes or reruns separately.
5. Report the observed model when available, the evidence that passed, and the first unverified or failed step. Remove temporary one-shot Sidecar configuration after the test. Leave standing background operation to an explicitly requested setup.
