#!/bin/bash
# Claude Code 状态栏：仓库 | Token用量 | DeepSeek余额

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
repo=$(echo "$input" | jq -r '.workspace.repo | if . then .owner + "/" + .name else empty end')
used=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total=$(echo "$input" | jq -r '.context_window.context_window_size // "?"')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# 仓库名（绿色）
if [ -n "$repo" ]; then
    printf '\033[2;32m%s\033[0m' "$repo"
else
    printf '\033[2;32m%s\033[0m' "$(basename "$cwd")"
fi

# Token 用量（黄色）
if [ "$total" != "?" ] && [ "$total" != "null" ] && [ -n "$total" ]; then
    printf ' Token:\033[2;33m%s/%s\033[0m' "$used" "$total"
else
    printf ' Token:\033[2;33m%s\033[0m' "$used"
fi

# 剩余百分比
if [ -n "$remaining_pct" ]; then
    printf ' \033[2;35m(%.0f%%)\033[0m' "$remaining_pct"
fi

# DeepSeek 余额（5分钟缓存）
BALANCE=$(bash "$HOME/.claude/scripts/deepseek-balance.sh" 2>/dev/null)
if [ -n "$BALANCE" ] && [ "$BALANCE" != "NoKey" ] && [ "$BALANCE" != "Offline" ] && [ "$BALANCE" != "Error" ]; then
    BAL_NUM=$(echo "$BALANCE" | sed 's/[^0-9.]//g')
    if [ -n "$BAL_NUM" ]; then
        if [ "$(echo "$BAL_NUM <= 1" | bc 2>/dev/null)" = "1" ]; then
            printf ' | 💰:\033[2;31m¥%s\033[0m' "$BALANCE"
        elif [ "$(echo "$BAL_NUM <= 10" | bc 2>/dev/null)" = "1" ]; then
            printf ' | 💰:\033[2;33m¥%s\033[0m' "$BALANCE"
        else
            printf ' | 💰:\033[2;36m¥%s\033[0m' "$BALANCE"
        fi
    else
        printf ' | 💰:\033[2;36m¥%s\033[0m' "$BALANCE"
    fi
elif [ "$BALANCE" = "Offline" ]; then
    printf ' | 💰:\033[2;31m离线\033[0m'
elif [ "$BALANCE" = "Error" ]; then
    printf ' | 💰:\033[2;31m异常\033[0m'
fi

printf '\n'
