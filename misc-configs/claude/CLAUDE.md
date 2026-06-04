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

## Git

- ALWAYS run all Git commands directly from the current working directory.
  Git automatically finds the repo root.
- NEVER, EVER, commit, push, or create PRs on your own unless explicitly told to.
  PRs are a human responsibility; the user wants to review, title, and submit them on their own terms.
- When asked to resolve Git conflicts, only resolve the conflicts.
  Don't stage, commit, continue the rebase/merge, build, test, or offer extra steps unless explicitly told to.

## Testing

- Structure every test using AAA comments (Arrange, Act, Assert) to separate setup, execution, and verification.
  This makes tests scannable and forces each test to have a clear single action under test.

## Writing Style

- Limit the usage of em dashes (—).
  It's a bad habit from LLM training data where em dashes are overrepresented and they make the output feel unnatural.
  Prefer commas, semicolons, colons, parentheses, or just splitting into separate sentences.
