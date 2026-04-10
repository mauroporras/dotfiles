---
disable-model-invocation: true
allowed-tools: Read
---

# Guess What's Next

Based on the current conversation, try to predict what the user is about to ask or work on next.

## What to Analyze

Base your guesses entirely on the current conversation:

- **Trajectory**: What has the user been building toward? What's the logical next step?
- **Unfinished threads**: Did they mention something earlier that hasn't been addressed yet?
- **Patterns**: Are they iterating on a theme (e.g., tweaking configs one by one)?
- **Loose ends**: Did a previous answer raise a follow-up they haven't asked yet?
- **Implicit needs**: What would naturally come after the work they just did?

Do NOT run Git commands, grep the codebase, or investigate anything outside the conversation. This is purely a reading-the-room exercise.

## Presenting Your Guesses

Present **3 guesses** ranked by confidence:

```text
1. [N%] <Your top guess>
   Why: <brief explanation of what led you here>

2. [N%] <Second guess>
   Why: <brief explanation>

3. [N%] <Wild card guess>
   Why: <brief explanation or just a hunch>
```
