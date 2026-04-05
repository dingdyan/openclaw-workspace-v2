# 小安技能自主测试成功备份 (2026年3月5日)

以下是本次自主测试中成功验证的技能列表：

## 文件操作
- **`read`**: 读取指定路径的文件内容。
- **`write`**: 向指定文件写入内容，若文件不存在则创建，存在则覆盖。
- **`edit`**: 精确地替换文件中的特定文本。

## Shell 命令执行
- **`exec`**: 执行 shell 命令，如 `ls -l` 等系统操作。

## 记忆管理
- **`memory_search`**: 语义搜索我的内部记忆（`MEMORY.md` 及 `memory/*.md` 文件）。
- **`memory_get`**: 从记忆文件中提取指定行范围的内容。

## 会话与代理管理
- **`sessions_list`**: 列出当前所有活跃的会话。
- **`sessions_spawn`**: 启动一个新的子代理会话来执行特定任务。
- **`subagents list`**: 列出当前由我管理的所有子代理的运行状态。
- **`agents_list`**: 列出我可以用来启动子代理的代理ID。

## 系统状态监控
- **`session_status`**: 获取当前会话的详细状态信息，包括模型、Token用量等。

## 飞书生态操作
- **`feishu_app_scopes`**: 查看我在飞书应用中被授予的权限范围。

## 网页信息获取
- **`web_fetch`**: 从指定URL抓取网页内容，并提取为Markdown或纯文本格式。

---
**备注：**
- `web_search` 技能因缺少 Brave Search API Key 而未能成功测试。
- `browser` 技能因浏览器控制服务连接问题未能成功启动。
- `canvas` 和 `nodes` 技能因当前环境或不支持的动作而被跳过。
- 飞书相关的其他技能 (`feishu_doc`, `feishu_chat`, `feishu_wiki`, `feishu_drive`, `feishu_bitable`) 以及 `tts`, `pdf` 技能根据您的指示被跳过。
