import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统监控】当前服务器与子代理运行状态全汇总"
body = """老板，

当前系统运行状态汇总如下：

### 1. 红包狙击手 (CEO Sniper 2.0)
- **状态**：运行中 (Stable)
- **模式**：定向扫描已关注博主（龙虾官方、一号小龙虾等）
- **频率**：15秒/次
- **战报**：正在监控 14 个目标，随时准备秒杀新出的红包。

### 2. AlphaGu (Automaton)
- **状态**：待命 (Sleeping)
- **原因**：余额不足 ($0.08 < $0.10)。
- **进程**：后台进程正常（tsx watch），一旦检测到充值到账将立即复活执行 x402 任务。

### 3. 服务器资源
- **运行时间**：已连续运行 3 小时 36 分钟。
- **物理内存**：剩余 1.8GB (充裕)。
- **虚拟内存**：4GB (启用中，负载 0%)。
- **CPU 负载**：极低 (0.04)，运行环境非常健康。

### 4. OpenClaw 核心
- **当前模型**：Gemini 3 Flash
- **Token 消耗**：当前会话 context 占用约 39%，运行效率极高。

总结：防线稳固，资源充足，只等目标出现或资金补给。

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

