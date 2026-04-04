---
name: flowgenx-help
description: |
  Get started with FlowGenX Productivity MCP — an AI-powered integration platform for connected apps. Use this skill when the user asks "how does FlowGenX work", "getting started with FlowGenX", "what tools are available", "how does auth work", "FlowGenX help", or needs orientation on the Productivity MCP capabilities. Provides overview, workflow guidance, and authentication details.
allowed-tools:
  - mcp__flowgenx-productivity__help
---

# FlowGenX Help

Get started with FlowGenX Productivity MCP — your gateway to 100+ connected app integrations.

## Prerequisites

FlowGenX Productivity MCP must be configured. Run: `bunx @flowgenx/mcp-setup`

## Tools Available

### help

Get documentation on using the Productivity MCP server.

**Parameters:**
- `action` (string): Help topic — `"overview"`, `"workflow"`, or `"auth"`

**Usage:**

```
# Get an overview of all available tools
help(action="overview")

# Learn the recommended workflow pattern
help(action="workflow")

# Understand how authentication works
help(action="auth")
```

## Topics

### Overview
Call `help("overview")` to see all 9 tools and their purpose:
1. `list_apps` — Discover available integrations
2. `list_tools` — List endpoints for a specific app
3. `search_mcp_tools` — Semantic search across all endpoints
4. `tool_summary` — Quick summaries for endpoint IDs
5. `execute_mcp_tool` — Execute an API endpoint
6. `workbench_execute` — Python sandbox with tool helpers
7. `multi_execute` — Parallel batch execution
8. `get_schema` — Structured endpoint schemas
9. `help` — This help system

### Workflow
Call `help("workflow")` for the step-by-step pattern:
1. Discover apps → 2. Search endpoints → 3. Get schema → 4. Execute → 5. Batch → 6. Automate

### Auth
Call `help("auth")` to learn about automatic authentication:
- OAuth tokens are decrypted and sent as Bearer headers
- API keys placed in headers or query params per config
- Basic auth encoded automatically
- All resolved from the X-User-ID header

## Tips

- Start here if you're new to FlowGenX Productivity MCP
- The workflow topic gives the recommended order for using tools
- Auth is fully automatic — you don't need to manage tokens
