# Stack: Rust

Slot values for the Rust ecosystem. Every fenced block is a slot; the block's
heading names the placeholder it fills.

**Variants to ask about:** workspace vs single crate (`--workspace` vs
`--all-features`), and whether `cargo-llvm-cov` is acceptable for coverage.

## `{{STACK_NAME}}`

Rust (stable toolchain, pinned via `rust-toolchain.toml`)

## `{{FULL_COMMANDS}}`

```sh
cargo fmt --check
cargo clippy --all-features --all-targets -- -D warnings
cargo check --all-features
cargo test --all-features
cargo llvm-cov --all-features --fail-under-lines {{COVERAGE_FLOOR}}
```

## `{{NARROW_COMMANDS}}`

```sh
cargo test ut_name                # one unit test
cargo test --test integration     # one integration test file
cargo check -p member             # typecheck one workspace member
cargo llvm-cov --all-features --html   # browsable per-line coverage
```

## `{{UNIT_TEST_CONVENTION}}`

`#[cfg(test)] mod tests` at the bottom of the file under test, functions named
`ut_*`.

## `{{INTEGRATION_TEST_CONVENTION}}`

`tests/`, functions named `it_*`.

## `{{ID_CITATION_EXAMPLE}}`

`/// FR-R-012 — …`

## `{{ID_CITATION_BLOCK}}`

```rust
#[test]
/// FR-R-012 — The checksum is computed over the full frame excluding the checksum field.
fn ut_checksum_excludes_trailer() { /* … */ }
```

## `{{SETUP_STEPS}}`

Install the toolchain via [rustup.rs](https://rustup.rs/), then:

```sh
cargo build --all-features
```

For the coverage gate you also need `cargo-llvm-cov`:

```sh
cargo install cargo-llvm-cov --locked
```

## `{{STACK_CONVENTIONS}}`

- Edition 2024, stable toolchain (`rust-toolchain.toml`). MSRV is a non-functional
  requirement — raising it is normative.
- No bare `unwrap` outside tests; `expect("why this cannot fail")`.
- Domain values are distinct transparent newtypes wrapped where they enter the API;
  mixing two of them must not compile. Raw integers only for genuinely opaque bytes.
- `#[non_exhaustive]` on public error enums so adding a variant is not breaking.
- Prefer typed handling over `serde_json::Value` — the compiler must catch a wrong
  field name, not the wire. This holds even when it forces duplication across
  protocol versions.

## `ci` → `.github/workflows/check.yml`

```yaml
name: check

on:
  push:
  pull_request:

env:
  CARGO_TERM_COLOR: always
  RUSTFLAGS: -D warnings

jobs:
  fmt:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt
      - run: cargo fmt --check

  clippy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: clippy
      - uses: Swatinem/rust-cache@v2
      - run: cargo clippy --all-features --all-targets -- -D warnings

  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - uses: Swatinem/rust-cache@v2
      - run: cargo check --all-features

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - uses: Swatinem/rust-cache@v2
      - run: cargo test --all-features

  coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: llvm-tools-preview
      - uses: Swatinem/rust-cache@v2
      - uses: taiki-e/install-action@cargo-llvm-cov
      - run: cargo llvm-cov --all-features --fail-under-lines {{COVERAGE_FLOOR}}
```

## `lefthook` → `.lefthook.yml`

```yaml
pre-commit:
  piped: true
  commands:

    fmt:
      glob: "*.rs"
      run: cargo fmt -- --check
      fail_text: |
        cargo fmt found formatting issues.
        Run `cargo fmt` to fix them, then re-stage your changes.

    clippy:
      glob: "*.rs"
      run: cargo clippy --all-features --all-targets -- -D warnings
      fail_text: |
        cargo clippy found issues.
        Fix the warnings above, then re-stage your changes.

    # Warning only (never blocks the commit): this project is spec-driven, so a
    # change to src/ usually comes with a docs/specs/ update in the same commit.
    spec-reminder:
      run: |
        staged="$(git diff --cached --name-only)"
        code="$(printf '%s\n' "$staged" | grep -E '^src/' || true)"
        spec="$(printf '%s\n' "$staged" | grep -E '^docs/specs/' || true)"
        if [ -n "$code" ] && [ -z "$spec" ]; then
          echo "note: product code changed but no docs/specs/ file is staged."
          echo "      If this commit changes behavior, update the area's requirements.md too"
          echo "      (see AGENTS.md 'Spec-driven'). This is a reminder, not a failure."
        fi
        exit 0

    # Warning only: every test that pins observable behavior cites its requirement ID
    # in a doc comment directly below the #[test] attribute (see AGENTS.md).
    test-id-reminder:
      glob: "*.rs"
      run: |
        staged="$(git diff --cached --name-only | grep -E '\.rs$' || true)"
        [ -z "$staged" ] && exit 0
        if printf '%s\n' "$staged" | xargs grep -l '#\[\(tokio::\)\?test\]' 2>/dev/null | head -1 > /dev/null; then
          if ! git diff --cached -U1 -- $staged | grep -qE '^\+\s*///\s*({{ID_PREFIX_ALTERNATION}})-R-[0-9]+'; then
            echo "note: tests changed but no requirement ID appears in an added doc comment."
            echo "      Tests pinning observable behavior cite their requirement (see AGENTS.md)."
            echo "      Reminder, not a failure."
          fi
        fi
        exit 0
```

## `config` → `clippy.toml` (default)

```toml
# Deny the lint families that let a panic reach a user of the library.
avoid-breaking-exported-api = false
```

## `config` → `rust-toolchain.toml` (default)

```toml
[toolchain]
channel = "stable"
components = ["rustfmt", "clippy"]
```
