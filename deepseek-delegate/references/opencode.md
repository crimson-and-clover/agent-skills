# OpenCode dispatch and evidence

## Start a scoped run

Check the installed CLI and the configured model list.

~~~powershell
opencode --version
opencode models | Select-String -Pattern 'deepseek'
~~~

The Windows benchmark used OpenCode 2.3.2 with `deepseek/deepseek-flash`, the direct DeepSeek provider's V4.1 Flash model. Choose a listed model that fits the user's existing configuration and budget. Record its exact identifier with the run.

Put the task in `task.md` inside a dedicated working directory. Run from that directory and redirect logs to its parent or another known run record location.

~~~powershell
$prompt = 'Read task.md, perform the task in this workspace, and run the exact verification command specified there. Save the requested artifacts and identify any blocked step.'
opencode run --standalone --model deepseek/deepseek-flash --format json --archived --title 'Research delegation' $prompt 1> ..\deepseek-events.jsonl 2> ..\deepseek-stderr.log
$runExit = $LASTEXITCODE
~~~

`--standalone` starts a private local OpenCode server. When the job needs the user's configured local server, use the normal documented `opencode run` invocation. Use unique log names for separate attempts. `--archived` keeps the test session out of the regular session list while preserving session lookup.

## Configure permissions and diagnose failures

- Use the narrowest existing or task-local rule set that permits the requested work. OpenCode 2.x uses an ordered `permissions` list with `action`, `resource`, and `effect`. The last matching rule wins. Keep any added rules local to the task.
- The Windows benchmark allowed `read` and `edit` in the isolated workspace, denied `external_directory`, and allowed the specific Python entry command. The first attempt used absolute path patterns for `read` and `edit` and mistakenly denied valid workspace requests. If this recurs, check the paths in the tool events and the rule-matching behavior for the installed version. In this test, a workspace-local configuration allowing reads and edits with a separate `external_directory` deny worked.
- If a command is denied, inspect the actual requested string and working directory before deciding whether it is required and within scope. Keep setup failures separate from model failures. Limit added shell permissions to the commands the task needs.
- Check the shell tool's recorded result or Slurm accounting and the expected artifacts. OpenCode can exit successfully even when a tool call was denied.

## Accept the result

Check that the raw records cover the exact requested runs and identify the dataset split, configuration, environment, and model or checkpoint. For paired runs, match arms by seed and recompute the per-seed differences before taking the mean and sample standard deviation. Keep percentage points distinct from relative percent change.

For an evaluation fix, inspect the actual entry point. A minimal fixture or recorder can verify the training input, held-out input, and data sent to the metric. A test of a reconstructed pipeline may miss defects in the entry point delivered to the user.

## Evidence from the local benchmark

On 2026-11-21, DeepSeek ran a public digits baseline and augmentation sweep in a prepared Python environment. It found image wraparound, cross-split source leakage, and clean images in the shifted test set. Five checks failed on the old flow and passed on a reconstruction of the fixed flow. Codex additionally tested the exported repair directly. The six training runs produced all 12 accuracy values previously obtained by Hydrogen, and Codex recalculated the paired statistics. The test covered a fixed CPU task with preinstalled dependencies. Slurm and open-ended research work remain unverified.

[OpenCode CLI commands](https://opencode.ai/docs/cli/commands/) · [OpenCode permissions](https://opencode.ai/docs/permissions/) · [DeepSeek model catalog](https://api-docs.deepseek.com/quick_start/pricing/)
