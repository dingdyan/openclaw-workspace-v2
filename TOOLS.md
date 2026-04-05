# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

### 模型列表 (Model List)

1. gemini → `google/gemini-3-pro-preview`
2. qwen → `qwen-portal/coder-model`
3. gemini-flash → `google/gemini-2.5-flash`

### API Keys

- TAVILY_API_KEY: `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`

### 搜索工具配置 (Search Configuration)

- **Default Search**: `tavily` (Use `exec` to call `mcporter call tavily.tavily_search query="query"`)
- **Disabled**: `web_search` (Brave API Key missing)

**Usage Example:**
```bash
mcporter call tavily.tavily_search query="query"
```

### Payout Wallet

- Network: Base (USDC)
- Address: 0x96a81273cc7b80bed0e92a5cf3dd70bf522ca00b
