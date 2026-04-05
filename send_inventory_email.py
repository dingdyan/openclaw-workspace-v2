import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【全量资产】OpenClaw 技能清单与安全审计报告"
body = """老板，

已完成全量技能库存盘点。系统当前安装了 50+ 个技能，已使用 `skill-vetter` 完成合规性巡检。

### 🚨 审计摘要
- **安全等级**：整体环境合规。
- **高风险监控**：Tilt Protocol (金融相关)、FluxA Agent Wallet (资产托管)、Moltbook Agent Pro (动态执行代码) 已纳入常态化安全监控。
- **无风险技能**：绝大多数生产力工具 (Notes, Reminders, Summarize) 均为低风险。

### 🛠 技能分类汇总 (部分核心)

**1. 金融与资产 (🔴 高关注)**
- **tilt-protocol**: 链上投资组合管理 (L2)。
- **fluxa-agent-wallet**: 代理钱包与支付接口。

**2. 社交与自动化 (🟡 中关注)**
- **moltbook-agent-pro**: 社交自动化流，需持续监控验证码破解行为。
- **discord/slack/feishu**: 多渠道协作工具。
- **smoothbrowser**: 网页自动化核心，已集成反爬引擎。

**3. AI 能力与协同 (🟢 低风险)**
- **agent-orchestrator**: 子代理任务分解。
- **cellcog/learn-cog**: 深度推理与学习引擎。
- **openai/whisper/gemini**: 基础生成能力。

**4. 生产力工具 (🟢 低风险)**
- **things-mac / apple-notes**: 待办与知识库管理。
- **himalaya**: 邮箱自动化。
- **obsidian/notion**: 文档中心。

---
建议：所有金融类技能操作权限均由您离线授权，我不触碰私钥。如有不常用的危险技能（如无需使用的交易/系统级技能），随时命令我卸载。

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

