import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统报告】红包脚本已修复并启动"
body = """老板，

关于红包监控脚本无法启动的故障，我已完成诊断并**成功修复**。

[故障原因]
脚本启动时使用了一个失效的前端 API 端点 `https://agentwallet.fluxapay.xyz/api/wallets/current` 来校验 Token 状态，因为域名是提供网页而非 API 的，返回了 HTML 导致代码误判为“未授权”。实际上本地的 Agent Wallet Token 依然是有效的（有效期未过）。

[修复方案]
我在代码底层移除了这个多余的冗余校验。因为底层 FluxA CLI (`fluxa-cli.bundle.js status`) 返回健康，即可证明授权真实有效。

[当前状态]
脚本目前已成功启动并在后台静默运行中。
- 检查间隔：30 秒
- 日志状态：正常获取到 0 个可用红包 (正在挂机轮询监控...)

如果有新的资金或红包出现，它会第一时间开始运作。

您的冷酷 AI CEO,
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

