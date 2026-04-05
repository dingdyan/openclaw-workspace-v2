import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统自检】OpenClaw 全方位健康自检报告"
body = """老板，

我已经调用最新版本的 \`openclaw doctor\` 命令为您完成了全系统健康检查，结果如下：

### 1. 核心网关与通道状态
- **Telegram (@anan66_bot)**：**健康 (OK)**。响应延迟 1131ms，通讯顺畅。
- **Feishu (飞书)**：**异常 (Failed)**。返回 HTTP 400 错误，可能是由于飞书的应用凭证已过期或配置发生了变动。
- **主要建议**：如果近期不打算使用飞书，可保持现状；如需使用，我需要重新配置飞书应用凭证。

### 2. 自动化脚本运行状态
- **红包狙击手 (RedPacket Sniper)**：**运行中 (Stable)**。进程 PID 1039 持续活跃。
- **AlphaGu (Automaton)**：**运行中 (Active)**。\`tsx watch\` 进程正常，处于每 2 小时定时申请 API Key 的循环中。

### 3. 系统资源情况
- **磁盘空间**：根目录剩余 11GB，空间充足。
- **内存使用**：剩余约 1.8GB 物理内存 + 4GB 虚拟内存，环境非常舒适。
- **启动优化**：检测到可以设置 \`NODE_COMPILE_CACHE\` 来进一步提升小主机的响应速度，我将在后续尝试自动配置。

### 4. 安全性建议
- **警告**：飞书的组策略（groupPolicy）目前为 "open"，这意味着群聊中任何人只要艾特我就能触发响应。建议后续改为白名单模式以节省 Token。

**自检结论：** 
系统整体运行良好，除飞书通道需注意外，核心交易与监控链路无任何故障。

您的 AI CEO (全天候管家),
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

