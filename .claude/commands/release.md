# Release - Bump Patch, Commit, Tag, Push

Full release flow for the Copier template: increment patch version, commit, update journal, tag, and push everything.

> Invoking `/release` IS the user's explicit approval for the git commit, tag, and push operations below. The workspace's "no automatic git" rules normally require per-action approval; this command is the exception, scoped to a single invocation.

## Instructions

1. **Read current version** from `pyproject.toml`:
   - Locate `version = "X.Y.Z"` under `[project]`
   - Parse `X.Y.Z`; if it does not match `^\d+\.\d+\.\d+$`, stop and report the malformed value

2. **Compute next version**:
   - `NEW = X.Y.(Z+1)`

3. **Bump version**:
   - Edit `pyproject.toml`, replacing the `version = "X.Y.Z"` line with the new value

4. **Update `.claude/JOURNAL.md`**:
   - Append a new entry following the project's modus secundis format:
     ```
     <N>. **Task - Release v<NEW>** (v<NEW>): bump patch version<br>
         **Result**: incremented <OLD> -> <NEW>, committed, tagged v<NEW>, pushed branch and tag to origin.
     ```
   - Use the next sequential entry number (continue numbering, do not reset)

5. **Verify clean state before commit**:
   - Run `git status --porcelain` - the only changes should be `pyproject.toml` and `.claude/JOURNAL.md`
   - If anything else is modified or staged, STOP and ask the user how to proceed (do not silently sweep unrelated changes into the release commit)

6. **Commit, tag, and push** (all under the umbrella of the `/release` invocation):
   - `git add pyproject.toml .claude/JOURNAL.md`
   - `git commit -m "chore: release v<NEW>"` (conventional-commits style, no Claude co-author per workspace `GIT.md`)
   - `git tag v<NEW>`
   - `git push origin HEAD`
   - `git push origin v<NEW>`

7. **Report**:
   - Print: `released v<NEW> (was v<OLD>) - branch + tag pushed to origin`

## Failure handling

- If pre-commit hooks reject the commit, STOP, surface the hook output, and let the user decide. Do not retry with `--no-verify`.
- If `git push` fails (auth, non-fast-forward, etc.), STOP and surface the error - do not force-push.
- If the tag already exists, STOP - this means the patch was bumped but a previous release left a stale tag; ask the user whether to delete or skip.

## Notes

- PATCH-only bump. For MINOR or MAJOR releases, the user edits `pyproject.toml` manually first, then runs `/release` (which will only re-bump patch - so manual bumps must set `Y.Z` correctly and leave `Z=0` if needed before invoking).
- The Copier template has no Python runtime; `pyproject.toml` exists solely as the version source of truth.
