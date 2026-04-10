# Skill: Maintainer Workflow

## Maintainer Workflow

Use this skill for package maintenance and implementation changes.

### Scope

Apply this skill when tasks involve any of the following:

- Changes in `R/` implementation.
- Changes in tests, cassettes, or test infrastructure.
- Changes in API behavior, error handling, or output contracts.
- Versioning, changelog/release notes, and documentation
  synchronization.

For endpoint-only user workflows, use `user-search`, `user-enrich`,
`user-summarize`, `user-fastgpt`, or `user-corpus-workflow` instead.

### Required Design Principles

1.  Query-first architecture. Build endpoint query objects first;
    execute with
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md).
2.  Constructor and execution separation. Query constructors define
    intent; request layer handles IO and endpoint execution.
3.  JSON is source-of-truth. Requests persist JSON artifacts. Treat
    parquet as derivative.
4.  Consistent scaling. Constructor outputs must support single and
    batch execution consistently.
5.  Explicit fault tolerance. Keep `error_mode = "stop"` and
    `error_mode = "write_dummy"` coherent and tested.

### Naming Principles

Enforce these naming rules:

- Query constructors use `query_<endpoint>` names (for example
  `query_search`, `query_fastgpt`).
- Request executors are generic (`kagi_request`,
  `kagi_request_parquet`).
- Constructor output contract remains consistent across endpoints.
- Output folders should be explicit and stable in examples/tests.

### Testing Workflow

Use `testthat` with `vcr` and preserve deterministic cassette structure.

Required checks for relevant changes:

1.  Run targeted tests for modified behavior.
2.  Ensure cassette location remains
    `tests/testthat/fixtures/cassettes`.
3.  If re-recording, use key retrieval via
    `keyring::key_get("API_kagi")`.
4.  Cover both strict and graceful error modes where request behavior
    changed.
5.  Validate parquet conversion for mixed success/error payloads when
    relevant.

### Release Hygiene Checklist

For release-prep changes, execute this checklist:

1.  Bump version in `DESCRIPTION`.
2.  Update release notes/changelog (`NEWS.md` and `NES.md`).
3.  Confirm docs are synchronized: `README.md`, `PROJECT_DESIGN.md`,
    quickstart and endpoint/corpus vignettes, man pages.
4.  Confirm no stale names, paths, or deprecated references remain.
5.  Run regression tests relevant to touched behavior.

### Implementation Guardrails

- Branch policy:
  - Maintain exactly two long-lived branches: `main` and `dev`.
  - All feature/release integration flows through pull requests into
    `main`.
  - `dev` must never be deleted after pull request merge.
  - Do not delete any branch unless the user explicitly asks for
    deletion and explicitly confirms it.
- Do not introduce undocumented behavior in skills or docs.
- Do not claim endpoint capabilities not present in code/tests.
- Keep user-facing docs narrative, but keep this skill imperative and
  concise.
- If behavior changes, update tests and docs in the same change set.
- Before commit, explicitly verify and update when needed:
  - `NEWS.md`
  - `PROJECT_DESIGN.md`
  - `README.md`
  - `vignettes/*.qmd` relevant to changed behavior
- Use detailed commit messages for maintainer changes. Minimum
  structure:
  1.  short imperative subject,
  2.  grouped bullets for behavioral changes,
  3.  grouped bullets for docs/tests/regenerated artifacts.

### References

Read and apply: - `references/design-principles.md` -
`references/naming-principles.md` -
`references/testing-and-cassettes.md` -
`references/release-checklist.md`

### References

#### Design Principles

## Design Principles

### Canonical Workflow

1.  Build query objects with endpoint-specific constructors.
2.  Create one
    [`kagi_connection()`](https://rkrug.github.io/kagiPro/reference/kagi_connection.md).
3.  Execute with
    [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
    into JSON output directories.
4.  Optionally convert with
    [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md).

### Architecture Rules

- Keep constructor logic endpoint-specific.
- Keep request execution generic where possible.
- Keep JSON writing deterministic and explicit.
- Keep graceful error handling predictable and structured.

### Error-Handling Contract

- `error_mode = "stop"` must fail fast with actionable errors.
- `error_mode = "write_dummy"` must warn and write endpoint-compatible
  fallback JSON.
- Dummy outputs must remain convertible by parquet conversion paths.

### Data Contract Priorities

- Preserve stable fields where feasible.
- Avoid hidden coercions in constructor output.
- Preserve consistency between single and batch query execution.

#### Naming Principles

## Naming Principles

### Function Names

- Query constructors use `query_<endpoint>` naming.
- Core execution functions are
  [`kagi_request()`](https://rkrug.github.io/kagiPro/reference/kagi_request.md)
  and
  [`kagi_request_parquet()`](https://rkrug.github.io/kagiPro/reference/kagi_request_parquet.md).
- Endpoint-specific helpers must use explicit endpoint terms (`search`,
  `enrich`, `summarize`, `fastgpt`).

### Output and Object Conventions

- Constructor outputs are named lists.
- Output directories should reflect endpoint/run intent (`search_batch`,
  `summarize_mixed`).
- Avoid ambiguous or overloaded names in new helpers.

### Documentation Naming Consistency

- Use the same function names in code, docs, tests, and cassettes.
- Remove stale aliases/references when names change.
- Keep vignette terminology aligned with exported function names.

#### Testing And Cassettes

## Testing and Cassettes

### Baseline Expectations

- Use `testthat` (edition 3).
- Use `vcr` for HTTP recording/replay.
- Keep cassettes in `tests/testthat/fixtures/cassettes` only.

### Re-recording Workflow

1.  Ensure API key is available via `keyring::key_get("API_kagi")`.
2.  Set `VCR_RECORD_MODE` appropriately (for example `all` during
    refresh).
3.  Re-run targeted tests that exercise changed requests.
4.  Review cassettes for expected endpoint URLs and payload shape.
5.  Reset recording mode after cassette updates.

### Required Coverage for Request-Path Changes

- Successful request path.
- List/batch request path.
- At least one failure path with `error_mode = "write_dummy"`.
- Parquet conversion handling for dummy/error payloads.

### Regression Triggers

Always re-run tests if changing:

- Constructor return shape.
- Request recursion/list handling.
- Error formatting/dummy payload shape.
- Parquet extraction logic.

#### Release Checklist

## Release Checklist

### Version and Metadata

1.  Update `DESCRIPTION` version.
2.  Verify package metadata and URLs are current.

### Changelog and Design Docs

1.  Update `NES.md` (features, fixes, breaking changes, docs).
2.  Update `PROJECT_DESIGN.md` when architecture or conventions changed.

### Documentation Sync

1.  Sync README examples with current function names.
2.  Sync quickstart and endpoint vignettes with runtime behavior.
3.  Regenerate man docs if roxygen comments changed.

### Test and Validation Gate

1.  Run targeted tests for changed modules.
2.  Validate cassette integrity if HTTP behavior changed.
3.  Confirm no stale references remain (legacy names, old fixture
    paths).

### Pre-Commit Quality Gate

- No contradictory behavior across code, tests, and docs.
- No unreviewed placeholder text in new docs.
- All new skills/reference files are discoverable from
  `inst/skills/README.md`.
- Branch policy is respected:
  - keep `main` and `dev` as long-lived branches,
  - never delete `dev` after PR merge.
