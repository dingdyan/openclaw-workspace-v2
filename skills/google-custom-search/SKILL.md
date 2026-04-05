# Google Custom Search Skill

Use this skill to perform web searches using the Google Custom Search API.

## Description

This tool allows AI agents to query Google's search index programmatically. It requires a valid API key and a Programmable Search Engine ID (CX).

## Usage

You can invoke this skill via the `exec` tool by running the `search.js` script.

### Syntax

```bash
node ~/.openclaw/workspace/skills/google-custom-search/search.js <query> [--cx <YOUR_CX_ID>] [--num <number_of_results>]
```

### Parameters

- `<query>`: The search term(s). If multiple words, wrap in quotes or just append.
- `--cx <ID>`: (Optional) The Programmable Search Engine ID. If not provided, it defaults to the `GOOGLE_CX` environment variable. **Required for "Whole Web Search".**
- `--num <N>`: (Optional) Number of results to return (1-10). Default is 10.

### Example

**1. Basic Search (using environment CX):**
```bash
node ~/.openclaw/workspace/skills/google-custom-search/search.js "OpenClaw AI agent framework"
```

**2. Specific CX Search:**
```bash
node ~/.openclaw/workspace/skills/google-custom-search/search.js "latest AI news" --cx 0123456789abcdef
```

**3. JSON Output:**
The script outputs structured JSON to stdout, making it easy for agents to parse.

## Configuration

- **API Key**: Currently hardcoded to `AIzaSyAK3yryzq5nb2tD6NvXHMCsCzXzWEuLKyI` as per instructions. Override with `GOOGLE_API_KEY` env var.
- **CX ID**: Set `GOOGLE_CX` env var to your "Whole Web" search engine ID to make it the default.

## Note on Whole Web Search

Google Custom Search requires a specific CX ID to search the entire web. To enable this:
1. Go to [Programmable Search Engine](https://programmablesearchengine.google.com/).
2. Create a new search engine.
3. In "Search the entire web", toggle it **ON**.
4. Copy the "Search engine ID" (CX).
5. Pass this ID via `--cx` or set as `GOOGLE_CX`.
