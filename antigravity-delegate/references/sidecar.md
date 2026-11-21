# Native Antigravity Sidecar dispatch

## Verified local smoke test

On 2026-11-21, Antigravity desktop hot-loaded a one-shot Windows Sidecar from its documented global customization directory. The worker ran native agentapi, which returned a conversation ID and exit code 0. The delegated conversation read a synthetic CSV and wrote the requested JSON. An independent check confirmed paired differences of 52, 47, and 57 percentage points, a mean of 52, and a sample standard deviation of 5. The conversation's generation metadata identified Gemini 4 Hydrogen High. This validates account-backed dispatch and result pickup for that desktop configuration.

## Verified CPU research benchmark

A second Sidecar run used the same account and the same observed Hydrogen High model. Codex provided an isolated Python environment with scikit-learn 1.7.2 already installed. Hydrogen wrote and ran the experiment and evaluation tests via one scoped command from that workspace. It found wraparound, same-source split leakage, and contamination of the shifted test partition. Its 12 unit tests passed, including a Codex rerun. The three-seed result was recomputed independently from raw JSON. Mean paired difference and sample standard deviation were −1.67 and 0.48 percentage points on clean data, and +48.70 and 1.43 points on shifted data.

This check used a public CPU dataset. Model pinning at dispatch, installation of dependencies by the agent, standing inbox operation, and remote Slurm execution were outside the test. Check any statement about the gain from augmentation against the training budget. Adding extra training samples also changes the number of updates. A same-budget duplicate-original control can help separate the two effects.

## Configure a one-shot run

1. Scope work to a dedicated local directory and put the task and inputs there. Keep the sidecar worker logs outside the agent's input directory when practical. On Windows, use an absolute path to the Python interpreter or other trusted runner in the Sidecar command.
2. Antigravity discovers a Sidecar manifest in ~/.gemini/config/sidecars/<unique-id>/sidecar.json. Use a command Sidecar with args and restart_policy set to never for an individual test. Configure agent_permissions.workspace_uris with the isolated directory's file URI. Restrict any extra access_grants to the input, output, and commands the job requires. Do not grant shell access broadly just to remove a permission prompt.
3. Enable the Sidecar by adding its entry to the existing sidecars object in ~/.gemini/config/config.json. Preserve the rest of the user configuration. A Sidecar calling new-conversation needs a projectId. The verified isolated smoke run used the installed outside-of-project ID with an explicit workspace URI. Confirm that this ID exists locally before using it or use an otherwise appropriate isolated Antigravity project.
4. From the Sidecar worker, invoke agentapi new-conversation -- <task prompt> with a bounded subprocess timeout, and save stdout, stderr, and the exit code. Native Antigravity adds agentapi to the Sidecar process PATH. Record the returned response.newConversation.conversationId. Write an atomic claim or use a unique per-job directory for retryable dispatch and avoid resubmitting an accepted job.
5. Check the expected artifact and the specific conversation. On the tested installation, Sidecar events and logs are under ~/.gemini/antigravity/sidecar_data/<unique-id>, and a conversation's local logs are under ~/.gemini/antigravity/brain/<conversation-id>/.system_generated/logs. These local formats may change. Prefer app-visible model information or generation metadata for the exact conversation. Do not infer the selected model from the prompted model name or a worker's self-report. The documented new-conversation command does not expose a per-call model selector.
6. On completion or failure, disable and remove the test's manifest and configuration entry while preserving subsequent user edits. Do not restart the desktop app during a different active job unless necessary and authorized.

Use the [Google Sidecars documentation](https://antigravity.google/docs/sidecars) to refresh the manifest and API contract. Consult [tool permission syntax](https://antigravity.google/docs/permissions) for a denied command and the [Google Antigravity FAQ](https://antigravity.google/docs/faq) for account restrictions.

