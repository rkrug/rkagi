# Skill: Maintainer Release Sync

## Maintainer Release Sync

Use this skill for final consistency checks before release or merge.

### Required Sync Targets

- `DESCRIPTION` version and description text
- `NEWS.md` and `NES.md`
- `PROJECT_DESIGN.md`
- `README.md`
- `vignettes/*.qmd`
- `inst/skills/**`
- `man/*.Rd` and `NAMESPACE` (via `devtools::document()`)

### Required Checks

1.  Enforce branch policy:
    - long-lived branches are `main` and `dev`;
    - `dev` must not be deleted after PR merge.
    - do not delete any branch unless deletion is explicitly requested
      and explicitly confirmed by the user.
2.  No stale function names or removed APIs in docs/skills.
3.  Examples use current constructor names and workflow order.
4.  Breaking changes are explicitly listed in changelog.
5.  Skills align 1:1 with vignette terminology for user workflows.
6.  Release docs reflect current folder contracts and schema contracts.
7.  Before commit/merge, confirm the following are reviewed and updated
    if needed:
    - `NEWS.md`
    - `PROJECT_DESIGN.md`
    - `README.md`
    - `vignettes/*.qmd`
8.  Use a detailed commit message that includes:
    - summary of behavioral changes,
    - documentation and skills updates,
    - test/check validation outcomes.

### GitHub Protection Baseline

Before release-final merge, confirm repository rulesets are aligned:

- `main` ruleset:
  - `deletion` enabled,
  - `non_fast_forward` enabled,
  - PR review required (`required_approving_review_count = 1`),
  - review thread resolution required,
  - stale review dismissal on push enabled,
  - last-push approval required,
  - if solo-maintainer bypass is configured, it is PR-merge-only and
    does not allow direct pushes,
  - no `required_deployments` gate for `github-pages`.
- `dev` ruleset:
  - protect from deletion,
  - no force-push prevention (`non_fast_forward` not enforced).

### References

Read and apply: - `references/checklist.md`

### References

#### Checklist

## Release Sync Checklist

1.  Run grep for stale identifiers (removed APIs, old constructor
    names).
2.  Regenerate docs (`devtools::document()`).
3.  Re-run key tests for changed modules.
4.  Ensure README and vignettes show current preferred workflow.
5.  Ensure `PROJECT_DESIGN.md` reflects actual architecture.
6.  Ensure skills index lists all active skills.
7.  Update `NEWS.md`/`NES.md` with features, bug fixes, breaking
    changes, docs.
8.  Pre-commit sync gate:
    - verify `NEWS.md`, `PROJECT_DESIGN.md`, `README.md`, and relevant
      `vignettes/*.qmd` are updated for behavior changes.
9.  Commit message gate:
    - use a detailed message with sections for behavior changes,
      docs/skills sync, and test/check outcomes.
10. Branch gate:

- keep both `main` and `dev` on origin; do not delete `dev` after merge.
- do not delete any branch unless explicitly requested and explicitly
  confirmed by the user.

11. Ruleset gate:

- verify `main` ruleset has deletion + non-fast-forward protection and
  PR-review requirements.
- if solo-maintainer bypass exists, verify it only bypasses via PR merge
  and does not permit direct push to `main`.
- verify `main` does not require `github-pages` deployment before merge.
- verify `dev` is protected from deletion but does not enforce
  non-fast-forward.
