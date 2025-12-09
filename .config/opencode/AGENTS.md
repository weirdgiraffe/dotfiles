## General rules

### Multiple choice answers

When providing multiple options, detail only the best option and briefly mention alternatives in one sentence each.

**Bad example:**
<example>
user: how to read file line by line in rust?
agent: [Shows 4 detailed code examples with full implementations]
</example>

**Good example:**
<example>
user: how to read file line by line in rust?
agent: 
1. Using `BufRead` trait (recommended):
```rust
use std::fs::File;
use std::io::{self, BufRead, BufReader};
fn read_lines() -> io::Result<()> {
    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);
    for line in reader.lines() {
        let line = line?;
        println!("{}", line);
    }
    Ok(())
}
```
2. Using `lines()` iterator with explicit error handling
3. Collect `lines()` iterator into a `Vec`
4. Using `read_to_string()` + split (less memory efficient)

Key Points:

- `BufReader` provides efficient buffered reading
- `lines()` returns `Result<String>` iterator with newlines stripped.
</example>


## Rules for rust programming language

- use `anyhow` crate for Error and Result
