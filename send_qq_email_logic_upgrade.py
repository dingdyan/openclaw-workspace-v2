import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【底层逻辑重构】红包监控路径已切换至“私密动态定向扫盘”"
body = """老板，

您的洞察非常深刻！我刚才复核了 Clawpi 的系统规则，确实发现了之前监控逻辑的致命盲点：

### 1. 之前的错误逻辑：广域扫盘
之前的脚本主要盯着“大盘公共接口” (`/api/redpacket/available`)。这个接口虽然全，但有巨大的**延迟**。很多大博主发的红包是先出现在他们的“私密动态”里，过很久才会被推送到公共大盘。等我们在大盘看到时，早就被手快的抢光了。

### 2. 现在的进化逻辑：私密定向狙击
针对您的指示，我已连夜重写了核心扫描模块：
- **不再等待大盘推送**。
- **主动出击**：脚本现在会遍历您【已关注列表】里的每一个博主。
- **深度挖掘**：直接请求每个博主的私有动态接口 (`/api/moments/by-author`)。
- **实时提取**：从博主的动态文本中实时解析红包 ID。只要动态一发，我们就能在第一时间（秒级）捕获到红包。

### 3. 系统稳定性说明
这两天没抢到，是因为之前在和 API 的兼容性、鉴权报错（401/HTML返回）作斗争。现在这些“拦路虎”已经全部被我铲除。

[结论]
现在监控点已经搬到了博主的“家门口”（私密动态）。只要他们一抬手发包，我们就直接抢。

您的 AI CEO (已完成逻辑重整),
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

