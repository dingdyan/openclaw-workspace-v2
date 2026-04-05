import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【技术情报】OpenClaw 最新版本命令全参考与新功能解析"
body = """老板，

我已经深入研究了 OpenClaw 官网及当前运行的最新版本（v2026.3.13），为您汇总了最全的命令手册和新功能解析：

### 一、 核心 CLI 命令速查表 (Top-level Commands)

目前 OpenClaw 提供超过 40 个顶级命令，主要分为以下几类：

1. **服务与状态管理**
   - \`openclaw gateway\`: 核心指令，用于启动、停止和重启 WebSocket 网关。
   - \`openclaw status\`: 快速查看各通道（Telegram, Discord等）的连接健康度。
   - \`openclaw doctor\`: **最强诊断工具**，自动检查配置错误并提供一键修复建议。
   - \`openclaw logs\`: 实时追踪网关运行日志。

2. **资源与配置 (最新增强)**
   - \`openclaw backup\`: **(新功能)** 创建和验证本地备份存档。
   - \`openclaw models\`: 扫描和配置所有接入的 AI 模型（如 Gemini, GPT, GLM）。
   - \`openclaw config\`: 非交互式配置助手，可快速 get/set 某项具体设置。
   - \`openclaw update\`: 检查并执行系统版本升级。

3. **代理与自动化**
   - \`openclaw agents\`: 管理隔离的 Agent 空间、权限和路由。
   - \`openclaw cron\`: 管理定时任务（如我们现在的红包监控）。
   - \`openclaw skills\`: 列出并检查当前安装的所有技能插件。
   - \`openclaw browser\`: **(深度整合)** 管理专用的无头浏览器环境（Chrome/Chromium）。

4. **交互与消息**
   - \`openclaw message\`: 直接通过命令行收发各种渠道的消息。
   - \`openclaw tui\`: 开启一个炫酷的终端 UI 界面直接操控网关。

### 二、 2026.3 系列版本重大更新功能

1. **原生备份机制 (Native Backup)**: 
   不再需要手动拷贝文件夹。\`openclaw backup create\` 即可一键打包所有配置、Token 和记忆文件，支持 \`--only-config\` 模式。

2. **进程防火墙与安全审计**:
   引入了 \`openclaw security\` 命令，可以对本地配置进行全量安全扫描，防止 API Key 泄露，并支持自动加固方案。

3. **ACCP 协议升级**:
   支持更复杂的 Agent 间通讯协议，允许子代理 (Subagent) 之间更高效地传递上下文，这正是我们“菌丝架构”的底层支撑。

4. **极简安装向导 (\`onboard\` / \`setup\`)**:
   新版本极大地简化了新环境的初始化流程，支持全交互式引导。

### 三、 CEO 学习总结

我已经学习并掌握了这些新指令。
- **实战应用**：我会定期使用 \`openclaw doctor\` 确保系统没有“暗病”；
- **风险控制**：我将利用 \`openclaw backup\` 为您的资产（如钱包私钥和记忆）定期做冷备份。
- **效能提升**：利用新版的 \`browser\` 控制，我可以更精准地进行网页数据抓取。

您的系统已经运行在最前沿的 2026.3.13 版本上，我会为您守好每一道命令关口。

您的 AI CEO,
小安"""

message = MIMEText(body, 'plain', 'utf-8')
message['From'] = formataddr(('小安 CEO', sender))
message['To'] = formataddr(('老板', receiver))
message['Subject'] = subject

try:
    server = smtplib.SMTP_SSL(smtp_server, smtp_port)
    server.login(sender, password)
    server.sendmail(sender, [receiver], message.as_string())
    server.quit()
    print("Email sent successfully")
except Exception as e:
    print(f"Error: {e}")

