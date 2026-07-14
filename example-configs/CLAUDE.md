# CLAUDE.md

## CRITICAL REMINDERS

- **ALWAYS** use the task runner (Taskfile) to execute any commands related to this project.

## Key Technologies

- **Task Runner**: Taskfile (Taskfile.yaml)

## Environment Variables

- When adding environment variables, prefix them with `MY_APP_` to avoid collisions with system and third-party variables.
  - `MY_APP_` will be replaced with this project's actual prefix.
  - Use `SCREAMING_SNAKE_CASE`: `MY_APP_DATABASE_URL`, not `my_app-databaseUrl`.
