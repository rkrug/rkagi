# Skill: R Package Maintainer

## R Package Maintainer Workflow (Generic)

Use this skill for package maintenance and release work in any R package
repository.

### Purpose

- Preserve API and behavior quality.
- Keep docs and generated references synchronized with code.
- Enforce reproducible validation and safe branch/merge governance.

### Maintainer Roles

1.  Implementation maintainer:
    - preserve API contracts,
    - keep behavior changes explicit and tested.
2.  Documentation maintainer:
    - keep user docs and reference docs synchronized with runtime
      behavior.
3.  Release maintainer:
    - keep versioning/changelog/release notes consistent and complete.
4.  Governance maintainer:
    - enforce branch and merge safety rules.

### Required Workflow Phases

1.  Understand scope
2.  Implement safely
3.  Synchronize docs and references
4.  Validate and record reproducible evidence
5.  Apply governance and merge gates

Use `references/checklist.md` as the execution gate before commit/merge.

### Non-Negotiable Rules

- Breaking changes must be explicit and documented.
- Validation claims must be reproducible (record exact commands and
  outcomes).
- R code formatting must follow `air`.
- AI-readable docs must remain separate from narrative user docs.
- Branch governance baseline:
  - long-lived branches are `main` and `dev`,
  - do not delete `dev` after PR merges,
  - do not delete any branch unless explicitly requested and confirmed,
  - solo-maintainer bypass on `main` is allowed only for PR merges and
    must not create a direct-push path.

### AI-Readable Docs Policy

- Keep user docs narrative-first (`README`, vignettes).
- Keep machine-oriented docs in dedicated artifacts (for example
  `llms.txt`, `llms-full.txt`, contracts/quick-index pages, skills).
- If code/API/output contracts change, update impacted AI-readable
  artifacts in the same change set.
- For skills in pkgdown, render HTML from include-based vignette
  wrappers that include `inst/skills/*/SKILL.md` and
  `inst/skills/*/references/*.md`; do not duplicate skill/reference text
  in vignettes.
- Keep one wrapper page per skill (not per reference file). Embed
  references inside the skill wrapper page under a references section.
- Keep navbar compact: one menu item per skill only.
- Keep `_pkgdown.yml` articles index synchronized with the actual skill
  wrapper vignette files.
- Remove obsolete skill-reference wrapper files when moving to
  single-page wrappers.

### Baseline CI Requirement

- Ensure baseline check workflow exists via
  `usethis::use_github_action("check-standard")`.
- As part of release/audit validation, run a local package check using
  `devtools::check()` (preferred in interactive development
  environments) and record outcomes.

### Package Skill Design Standard

- Keep `SKILL.md` thin: policy, workflow phases, non-negotiable rules.
- Keep operational detail in `references/*` files.
- Add section-level reference pointers plus a final references section.
- Avoid duplication between `SKILL.md` and checklist-style execution
  docs.
- Maintain clear user-skill vs maintainer-skill boundaries.
- When package APIs/workflows change, update impacted skills in the same
  change set and run stale-reference checks before commit.

### Commit Standard

- Use a detailed commit message covering:
  - behavior/API changes,
  - docs/changelog/design updates,
  - validation summary.

### References

Read and apply: - `references/checklist.md` -
`references/branch-protection-baseline.md` -
`references/commit-template.md` -
`references/check-ai-docs-template.sh` -
`references/skill-design-standard.md`

### References

#### Checklist

## Generic R Package Maintainer Checklist

### Pre-Implementation

1.  Classify change scope: API, behavior, docs, tests, release metadata,
    or governance.
2.  Identify impacted public interfaces and compatibility risk.
3.  Decide whether change is additive, behavioral, or breaking.

### Implementation

1.  Keep behavior changes explicit in code and tests.
2.  Preserve existing interfaces unless breaking change is intentional.
3.  Keep naming consistent across code, docs, and examples.

### Documentation Sync

1.  Update `README.md` for user-facing behavior changes.
2.  Update changelog (`NEWS.md` and any additional release notes files).
3.  Update design/architecture docs when architecture or conventions
    change.
4.  Update relevant vignettes.
5.  Regenerate reference docs (`devtools::document()`) when
    roxygen/signatures/imports change.

### AI Docs Sync

1.  Verify user-doc readability is preserved (no machine-oriented
    schema/contract dumps in narrative-first sections).
2.  Verify machine-oriented artifacts are updated when
    API/contracts/output schema/folder contracts changed.
3.  Verify links/index references to machine artifacts are valid.
4.  Verify dedicated machine pages exist and are indexed (for example:
    API contracts page and quick function index page).
5.  If skills are exposed in pkgdown, verify wrapper vignettes use
    includes from `inst/skills/*/SKILL.md` and
    `inst/skills/*/references/*.md` (single source, no copied
    skill/reference text).
6.  Verify one-wrapper-per-skill convention:
    - each skill has one `vignettes/skills-<skill>.qmd`,
    - references are embedded in that wrapper,
    - no orphan `skills-*-ref-*.qmd` files remain unless explicitly
      intended.
7.  Verify `_pkgdown.yml` keeps a compact skills menu (one entry per
    skill) and that all skill wrappers are listed under articles.
8.  If skill wrapper pages are pkgdown-only (not package vignettes),
    ensure they are excluded via `.Rbuildignore` (for example
    `^vignettes/skills-.*\\.qmd$`) to avoid vignette-engine check notes.

### Validation

1.  Run targeted tests for touched modules.
2.  Run package checks appropriate to change risk.
3.  Ensure baseline CI check workflow is present:
    - initialize/refresh with
      `usethis::use_github_action("check-standard")`.
4.  Run a local package check with `devtools::check()` and record
    outcome. Use `R CMD check` only when explicitly needed for
    tarball-level parity.
