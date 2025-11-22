# Release Please Process

## How It Works

Release Please automates changelog generation and version bumping based on conventional commits.

## Workflow

1. **Commit with conventional format** to feature branches:
   - `feat:` - new feature (minor version bump)
   - `fix:` - bug fix (patch version bump)
   - `chore:` - maintenance (no version bump)
   - Add `!` or `BREAKING CHANGE:` for major version bumps

2. **Merge to main** - triggers release-please action via `.github/workflows/release-please.yml`

3. **Release PR created** - release-please opens/updates a PR with:
   - Updated CHANGELOG.md
   - Version bump

4. **Merge release PR** - creates:
   - Git tag
   - GitHub release
   - Updated version files

## Configuration

- Action: `google-github-actions/release-please-action@v4`
- Release type: `simple`
- Triggered on pushes to `main` branch
