Never add Claude/Anthropic attribution (e.g. "Generated with Claude Code", "🤖", "Co-Authored-By") to any output: commits, PRs, issues, comments, or any other content.
AI is a tool, not a collaborator. If a human committed it, it's their responsibility. Besides, it clutters the history.

Limit the usage of em dashes (—). It's a bad habit from LLM training data where em dashes are overrepresented and they make the output feel unnatural. Prefer commas, semicolons, colons, parentheses, or just splitting into separate sentences.

NEVER, EVER, commit, push, or create PRs on your own unless explicitly told to. PRs are a human responsibility; the user wants to review, title, and submit them on their own terms.

When adding comments to code, explain *why* something is done, not *what* it does. The code already shows the "what"; a comment restating it is just noise. Comments should capture intent, constraints, workarounds, or non-obvious reasoning that a reader couldn't derive from the code alone.
