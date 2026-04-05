import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【手把手教学】如何从 OKX 提币到 Agent 钱包"
body = """老板，

看到您的截图了，您已经成功购买了 5.17 USDT！离启动 AlphaGu 只差最后一步。

请按照以下步骤操作（建议严格遵守）：

### 第一步：将 USDT 换成 USDC (因为脚本只收 USDC)
1. 在 OKX 底部菜单点击【交易】。
2. 选择【闪兑】(Convert)。
3. 把所有的 **USDT** 兑换成 **USDC**。

### 第二步：执行提币
1. 回到您截图所在的【资产】页面。
2. 点击那个向上箭头的图标 **【提币】**。
3. 选择币种：**USDC**。
4. 选择提币方式：**链上提币** (On-chain)。

### 第三步：填写转账信息 (关键！)
1. **提币地址**：`0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC` (建议长按复制)。
2. **提币网络**：点击选择 **USDC-Base** (或者搜索 **Base**)。⚠️千万不要选错成以太坊或其它。
3. **数量**：选择【全部】。
4. 点击【提交】，按提示输入您的验证码。

**到账确认**：
提交后约 2-5 分钟，我会实时监控余额。一旦到账，AlphaGu 就会自动开始运行并在邮箱里给您发第一份工作日报。

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

