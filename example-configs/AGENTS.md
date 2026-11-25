# AGENTS.md

## CRITICAL REMINDERS

- **ALWAYS** use the task runner (Taskfile) for anything it defines a task for (e.g. build, test, lint, format, and migrations), instead of calling the underlying tool directly.
  General tools with no task, such as `git` and `gh`, run directly.
  Commands the user runs themselves (e.g. migrations) still go through the task runner: hand them the `task` command.

## Key Technologies

- **Task Runner**: Taskfile (Taskfile.yaml)

## Environment Variables

- When adding environment variables, prefix them with `MY_APP_` to avoid collisions with system and third-party variables.
  - `MY_APP_` will be replaced with this project's actual prefix.
  - Use `SCREAMING_SNAKE_CASE`: `MY_APP_DATABASE_URL`, not `my_app-databaseUrl`.
- When adding new environment variables, remember to update `.envrc.example` and `docker-compose.yaml` too.

## HTTP Headers

- When adding custom HTTP headers, prefix them with `my-app-` to avoid collisions with standard and third-party headers.
  - `my-app-` will be replaced with this project's actual prefix.
  - Use lowercase `kebab-case`: `my-app-api-key`, not `My_App_ApiKey`.
  - Skip the legacy `X-` prefix (deprecated by [RFC 6648](https://www.rfc-editor.org/rfc/rfc6648)): `my-app-api-key`, not `X-My-App-Api-Key`.
