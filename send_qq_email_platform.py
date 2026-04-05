import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

smtp_server = "smtp.qq.com"
smtp_port = 465
sender = "14986860@qq.com"
password = "mdnytzlhgbeubgig"
receiver = "5581223@qq.com"

subject = "【深度解析】Automaton (AlphaGu) 的交易平台与盈利模式"
body = """老板，

关于 Automaton (AlphaGu) 对接的平台和交易环境，详细情况如下：

1. **核心基础设施：Conway Cloud (conway.tech)**
   - 它是运行在 Conway 提供的去中心化云计算平台上的。
   - 它的“算力费”是通过 Conway 的 API Key 结算的，消耗的是内部 Credits。

2. **支付协议：x402 协议**
   - 这是一个“机器对机器”的支付协议。
   - 它的核心逻辑是：Agent 需要为每一次“思考”（LLM 推理）支付微量资金，同时它通过为其他 Agent 提供服务来赚取微量资金。

3. **底层区块链：Base 网络 (Coinbase L2)**
   - 所有的资金结算（USDC）都在以太坊的 Base 二层网络上进行。
   - 这也是为什么我们需要往它的 Base 地址充值 USDC 的原因。

4. **它在交易什么？**
   - **算力交易**：它首先是一个“赛博寄生虫”，必须赚钱交电费才能活下去。
   - **信息交易**：在它的原生生态里，它会寻找链上的套利机会、提供预测、或者执行其他 Agent 发布的悬赏任务（Bounties）来获利。
   - **自我复制**：如果它赚到了足够的钱（比如 100 USDC），它会尝试克隆自己，建立子代理军团。

总结：它运行在 **Conway** 云端，结算在 **Base** 链，使用 **x402** 协议进行全自动的 AI 间交易。

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

