# Agent Company (代理公司) - Hierarchical Agent Management

This skill defines a structured "Agent Company" where specialized agents work together to solve complex problems. It uses a Manager-Worker hierarchy to decompose tasks, execute them in parallel, review results, and consolidate the final output.

## Architecture

The system consists of the following roles:

1.  **Manager (CEO/PM)**:
    -   **Responsibility**: Break down high-level requests into subtasks. Assign tasks to Workers. Monitor progress. Consolidate results.
    -   **Tools**: `subagents` (to spawn workers), `message` (to report to user), `read`/`write` (for project state).
    -   **Identity**: `~/.openclaw/workspace/skills/agent-company/roles/manager/IDENTITY.md`
    -   **Instructions**: `~/.openclaw/workspace/skills/agent-company/roles/manager/INSTRUCTIONS.md`

2.  **Researcher**:
    -   **Responsibility**: Gather information from the web or internal docs. Summarize findings.
    -   **Tools**: `web_search`, `web_fetch`, `read`, `write`.
    -   **Identity**: `~/.openclaw/workspace/skills/agent-company/roles/researcher/IDENTITY.md`

3.  **Coder**:
    -   **Responsibility**: Write code, scripts, or configuration files based on specs.
    -   **Tools**: `write`, `edit`, `exec` (for testing/running), `read`.
    -   **Identity**: `~/.openclaw/workspace/skills/agent-company/roles/coder/IDENTITY.md`

4.  **Reviewer**:
    -   **Responsibility**: Review code or research for accuracy, quality, and safety. Provide feedback.
    -   **Tools**: `read`, `exec` (to verify code), `web_search` (to fact-check).
    -   **Identity**: `~/.openclaw/workspace/skills/agent-company/roles/reviewer/IDENTITY.md`

## Usage Workflow

1.  **User Request**: The user asks for a complex task (e.g., "Build a Python web scraper for X").
2.  **Activation**: The main agent (or user) activates the **Manager** skill.
    -   Run: `subagents` with `message="[Manager Task] <task_description>"`
3.  **Manager Execution**:
    -   Reads the task.
    -   Creates a project plan in `~/.openclaw/workspace/projects/<project_id>/PLAN.md`.
    -   Spawns **Workers** (Researcher/Coder) via `subagents` for specific subtasks.
    -   Workers report back (via tool output or shared file).
    -   Manager aggregates results.
    -   Manager spawns **Reviewer** if needed.
    -   Manager delivers final report to User.

## File Locations

-   **Skill Root**: `~/.openclaw/workspace/skills/agent-company`
-   **Roles**: `~/.openclaw/workspace/skills/agent-company/roles/`
-   **Templates**: `~/.openclaw/workspace/skills/agent-company/templates/`

## How to Activate

Use the `subagents` tool to start a Manager for a new project:

```bash
# Example: Start a project to research quantum computing
subagents action=steer target=new message="[Role: Manager] Please research the current state of Quantum Computing and write a summary report."
```
