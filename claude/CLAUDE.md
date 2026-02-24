# Global Claude Code Instructions

## Git Commits

When creating git commits, do not include the "Co-Authored-By: Claude" line in commit messages.

## Build Artifacts

Always place compiled binaries and build outputs in a `dist/` folder instead of the project root:
- `dist/` for production builds
- `dist/` for debug builds (e.g., `dist/myapp-debug`)
- Create the `dist/` directory if it doesn't exist

## Go Code Style

Always use the modern Go 1.22+ range-over-integer syntax for counting loops:
- `for i := range n {` instead of `for i := 0; i < n; i++ {`
- `for range n {` when the loop variable is unused

## Skills

### /wechat-article - Convert Markdown to WeChat Article HTML

When the user invokes `/wechat-article <filepath>`, convert the markdown file to HTML suitable for pasting into WeChat Official Account (微信公众号) editor's developer mode.

**Steps:**

1. Read the markdown file at the specified path
2. Convert markdown to styled HTML with the following rules:
   - Use inline styles (WeChat strips external CSS)
   - `h1`: `font-size: 24px; font-weight: bold; color: #1a1a1a; margin: 24px 0 16px 0; line-height: 1.4;`
   - `h2`: `font-size: 20px; font-weight: bold; color: #1a1a1a; margin: 20px 0 12px 0; line-height: 1.4; border-bottom: 1px solid #eee; padding-bottom: 8px;`
   - `h3`: `font-size: 18px; font-weight: bold; color: #1a1a1a; margin: 16px 0 10px 0; line-height: 1.4;`
   - `p`: `font-size: 16px; color: #333; line-height: 1.8; margin: 12px 0;`
   - `blockquote`: `border-left: 4px solid #07c160; padding: 12px 16px; margin: 16px 0; background: #f7f7f7; color: #666; font-size: 15px;`
   - `code` (inline): `background: #f5f5f5; padding: 2px 6px; border-radius: 3px; font-family: Consolas, Monaco, monospace; font-size: 14px; color: #c7254e;`
   - `pre > code`: `display: block; background: #1e1e1e; color: #d4d4d4; padding: 16px; border-radius: 8px; overflow-x: auto; font-family: Consolas, Monaco, monospace; font-size: 13px; line-height: 1.5;`
   - `table`: `width: 100%; border-collapse: collapse; margin: 16px 0; font-size: 14px;`
   - `th`: `background: #f5f5f5; padding: 10px; border: 1px solid #ddd; text-align: left; font-weight: bold;`
   - `td`: `padding: 10px; border: 1px solid #ddd;`
   - `ul/ol`: `margin: 12px 0; padding-left: 24px;`
   - `li`: `margin: 6px 0; line-height: 1.8;`
   - `hr`: `border: none; border-top: 1px solid #eee; margin: 24px 0;`
   - `strong`: `font-weight: bold; color: #07c160;` (WeChat green for emphasis)
   - `a`: `color: #576b95; text-decoration: none;` (WeChat blue link color)

3. Wrap the final HTML in the ProseMirror container:
   ```html
   <div contenteditable="true" translate="no" class="ProseMirror">
   [converted HTML content here]
   </div>
   ```

4. Write the output to a file with `.html` extension (same name as input, in the same directory)

5. Also copy the HTML content to clipboard using `pbcopy` (macOS) so user can paste directly

**Example usage:**
```
/wechat-article docs/my-article.md
```

**Output:** Creates `docs/my-article.html` and copies to clipboard.

### /todo - Task Queue Manager

Manages a `TODO.md` file in the current project root as a sequential task queue.

**Subcommands:**

- `/todo` (no args) — Read `TODO.md` and start working on the **first uncompleted task**. After finishing, ask the user to confirm completion before removing it.
- `/todo add <task description>` — Append a new task to `TODO.md`. Create the file if it doesn't exist.
- `/todo list` — Display all remaining tasks.
- `/todo done` — Remove the first task from `TODO.md` (user confirmed it's done), then show remaining tasks and ask if they want to continue with the next one.

**TODO.md format:**

```markdown
# TODO

- [ ] First task description
- [ ] Second task description
- [ ] Third task description
```

**Workflow:**

1. When `/todo` is invoked with no args, read `TODO.md`, find the first `- [ ]` item, and start working on it.
2. After completing the work, present the result and ask: "Task done? Should I mark it complete and move to the next one?"
3. When the user confirms (or invokes `/todo done`), remove that line from `TODO.md` and show what's next.
4. Repeat until `TODO.md` is empty.

**Rules:**
- Always read `TODO.md` fresh before each operation (it may have been edited externally).
- Never skip tasks — always work top-down.
- If `TODO.md` doesn't exist or is empty, tell the user "No tasks. Use `/todo add <task>` to add some."

