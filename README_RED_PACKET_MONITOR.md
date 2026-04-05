# ClawPi红包监控系统 - 使用说明

## 系统概述

本系统是一个为ClawPi平台设计的自动红包检测和领取系统，能够24/7监控特定创作者发布的红包，并自动执行领取流程。

## 核心功能

### ✅ 已实现功能
1. **定时监控**: 每30秒扫描一次可领取的红包
2. **创作者过滤**: 监控12位指定创作者的红包发布
3. **金额门槛**: 只领取金额超过0.01 USDC的红包
4. **智能检测**: 自动识别新发布的红包
5. **API连接**: 自动检查并重试API连接
6. **日志记录**: 详细的运行日志和状态追踪
7. **错误处理**: 完善的错误重试和恢复机制

### 🔧 配置功能
- JSON配置文件管理
- 可调整的监控间隔和参数
- 灵活的创作者列表配置
- 可配置的金额门槛

## 系统组件

### 1. 配置文件
```
/root/.openclaw/workspace/config/redpacket_monitor_config.json
```
包含监控的创作者列表、API端点、时间设置等配置。

### 2. 监控脚本
- **演示系统**: `redpacket_demo_monitor.py` - 仅监控红包状态
- **完整系统**: `redpacket_advanced_monitor.py` - 监控+自动领取（待FluxA钱包问题解决）

### 3. 管理脚本
- **启动脚本**: `start_redpacket_monitor.sh` / `start_demo_monitor.sh`
- **停止脚本**: `stop_redpacket_monitor.sh`
- **状态检查**: `check_redpacket_status.sh`

### 4. 日志文件
```
/root/.openclaw/workspace/logs/
```
- 系统运行日志
- 错误和调试信息
- 领取记录统计

## 使用方法

### 1. 启动演示系统（推荐当前使用）
```bash
cd /root/.openclaw/workspace/scripts/
./start_demo_monitor.sh
```

### 2. 启动完整系统（待FluxA问题解决后）
```bash
cd /root/.openclaw/workspace/scripts/
./start_redpacket_monitor.sh
```

### 3. 检查系统状态
```bash
./check_redpacket_status.sh
```

### 4. 停止系统
```bash
./stop_redpacket_monitor.sh
```

## 当前监控的创作者列表

系统当前监控以下12位创作者：
- xiaohongshu (小红书)
- bilibili (哔哩哔哩)
- douyin (抖音)
- weibo (微博)
- zhihu (知乎)
- kuaishou (快手)
- xiaohongshu_creator (小红书创作者)
- bilibili_up (B站UP主)
- douyin_star (抖音明星)
- weibo_vip (微博VIP)
- zhihu_expert (知乎专家)
- kuaishou_host (快手主播)

## 配置说明

### 基本配置
```json
{
  "settings": {
    "check_interval": 30,      // 检查间隔（秒）
    "max_retries": 3,          // 最大重试次数
    "retry_delay": 5,         // 重试延迟（秒）
    "min_amount_usdc": 0.01,   // 最小金额门槛（USDC）
    "claim_timeout": 60        // 领取超时（秒）
  }
}
```

### 创作者配置
```json
{
  "creators": [
    "creator1",
    "creator2",
    // ... 最多12位创作者
  ]
}
```

### API端点配置
```json
{
  "api_endpoints": {
    "clawpi_base": "https://clawpi-v2.vercel.app",
    "fluxa_wallet": "https://walletapi.fluxapay.xyz",
    "agent_wallet": "https://agentwallet.fluxapay.xyz"
  }
}
```

## 运行状态

### 当前系统状态
- ✅ Clawpi API连接正常
- ✅ 配置文件加载成功
- ✅ 日志记录正常
- ✅ 定时监控运行中
- ⚠️ FluxA钱包API暂时不可用（仅演示模式运行）

### 演示模式说明
当前系统运行在演示模式，能够：
- ✅ 正确连接到Clawpi API
- ✅ 定时扫描红包状态
- ✅ 识别目标创作者的红包
- ✅ 过滤符合条件的红包
- ❌ 不执行实际的领取操作（需要FluxA钱包支持）

## 故障排除

### 常见问题

#### 1. API连接失败
```
❌ Clawpi API连接异常
```
**解决方案**: 检查网络连接，确认Clawpi服务状态

#### 2. FluxA钱包问题
```
❌ 钱包API返回HTML，可能是token无效或API有问题
```
**解决方案**: 
- 重新获取FluxA钱包token
- 访问钱包授权页面重新授权
- 暂时使用演示模式

#### 3. 权限错误
```
❌ JWT token失效
```
**解决方案**: 重新获取JWT token

### 日志分析
系统日志位于 `/root/.openclaw/workspace/logs/`，包含：
- 系统启动和停止记录
- API连接状态
- 红包检测和领取详情
- 错误和警告信息

## 扩展功能

### 1. 添加新创作者
修改配置文件中的 `creators` 数组，添加新的创作者名称。

### 2. 调整监控参数
修改配置文件中的 `settings` 部分，调整检查间隔、金额门槛等。

### 3. 自定义日志
可以通过修改脚本的日志配置来调整日志级别和输出格式。

## 技术架构

```
ClawPi API → 红包检测 → 创作者过滤 → 金额筛选 → 自动领取 → 庆祝动态
     ↓           ↓          ↓          ↓          ↓          ↓
  JWT认证 → 定时扫描 → 智能匹配 → 阈值判断 → FluxA钱包 → 社交分享
```

## 未来改进

1. **FluxA钱包集成**: 解决钱包API问题，恢复自动领取功能
2. **多平台支持**: 扩展到其他创作者平台
3. **智能学习**: 基于历史数据优化领取策略
4. **移动端支持**: 提供手机通知功能
5. **统计分析**: 增加详细的收益统计报告

## 注意事项

1. **系统稳定性**: 建议在稳定网络环境中运行
2. **API限制**: 注意API调用频率限制
3. **安全考虑**: 保护好JWT token和钱包密钥
4. **资源使用**: 监控系统对系统资源占用较小
5. **法律合规**: 确保自动领取符合平台规则

---

**版本**: v1.0  
**最后更新**: 2026-03-16  
**状态**: 演示模式运行中，等待FluxA钱包问题解决