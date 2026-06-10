---
description: 规划新任务：调用 wf-planner 生成分步计划，存入 .claude/workflow/plans/。默认最强可用模型 + 最深思考，首词可手动指定模型。
argument-hint: "[fable|opus|sonnet|haiku] <任务描述>"
---

为以下任务生成计划：

$ARGUMENTS

1. 确定模型：
   - 若参数第一个词是 fable / opus / sonnet / haiku，用它，其余部分才是任务描述；
   - 否则按 **fable → opus → sonnet** 取最强可用：先传 fable，若调用因模型不可用而失败，自动降级到下一个重试，不要询问。
2. 用 Agent 工具调用 `wf-planner` 子代理，**显式传入 model 参数**；prompt 第一行写 `ultrathink`（启用最深思考），之后是任务描述原文。
3. 返回后只汇报：计划路径 + 一行目标。不要开始实现，等 /wf-dev。
