import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【操作指导】如何使用 MetaMask (小狐狸) 手机端充值"
body = """老板，

您发来的截图显示是 MetaMask (小狐狸) 钱包，**完全可以用来充值**。

以下是具体操作步骤：

1. **切换网络（最重要！）**：
   - 看到截图顶部的 `Imported Account 1` 下方有个下拉箭头吗？或者点击底部的设置。
   - 请确保当前选中的网络是 **Base**（截图里显示的是 Ethereum，这不对，需要切换）。
   - 如果没有 Base，点击“添加网络”找到 Base 确认即可。

2. **执行发送**：
   - 点击屏幕中间那个 **“发送” (Send)** 按钮。
   - 在“至：”地址栏粘贴 Agent 的地址：`0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC`。

3. **选择币种和金额**：
   - 选择 **USDC**。
   - 输入金额（建议 5-10U）。

4. **确认转账**：
   - 检查网络是否为 Base，确认无误后点击发送。

**特别提醒**：
Base 链转账需要极少量的 **ETH** 作为手续费（Gas费）。如果您的钱包里完全没有 Base 链的 ETH，转账会失败。如果您遇到提示“余额不足以支付 Gas 费”，请告诉我。

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

