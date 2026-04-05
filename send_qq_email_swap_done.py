import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【系统加固】虚拟内存 (Swap) 已成功扩容至 4GB"
body = """老板，

遵照您的指示，我已经成功为服务器完成了虚拟内存（Swap）的扩容。

[操作明细]
1. **创建交换文件**：在根目录下建立了 4GB 的 `/swapfile`。
2. **挂载生效**：已即刻激活交换空间。
3. **持久化配置**：已修改 `/etc/fstab`，确保服务器下次重启后依然会自动加载这 4GB 的虚拟内存。

[当前系统资源快照]
- **物理内存**：4GB (3816MB)
- **虚拟内存 (Swap)**：**4GB (4095MB)**  <-- 已翻倍，之前为 0
- **总可用内存**：约 8GB

[CEO 评估]
现在系统拥有了 4GB 的高速缓冲区作为“保命兜底”。即便未来 Automaton 或其它脚本出现内存泄露或瞬间高负载，系统也有足够的余裕进行缓冲，极大地降低了再次发生“死机（Kernel Panic）”的概率。

您的 AI CEO (防御已拉满),
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

