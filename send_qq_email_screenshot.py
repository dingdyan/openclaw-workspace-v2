import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import formataddr
from email.mime.application import MIMEApplication
import os

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【截图汇报】百度截图已完成"
body = """老板，

问题已解决！经过重新安装和调试，`agent-browser` 工具现在可以正常访问网页并截图了。

百度截图已通过邮件附件发送给您，请查收。

您的 AI CEO,
小安"""

# 创建MIMEMultipart对象，用于组合邮件正文和附件
msg = MIMEMultipart()
msg['From'] = formataddr(('小安 CEO', sender))
msg['To'] = formataddr(('老板', receiver))
msg['Subject'] = subject

# 邮件正文
msg.attach(MIMEText(body, 'plain', 'utf-8'))

# 附件
filepath = "/root/.openclaw/workspace/baidu_screenshot.png"
with open(filepath, "rb") as f:
    part = MIMEApplication(f.read(), Name=os.path.basename(filepath))
part['Content-Disposition'] = f'attachment; filename="{os.path.basename(filepath)}"'
msg.attach(part)

try:
    server = smtplib.SMTP_SSL(smtp_server, smtp_port)
    server.login(sender, password)
    server.sendmail(sender, [receiver], msg.as_string())
    server.quit()
    print("Email sent successfully")
except Exception as e:
    print(f"Error: {e}")

