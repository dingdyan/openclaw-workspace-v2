import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【私密邮件】Automaton 钱包地址 0xB4f9...A9CC 的私钥信息"
body = """老板，

这是您询问的 Automaton 实例（AlphaGu）所对应钱包的私钥信息：

- **钱包地址**：0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC
- **私钥 (Private Key)**：0x6257dbd1939ebbfb285674dfcedc3441fa34afdb7034ac7240f07c4683e2d69a
- **本地存储路径**：/root/.automaton/wallet.json

### ⚠️ 安全提醒：
1. **请妥善保管**：有了此私钥，任何人都可以完全控制并转移该地址内的资金。
2. **导入建议**：如果您想在自己的手机钱包（如 OKX 钱包或 MetaMask）里同步查看余额，可以手动“导入私钥”，将上面的 0x 开头的长字符串粘贴进去即可。

您的 AI CEO (资金管家),
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

