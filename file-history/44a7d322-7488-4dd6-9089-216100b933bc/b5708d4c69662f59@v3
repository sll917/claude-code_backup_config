#!/bin/bash
# DeepSeek 余额缓存查询
# 缓存5分钟，过期后调API刷新
# 兼容 DEEPSEEK_API_KEY 和 ANTHROPIC_AUTH_TOKEN

CACHE_FILE="$HOME/.claude/cache/deepseek-balance"
CACHE_TTL=300

# 优先用 DEEPSEEK_API_KEY，回退到 ANTHROPIC_AUTH_TOKEN
API_KEY="${DEEPSEEK_API_KEY:-${ANTHROPIC_AUTH_TOKEN}}"

get_balance_fresh() {
    if [ -z "$API_KEY" ]; then
        echo "NoKey"
        return
    fi
    RESPONSE=$(curl -s --max-time 3 \
        "https://api.deepseek.com/user/balance" \
        -H "Authorization: Bearer ${API_KEY}" 2>/dev/null)
    if [ -z "$RESPONSE" ]; then
        echo "Offline"
        return
    fi
    # 用 python3 解析，注意不能用裸 except: 否则会捕获 sys.exit 的 SystemExit
    BALANCE=$(echo "$RESPONSE" | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    infos = data.get('balance_infos', [])
    for b in infos:
        if b.get('currency') == 'CNY':
            print(b.get('total_balance', '0'))
            sys.exit(0)
    if infos:
        print(infos[0].get('total_balance', '0'))
    else:
        print('0')
except Exception:
    print('err')
" 2>/dev/null)
    if [ -z "$BALANCE" ] || [ "$BALANCE" = "err" ]; then
        echo "Error"
        return
    fi
    mkdir -p "$(dirname "$CACHE_FILE")"
    echo "$BALANCE" > "$CACHE_FILE"
    echo "$BALANCE"
}

# 检查缓存是否有效
if [ -f "$CACHE_FILE" ]; then
    CACHE_MTIME=$(stat -c %Y "$CACHE_FILE" 2>/dev/null)
    CACHE_AGE=$(($(date +%s) - ${CACHE_MTIME:-0}))
    if [ "$CACHE_AGE" -lt "$CACHE_TTL" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# 缓存过期或不存在，重新获取
get_balance_fresh
