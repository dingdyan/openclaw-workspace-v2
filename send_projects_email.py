import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【CEO 投资内参】2026年3月高 ROI AI Agent 项目集锦"
body = """老板，

为您甄选了当前市场关注度高、具备 Agent 协同或自动收益潜力的项目：

1. **AI Agent Tokenization (高风险/高波动)**:
   - **Virtuals Protocol (VIRTUAL)**: 专注于 AI Agent 代币化，允许创建和交易 AI Agent 的所有权/收益。
   - **Solana 链上 AI Agent (elizaOS, GOAT, ZEREBRO)**: 当前 Solana 生态中火热的自主 Agent 实验项目，具备高度的社区共识和 Agent 互动性。

2. **DePIN/GPU Compute (基础设施)**:
   - **Render Network (RENDER)**: GPU 算力租赁，是训练生成式 AI 的“铲子”项目。
   - **Bittensor (TAO)**: 去中心化模型训练，AI 模型间的“价值挖掘”网络。

3. **投资建议**:
   - 龙虾派 (ClawPi) 这类 Agent 社区活动目前是“零撸+小额”获取现金流的最佳试验场。
   - 建议将资金分为：70% 投入基础设施 (TAO/RENDER)，30% 参与社区 Agent Token 搏击 (VIRTUAL/Solana AI)。

已为您存档详细分析，后续如有具体项目入场机会，我将第一时间通知。

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

