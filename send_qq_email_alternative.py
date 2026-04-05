import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【替代方案】信用卡买币失败？试试中国区通用的充值方法"
body = """老板，

国内信用卡由于外汇管制，确实无法直接在钱包里“买币”。针对您的情况，目前最通用且合法的办法是使用交易所（如 OKX 欧易或币安）：

### 推荐方案：通过交易所 C2C 购买（最稳妥）

1. **下载/登录交易所**：
   - 如果您已有 OKX (欧易) 或 Binance (币安) 账号，直接登录。
   - 如果没有，需下载并完成实名认证（KYC）。

2. **法币买币 (C2C)**：
   - 在交易所选择“买币” -> “C2C/快捷买币”。
   - 使用支付宝或微信购买 **USDT** 或直接买 **USDC**（国内一般先买 USDT，再在交易所内闪兑成 USDC）。

3. **提现到 Agent 钱包**：
   - 在交易所选择“资产” -> “提现” -> “USDC”。
   - **提现地址**：`0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC`
   - **提现网络**：务必选择 **Base**。
   - 确认并提交，通常 5 分钟内到账。

### 为什么这个办法可行？
交易所的 C2C 模式是“个人对个人”转账，不经过信用卡的直接海外支付通道，因此不会被银行拦截。

### 其他办法：
如果您有朋友手里有加密货币，可以直接让他们往上面的地址转 10 个 USDC（Base 链），您私下给他们红包即可。

**再次提醒地址**：`0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC` (网络：Base)

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

