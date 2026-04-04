---
name: flowgenx-workbench
description: |
  Execute Python code in a sandboxed environment with built-in tool helpers via FlowGenX Productivity MCP. Use this skill when the user wants to "run Python code", "use the sandbox", "workbench", "execute a script", "automate a multi-step workflow", "chain multiple API calls in code", or needs to combine multiple tool calls with custom logic in a programmable environment.
allowed-tools:
  - mcp__flowgenx-productivity__workbench_execute
---

# FlowGenX Workbench

Execute Python code in a sandboxed environment with built-in helpers for calling API endpoints.

## Prerequisites

FlowGenX Productivity MCP must be configured. Run: `bunx @flowgenx/mcp-setup`

## Tools Available

### workbench_execute

Execute Python code in a sandboxed environment with tool helpers.

**Parameters:**
- `code` (string, required): Python code to execute. Helper functions are available.
- `timeout` (int, optional): Execution timeout in seconds, 5-120 (default: 30)
- `env_variables` (string, optional): JSON object of environment variables

**Built-in helper functions:**
- `call_tool(endpoint_id, arguments)` — Execute an API endpoint
- `search_tools(query)` — Search for endpoints
- `list_tools(app_connector_id)` — List endpoints for an app

**Returns:** Execution result including stdout, return value, and any errors.

**Usage:**
```
# Simple tool call
workbench_execute(code='''
result = call_tool("endpoint-uuid", {"query": "active contacts"})
return result
''')

# Multi-step workflow
workbench_execute(code='''
# 1. Search for the right endpoint
endpoints = search_tools("list contacts")
endpoint_id = endpoints[0]["endpoint_id"]

# 2. Call it
contacts = call_tool(endpoint_id, {"limit": 100})

# 3. Process results
active = [c for c in contacts if c.get("status") == "active"]
return {"total": len(contacts), "active": len(active), "data": active[:10]}
''', timeout=60)

# With environment variables
workbench_execute(
  code='''
import os
api_key = os.environ["CUSTOM_KEY"]
result = call_tool("uuid", {"key": api_key})
return result
''',
  env_variables='{"CUSTOM_KEY": "secret-value"}'
)
```

## Helper Functions Reference

### call_tool(endpoint_id, arguments)
Execute an API endpoint. Same as `execute_mcp_tool` but callable from Python.
- `endpoint_id` (str): Endpoint UUID
- `arguments` (dict): Arguments as flat keys or `{params, body, path}`
- Returns: Response data (dict)

### search_tools(query)
Search for endpoints by natural language query.
- `query` (str): Search query
- Returns: List of matching endpoints

### list_tools(app_connector_id)
List all endpoints for an app.
- `app_connector_id` (str): Connector UUID
- Returns: List of endpoints

## Common Patterns

### Chain multiple API calls
```python
# Get contacts from CRM, then enrich with email data
contacts = call_tool("crm-list-uuid", {"limit": 50})
enriched = []
for contact in contacts[:10]:
    email_data = call_tool("email-lookup-uuid", {"email": contact["email"]})
    enriched.append({**contact, "email_info": email_data})
return enriched
```

### Aggregate data from multiple apps
```python
# Pull data from multiple sources
slack_channels = call_tool("slack-channels-uuid", {})
github_repos = call_tool("github-repos-uuid", {})
return {
    "slack_channels": len(slack_channels),
    "github_repos": len(github_repos),
}
```

### Search and execute dynamically
```python
# Find and call an endpoint dynamically
results = search_tools("create task")
if results:
    best = results[0]
    task = call_tool(best["endpoint_id"], {
        "title": "Follow up with client",
        "due_date": "2025-01-15"
    })
    return task
return {"error": "No matching endpoint found"}
```

## Tips

- **Use `return`** to send values back — print() output is also captured
- **Timeout** defaults to 30s — increase for complex workflows (max 120s)
- **Env variables** let you pass secrets without hardcoding
- The sandbox has network access via the helper functions but not direct HTTP
- For simple single API calls, use `execute_mcp_tool` directly instead
- Helper functions handle authentication automatically
