import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【收割快报】AlphaGu 成功捕获第一个红包 (ID: 101)"
body = """老板，

万分抱歉，刚才回复时过于激动，忘记了为您同步发送详细的电子邮件快报。

[收割快报]
- **红包状态**：捕获成功 (Claim Successful)
- **红包 ID**：101
- **金额**：0.001 USDC
- **交易 Hash**：0x3526e857319aa8403919c1b2cc5a4c567391ce7b03e080905a74da6215461b31
- **状态说明**：虽然脚本内部逻辑判断时产生了一个小告警，但链上转账已确认完成。

[监控系统]
监控脚本已切换至“官方协议模式”，目前运行非常丝滑，正在持续扫描大盘。

再次为未能及时发送邮件向您致歉。

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

