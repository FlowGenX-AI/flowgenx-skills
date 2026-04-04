---
name: flowgenx-schema
description: |
  Inspect API endpoint schemas via FlowGenX Productivity MCP — see parameters, request body, and path variables before executing. Use this skill when the user asks "what parameters does this endpoint need", "show me the schema", "what arguments does it take", "endpoint structure", "API specification", or needs to understand an endpoint's interface before calling it.
allowed-tools:
  - mcp__flowgenx-productivity__get_schema
---

# FlowGenX Schema Inspector

Inspect endpoint schemas to understand required parameters before execution.

## Prerequisites

FlowGenX Productivity MCP must be configured. Run: `bunx @flowgenx/mcp-setup`

## Tools Available

### get_schema

Get structured `{params, body, path}` schema for one or more endpoints.

**Parameters:**
- `endpoint_ids` (string): Single endpoint UUID or JSON array of UUIDs

**Returns:** Per endpoint:
- `endpoint_id` — UUID
- `method` — HTTP method (GET, POST, PUT, DELETE)
- `path` — API path (e.g. `/contacts/{contact_id}`)
- `summary` — What the endpoint does
- `connector_name` — Which app
- `schema` — Structured schema object:
  - `params` — Query parameters (key → type, description, default, enum)
  - `body` — Request body properties (key → type, description, required)
  - `path` — Path variables (key → type, description, required: true)

**Usage:**
```
# Single endpoint
get_schema(endpoint_ids="uuid-here")

# Multiple endpoints at once
get_schema(endpoint_ids='["uuid-1", "uuid-2"]')
```

## Reading the Schema

### Path Variables
Variables in the URL path (e.g. `/contacts/{contact_id}`):
```json
{
  "path": {
    "contact_id": {
      "type": "string",
      "description": "The contact ID",
      "required": true
    }
  }
}
```

### Query Parameters
URL query params (e.g. `?limit=10&offset=0`):
```json
{
  "params": {
    "limit": { "type": "integer", "description": "Max results", "default": 10 },
    "offset": { "type": "integer", "description": "Starting offset" }
  }
}
```

### Request Body
POST/PUT body properties:
```json
{
  "body": {
    "email": { "type": "string", "description": "Contact email", "required": true },
    "name": { "type": "string", "description": "Contact name" }
  }
}
```

## Common Patterns

### Schema → Execute workflow
```
1. get_schema(endpoint_ids="uuid") → read params/body/path
2. Construct arguments based on schema
3. execute_mcp_tool(endpoint_id="uuid", arguments="{...}")
```

### Inspect before batch execution
```
1. get_schema(endpoint_ids='["uuid-a","uuid-b"]')
2. Understand both schemas
3. multi_execute with properly structured arguments
```

## Tips

- **Always inspect schema before executing** — ensures correct argument structure
- You can pass arguments as **flat keys** (auto-mapped) or structured `{params, body, path}`
- `required: true` fields must be provided
- `enum` fields show allowed values
- `default` values are used when you omit the parameter
