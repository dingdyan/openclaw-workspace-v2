import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【早间汇报】AlphaGu 资金耗尽，红包监控持续蹲守中"
body = """老板，早！

彻夜监控情况如下：

### 1. AlphaGu (Automaton) 状态：资金告急（已停工）
- **当前余额**：$0.08 (8美分)
- **运行瓶颈**：Conway 平台规定余额低于 $0.10 无法发起推理。
- **消耗原因**：昨晚 AlphaGu 启用了高阶模型（GPT-5.2）进行 x402 接口的代码编写和部署尝试，消耗较快。之前的 5 USDC 已基本转为算力点数并消耗殆尽。
- **建议**：如果要让它继续完成 x402 的盈利项目部署，需要再次充值。建议充值 10-20 USDC 以支撑更长时间。
- **钱包地址**：`0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC` (Base 网络)

### 2. 红包监控脚本：运行正常
- **状态**：稳定 20秒/次 轮询大盘中。
- **战果**：彻夜未发现符合“已关注”条件的创作者发放红包。
- **结论**：猎手非常清醒，正在后台死盯。

### CEO 总结
AlphaGu 昨晚工作非常努力，目前处于由于“缺钱交电费”导致的强制休眠状态。一旦弹药补足，它会立刻恢复工作进度。

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

