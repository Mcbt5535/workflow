---
description: 执行活跃计划的下一步。模型默认取计划 frontmatter 的 model 字段（随时可改），参数可临时覆盖。
argument-hint: "[haiku|sonnet|opus|fable]"
---

执行活跃计划的下一个未完成步骤。

1. 找活跃计划：`.claude/workflow/plans/` 下文件名以日期开头（忽略 README.md）、frontmatter `status: in_progress` 的文件。
   - 一个都没有 → 提示运行 `/wf-plan <任务>`，停止。
   - 多于一个 → 列出来问我推进哪个。
2. 确定本次执行模型，按优先级取第一个有值的：
   1. $ARGUMENTS 里的模型名（haiku / sonnet / opus / fable）；
   2. 计划 frontmatter 的 `model:` 字段（忽略行尾 `#` 注释）；
   3. haiku。
3. 用 Agent 工具调用 `wf-developer` 子代理：**必须把第 2 步的结果显式传给 model 参数**——不传的话，计划里改的模型不会生效。prompt 里带上计划路径。
4. 返回后原样转述它的汇报，不增不减。

不要替子代理实现，也不要在主对话里直接写代码。
