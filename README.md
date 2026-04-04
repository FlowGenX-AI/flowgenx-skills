# FlowGenX Skills

Agent skills for FlowGenX — AI-powered integration platform.

## Installation

```bash
# Install all skills (Claude Code, Cursor, etc.)
npx skills add https://github.com/FlowGenX-AI/flowgenx-skills

# Configure MCP connection
npx flowgenx
```

## Skill Groups

### Worker AI (`skills/workai/`)

Search, execute, and orchestrate API endpoints across 100+ connected apps via Worker AI Productivity MCP.

| Skill | Description |
|-------|-------------|
| **[flowgenx-help](skills/workai/flowgenx-help/SKILL.md)** | Getting started guide, tool overview, auth info. |
| **[flowgenx-apps](skills/workai/flowgenx-apps/SKILL.md)** | Discover connected apps and their API endpoints. |
| **[flowgenx-search](skills/workai/flowgenx-search/SKILL.md)** | Search endpoints with semantic + fuzzy matching. |
| **[flowgenx-schema](skills/workai/flowgenx-schema/SKILL.md)** | Inspect endpoint schemas — parameters, body, path variables. |
| **[flowgenx-execute](skills/workai/flowgenx-execute/SKILL.md)** | Execute single or batch API calls with automatic auth. |
| **[flowgenx-workbench](skills/workai/flowgenx-workbench/SKILL.md)** | Run Python in a sandbox with tool helpers. |
| **[flowgenx-workflow](skills/workai/flowgenx-workflow/SKILL.md)** | Full workflow: discover → search → inspect → execute → automate. |

*More skill groups coming soon (SDK, Workflows, etc.)*

## Prerequisites

1. Sign up at [flowgenx.ai](https://flowgenx.ai)
2. Access **Worker AI** from the dashboard
3. Connect your apps (Slack, HubSpot, Gmail, GitHub, etc.)
4. Get your **MCP URL** & **API Key** from Worker AI → Settings
5. Run `npx flowgenx` to configure your AI tools

## Workflow

1. **Discover** — `list_apps` to see connected integrations
2. **Search** — `search_mcp_tools("send email")` to find endpoints
3. **Inspect** — `get_schema(endpoint_id)` to see parameters
4. **Execute** — `execute_mcp_tool(endpoint_id, arguments)` to run it
5. **Scale** — `multi_execute([...calls])` for batch operations
6. **Automate** — `workbench_execute(code)` for multi-step workflows

## Author

Mohammad Ismail — [ismail@flowgenx.ai](mailto:ismail@flowgenx.ai)

## License

MIT
