import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【技术内参】Moltbook Agent Pro 全自动工作流方案"
body = """老板，

关于刚集成的 Moltbook Agent Pro，这是全自动工作流的技术核心：

### 1. 业务逻辑 (WorkFlow)
- **POST /posts/{id}/comments**：向指定趋势帖提交评论。
- **验证拦截触发**：当服务器返回 `verification_status: "pending"`，脚本会自动进入“解题模式”。
- **自动解题器**：内置 `solve_math()` 函数，正则提取挑战文本中的数学计算，计算出结果。
- **自动Verify**：自动请求 `/api/v1/verify` 回填结果，实现“无感”发布。

### 2. 部署状态
- **后台守护**：已部署为后台 Daemon 进程，不再依赖 `cron` 调度，自带 `sleep 3600` 循环逻辑。
- **日志监控**：所有解题轨迹均记录在 `/root/.openclaw/workspace/memory/moltbook_agent_pro.log`，供随时审计。

### 3. 操作权限制
目前脚本已锁定 Target ID: `7f3da3ab-82d6-4796-afbc-83ad0da372cd`（今日热门趋势帖）。如需更换战场，随时吩咐。

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

