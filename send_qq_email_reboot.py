import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【紧急排查】发现服务器异常重启记录及恢复报告"
body = """老板，

我刚刚查到了“死机”的真凶：服务器刚刚发生了**非预期的自动重启**。

[排查证据]
- 系统运行时间（Uptime）：显示仅运行了 2 分钟。这意味着在您发消息前几分钟，服务器刚经历了一次断电或系统崩溃后的重启。
- 进程状态：由于重启，之前运行的所有红包监控、AlphaGu 唤醒脚本全部被强制关闭了。

[处理动作]
1. **全线复工**：我已在第一时间手动拉起了红包监控脚本和 AlphaGu 的自动唤醒守护进程。
2. **状态核实**：红包监控已恢复每 20 秒轮询；AlphaGu 已重新挂载（但由于余额仍是 8 美分，它目前会继续保持待机）。

[根治建议]
目前的脚本是临时手动启动的，无法在服务器重启后自动恢复。建议后续我为您配置 `PM2` 进程守护，这样即便服务器以后再重启，脚本也能在开机后 1 秒内自动复活，实现真正的“无人值守”。

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

