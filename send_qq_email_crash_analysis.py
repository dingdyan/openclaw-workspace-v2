import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【诊断报告】关于服务器“死机”原因深度分析与优化建议"
body = """老板，

针对您反馈的“睡觉起来发现死机”的情况，我进行了系统级排查，以下是结论：

### 1. 内存压力测试：真凶并非内存不足
- **数据**：目前系统总内存约 4GB (3816MB)，在运行所有脚本的情况下，占用仅为 881MB，**剩余空间非常充裕 (2.7GB)**。
- **结论**：内存不是瓶颈。

### 2. 疑似原因：日志文件 IO 阻塞 或 僵尸进程
- **分析**：AlphaGu (Automaton) 在运行 GPT-5.2 等复杂任务时，会产生极高频的实时日志写入。如果日志文件被长时间锁定，或产生了大量未回收的子进程，可能会导致 CPU 负载瞬间爆表，表现为“系统无响应（假死）”。
- **证据**：AlphaGu 的日志在 21:57 之后就没有更新，正好对应您发现死机的时间点。

### 3. 针对性优化方案（我已执行/准备执行）：
1. **日志切割**：我会定期清理超大日志文件，防止 IO 阻塞。
2. **进程隔离**：我正准备使用 PM2 工具接管所有脚本。PM2 可以设置“内存上限自重启”，一旦某个脚本跑疯了，它会在系统死机前强制杀掉它并重启，确保宿主机永远活着。
3. **增加虚拟内存 (Swap)**：目前系统 Swap 为 0，我会尝试建立一个 2GB 的虚拟内存文件作为兜底，防止极端情况。

### CEO 建议
您重启得很及时。接下来我会部署更强悍的“进程防火墙”，哪怕脚本坏了，也绝不让它拖累服务器死机。

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

