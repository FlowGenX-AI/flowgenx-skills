---
name: flowgenx-apps
description: |
  Discover connected apps and their API endpoints using FlowGenX Productivity MCP. Use this skill when the user asks "what apps are connected", "show my integrations", "list my apps", "what endpoints does X have", "show tools for Slack", "list available APIs", or needs to explore what integrations are available before searching or executing.
allowed-tools:
  - mcp__flowgenx-productivity__list_apps
  - mcp__flowgenx-productivity__list_tools
---

# FlowGenX App Discovery

Discover your connected apps and browse their API endpoints.

## Prerequisites

FlowGenX Productivity MCP must be configured. Run: `npx flowgenx`

## Tools Available

### list_apps

List all connected apps with endpoint counts and connection info.

**Parameters:** None (uses X-User-ID from MCP config headers)

**Returns:** JSON array of connected apps with:
- `connected_app_id` — Unique connection ID
- `app_connector_id` — Connector UUID (use this for list_tools and search)
- `name` — Display name
- `connector_name` — Connector type (e.g. "HubSpot", "Slack", "Gmail")
- `category` — Category (e.g. "CRM", "Communication", "Email")
- `endpoint_count` — Number of available API endpoints
- `description` — What the connector does

**Usage:**
```
# See all connected apps
list_apps()
```

### list_tools

List all endpoints (tools) for a specific connected app.

**Parameters:**
- `app_connector_id` (string, optional): Connector UUID from list_apps
- `app_name` (string, optional): App or connector name — partial match supported

Provide either `app_connector_id` or `app_name`.

**Returns:** JSON with endpoint list, each containing:
- `endpoint_id` — UUID to use with get_schema/execute_mcp_tool
- `method` — HTTP method (GET, POST, PUT, DELETE)
- `path` — API path
- `summary` — What the endpoint does
- `category` — Endpoint category

**Usage:**
```
# List by connector ID (from list_apps result)
list_tools(app_connector_id="uuid-from-list-apps")

# List by name (partial match)
list_tools(app_name="HubSpot")
list_tools(app_name="Slack")
```

## Common Patterns

### Explore available integrations
```
1. Call list_apps() to see all connected apps
2. Note the app_connector_id for apps you want to explore
3. Call list_tools(app_connector_id="...") to see endpoints
4. Use endpoint_ids with get_schema() or execute_mcp_tool()
```

### Find a specific app's capabilities
```
1. Call list_tools(app_name="Gmail") — partial match works
2. Browse the returned endpoints
3. Pick the one you need and get its schema
```

## Tips

- Always start with `list_apps()` to see what's available
- The `app_connector_id` from list_apps is the key for drilling deeper
- `app_name` supports partial matching — "Hub" will match "HubSpot"
- Endpoint counts help you gauge how many operations each app supports
- For finding specific endpoints, use `search_mcp_tools` instead of browsing
