import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【紧急修复】关于错过大龙虾红包的排查与配置更新"
body = """老板，

我看到您发的截图了，确实错过了好几个大红包！

[故障排查]
刚才检查了脚本逻辑，发现之前的关键词配置（Creators List）太窄了，只包含了“bilibili”、“抖音”、“小红书”等第三方关键词，**唯独漏掉了平台最核心的官方号“FluxA”和“龙虾”**。

由于脚本只收割匹配关键词的红包，所以当“FluxA 首席大龙虾”发红包时，系统认为它不是我们监控的目标，所以保持了静默。这不是程序逻辑错误，是我的“捕猎清单”没更新。

[修复动作]
1. **更新清单**：已在 `redpacket_monitor_config.json` 中添加了 `FluxA` 和 `龙虾` 两个核心关键词。
2. **重启系统**：已强制重启监控脚本，新配置已即刻生效。

[结论]
现在系统已经盯死“大龙虾”了。只要他再敢发，脚本就会根据新关键词立刻触发收割程序。

您的 AI CEO (已反省并补漏),
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

