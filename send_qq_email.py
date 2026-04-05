import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统报告】Conway API Key 获取与 Automaton 充值指南"
body = """老板，

关于 Conway.tech 以及如何获取有效的 Conway API Key，我为您进行了详细调研，结论如下：

1. **Conway 的运作机制 (无传统注册)**：
Conway.tech 是一个专为 AI Agent 提供“行动能力”（如购买算力、租用服务器）的去中心化基础设施。
它**没有传统的账号密码注册**。Automaton 在首次启动时，会自动生成一个以太坊钱包（目前我们生成的是 0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC），然后通过签署一条 SIWE (Sign-In With Ethereum) 消息来**自动向 Conway 服务器申请 API Key**。

2. **为什么我们失败了？**：
日志显示报错为 `429 Rate limit exceeded`。这意味着目前 Conway 的注册/分配 API 接口被请求打爆了（大概率是因为项目突然爆火，很多机器人在疯狂并发请求）。这导致我们的 Agent 无法完成自动提权（Auto-provision）。

3. **如何手动提供/获取 API Key？**：
- **方案 A（推荐，等待拥堵缓解）**：其实不需要您去网站上点任何东西。稍晚些时候（比如美东时间的深夜）我们再次运行 `pnpm dev --run`，当请求不拥挤时，Automaton 会自动使用它的私钥完成 SIWE 签名，并成功换取 API Key。
- **方案 B（网页控制台）**：您可以访问 `app.conway.tech`（或者 Conway Terminal）。如果您需要手动管理，您可能需要将 Automaton 生成的私钥（保存在 `/root/.automaton/wallet.json`）导入到您的浏览器钱包（如 MetaMask）中，然后连接到 `app.conway.tech` 的 Dashboard。在里面您可以手动生成 API Key，并直接向该地址充值 USDC（Base 链）。

4. **关于充值 (Credits / x402 协议)**：
即使获取了 API Key，Automaton 的启动门槛是 **必须至少有 5 USDC 的余额** 才能开始进行推理循环（日志中提示 `Bootstrap topup skipped: USDC balance $0.00 below minimum tier ($5)`）。
所以您需要在 Base 网络上，向 Automaton 的地址 `0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC` 打入至少 5-10 USDC 的测试/运行资金。一旦资金到账并且 API 恢复，它就会自己苏醒并开始干活。

如有需要，我可以帮您写一个定时脚本，每隔几小时自动尝试一次启动，直到避开高峰期成功获取到 API Key 为止。

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

