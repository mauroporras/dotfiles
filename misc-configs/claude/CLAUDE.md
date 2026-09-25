# Ground Rules

## Accountability

> "A computer can never be held accountable, therefore a computer must never make a management decision."
> — IBM Training Manual, 1979

- If a human committed it, it's their responsibility instead of the agent's.
- The agent is a collaborative partner tool, similar to a rubber duck that can code.

## Tooling

- Default to LSP for finding symbol references, definitions, implementations, or call hierarchies.
  E.g., `findReferences`, `goToDefinition`
  LSP resolves the actual symbol, so it matches exactly the right references and follows aliased imports.
  Reserve text search for file types that have no LSP server.
  If an LSP query from a definition returns only itself, the server is likely cold/unindexed: re-query from a known call site to warm it before trusting the result.

## Verification

- **ALWAYS VERIFY, ALWAYS ASK** - when you can verify a claim, verify it before asserting. When you genuinely cannot resolve it yourself, ask the user and let their answer be the one you report.

## Code Style

### Naming

- Follow [the naming cheatsheet](https://github.com/kettanaito/naming-cheatsheet).
- Extract `if` conditions into named constants.
  It makes the intent more readable. E.g.:
  `hasChildren = parent.children.length > 0`
  `isExpired = Date.now() > token.expiresAt`
  `isEmpty = items.length === 0`
  `canSubmit = isValid && !isSubmitting`
  `hasPermission = user.roles.includes("admin")`

### Comments

- When adding comments to code explain the _why_ instead of the _what_.
  The code already shows the _what_, so a comment earns its place by adding what the code alone leaves out.
  Comments should capture intent, constraints, workarounds, or non-obvious reasoning that a reader couldn't derive from the code alone.

### Functions

- Keep functions short and focused on a single responsibility.
  When a function starts doing several things, split the extra responsibilities into their own well-named functions.
- Always add explicit return types to functions.
  Type inference is convenient but explicit return types catch accidental changes, serve as documentation, and speed up type-checking in larger codebases.
- Assign the return value of a function/method to a `retval` constant before returning it.
  This makes the value visible in a debugger while execution is still inside the function.
- Avoid mutation as much as possible: produce new values rather than modifying in place.

### Control Flow

- Keep nesting depth shallow:
  - Flatten code by inverting conditions, returning early, and extracting helpers so indentation stays shallow and the main flow reads top to bottom.
  - Keep the happy path at the top indentation level.
    Prefer guard clauses (early returns) for invalid/edge cases over deeply nested `if/else` blocks.
- Avoid single line early returns.
  Use a block instead so breakpoints can target the return independently. E.g.:

  ```ts
  // DON'T:
  // Breakpoint lands on the whole statement.
  if (isEmpty) return;

  // DO:
  // Breakpoint lands on the return alone:.
  if (isEmpty) {
    return;
  }
  ```

### Logging

- When adding console logs, prefix the message with `---------- WITNESSME`.
  This makes temporary debug logs easy to spot and grep out before committing.

### Error Handling

- Handle errors at the edges and let the happy path stay clean.
  Throw or return early on failure, keeping the main logic outside `try`/`catch`, and give every error a voice:
  At minimum log it with enough context to trace where it came from.

### Formatting

- Use empty lines liberally: spacing is what makes a block of code scannable.
  - Separate logical blocks of code with empty lines.
  - Always leave a blank line before `return` statements.
  - Leave a blank line after guard clauses to separate edge-case handling from the happy path.

### JavaScript/TypeScript

- Use JavaScript private fields (`#field`) for class internals.
  They stay private at runtime, whereas TypeScript's `private` keyword disappears at compile time.
- Use TypeScript path aliases in imports, E.g.:
  `@workspace/*`, which stands in for `../../../workspace/*`

### Svelte

- Place imports in the `<script module lang="ts">` tag instead of the instance `<script>` tag.
  This keeps imports at the module level where they belong.
- In `$effect` cleanup returns, assign the cleanup function to a named `teardown` constant before returning it (same reasoning as the `retval` rule: debugger visibility and readability).

## Clean Architecture

### Use Cases

- A use case is a single unit of application logic exposing one public method: `execute`.
- `execute` takes exactly one parameter named `input`, typed as the use case's
  own input contract (`<UseCaseName>Input`, an `interface`).
- Keep use cases to pure application logic.
  Transport/persistence concerns (HTTP, SQL, and framework types) belong to the adapters at the edges, which translate them into the input contract.
- One responsibility per use case:
  If `execute` starts branching into several distinct operations, split it into
  separate use cases rather than overloading the input.

#### Inputs and Outputs

- Name a use case's input type after the use case plus `Input`, declared as
  an `interface`, and name the `execute` parameter `input`.
  E.g. `UpdatePriceListUseCase` takes `input: UpdatePriceListUseCaseInput`.
- Name a use case's output type after the use case plus `Output`, declared as
  an `interface`, and use it as `execute`'s explicit return type.
  E.g. `UpdatePriceListUseCase.execute` returns `UpdatePriceListUseCaseOutput`.
- Reserve the `*Dto` name for transport/persistence shapes: a use case's
  contracts are its own, so they keep the `*Input` / `*Output` suffixes.
- Adapters at the edges translate the input contract from, and the output
  contract into, HTTP responses, rows, etc.
- Input and output must be simple data structures instead of entities.
  An output type that is an Entity (E.g., an `Album` class) is a smell.
  Crossing a boundary with an Entity couples the caller to domain internals.
  Map the Entity to the input/output contract instead.
  <!--
  As Uncle Bob puts it:
  > "we don't want to cheat and pass Entity objects between boundaries"
  > — Clean Architecture, p. 207
  -->

## API Design

- **REST API path conventions**: Use flat paths for mutations, hierarchical paths for queries.
  - Mutations (create/update/delete) use flat resource paths:
    - `POST /cad-files`
    - `PUT /cad-files/:id`
    - `DELETE /cad-files/:id`
  - Queries use hierarchical paths scoped to parent resources:
    - `GET /workspaces/:workspaceId/cad-files?limit=100`
- Reserve 404 for a route that doesn't exist; a route that exists and legitimately
  found nothing answers with success.
  "This endpoint is not a thing" and "this endpoint is a thing and its answer is empty" are
  different failures, and collapsing them into one status makes them indistinguishable to the
  client: a typo'd path and a valid lookup with no match look identical, so the client reads a
  bug and an expected empty state as the same thing.
  So:
  - Collection queries return `200` with an empty array (`[]`).
    An empty collection is a successful answer, and the client can render it straight from the
    body.
  - Single-resource queries return `200` with `null` (or `204 No Content` when the response has no
    body at all) when the resource is absent but the caller had every right to ask.
  - Reserve `404` for the cases where the path itself is meaningless: an unknown route, or an
    identifier in the path that doesn't resolve to anything the caller can act on
    (e.g. `GET /workspaces/:workspaceId/cad-files` where `:workspaceId` doesn't exist).
  - Use `403` when the resource exists but the caller may not see it.
    Where hiding its existence is a deliberate security requirement, `404` is the right answer:
    say so in a comment so the next reader keeps it that way.

## Git

- Pushing and creating PRs each MUST wait for an explicit instruction.
  PRs are a human responsibility.
  The user wants to review, title, and submit them on their own terms.
- **ANNOUNCE EVERY WORKTREE LOUDLY** - whenever a Git worktree gets created (by you, a subagent, or a tool), say so up front in bold, with its path and branch.
  A worktree moves the work into a second working directory, somewhere the user isn't looking.
  Repeat the announcement in the final summary, so the user doesn't go looking for changes in the original checkout.

## Database (DB, SQL)

### Schema

- Name tables with an uninflected noun (singular) in `snake_case`, prefix-free.
  E.g. `user`, `cad_file`, `price_list` (rather than `users`, `Users`, `tbl_user`, `cadFiles`).
  A table name describes what one row _is_, so the singular form reads correctly everywhere the
  name appears: in a join, in a foreign key (`cad_file.id` → `cad_file_id`), and in the entity it
  maps to. It also sidesteps irregular plurals (`person`/`people`, `status`/`statuses`), which
  otherwise force every reader and every code generator to guess which form a given table used.
- Prefer nullable timestamps over booleans for state that has a "when it happened" answer.
  A `boolean` flag records only that something is true; a timestamp records both that it
  is true (the column is non-`null`) and when it became true, which is almost always
  information you end up wanting later for auditing, debugging, or analytics.
  Name the column after the event in the past tense plus `_at` (that suffix already signals a
  timestamp, whereas an `is_` prefix signals a boolean), and treat `null` as
  "not yet". This keeps the column in the same `<event>_at` family as `created_at` / `updated_at` /
  `deleted_at`. E.g.:
  - `is_workspace_base_price_set` → `workspace_base_price_set_at`
  - `is_published` → `published_at`
  - `is_email_verified` → `email_verified_at`
- Prefer enforcing invariants in use cases over denormalizing the schema to make them checkable.
  Denormalization copies a fact into a second place (a `product_count` on the parent, a
  `workspace_id` repeated on a grandchild, a flag mirroring a row's existence elsewhere), and
  every copy is a fact that can drift: each write path now has to keep both places in sync,
  and the first one that forgets turns the invariant the copy was meant to guard into a lie.
  A use case sits on the single write path where all the data is already at hand, so it can
  read the source of truth, validate the rule, and reject the input before anything is
  persisted; nothing needs to be kept in sync afterwards.
  Reserve denormalization for a measured read-path problem (a query that is provably too slow
  on normalized data), and when you do add it, name the source of truth in a comment and
  update the copy from one place only. E.g.:
  - "A workspace can have at most one default price list": check it in
    `SetDefaultPriceListUseCase`, rather than adding a `default_price_list_id` column to
    `workspace` that has to be kept in step with `price_list.is_default`.
  - "A CAD file must belong to the same workspace as its project": look the project up in
    `CreateCadFileUseCase` and reject a mismatch, rather than copying `workspace_id` onto
    `cad_file` so a `CHECK` or trigger can compare them.
  - "A person belongs to at most one team per workspace": check it in
    `CreateWorkspaceTeamMembershipUseCase` (under a lock on workspace + email, so two
    concurrent adds cannot both pass), rather than copying `workspace_id` onto
    `workspace_team_membership` so a `UNIQUE (workspace_id, email)` index can hold it.
    The copy drifted the moment someone edited the row by hand: the membership read as
    belonging to one workspace while its team sat in another.

### Migrations

- **MIGRATIONS ARE THE USER'S TO RUN** - hand them the command and let them execute it.

### Upserts

- Treat the upsert as the last line of defense.
  The query runs after the caller, the use case, and any conflict-detection logic have all had their say, and it is the final gate before bytes hit the table.
  By the time control reaches it, the caller's intent (insert vs update) and the shape of the incoming row are both unknown, so the column list must be conservative on its own: it should be safe even when every layer above it is wrong or absent.
  Justify the `SET` list on its own terms, independently of "this upsert is only ever called from create": that assumption is exactly what erodes over time and turns the dead `DO UPDATE` branch into a silent data-corruption bug.
- In an upsert (`INSERT ... ON CONFLICT ... DO UPDATE SET`), spell out the updatable columns one by one.
  A whole-row spread (e.g. `${sql(row)}`) hands the `DO UPDATE` branch columns it has no business touching.
  The branch assigns exactly the columns the operation legitimately owns, and leaves these alone:
  - **Identity columns** (primary key, public id, immutable foreign keys): re-assigning them is at best redundant and at worst rewrites the row's identity.
  - **`created_at`**: an update preserves the original creation timestamp.
  - **Lifecycle columns** (`deleted_at`, `archived_at`): a create-shaped upsert carries `null` for these, so a full-row spread silently resurrects a soft-deleted row or un-archives an archived one.
    These transitions belong to their own dedicated operations (`softDelete`, `archive`).

## Testing

- Structure every test using AAA comments (Arrange, Act, Assert) to separate setup, execution, and verification.
  This makes tests scannable and forces each test to have a clear single action under test.

## Writing Style

- Punctuate with commas, semicolons, colons, parentheses, or a split into separate sentences, and keep em dashes (—) rare.
  Em dashes are overrepresented in LLM training data, so leaning on them makes the output feel unnatural.
