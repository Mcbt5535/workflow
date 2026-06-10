# Claude Code Workflow

一个极简的 **Plan → Dev → Review** 工作流：规划和审查交给强模型，批量实现交给便宜模型，执行模型随时可换。

```
🧠 /wf-plan (opus)  →  ⚙️ /wf-dev (haiku) × N  →  🔍 /wf-review (opus)
              ↘  计划有变？/wf-interrupt 随时修订  ↙
```

## 安装

把 `.claude/` 目录复制到你的项目根目录：

```bash
cp -r /path/to/workflow/.claude /your/project/
cd /your/project && claude
```

## 命令

| 命令 | 作用 | 默认模型 |
|---|---|---|
| `/wf-plan [模型] <任务>` | 拆解任务，生成分步计划 | 最强可用（fable → opus → sonnet）+ 最深思考 |
| `/wf-dev [模型]` | 执行计划的下一步 | 计划里的 `model:` 字段（缺省 haiku） |
| `/wf-review [模型]` | 对照计划审查 `git diff`（只读） | 最强可用（fable → opus → sonnet）+ 最深思考 |
| `/wf-interrupt <变更>` | 修订计划：增删步骤、转向、记录死胡同 | 主对话 |

## 模型随时可调

执行模型按优先级取（高 → 低）：

1. **命令参数** —— 如 `/wf-dev opus`、`/wf-plan sonnet 加个排序参数`，只对本次生效；
2. **计划 frontmatter** —— 改计划文件顶部的 `model: haiku`，下一次 `/wf-dev` 生效（仅 dev）；
3. **默认值** —— dev 用 haiku；plan / review 按 **fable → opus → sonnet** 自动取最强可用，
   模型不可用时自动降级重试，并以 `ultrathink` 启用最深思考。

可选值：`fable` / `opus` / `sonnet` / `haiku`。
命令会把选定的模型显式传给子代理，所以改 frontmatter 是真正生效的。

## 计划即合同

- 计划是 `.claude/workflow/plans/YYYY-MM-DD-<slug>.md` 的普通 markdown，**随时可手动编辑**，下一次 `/wf-dev` 读取的就是最新内容。
- `status: in_progress` 的是活跃计划；全部步骤完成后 dev agent 自动改为 `done`。
- 计划有变就用 `/wf-interrupt`：过时步骤直接删除（避免误导），被废弃的方向记入计划的 **「死胡同」** 一节——dev / review agent 都会读它，防止重走老路。

## 目录结构

```
.claude/
├── agents/          wf-planner / wf-developer / wf-reviewer
├── commands/        wf-plan / wf-dev / wf-review / wf-interrupt
├── hooks/           wf-session-start.sh（启动时注入活跃计划进度）
├── settings.json    权限 + hook + 状态栏
├── statusline-*     状态栏脚本（独立组件）
└── workflow/
    ├── plans/             所有计划
    └── version-scripts/   独立的版本管理工具（可选，与工作流无关）
```

## 状态栏

`settings.json` 已配置状态栏，Claude Code 底部实时显示：

```
claude-sonnet-4-6  Thinking:xhigh  In:12.3k Out:1.2k  Ctx:13.5k/200k  5h:42%(↻ 1h30m)  7d:8%
```

依赖 `.claude/statusline-command.sh` 和 `.claude/statusline-parse.py`，随 `.claude/` 一起复制即可使用。

## 版本管理（可选）

`.claude/workflow/version-scripts/` 是独立的版本管理工具，与 wf 工作流无关：

| 文件 | 用途 |
|---|---|
| `version_manager.py` | 版本管理 CLI |
| `analyze_commits.py` | 提交分析脚本 |
| `version-bump.yml` | GitHub Actions 自动版本增量模板 |

手动复制到目标项目即可使用。
