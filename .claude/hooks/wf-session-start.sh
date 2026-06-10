#!/usr/bin/env bash
# SessionStart hook：把活跃计划的进度注入会话上下文（轻量，只输出几行）。
set -euo pipefail
cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

# 找活跃计划：仅扫描日期开头的文件（跳过 README.md 等文档）
ACTIVE_PLAN=""
for f in $(ls -r .claude/workflow/plans/*.md 2>/dev/null); do
  case "$(basename "$f")" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*.md)
      if grep -q "^status: in_progress" "$f" 2>/dev/null; then
        ACTIVE_PLAN="$f"
        break
      fi
      ;;
  esac
done

if [ -n "$ACTIVE_PLAN" ]; then
  # grep 无匹配时退出码非零，须 || true 兜底，否则 pipefail+set -e 会静默杀掉整个 hook
  TOTAL=$(grep "^- \[" "$ACTIVE_PLAN" 2>/dev/null | wc -l | tr -d ' ' || true)
  DONE=$(grep "^- \[x\]" "$ACTIVE_PLAN" 2>/dev/null | wc -l | tr -d ' ' || true)
  BLOCKED=$(grep "^- \[?\]" "$ACTIVE_PLAN" 2>/dev/null | wc -l | tr -d ' ' || true)
  NEXT=$(grep -m1 "^- \[ \]" "$ACTIVE_PLAN" 2>/dev/null | sed 's/^- \[ \] //' | cut -c1-120 || echo "")
  MODEL=$(grep -m1 "^model:" "$ACTIVE_PLAN" 2>/dev/null | sed -e 's/^model:[[:space:]]*//' -e 's/[[:space:]]*#.*//' || echo "")
  OUT="ACTIVE PLAN: ${ACTIVE_PLAN} (${DONE}/${TOTAL} done"
  [ "${BLOCKED:-0}" -gt 0 ] 2>/dev/null && OUT="${OUT}, ${BLOCKED} blocked"
  OUT="${OUT})."
  [ -n "$NEXT" ] && OUT="${OUT} Next: ${NEXT}."
  [ -n "$MODEL" ] && OUT="${OUT} Dev model: ${MODEL}."
  OUT="${OUT} Run /wf-dev to continue."
else
  OUT="No active plan. Start with /wf-plan <task>."
fi

# 按 SessionStart JSON 契约输出 additionalContext；转义引号/反斜杠，压平换行
ESCAPED=$(printf '%s' "$OUT" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | tr '\n' ' ')

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${ESCAPED}"
  }
}
EOF
