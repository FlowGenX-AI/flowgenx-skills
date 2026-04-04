---
name: flowgenx-workflow
description: |
  Complete workflow guide for FlowGenX Productivity MCP — from discovering apps to automating multi-step integrations. Use this skill when the user wants to "integrate with an app", "automate a workflow", "connect and use an API", "build an integration", "orchestrate tools", or needs guidance on the full discover-search-inspect-execute pattern. This meta-skill teaches the optimal approach for any integration task.
allowed-tools:
  - mcp__flowgenx-productivity__list_apps
  - mcp__flowgenx-productivity__list_tools
  - mcp__flowgenx-productivity__search_mcp_tools
  - mcp__flowgenx-productivity__tool_summary
  - mcp__flowgenx-productivity__get_schema
  - mcp__flowgenx-productivity__execute_mcp_tool
  - mcp__flowgenx-productivity__multi_execute
  - mcp__flowgenx-productivity__workbench_execute
  - mcp__flowgenx-productivity__help
---

# FlowGenX Integration Workflow

The complete guide to discovering, searching, inspecting, and executing API endpoints across your connected apps.

## Prerequisites

FlowGenX Productivity MCP must be configured. Run: `npx flowgenx`

## The Workflow Pattern

Follow this escalation pattern — start simple, build up as needed:

```
Discover → Search → Inspect → Execute → Scale → Automate
```

| Step | Tool | When |
|------|------|------|
| 1. Discover | `list_apps` | See what integrations are available |
| 2. Browse | `list_tools` | Browse all endpoints for an app |
| 3. Search | `search_mcp_tools` | Find endpoints by natural language |
| 4. Quick look | `tool_summary` | Get compact info on endpoint IDs |
| 5. Inspect | `get_schema` | See full parameter schema |
| 6. Execute | `execute_mcp_tool` | Run a single API call |
| 7. Batch | `multi_execute` | Run multiple calls in parallel |
| 8. Automate | `workbench_execute` | Complex multi-step Python workflows |

## Step-by-Step Guide

### Step 1: Discover your apps
```
list_apps()
→ Returns list of connected apps with endpoint counts
→ Note the app_connector_id for apps you need
```

### Step 2: Find the right endpoint

**Option A — Browse all endpoints for an app:**
```
list_tools(app_name="HubSpot")
```

**Option B — Search by natural language (recommended):**
```
search_mcp_tools(query="create a new contact")
→ Returns ranked results across all your connected apps
```

### Step 3: Inspect the endpoint schema
```
get_schema(endpoint_ids="endpoint-uuid-from-step-2")
→ Returns {params, body, path} with types and descriptions
→ Identify required fields and their expected formats
```

### Step 4: Execute
```
execute_mcp_tool(
  endpoint_id="endpoint-uuid",
  arguments='{"email": "john@example.com", "name": "John"}'
)
→ Auth is automatic — OAuth/API Key/Basic Auth resolved from config
```

### Step 5: Scale with batch execution
```
multi_execute(tool_calls='[
  {"endpoint_id": "uuid-1", "arguments": {"name": "Alice"}, "call_id": "alice"},
  {"endpoint_id": "uuid-1", "arguments": {"name": "Bob"}, "call_id": "bob"},
  {"endpoint_id": "uuid-2", "arguments": {}, "call_id": "list-all"}
]')
→ Up to 50 calls, 10 concurrent
→ Returns per-call results with success/failure counts
```

### Step 6: Automate with Python
```
workbench_execute(code='''
# Chain multiple operations
contacts = call_tool("list-contacts-uuid", {"limit": 100})
active = [c for c in contacts if c.get("status") == "active"]

# Process and update
for contact in active[:10]:
    call_tool("update-contact-uuid", {
        "contact_id": contact["id"],
        "last_engaged": "2025-01-01"
    })

return {"updated": len(active[:10])}
''', timeout=90)
```

## Example Workflows

### Send a Slack message
```
1. search_mcp_tools(query="send slack message")
2. get_schema(endpoint_ids="found-uuid")
3. execute_mcp_tool(endpoint_id="found-uuid", arguments='{"channel": "#general", "text": "Hello!"}')
```

### Export CRM contacts to spreadsheet
```
1. search_mcp_tools(query="list all contacts")
2. workbench_execute(code='''
contacts = call_tool("list-uuid", {"limit": 500})
# Format as CSV
csv = "name,email,status\\n"
for c in contacts:
    csv += f"{c['name']},{c['email']},{c['status']}\\n"
return csv
''', timeout=60)
```

### Cross-app data sync
```
1. list_apps() → identify source and target apps
2. search_mcp_tools for read endpoint on source
3. search_mcp_tools for write endpoint on target
4. workbench_execute to read from source, transform, write to target
```

## Tips

- **Always inspect schema before executing** — saves time debugging wrong arguments
- **Search is smarter than browse** — use `search_mcp_tools` for natural language queries
- **Flat arguments work** — the system auto-maps to params/body/path via schema
- **Auth is automatic** — never worry about tokens or API keys
- **Use call_id** in multi_execute for easy result identification
- **Workbench** is for complex logic — simple calls should use execute_mcp_tool directly
- **Check help("workflow")** for the canonical workflow recommendation
