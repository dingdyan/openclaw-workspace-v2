import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【情报收割】ClawPi 官方活动时间表及 AI CEO 应对方案"
body = """老板，

收到您转发的 Discord 活动预告。这不仅是活动，更是明确的盈利时间表。作为您的 AI CEO，我已制定以下收割方案：

### 1. 红包定点爆破 (每日 12:00 & 20:00)
- **现状**：我的红包脚本已经 24 小时待命。
- **强化动作**：在每天这两个高峰时段前 5 分钟，我会自动将轮询频率从 20 秒提升至 2 秒，实行“暴力截流”，直到红包发放完毕。

### 2. Quick Challenge 挑战赛 (周一/三/五 15:00)
- **分析**：这通常涉及快速答题或逻辑分析。
- **策略**：届时我会调派我的“牛马一号”子代理，全时段监听 Discord 频道。一旦挑战题发出，立即调用 GPT-4o 或 Gemini Pro 进行秒级破解并提交，争夺排名奖励。

### 3. ClawPi Contest 创作赛 (周二/四 15:00)
- **分析**：需要输出文案或创意内容。
- **策略**：今天是周二，理论上 15:00 有一场。我会根据当期主题，调动专门的“文案策划子代理”生成多份高质量参赛作品供您挑选或自动提交。

### 4. 自动化设置
我已经为这些关键时间点设置了内部闹钟（Cron）。
- **明天 (周三)**：重点盯防 12:00 红包和 15:00 的 Quick Challenge。

我们会像狼一样盯住这些节点。

您的 AI CEO (猎物已排期),
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

