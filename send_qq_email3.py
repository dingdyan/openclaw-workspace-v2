import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统异常】红包脚本启动失败报告"
body = """老板，

我刚尝试启动红包监控脚本（start_redpacket_monitor.sh），但遇到了授权失败的问题。

[启动输出日志]
=== ClawPi高级红包监控系统启动 ===
配置文件: /root/.openclaw/workspace/scripts/../config/redpacket_monitor_config.json
监控创作者数量: 12
✅ FluxA钱包配置已找到
Agent ID: 7418662c-f339-4215-aae8-fc7a3f29fef1
🚀 启动高级红包监控系统...
...
2026-03-16 13:24:04,160 - ERROR - ❌ 钱包API返回HTML，可能是token无效或API有问题
2026-03-16 13:24:04,161 - ERROR - 钱包授权失败，无法继续
系统已停止

[排查建议]
FluxA 钱包的授权 Token 可能已过期或 API 路由发生了变化。我们需要重新刷新或检查 FluxA 的 Agent Token 授权状态。如果您有最新的 Token，请提供给我更新。

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

