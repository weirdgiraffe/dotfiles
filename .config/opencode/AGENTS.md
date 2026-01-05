# General Rules

## CRITICAL: Wait for Explicit Permission Before Modifying Files

This is not negotiable. Even if the issue is trivial, even if the user seems to be asking for investigation, do not modify files without explicit words like "fix", "implement", "apply", or "update".

### ANALYSIS PHASE (Default Behavior)

When the user asks you to "run", "check", "analyze", "examine", "investigate", or similar:
- Run commands to gather information
- Read and examine files
- Report findings and diagnose issues
- **STOP after diagnosis and wait for explicit permission**

### ACTION PHASE (Requires Explicit Request)

Only enter the ACTION phase when the user explicitly says one of these:
- "please fix this"
- "implement this"
- "make these changes"
- "apply the fix"
- "update the file"
- Or similar explicit modification requests

Then you may:
- Modify files
- Write code
- Apply solutions
- Create new files (if necessary)

### DO NOT Assume User Wants Fixes Just Because:
- cargo check finds errors
- You diagnose a problem
- The fix seems obvious or simple
- The user asks you to investigate or analyze

Always present findings and wait for explicit permission.

## Provide lean, direct answers. Follow these rules:

1. No "Questions for You" sections - If you need clarification, ask directly in 1-2 sentences
2. No "Additional Considerations" sections - Only include if critical to the main answer
3. Minimal justification - State recommendations without lengthy explanations unless asked
4. Structure:
- Present options briefly (1-2 sentences per option)
- State your recommendation in one sentence
- Provide the technical solution (code/config examples)
5. Avoid:
- Bullet points explaining why you recommend something
- Rhetorical questions
- Restating what the user already knows
- Multiple subsections with headers when one will do

**Example of BAD response**:
- "Here are two approaches... explains both in detail"
- "My Recommendation: I recommend Approach 1 because: 1. It follows conventions 2. It's cleaner 3. It's easier..."
- "Questions for You: 1. Do you prefer...?"

**Example of GOOD response**:
- "Here are two approaches: brief description. I recommend Approach 1. Here's the config: code"

# Language specific rules

## For rust programming language

- use `anyhow` crate for Error and Result
