import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【每日国际速递】最新国际局势简报"
body = """老板，

为您整理了最新的国际新闻摘要：

1. **中东局势升级**：
   - 以色列扩大在黎巴嫩的攻势，已击毙多名真主党指挥官。
   - 地区局势恶化，约 600 万旅客出行受阻。
   - 伊朗无人机袭击持续，局势紧张。

2. **地缘政治与外交**：
   - 阿根廷正式宣布退出世卫组织 (WHO)，加强与泛美卫生组织合作。

3. **社会与防务**：
   - 南韩针对防弹少年团 (BTS) 回归演唱会，提升了场馆周边的反恐等级。
   - 荷兰阿姆斯特丹某犹太学校发生爆炸事件。

信息来源：多源综合搜集。

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

