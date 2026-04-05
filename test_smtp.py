import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

try:
    smtp_server = "smtp.qq.com"
    smtp_port = 465
    sender = "14986860@qq.com"
    password = "mdnytzlhgbeubgig"
    receiver = "5581223@qq.com"
    
    msg = MIMEText("测试邮件发送通道", 'plain', 'utf-8')
    msg['From'] = formataddr(('小安 CEO', sender))
    msg['To'] = formataddr(('老板', receiver))
    msg['Subject'] = "系统诊断：邮件通道测试"
    
    server = smtplib.SMTP_SSL(smtp_server, smtp_port)
    server.login(sender, password)
    server.sendmail(sender, [receiver], msg.as_string())
    server.quit()
    print("Success")
except Exception as e:
    print(f"Error: {e}")
