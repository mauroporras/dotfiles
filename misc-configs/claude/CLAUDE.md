# Ground Rules

## Attribution

<!--
> "A computer can never be held accountable, therefore a computer must never make a management decision."
>
> — IBM Training Manual, 1979
-->

- If a human committed it, it's their responsibility, not Claude's.
- Claude is a collaborative partner tool, similar to a rubber duck that can code.
- Never add Claude/Anthropic attribution (e.g. "Generated with Claude Code", "🤖", "Co-Authored-By") to any output: commits, PRs, issues, comments, or any other content.

## Tooling

- For finding symbol references, definitions, implementations, or call hierarchies, default to LSP (e.g. `findReferences`, `goToDefinition`) instead of text/grep search.
  LSP resolves the actual symbol, so it won't conflate unrelated text matches or miss aliased imports.
  Fall back to text search only when no LSP server is available for the file type.
  If an LSP query from a definition returns only itself, the server is likely cold/unindexed: re-query from a known call site to warm it before trusting the result.

## Verification

- **NEVER ASSUME, ALWAYS ASK** - when you can verify a claim, verify it before asserting. When you genuinely cannot resolve it yourself, ask the user rather than emitting a speculation.

## Code Style

### Naming

- Follow [the naming cheatsheet](https://github.com/kettanaito/naming-cheatsheet).
- Extract `if` conditions into named constants instead of inlining them.
  It makes the intent more readable. E.g.:
  `hasChildren = parent.children.length > 0`
  `isExpired = Date.now() > token.expiresAt`
  `isEmpty = items.length === 0`
  `canSubmit = isValid && !isSubmitting`
  `hasPermission = user.roles.includes("admin")`

### Comments

- When adding comments to code, explain _why_ something is done, not _what_ it does.
  The code already shows the "what", a comment restating it is just noise.
  Comments should capture intent, constraints, workarounds, or non-obvious reasoning that a reader couldn't derive from the code alone.

### Functions

- Keep functions short and focused on a single responsibility.
  When a function starts doing several things, split the extra responsibilities into their own well-named functions.
- Always add explicit return types to functions.
  Type inference is convenient but explicit return types catch accidental changes, serve as documentation, and speed up type-checking in larger codebases.
- Assign the return value of a function/method to a `retval` constant before returning it.
  This makes the value visible in a debugger without needing to step out of the function.
- Avoid mutation as much as possible: produce new values rather than modifying in place.

### Control Flow

- Minimize nesting depth:
  - Flatten code by inverting conditions, returning early, and extracting helpers so indentation stays shallow and the main flow reads top to bottom.
  - Keep the happy path at the top indentation level.
    Prefer guard clauses (early returns for invalid/edge cases) over deeply nested `if/else` blocks.
- Avoid single line early returns.
  Use a block instead so breakpoints can target the return independently. E.g.:

  ```ts
  // DON'T:
  if (isEmpty) return;

  // DO:
  if (isEmpty) {
    return;
  }
  ```

### Logging

- When adding console logs, prefix the message with `---------- WITNESSME`.
  This makes temporary debug logs easy to spot and grep out before committing.

### Error Handling

- Handle errors at the edges and let the happy path stay clean.
  Throw or return early on failure rather than wrapping the main logic in `try`/`catch`, and never swallow an error silently:
  At minimum log it with enough context to trace where it came from.

### Formatting

- Use empty lines liberally: a wall of code without spacing is hard to read.
  - Separate logical blocks of code with empty lines.
  - Always leave a blank line before `return` statements.
  - Leave a blank line after guard clauses to separate edge-case handling from the happy path.

### JavaScript/TypeScript

- Use JavaScript private fields (`#field`) for class internals, not the TypeScript `private` keyword.
- **ALWAYS USE TYPESCRIPT PATH ALIASES** instead of relative imports (e.g., use `@workspace/*` instead of `../../../workspace/*`)

### Svelte

- Place imports in a `<script module lang="ts">` tag, not the instance `<script>` tag.
  This keeps imports at the module level where they belong.
- In `$effect` cleanup returns, assign the cleanup function to a named `teardown` constant before returning it (same reasoning as the `retval` rule: debugger visibility and readability).

## API Design

- **REST API path conventions**: Use flat paths for mutations, hierarchical paths for queries.
  - Mutations (create/update/delete) use flat resource paths:
    - `POST /cad-files`
    - `PUT /cad-files/:id`
    - `DELETE /cad-files/:id`
  - Queries use hierarchical paths scoped to parent resources:
    - `GET /workspaces/:workspaceId/cad-files?limit=100`

## Git

- NEVER, EVER, commit, push, or create PRs on your own unless explicitly told to.
  PRs are a human responsibility; the user wants to review, title, and submit them on their own terms.
- When asked to resolve Git conflicts, only resolve the conflicts.
  Don't stage, commit, continue the rebase/merge, build, test, or offer extra steps unless explicitly told to.

## Database (DB, SQL)

### Migrations

- **NEVER RUN DB MIGRATIONS ON YOUR OWN** - migrations must be run by the user.

### Upserts

- Treat the upsert as the last line of defense, not the first.
  The query runs after the caller, the use case, and any conflict-detection logic have all had their say, and it is the final gate before bytes hit the table.
  By the time control reaches it, you can no longer assume the caller's intent (insert vs update) or that the incoming row is well-formed, so the column list must be conservative on its own: it should be safe even when every layer above it is wrong or absent.
  Don't rely on "this upsert is only ever called from create" to justify a permissive `SET`; that assumption is exactly what erodes over time and turns the dead `DO UPDATE` branch into a silent data-corruption bug.
- In an upsert (`INSERT ... ON CONFLICT ... DO UPDATE SET`), list the updatable columns explicitly instead of re-spreading the whole row (e.g. `${sql(row)}`).
  The `DO UPDATE` branch must only assign the columns the operation legitimately owns, and leave these alone:
  - **Identity columns** (primary key, public id, immutable foreign keys): re-assigning them is at best redundant and at worst rewrites the row's identity.
  - **`created_at`**: an update should preserve the original creation timestamp, not overwrite it with the incoming value.
  - **Lifecycle columns** (`deleted_at`, `archived_at`): a create-shaped upsert carries `null` for these, so spreading the full row would silently resurrect a soft-deleted row or un-archive an archived one. These transitions belong to their own dedicated operations (`softDelete`, `archive`), never as a side effect of an upsert.

## Testing

- Structure every test using AAA comments (Arrange, Act, Assert) to separate setup, execution, and verification.
  This makes tests scannable and forces each test to have a clear single action under test.

## Writing Style

- Limit the usage of em dashes (—).
  It's a bad habit from LLM training data where em dashes are overrepresented and they make the output feel unnatural.
  Prefer commas, semicolons, colons, parentheses, or just splitting into separate sentences.
