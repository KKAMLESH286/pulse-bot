# GitHub PR Creation Command

## Objective
Create a GitHub Pull Request with automated commit message analysis, code safety checks, and PR generation.

> **CRITICAL: Target Branch is ALWAYS `dev`**
> - NEVER use `main` as target branch
> - NEVER override `--base` to anything other than `dev`

## Pre-Push Safety Checks

Before committing or pushing, verify:

1. **No localhost/development URLs**
   - Check for `localhost`, `127.0.0.1`, `192.168.x.x`
   - Verify API base URLs point to staging/production endpoints
   - Look for hardcoded development URLs in:
     - API service files
     - Environment configurations
     - HTTP client initialization
     - WebSocket connections

2. **Environment Configuration**
   - Ensure `.env` files aren't committed
   - Verify environment-specific configs use proper staging values
   - Check that debug flags are disabled
   - Confirm logging levels are appropriate for staging

3. **Sensitive Data**
   - No API keys, tokens, or credentials in code
   - No console.log/print statements with sensitive data
   - No commented-out sensitive information

4. **Code Quality**
   - No TODO/FIXME comments that block deployment
   - No merge conflict markers
   - No debugger statements or breakpoints

## Workflow

### Step 1: Safety Validation
```bash
# Search for potential issues
grep -r "localhost" --include="*.dart" --include="*.js" --include="*.ts" .
grep -r "127.0.0.1" --include="*.dart" --include="*.js" --include="*.ts" .
grep -r "TODO.*CRITICAL\|FIXME.*BLOCKING" --include="*.dart" --include="*.js" --include="*.ts" .
```

**Action**: Review findings and confirm it's safe to proceed.

### Step 2: Commit Changes
```bash
# Stage all changes
git add .

# Create commit with provided message
git commit -m "[Commit message provided by user or generated]"
```

### Step 3: Analyze Commit History
```bash
# Get commits since branching from dev
git log dev..HEAD --oneline --no-merges
```

**Action**: Read and analyze all commit messages to understand:
- Feature additions
- Bug fixes
- Refactoring work
- Configuration changes

### Step 4: Generate PR Details

Based on commit analysis, create:

**PR Title Format**:
- `feat: [Brief feature description]` for new features
- `fix: [Brief fix description]` for bug fixes
- `refactor: [Brief refactor description]` for code improvements
- `chore: [Brief description]` for maintenance tasks

**PR Description Template**:
```markdown
## Changes
[Bullet points summarizing key changes from commits]

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Refactoring
- [ ] Configuration change

## Testing
- [ ] Tested locally
- [ ] No localhost URLs present
- [ ] Environment configs verified
- [ ] Ready for staging deployment

## Related Issues
[If applicable, link to issues]
```

### Step 5: Create GitHub PR
```bash
# Push to remote
git push -u origin HEAD

# Create PR using GitHub CLI
gh pr create \
  --title "[Generated title]" \
  --body "[Generated description]" \
  --base dev
```

## Usage Example

When user runs:
```
/github-pr "Implemented dark mode feature"
```

The command should:
1. Run all safety checks
2. Report any issues found
3. Ask for confirmation to proceed
4. Commit with provided message
5. Analyze commit history
6. Generate appropriate PR title and description
7. Create the PR on GitHub
8. Provide the PR URL

## Error Handling

If safety checks fail:
- List all issues found
- Do NOT proceed with commit/push
- Ask user to fix issues first
- Provide suggestions for common fixes
