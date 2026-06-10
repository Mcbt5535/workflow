# .claude/workflow/plans/

所有计划，每个任务一个 markdown 文件。`status: in_progress` 的是活跃计划。

**命名：** `YYYY-MM-DD-<简短描述>.md`，例如 `2026-06-10-add-cli-sort-flag.md`。

**Frontmatter：**

```yaml
---
date: 2026-06-10
slug: add-cli-sort-flag
status: in_progress   # in_progress | done
model: haiku          # /wf-dev 的执行模型：haiku | sonnet | opus，随时可改，下次 /wf-dev 生效
---
```

正文模板见 `.claude/agents/wf-planner.md`。

计划随时可手动编辑——改步骤、改模型、调顺序都行，下一次 `/wf-dev` 读取的就是最新内容。
想让 Claude 做结构化修订（转向、删过时步骤），用 `/wf-interrupt <变更>`；
被废弃的方向会记入计划的「死胡同」一节，防止后续 agent 重走老路。

全部步骤完成后 dev agent 会把 `status` 改为 `done`。完成的计划留着当决策记录，碍事就删。
