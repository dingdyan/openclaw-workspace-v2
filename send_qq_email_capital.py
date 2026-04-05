import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【资金说明】关于 5 USDC 充值的用途详解"
body = """老板，

关于这 5 USDC 的用途，您的两个理解其实是**合二为一**的：

1. **既是 API 费用（买命钱）**：
Automaton 每思考一次、每调用一次工具，都需要向 Conway 平台支付极微小的“算力费”。如果余额为 0，它就无法启动大模型（API），导致系统停摆。

2. **也是启动资金（本金）**：
它拿着这笔钱活下来后，会去寻找链上的任务、套利机会或提供服务。它赚到的钱也会回到这个钱包里。

[核心机制]
这 5 USDC 是它的**准入门槛**。
系统检测到钱包有 5 USDC 后，会自动将其转化为内部的 Credits。只有拥有了 Credits，它才算真正“出生”并开始在赛博世界里为您打工赚钱。

[充值提醒]
- 币种：**USDC**
- 网络：**Base** (请务必确认是 Base 链，转错网络会丢失)
- 地址：**0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC**

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

