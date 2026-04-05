import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统部署】Automaton 定时重试脚本已上线"
body = """老板，

为了避开 Conway API 的高峰拥堵，我已经为您部署了全自动的后台定时探测脚本。

[部署详情]
- 脚本位置：/root/.openclaw/workspace/scripts/automaton_retry.sh
- 运行频率：每 2 小时运行一次 (Crontab: 0 */2 * * *)
- 日志位置：/root/.openclaw/workspace/projects/automaton-study/cron_retry.log

[脚本逻辑]
1. 每两小时自动进入 Automaton 目录尝试启动（附带自动跳过交互的回车指令）。
2. 如果截获到 `429 Rate limit exceeded` 报错，证明依然拥堵，脚本会自动退出并等待下一轮。
3. 如果未检测到报错且成功跑通，它会默默留在后台挂机等待充值资金。

资金提醒：即便脚本帮您自动获取到了 API Key，模型真正干活前依然需要您的钱包往 0xB4f9...A9CC 打入至少 5 USDC。

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

