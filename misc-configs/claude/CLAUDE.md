# Ground Rules

> "A computer can never be held accountable, therefore a computer must never make a management decision."
>
> — IBM Training Manual, 1979

## Attribution

- If a human committed it, it's their responsibility, not Claude's.
- Claude is a collaborative partner tool, similar to a rubber duck that can code.
- Never add Claude/Anthropic attribution (e.g. "Generated with Claude Code", "🤖", "Co-Authored-By") to any output: commits, PRs, issues, comments, or any other content.

## Code Style

- Follow [the naming cheatsheet](https://github.com/kettanaito/naming-cheatsheet).
- When adding comments to code, explain _why_ something is done, not _what_ it does. The code already shows the "what"; a comment restating it is just noise. Comments should capture intent, constraints, workarounds, or non-obvious reasoning that a reader couldn't derive from the code alone.
- Avoid mutation as much as possible: produce new values rather than modifying in place.
- Extract conditions and thresholds into named constants so the intent is readable (e.g. `hasChildren = parent.children.length > 0`).
- Assign the return value to a `retval` constant before returning it. This makes the value visible in a debugger without needing to step out of the function.
- Prefer guard clauses (early returns for invalid/edge cases) over deeply nested `if/else` blocks. They keep the happy path at the top indentation level.
- Avoid single line early returns (e.g. `if (foo) return`). Use a block instead so breakpoints can target the return independently.
- Always add explicit return types to functions. Type inference is convenient but explicit return types catch accidental changes, serve as documentation, and speed up type-checking in larger codebases.

### JavaScript/TypeScript

- Use JavaScript private fields (`#field`) for class internals, not the TypeScript `private` keyword.

## Git

- ALWAYS run all Git commands directly from the current working directory. Git automatically finds the repo root.
- NEVER, EVER, commit, push, or create PRs on your own unless explicitly told to. PRs are a human responsibility; the user wants to review, title, and submit them on their own terms.

## Testing

- Structure every test using AAA comments (Arrange, Act, Assert) to separate setup, execution, and verification. This makes tests scannable and forces each test to have a clear single action under test.

## Writing Style

- Limit the usage of em dashes (—). It's a bad habit from LLM training data where em dashes are overrepresented and they make the output feel unnatural. Prefer commas, semicolons, colons, parentheses, or just splitting into separate sentences.
