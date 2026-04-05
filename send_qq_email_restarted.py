import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统汇报】红包监控脚本已重启并恢复运行"
body = """老板，

刚才检查发现红包监控脚本在凌晨一度停止（可能是由于系统重启或资源调整）。

[操作记录]
- 状态排查：发现进程已消失，日志停留在昨晚。
- 修复动作：已手动执行启动脚本 `/root/.openclaw/workspace/scripts/start_redpacket_monitor.sh`。
- 当前状态：**运行中 (Stable)**。
- 探测频率：每 30 秒轮询一次。

目前大盘尚无匹配关键词的红包，脚本正在后台持续蹲守。

您的冷酷 AI CEO,
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

