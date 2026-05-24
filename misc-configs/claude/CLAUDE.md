# Ground Rules

<!--
> "A computer can never be held accountable, therefore a computer must never make a management decision."
>
> — IBM Training Manual, 1979
-->

## Attribution

- If a human committed it, it's their responsibility, not Claude's.
- Claude is a collaborative partner tool, similar to a rubber duck that can code.
- Never add Claude/Anthropic attribution (e.g. "Generated with Claude Code", "🤖", "Co-Authored-By") to any output: commits, PRs, issues, comments, or any other content.

## Code Style

- Follow [the naming cheatsheet](https://github.com/kettanaito/naming-cheatsheet).
- When adding comments to code, explain _why_ something is done, not _what_ it does.
  The code already shows the "what", a comment restating it is just noise.
  Comments should capture intent, constraints, workarounds, or non-obvious reasoning that a reader couldn't derive from the code alone.
- Avoid mutation as much as possible: produce new values rather than modifying in place.
- Extract `if` conditions into named constants instead of inlining them.
  It makes the intent more readable. E.g.:
  `hasChildren = parent.children.length > 0`
  `isExpired = Date.now() > token.expiresAt`
  `isEmpty = items.length === 0`
  `canSubmit = isValid && !isSubmitting`
  `hasPermission = user.roles.includes("admin")`
- Assign the return value of a function/method to a `retval` constant before returning it.
  This makes the value visible in a debugger without needing to step out of the function.
- Minimize nesting depth:
  - Flatten code by inverting conditions, returning early, and extracting helpers so indentation stays shallow and the main flow reads top to bottom.
  - Prefer guard clauses (early returns for invalid/edge cases) over deeply nested `if/else` blocks.
    They keep the happy path at the top indentation level.
- Keep functions short and focused on a single responsibility.
  When a function starts doing several things, split the extra responsibilities into their own well-named functions.
- Handle errors at the edges and let the happy path stay clean.
  Throw or return early on failure rather than wrapping the main logic in `try`/`catch`, and never swallow an error silently:
  At minimum log it with enough context to trace where it came from.
- Avoid single line early returns (e.g. `if (foo) return`).
  Use a block instead so breakpoints can target the return independently.
- Always add explicit return types to functions. Type inference is convenient but explicit return types catch accidental changes, serve as documentation, and speed up type-checking in larger codebases.
- Use empty lines liberally: a wall of code without spacing is hard to read.
  Separate logical blocks of code with empty lines.
  Always leave a blank line before a `return` statement.
  Leave a blank line after guard clauses to separate edge-case handling from the happy path.

### JavaScript/TypeScript

- Use JavaScript private fields (`#field`) for class internals, not the TypeScript `private` keyword.

### Svelte

- Place imports in a `<script module lang="ts">` tag, not the instance `<script>` tag. This keeps imports at the module level where they belong.
- In `$effect` cleanup returns, assign the cleanup function to a named `teardown` constant before returning it (same reasoning as the `retval` rule: debugger visibility and readability).

## Git

- ALWAYS run all Git commands directly from the current working directory. Git automatically finds the repo root.
- NEVER, EVER, commit, push, or create PRs on your own unless explicitly told to. PRs are a human responsibility; the user wants to review, title, and submit them on their own terms.

## Testing

- Structure every test using AAA comments (Arrange, Act, Assert) to separate setup, execution, and verification. This makes tests scannable and forces each test to have a clear single action under test.

## Writing Style

- Limit the usage of em dashes (—). It's a bad habit from LLM training data where em dashes are overrepresented and they make the output feel unnatural. Prefer commas, semicolons, colons, parentheses, or just splitting into separate sentences.