5.  Confirm no stale references to removed/renamed APIs in docs/tests.
6.  Confirm touched R files conform to `air` formatting rules.
7.  Pre-commit AI gate:
    - if code changed, AI-readable artifacts were checked and updated
      where needed.
8.  Reproducibility gate:
    - record exact validation commands and outcomes in commit/PR notes.
9.  Run AI-doc consistency checks (script or equivalent CI gate) and
    confirm pass.
10. Run
    [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
    and confirm skills pages render without article index or navbar
    errors.

### Release/Merge

1.  Ensure branch policy and branch protections are respected.
2.  If solo-maintainer bypass is configured, confirm it is scoped to PR
    merges only and does not allow direct pushes to `main`.
3.  Ensure detailed commit message is used.
4.  Ensure PR description reflects behavior, docs, tests, and breaking
    changes.
5.  Generated-artifact gate:
    - commit `NAMESPACE` and `man/*.Rd` when regenerated,
    - do not commit build artifacts (for example `_site/`, check/temp
      outputs).

#### Branch Protection Baseline

## Branch Protection Baseline (Generic)

### Branch Model

- Long-lived branches: `main` and `dev`.
- Preferred integration flow: feature work -\> `dev` -\> PR -\> `main`.

### Branch Deletion Rules

- Do not delete `dev` after PR merges.
- Do not delete any branch unless deletion is explicitly requested and
  explicitly confirmed.

### Protection Ruleset Baseline

#### `main`

- protect from deletion
- prevent non-fast-forward (force push)
- require PR-based merge
- require at least one approving review
- require review thread resolution
- require stale review dismissal on push
- require last-push approval
- optional for solo-maintainer repos: add a bypass actor for PR merges
  only when no second reviewer exists
- if bypass is used, keep required checks and PR-only merge requirement
  active (no direct push path)

#### `dev`

- protect from deletion
- allow force push unless project policy says otherwise

### Deployment Gates

- Avoid merge-blocking deployment requirements on `main` unless
  deployment is guaranteed pre-merge in your workflow.

#### Commit Template

## Detailed Commit Template (Generic)

Use this structure for maintainer/release commits:

### Subject

- Short imperative summary (single line).

### Body

#### Behavior/API changes

- List functional changes and contract impacts.
- Explicitly call out breaking changes.

#### Documentation and metadata updates

- List updated docs (README/changelog/vignettes/design docs).
- Mention regenerated reference artifacts (`NAMESPACE`, `man/*.Rd`) if
  applicable.
- Explicitly list AI-readable artifact updates, or state:
  - `No AI-doc changes required` + short reason.
- State generated-artifact handling:
  - confirm package-standard artifacts were committed (`NAMESPACE`,
    `man/*.Rd` when regenerated),
  - confirm build artifacts were not committed.

#### Validation

- List tests/checks executed.
- Note any remaining non-actionable warnings/notes.
- Add AI-doc sync check:
  - pass/fail + what was verified.
- List exact validation commands (copyable) so results are reproducible.

#### Scope note (optional)

- Clarify inclusions/exclusions when commit intentionally bundles or
  excludes areas.

#### Skill Design Standard

## Package Skill Design Standard (Generic)

### Goal

Define a maintainable structure for package-local skills so agents and
humans can use them consistently without bloating user-facing docs.

### Structure

1.  Keep `SKILL.md` compact:
    - purpose,
    - scope,
    - workflow phases,
    - non-negotiable rules,
    - pointers to references.
2.  Put detailed procedures in `references/*`.
3.  Keep reusable scripts/templates in `references/` or a dedicated
    helper path.
4.  For pkgdown exposure, use one wrapper vignette per skill
    (`vignettes/skills-<skill>.qmd`) and include both `SKILL.md` and
    reference files from `inst/skills`.

### Linking Rules

1.  Include a final `References` section in `SKILL.md`.
2.  Add section-level pointers (“See also”) where a specific reference
    is required.
3.  Ensure every referenced file exists and is current.
4.  In `_pkgdown.yml`, keep skill pages indexed and linked via wrapper
    vignette HTML pages.

### Duplication Control

1.  Do not duplicate detailed checklist items in `SKILL.md`.
2.  Keep execution gates in checklist docs.
3.  Keep commit evidence format in commit-template docs.
4.  Do not create duplicate per-reference wrappers when references are
    embedded in the single skill wrapper page.

### Skill Taxonomy

1.  Separate user workflow skills from maintainer/internal skills.
2.  Keep naming clear and intention-revealing (for example `user-*`,
    `maintainer-*`).
3.  Maintain an index file with selection rules.

### Sync Rules (Required)

When code/API/workflow changes:

1.  Update impacted skills in the same change set.
2.  Update the skill index if skills are added/renamed/retired.
3.  Run stale-reference checks (old function names, removed APIs, path
    drift).
4.  Verify references and examples still match current package behavior.
5.  Keep `_pkgdown.yml` skills menu compact (one entry per skill) and
    keep the articles index synchronized with actual wrapper files.
6.  Remove obsolete `skills-*-ref-*.qmd` wrappers after migration to
    one-page skill wrappers.
7.  If wrapper pages are pkgdown-only, exclude them in `.Rbuildignore`
    to avoid vignette-engine notes during package checks.

### Readability Guardrails

1.  Keep user docs narrative-first.
2.  Keep machine/agent-specific operational details in skills and
    machine docs, not in narrative user guides.
3.  Keep skills concise and imperative; keep long rationale in
    references.

### Validation Gate

Before commit/merge:

1.  Confirm skill references resolve.
2.  Confirm no stale API names remain in skills.
3.  Confirm checklist/commit-template still reflect current governance.
4.  Confirm
    [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
    succeeds after skills/docs changes.
