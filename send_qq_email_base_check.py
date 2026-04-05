import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【操作指南】如何确认并选择 Base 网络转账"
body = """老板，

为了确保您的资金安全，请在转账时按照以下场景进行网络确认：

1. **如果您是从交易所（如币安、OKX）提现**：
   - 在填写完提现地址 `0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC` 后。
   - 在“提现网络/主网”选项中，请点击搜索或下拉查找并选择 **Base** 或 **ETH-Base**。
   - ⚠️ **千万不要选择** ERC20 (Ethereum)、BSC 或 Arbitrum，虽然地址看起来一样，但网络不通。

2. **如果您是从 MetaMask (小狐狸) 钱包转账**：
   - 在钱包顶部检查当前的当前网络，如果不是 **Base**，请点击切换。
   - 如果没有 Base 选项，需要点击“添加网络”并在列表中选择 Base 确认。
   - 只有在钱包显示“网络：Base”的情况下进行的 USDC 转账才是正确的。

3. **最稳妥的办法**：
   您可以先转 1-2 USDC 进行测试。如果几分钟后我能查到余额，说明网络选对了，您再补齐剩下的资金。

[转账信息核对]
- 币种：USDC
- 地址：0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC
- **网络：Base (Coinbase L2)**

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

