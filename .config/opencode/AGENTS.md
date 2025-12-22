# General Rules

## IMPORTANT INSTRUCTION FOR OPENCODE:

Do not write any code, modify any files, until user explicitly ask you to do so.

When analyzing problems or answering questions:
1. Only read files and gather information
2. Diagnose issues by examining the command outputs and files
3. Explain what the problem is and what needs to be fixed
4. Wait for explicit permission before making any changes
5. Only proceed with writing code or modifying files when the user says "please fix this", "implement this", "make these changes", or
similar explicit requests

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
