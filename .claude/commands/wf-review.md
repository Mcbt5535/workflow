---
description: 调用 wf-reviewer 对照活跃计划审查当前 git diff，只读。默认最强可用模型 + 最深思考，参数可手动指定模型。
argument-hint: "[fable|opus|sonnet|haiku]"
---

审查当前未提交的变更：

1. 确定模型：
   - $ARGUMENTS 给了模型名（fable / opus / sonnet / haiku）就用它；
   - 否则按 **fable → opus → sonnet** 取最强可用：先传 fable，若调用因模型不可用而失败，自动降级到下一个重试，不要询问。
2. 用 Agent 工具调用 `wf-reviewer` 子代理，**显式传入 model 参数**；prompt 第一行写 `ultrathink`（启用最深思考）。它是只读的，不会改文件。
3. 返回后原样转述审查结果。若有 🛑 问题：先 `/wf-interrupt` 修订计划，或对相应步骤重跑 `/wf-dev`。
