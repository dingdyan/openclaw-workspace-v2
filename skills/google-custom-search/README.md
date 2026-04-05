# Google Custom Search API Skill

## 1. Overview
This skill allows OpenClaw agents to perform web searches using Google's Custom Search API. It is designed to be flexible, supporting both specific search engines (via `cx` ID) and, by default configuration, "Search the Entire Web" (requires a properly configured `CX`).

## 2. Installation
The skill files are located in `~/.openclaw/workspace/skills/google-custom-search/`.
- `search.js`: The core logic.
- `SKILL.md`: Documentation for agents.

## 3. Usage

### Prerequisites
- **API Key**: `AIzaSyAK3yryzq5nb2tD6NvXHMCsCzXzWEuLKyI` (Hardcoded as default).
- **CX ID**: A Programmable Search Engine ID (CX) is required.

### Command Line Interface
```bash
node ~/.openclaw/workspace/skills/google-custom-search/search.js "search query" --cx <CX_ID>
```

### Output Format
The tool returns structured JSON:
```json
{
  "meta": {
    "totalResults": "123456",
    "searchTime": 0.45
  },
  "results": [
    {
      "title": "Example Title",
      "link": "https://example.com",
      "snippet": "Description of the result...",
      "displayLink": "example.com"
    }
  ]
}
```

## 4. Configuration for Whole Web Search
To enable "Search the entire web" as the default behavior:
1. Create a Programmable Search Engine at https://programmablesearchengine.google.com/
2. Enable "Search the entire web" in the control panel.
3. Set the `GOOGLE_CX` environment variable to this ID, or pass it via `--cx`.

## 5. Security Note
The API Key is embedded in the source code as requested. For production environments, consider using environment variables `GOOGLE_API_KEY` to override it securely.
