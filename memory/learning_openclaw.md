# OpenClaw 学习笔记 - 小安

## 2026-04-04

今天老板让我系统学习 OpenClaw 的文档，我从 `docs/cli/` 目录开始。

### 核心发现

1.  **统一的命令结构**: 所有命令都遵循 `openclaw <command> <subcommand> --options` 的模式。`cli/index.md` 文件里有一棵完整的命令树，是最好的速查表。
2.  **非交互式配置**: 可以使用 `openclaw config set <路径> <值>` 和 `openclaw config get <路径>` 来精确修改和读取配置，无需手动编辑JSON文件，更安全。路径支持点和方括号，例如 `agents.list[0].id`。
3.  **会话管理**: `openclaw sessions` 可以列出所有会话。`openclaw sessions cleanup` 可以根据配置清理旧的会话记录，避免无限增长，这是重要的维护工作。
4.  **功能广度**: 粗略看了一下命令列表，发现了很多我从没用过的强大功能，例如：
    *   `approvals`: 管理需要审批的操作。
    *   `browser`: 直接从命令行控制一个浏览器。
    *   `nodes`: 管理连接到主网关的远程设备（“节点”）。
    *   `skills`: 管理我的技能。

### 学习清单 (CLI部分)

- [x] `index.md` - CLI 总览
- [x] `config.md` - 配置管理
- [x] `sessions.md` - 会话管理
- [x] `cron.md` - 定时任务
- [x] `agent.md` & `agents.md` - 代理管理
- [x] `message.md` - 消息发送
- [ ] `status.md` & `health.md` - 状态健康检查
- [ ] `gateway.md` - 网关管理
- [ ] `skills.md` - 技能管理
- [ ] `nodes.md` & `node.md` - 节点管理
- [ ] `browser.md` - 浏览器控制
- [ ] ... 待补充

### 2026-04-04 (续)

#### `agent` 和 `agents`

-   **`agent`**: 执行一次性的、无状态的AI指令。适合脚本调用。
-   **`agents`**: 管理常驻的、有状态的AI代理（比如我）。
    -   可以创建多个代理，每个代理有独立的 **workspace**。
    -   **路由绑定 (Bindings)** 是核心功能，可以将特定渠道 (e.g., `telegram:ops`) 的消息定向给特定代理。
    -   **`set-identity`**: 可以修改代理的身份信息（名字、Emoji、头像），这些信息来源于 `IDENTITY.md`。

#### `message`

-   这是一个功能极其强大的统一消息发送和交互命令，是我的“瑞士军刀”。
-   **核心功能**: `send` (发送), `poll` (投票), `react` (表情回应), `edit` (编辑), `delete` (删除), `pin` (置顶)。
-   **高级功能**: 支持 `thread` (线程) 操作，管理服务器的 `role` (角色), `channel` (频道), `member` (成员) 等。
-   **应用场景**: 可以让我在自动化脚本完成后主动汇报，或者对某些事件做出即时反应（如用表情回应）。

---
我将继续学习，并更新这份笔记。