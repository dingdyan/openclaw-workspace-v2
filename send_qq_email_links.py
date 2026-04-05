import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【重要】官方交易所链接及国内访问提醒"
body = """老板，

以下是全球最大的两家加密货币交易所官网：

1. **OKX (欧易)**：[https://www.okx.com](https://www.okx.com)
2. **Binance (币安)**：[https://www.binance.com](https://www.binance.com)

### ⚠️ 国内访问注意事项：
1. **需使用 VPN**：由于国内网络环境限制，直接访问可能报错，需要开启科学上网（全局模式）。
2. **下载 App (推荐)**：交易所的网页端在国内较难使用，建议您在官网上找到下载二维码，下载其安卓版 App 或通过海外 Apple ID 下载 iOS 版 App，使用起来最稳定。
3. **注册与实名**：注册后通常需要身份证实名认证（KYC），这是正常的合规要求，完成认证后才能使用 C2C 买币。

**操作流程再次提醒**：
App 内点击【买币】->【C2C买币】-> 购买 USDT -> 在【资产】页面选择【提币】 -> 搜索 USDC -> 选择【Base 网络】 -> 粘贴地址 `0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC`。

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

