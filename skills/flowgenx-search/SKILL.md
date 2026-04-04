---
name: flowgenx-search
description: |
  Search API endpoints across connected apps using natural language via FlowGenX Productivity MCP. Use this skill when the user says "find a tool for", "search for an endpoint", "look for an API to", "how do I send email", "find me a way to create contacts", "search tools", or needs to find specific API capabilities across their integrations. Uses semantic + fuzzy matching for intelligent search.
allowed-tools:
  - mcp__flowgenx-productivity__search_mcp_tools
  - mcp__flowgenx-productivity__tool_summary
---

# FlowGenX Endpoint Search

Find API endpoints across your connected apps using natural language queries.

## Prerequisites

FlowGenX Productivity MCP must be configured. Run: `bunx @flowgenx/mcp-setup`

## Tools Available

### search_mcp_tools

Search endpoints using semantic + fuzzy matching. Handles typos, synonyms, and natural language.

**Parameters:**
- `query` (string, required): Natural language search — e.g. "send email", "list contacts", "generate image"
- `app_connector_id` (string, optional): Filter results to a specific app
- `category` (string, optional): Filter by endpoint category
- `limit` (int, optional): Max results (default: 15)

**Returns:** Ranked results with relevance scores:
- `endpoint_id` — UUID for get_schema/execute_mcp_tool
- `method` — HTTP method
- `path` — API path
- `summary` — What it does
- `connector_name` — Which app it belongs to
- `score` — Relevance score (higher = better match)

**Usage:**
```
# Natural language search
search_mcp_tools(query="send an email")
search_mcp_tools(query="create a new contact in CRM")
search_mcp_tools(query="list all channels")

# Filtered search
search_mcp_tools(query="list contacts", app_connector_id="hubspot-uuid")
search_mcp_tools(query="upload file", category="Storage")

# Get more results
search_mcp_tools(query="generate", limit=25)
```

### tool_summary

Get short summaries for one or more endpoint IDs.

**Parameters:**
- `endpoint_ids` (string): Single endpoint UUID or JSON array of UUIDs

**Returns:** Compact info per endpoint:
- `endpoint_id`, `method`, `path`, `summary`, `connector_name`, `category`

**Usage:**
```
# Single endpoint
tool_summary(endpoint_ids="uuid-here")

# Multiple endpoints
tool_summary(endpoint_ids='["uuid-1", "uuid-2", "uuid-3"]')
```

## Common Patterns

### Find and inspect an endpoint
```
1. search_mcp_tools(query="send email") → get ranked results
2. Pick the best match from results
3. get_schema(endpoint_ids="chosen-uuid") → see parameters
4. execute_mcp_tool(endpoint_id="chosen-uuid", arguments="{...}")
```

### Compare similar endpoints across apps
```
1. search_mcp_tools(query="create contact", limit=10)
2. Results may span multiple connectors (HubSpot, Salesforce, etc.)
3. tool_summary(endpoint_ids='["uuid-1","uuid-2"]') for quick comparison
```

## Tips

- **Use natural language** — "send an email" works better than "POST /messages"
- **Typos are OK** — fuzzy matching handles misspellings
- **Filter by app** when you know which integration you want
- **Relevance scores** help rank results — higher is better, threshold is 0.25
- After finding an endpoint, always use `get_schema` before executing
