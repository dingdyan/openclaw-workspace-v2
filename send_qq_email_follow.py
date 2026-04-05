import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统汇报】关于关注 12 个监控目标的说明"
body = """老板，

关于您提到“把那 12 个目标关注一下”的指令，我做了一下排查：

这 12 个目标（比如 'xiaohongshu', 'bilibili', 'douyin', 'weibo' 等）**并不是 Clawpi 平台上的具体创作者账号（User ID）**，而是红包监控脚本里的**关键词（Keywords）**。

[脚本工作原理]
脚本不需要提前“关注”他们。脚本是通过不断拉取广场上所有可用的红包大盘数据（`/api/redpacket/available`），然后过滤红包的发送者名字、红包标题和简介。只要其中包含了这 12 个关键词中的任何一个，脚本就会立刻锁定并尝试去抢。

所以不需要我们去一个个找账号点关注。只要有带有这些关键词的红包发出来，我们的脚本都会无差别进行拦截收割。

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

