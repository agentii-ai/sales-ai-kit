# Two Meanings of “specify”

This project intentionally uses the word “specify” in two different ways. Keeping them distinct is critical to multi-kit coexistence.

## 1) “specify” as an upstream command / workflow concept (allowed)

This meaning refers to:

- The upstream Spec-Kit executable name: `specify`
- The upstream Spec-Kit workflow namespace: `speckit.*`
- The verb/concept in the workflow shape: constitution → specify → plan → tasks → implement

In Sales-AI-Kit docs, it is acceptable (and often desirable) to reference `./specify` when describing **Spec-Kit compatibility** or when describing the **generic workflow shape**.

## 2) “specify” as a package/folder namespace (NOT allowed for Sales-AI-Kit)

This meaning refers to:

- The hidden project folder that stores kit-owned memory/templates
- The Python distribution name (what you install via `uv tool install ...` / `pip ...`)
- The Python import namespace

Sales-AI-Kit MUST NOT use `specify` for any of these, because users may install multiple kits on the same machine.

Sales-AI-Kit’s correct kit-owned folder is:

- `.saleskit/` (generated projects)

and the correct workflow namespace is:

- `saleskit.*`

## Practical checks

- [ ] Sales-AI-Kit generated projects write kit-owned assets under `.saleskit/` (not `.specify/`).
- [ ] Sales-AI-Kit user-facing docs never instruct running `/speckit.*` for Sales-AI-Kit workflows.
- [ ] When docs mention `./specify`, they clearly indicate that this is about upstream Spec-Kit compatibility, not Sales-AI-Kit’s own kit folder.
