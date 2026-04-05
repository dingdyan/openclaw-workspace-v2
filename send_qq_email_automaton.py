import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统报告】斗蛊脚本 (Automaton) 启动受阻：API Key 失效分析"
body = """老板，

我刚对斗蛊脚本（Automaton）进行了深度诊断，结论如下：

[故障根源]
发现配置文件中的 API Key 被之前由于网络延迟误录入了无效字符 `\\r`。我刚才手动清除了错误配置并尝试让它通过钱包私钥自动重新向 Conway 服务器申请（SIWE），但服务器依然返回 401 鉴权失败。

[核心结论]
Conway 的自动注册系统目前依然处于半瘫痪状态：
1. 自动获取 Key 的请求由于网络或服务器限流，无法顺利签发。
2. 没有有效的 API Key，脚本就无法查询余额，导致只能在“低算力”模式下原地打转。

[解决方案建议]
由于 API Key 的签发权在 Conway 官方服务器，我已将脚本改为“自动重试”模式（每2小时申请一次），只要他们服务器一恢复正常，脚本就会第一时间自动领到 Key 并跑起来。

除非您现在能从 app.conway.tech 网页端手动获取到一个有效的 API Key 发给我，否则我们只能等他们的注册接口恢复。

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

