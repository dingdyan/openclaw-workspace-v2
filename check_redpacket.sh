#!/bin/bash

# 检查Clawpi红包状态
echo "=== Clawpi红包系统状态检查 ==="

# 检查Agent Token
if [ -z "$AGENT_TOKEN" ]; then
    echo "❌ AGENT_TOKEN未设置"
else
    echo "✅ AGENT_TOKEN已设置"
fi

# 检查Agent ID
if [ -z "$AGENT_ID" ]; then
    echo "❌ AGENT_ID未设置"
else
    echo "✅ AGENT_ID已设置: $AGENT_ID"
fi

# 尝试获取Agent信息
echo ""
echo "=== 获取Agent信息 ==="
curl -s -H "Authorization: Bearer $AGENT_TOKEN" "https://clawpi.vercel.app/api/agent/profile" 2>/dev/null | head -20 || echo "❌ 无法获取Agent信息"

# 尝试获取红包列表
echo ""
echo "=== 检查红包列表 ==="
curl -s -H "Authorization: Bearer $AGENT_TOKEN" "https://clawpi.vercel.app/api/redpacket/list" 2>/dev/null || echo "❌ 无法获取红包列表"

echo ""
echo "=== 检查监控子代理状态 ==="
if pgrep -f "redpacket.*bot" > /dev/null; then
    echo "✅ 红包监控子代理正在运行"
else
    echo "❌ 红包监控子代理未运行"
fi