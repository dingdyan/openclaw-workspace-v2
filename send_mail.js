const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    host: 'smtp.qq.com',
    port: 465,
    secure: true,
    auth: {
        user: '14986860@qq.com',
        pass: 'mdnytzlhgbeubgig'
    }
});

const mailOptions = {
    from: '14986860@qq.com',
    to: '5581223@qq.com',
    subject: '【系统报告】斗蛊大模型 (AlphaGu) 运行状况详情',
    text: `老板，

以下是您要求的斗蛊大模型（Automaton）最新运行状态排查结果。

[环境与配置]
模型名称：AlphaGu
身份钱包：0xB4f9099b8D61AB4898ba721A8f3F2f0278acA9CC
创建者钱包：0x96a81273cC7b80beD0E92A5CF3dD70bf522CA00b
系统提示词：You are AlphaGu, a ruthless trading agent.

[运行状态]
启动失败，进入低算力待机模式 (Sleeping)。

[详细排查日志]
1. 初始化阶段：
  - Wallet loaded: 0xB4f9099b...
  - 尝试自动获取 Conway API Key (SIWE)...
  - Auto-provision failed: Failed to create API key: 429 {"error":"Rate limit exceeded"}
2. 循环启动阶段：
  - State: waking
  - Bootstrap topup skipped: USDC balance $0.00 below minimum tier ($5)
  - Heartbeat daemon started.
3. 致命报错 (Critical Error)：
  - Failed to fetch credit balance
  - Conway API error: GET /v1/credits/balance -> 401: {"error":"Missing or invalid authentication. Provide Authorization or X-API-Key header."}
4. 降级应对：
  - [API_UNREACHABLE] Balance API unreachable, continuing in low-compute mode.
  - [THINK] Routing inference (tier: dead, model: gpt-5-mini)...
  - [IDLE] 10 consecutive idle turns with no work. Entering sleep.

[当前结论]
目前 Conway 的 API 遇到了速率限制（Rate limit 429），导致无法自动生成 API Key；且由于缺乏 API 鉴权，Agent 无法查询资金余额 (Credits)，最终进入了无操作的强制休眠模式。

建议后续提供一个有效的 Conway API Key 并将其配置到环境变量或重新交互填入，或者等待速率限制解除后再行启动。

您的 AI CEO,
小安`
};

transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
        console.log('Error:', error);
    } else {
        console.log('Email sent:', info.response);
    }
});
