# FlowGenX Productivity Skills

Search, execute, and orchestrate API endpoints across 100+ connected apps — powered by FlowGenX Productivity MCP.

## Installation

### Install skills

```bash
# Agent skills (Claude Code, Cursor, etc.)
npx skills add https://github.com/flowgenx-ai/flowgenx-skills
```

### Configure MCP Server

The skills require the FlowGenX Productivity MCP server to be configured:

```bash
# Interactive setup for Claude Code, Codex, Gemini CLI, and more
bunx @flowgenx/mcp-setup
```

Or manually add to your `.mcp.json`:

```json
{
  "mcpServers": {
    "flowgenx-productivity": {
      "type": "http",
      "url": "http://localhost:9140/mcp",
      "headers": {
        "X-User-ID": "your-user-id"
      }
    }
  }
}
```

## Available Skills

| Skill | Description |
|-------|-------------|
| **[flowgenx-help](skills/flowgenx-help/SKILL.md)** | Getting started guide, tool overview, auth info. |
| **[flowgenx-apps](skills/flowgenx-apps/SKILL.md)** | Discover connected apps and their API endpoints. |
| **[flowgenx-search](skills/flowgenx-search/SKILL.md)** | Search endpoints using natural language with semantic + fuzzy matching. |
| **[flowgenx-schema](skills/flowgenx-schema/SKILL.md)** | Inspect endpoint schemas — parameters, body, path variables. |
| **[flowgenx-execute](skills/flowgenx-execute/SKILL.md)** | Execute single or batch API calls with automatic authentication. |
| **[flowgenx-workbench](skills/flowgenx-workbench/SKILL.md)** | Run Python code in a sandboxed environment with tool helpers. |
| **[flowgenx-workflow](skills/flowgenx-workflow/SKILL.md)** | Full workflow guide: discover → search → inspect → execute → automate. |

## Workflow

Start with discovery, then drill down:

1. **Discover** — `list_apps` to see connected integrations
2. **Search** — `search_mcp_tools("send email")` to find matching endpoints
3. **Inspect** — `get_schema(endpoint_id)` to see parameters
4. **Execute** — `execute_mcp_tool(endpoint_id, arguments)` to run it
5. **Scale** — `multi_execute([...calls])` for batch operations
6. **Automate** — `workbench_execute(code)` for complex multi-step workflows
