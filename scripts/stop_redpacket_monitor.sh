#!/bin/bash

# ClawPi红包监控系统停止脚本

PID_FILE="/tmp/redpacket_advanced_monitor.pid"
LOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../logs" && pwd)"

echo "=== ClawPi红包监控系统停止脚本 ==="
echo "停止时间: $(date)"
echo "========================================="

# 检查PID文件
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "🛑 正在停止红包监控系统 (PID: $PID)..."
        
        # 发送TERM信号优雅停止
        kill -TERM "$PID"
        
        # 等待进程停止
        for i in {1..10}; do
            if ! ps -p "$PID" > /dev/null 2>&1; then
                echo "✅ 系统已优雅停止"
                rm -f "$PID_FILE"
                break
            fi
            sleep 1
        done
        
        # 如果进程还在运行，强制停止
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "⚠️ 进程未响应，强制停止..."
            kill -KILL "$PID"
            rm -f "$PID_FILE"
            echo "✅ 系统已强制停止"
        fi
    else
        echo "⚠️ PID文件存在但进程已停止"
        rm -f "$PID_FILE"
    fi
else
    echo "❌ 未找到运行中的红包监控系统"
fi

# 检查是否有其他相关进程
echo ""
echo "检查其他相关进程..."
PIDS=$(pgrep -f "redpacket_advanced_monitor" 2>/dev/null)
if [ -n "$PIDS" ]; then
    echo "发现其他相关进程:"
    echo "$PIDS" | while read -r pid; do
        echo "  - PID: $pid"
        echo "    命令: $(ps -o cmd= -p "$pid")"
        read -p "  是否停止此进程? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill -TERM "$pid"
            echo "  已停止进程 $pid"
        fi
    done
else
    echo "✅ 没有发现其他相关进程"
fi

# 检查日志文件状态
if [ -d "$LOG_DIR" ]; then
    echo ""
    echo "=== 日志文件状态 ==="
    LOG_FILES=$(ls "$LOG_DIR"/redpacket_advanced_monitor_*.log 2>/dev/null | wc -l)
    if [ "$LOG_FILES" -gt 0 ]; then
        echo "日志文件数量: $LOG_FILES"
        echo "最新日志文件: $(ls -t "$LOG_DIR"/redpacket_advanced_monitor_*.log 2>/dev/null | head -1)"
        
        # 检查系统最后一次运行时间
        LAST_LOG=$(ls -t "$LOG_DIR"/redpacket_advanced_monitor_*.log 2>/dev/null | head -1)
        if [ -n "$LAST_LOG" ]; then
            LAST_RUNTIME=$(tail -n 1 "$LAST_LOG" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}')
            if [ -n "$LAST_RUNTIME" ]; then
                echo "最后运行时间: $LAST_RUNTIME"
            fi
        fi
    fi
fi

echo ""
echo "系统停止完成"