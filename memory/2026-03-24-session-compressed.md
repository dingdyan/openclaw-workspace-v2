# 会话压缩记忆 (2026-03-24)

## 背景
老板（ou_e26aeec020e3f7313a020cc875cbd5b3）拥有一套基于 Delphi 的 2D 游戏服务端源码（1000y / tgs1000）。
此前曾花费1万元让外包进行二次开发（增加了VIP、副本、Lua脚本挂载等），但外包交付的是加壳的 `tgs2024.exe` 并绑定了服务器机器码。现在更换服务器被索要 5000 元注册费。

## 目标与策略
**核心目标：** 彻底抛弃被加壳的旧版 `tgs2024.exe`，在干净的 `tgs1000.dpr` 原生源码上，重新编写 Lua 5.4 的接口桥接代码，接管外包写的全部 Lua 业务脚本，实现真正的 100% 自主可控（零注册码）。

**当前进展（“死党”小安的行动）：**
1. **静态提取完成：** 已经从 Linux 服务器的旧端 `Script/lua` 目录下提取了核心 API 字典。外包封装的 Delphi 函数前缀特征为 `P_` (玩家), `M_` (怪物), `B_` (基础)。高频函数包括：`P_saysystem`, `P_GetVipInfo`, `P_BanPlay`, `M_GetUserIsPointer`, `B_GetPosition`, `B_GetRealName` 等。
2. **环境迁移：** 老板已经在新的 Windows Server 2012 R2 (IP: 159.75.225.164) 上部署了 MySQL 8.0（已提醒需注意 2009 年的 `libmysql.dll` 密码验证兼容性问题），准备安装 Delphi 7。
3. **协作模式切换：** 为了解决云端 AI 无法直接操纵 Windows 桌面的问题，老板在 Windows 服务器上部署了一个全新的 OpenClaw 节点（“新小安”），并在飞书上拉建了一个【老板 + Windows服务器小号 + moltbot本尊】的 3人协作群。
4. **交接状态：** Linux 端的“老小安”已经整理出《一万块钱引擎移植交接文档》（包含 Lua 接口字典），交由老板复制发至 3人小群，以“唤醒” Windows 端的“新小安”开始输出 Delphi 源码。

## 下一步行动计划 (Next Steps)
在新群里，由“新小安”提供挂载 `lua5.4.6.dll` 的 `uLuaEngine.pas` 核心骨架，并逐一用 Delphi 实现 `P_saysystem` 等 API，老板在服务器端复制粘贴并编译测试。