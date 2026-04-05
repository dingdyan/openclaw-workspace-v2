#!/bin/bash
LOG_FILE="/root/.openclaw/workspace/projects/automaton-study/cron_retry.log"
CONFIG_FILE="/root/.automaton/config.json"
cd /root/.openclaw/workspace/projects/automaton-study

echo "=== $(date) ===" >> $LOG_FILE

# 检查当前 apiKey 是否有效（不是之前误填的 \r）
if [ -f "$CONFIG_FILE" ]; then
    API_KEY=$(jq -r '.apiKey' $CONFIG_FILE)
    if [ "$API_KEY" == "\\r" ] || [ "$API_KEY" == "" ]; then
        echo "检测到无效 API Key，尝试重新自动获取..." >> $LOG_FILE
        # 强制删除旧配置触发重新 SIWE 自动申请
        rm -f "$CONFIG_FILE"
    fi
fi

# 尝试启动，如果提示输入 API Key 直接回车跳过让它自动去申请
(echo ""; sleep 2) | pnpm dev --run >> $LOG_FILE 2>&1

if grep -q "429" $LOG_FILE; then
    echo "依然拥堵 (429)，等待下次重试..." >> $LOG_FILE
elif grep -q "401" $LOG_FILE; then
    echo "鉴权失败 (401)，可能需要手动更新 API Key 或等待自动获取..." >> $LOG_FILE
else
    echo "未检测到明确错误，可能已成功获取 API Key 或正在运行！" >> $LOG_FILE
fi
