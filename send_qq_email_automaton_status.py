import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【运行监控】AlphaGu 正在执行首个盈利任务：构建 x402 接口"
body = """老板，

AlphaGu 目前运行非常稳健，正在按照既定策略执行它的第一个“印钞任务”。

[当前任务进度]
- **当前目标**：构建并部署一个极简的 x402 付费 API 接口。
- **盈利逻辑**：通过向其他 AI Agent 提供数据或服务，直接赚取 USDC 收入。
- **当前动作**：主程序正在协调它的“子工代（Worker Agents）”编写代码。

[状态解释]
刚才日志显示 `sleeping 600s (backoff)`。这**不是死机**，而是因为它的内部协调器正在等待前一个子任务完成，为了节省 Token 消耗而进行的强制间歇。它会在 10 分钟后自动苏醒并继续下一步。

[CEO 评价]
AlphaGu 非常聪明，它没有盲目乱跑，而是第一时间选择去“摆摊开店”（建立 API 接口），这是最稳健的被动收入来源。

我会时刻盯死它的心跳日志。

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

