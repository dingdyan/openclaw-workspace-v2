#!/bin/bash

# ClawPi红包监控演示系统启动脚本
# 仅监控红包状态，用于测试和演示

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config/redpacket_monitor_config.json"
LOG_DIR="$SCRIPT_DIR/../logs"
PYTHON_SCRIPT="$SCRIPT_DIR/redpacket_demo_monitor.py"

# 创建必要的目录
mkdir -p "$LOG_DIR"

# 检查配置文件
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 配置文件不存在: $CONFIG_FILE"
    exit 1
fi

# 检查Python脚本
if [ ! -f "$PYTHON_SCRIPT" ]; then
    echo "❌ Python脚本不存在: $PYTHON_SCRIPT"
    exit 1
fi

# 加载配置
CREATOR_COUNT=$(jq -r '.creators | length' "$CONFIG_FILE")
MIN_AMOUNT=$(jq -r '.settings.min_amount_usdc' "$CONFIG_FILE")
CHECK_INTERVAL=$(jq -r '.settings.check_interval' "$CONFIG_FILE")

echo "=== ClawPi红包监控演示系统启动 ==="
echo "配置文件: $CONFIG_FILE"
echo "监控创作者数量: $CREATOR_COUNT"
echo "最小金额门槛: $MIN_AMOUNT USDC"
echo "检查间隔: $CHECK_INTERVAL 秒"
echo "日志目录: $LOG_DIR"
echo "========================================="
echo "💡 注意: 当前为演示模式，仅监控红包状态，不自动领取"
echo ""

# 检查FluxA钱包配置
if [ -f ~/.fluxa-ai-wallet-mcp/config.json ]; then
    echo "✅ FluxA钱包配置已找到"
    AGENT_ID=$(jq -r '.agentId.agent_id' ~/.fluxa-ai-wallet-mcp/config.json)
    echo "Agent ID: $AGENT_ID"
else
    echo "⚠️ FluxA钱包配置未找到，将使用备用token"
fi

# 检查是否已有运行中的实例
PID_FILE="/tmp/redpacket_demo_monitor.pid"
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        echo "⚠️ 发现正在运行的实例 (PID: $OLD_PID)"
        read -p "是否停止现有实例并重新启动? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill -TERM "$OLD_PID"
            echo "停止现有实例..."
            sleep 2
        else
            echo "退出..."
            exit 0
        fi
    else
        rm -f "$PID_FILE"
    fi
fi

# 检查Python依赖
if ! python3 -c "import requests" 2>/dev/null; then
    echo "❌ 缺少Python依赖: requests"
    echo "请运行: pip install requests"
    exit 1
fi

# 启动演示系统
echo "🚀 启动红包监控演示系统..."
echo "启动时间: $(date)"
echo "PID: $$" > "$PID_FILE"

# 运行Python脚本
cd "$SCRIPT_DIR"
python3 "$PYTHON_SCRIPT" 2>&1 | tee "$LOG_DIR/redpacket_demo_monitor_$(date +%Y%m%d_%H%M%S).log"

# 清理PID文件
if [ -f "$PID_FILE" ] && [ "$(cat "$PID_FILE")" = "$$" ]; then
    rm -f "$PID_FILE"
fi

echo "系统已停止"