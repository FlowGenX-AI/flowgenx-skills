---
name: flowgenx-execute
description: |
  Execute API endpoints via FlowGenX Productivity MCP with automatic authentication. Use this skill when the user wants to "run this endpoint", "call the API", "execute the tool", "send a request", "make an API call", "run these in parallel", "batch execute", or needs to actually invoke API operations on their connected apps. Supports single execution and parallel batch execution.
allowed-tools:
  - mcp__flowgenx-productivity__execute_mcp_tool
  - mcp__flowgenx-productivity__multi_execute
---

# FlowGenX Endpoint Execution

Execute API endpoints with automatic authentication — single calls or parallel batches.

## Prerequisites

FlowGenX Productivity MCP must be configured. Run: `npx flowgenx`

**Important:** Always use `get_schema` to inspect an endpoint before executing it.

## Tools Available

### execute_mcp_tool

Execute a single API endpoint using the user's connected app credentials.

**Parameters:**
- `endpoint_id` (string, required): Endpoint UUID from list_tools, search_mcp_tools, or get_schema
- `arguments` (string, optional): JSON string — flat keys or structured `{params, body, path}`. Default: `"{}"`

**Returns:** HTTP response with status, headers, and body.

**Usage:**
```
# Simple GET (no arguments needed)
execute_mcp_tool(endpoint_id="uuid-here")

# POST with flat arguments (auto-mapped to body)
execute_mcp_tool(
  endpoint_id="uuid-here",
  arguments='{"email": "john@example.com", "name": "John Doe"}'
)

# Structured arguments (explicit mapping)
execute_mcp_tool(
  endpoint_id="uuid-here",
  arguments='{"path": {"contact_id": "123"}, "body": {"name": "Updated"}, "params": {"include": "details"}}'
)

# GET with query parameters
execute_mcp_tool(
  endpoint_id="uuid-here",
  arguments='{"limit": 10, "status": "active"}'
)
```

### multi_execute

Execute multiple endpoint calls in parallel (up to 50, 10 concurrent).

**Parameters:**
- `tool_calls` (string, required): JSON array of calls. Each: `{"endpoint_id": "...", "arguments": {...}, "call_id": "optional-label"}`

**Returns:** Per-call results with:
- `call_id` — Your optional label
- `endpoint_id` — Which endpoint was called
- `success` — Boolean
- `result` — Response data
- `error` — Error message if failed
- `execution_time` — Seconds taken

Plus summary: `total`, `succeeded`, `failed`, `total_execution_time`

**Usage:**
```
# Batch of 3 calls
multi_execute(tool_calls='[
  {"endpoint_id": "uuid-1", "arguments": {"query": "active"}, "call_id": "get-active"},
  {"endpoint_id": "uuid-2", "arguments": {"email": "a@b.com"}, "call_id": "create-contact"},
  {"endpoint_id": "uuid-3", "arguments": {}, "call_id": "list-all"}
]')
```

## Argument Formats

### Flat keys (recommended for simple calls)
Pass arguments as a flat JSON object. The system auto-maps keys to the correct location (query params, body, or path) based on the endpoint schema.

```json
{"email": "john@example.com", "limit": 10}
```

### Structured (for explicit control)
Use `{params, body, path}` when you need precise control:

```json
{
  "path": {"contact_id": "123"},
  "params": {"include_details": true},
  "body": {"name": "John", "email": "john@example.com"}
}
```

## Common Patterns

### Search → Schema → Execute
```
1. search_mcp_tools(query="create contact in HubSpot")
2. get_schema(endpoint_ids="found-uuid")
3. execute_mcp_tool(endpoint_id="found-uuid", arguments='{"email":"...","name":"..."}')
```

### Parallel operations across apps
```
1. Search for similar endpoints across apps
2. multi_execute with calls to each app
3. Compare results
```

## Tips

- **Auth is automatic** — OAuth, API Key, Basic Auth all resolved from your connected app config
- **Flat arguments** work for most cases — the system maps them via schema
- **Max 50 calls** per multi_execute batch, 10 run concurrently
- **Use call_id** in multi_execute to label results for easy identification
- Check the HTTP status in the response — 2xx means success
- If execution fails, check `get_schema` to verify your arguments match the schema
