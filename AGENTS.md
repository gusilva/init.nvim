# AGENTS.md

- Scope: Entire repo (`/Users/gustavo/.config/nvim`), all Lua config.
- Build: No compile step. Use `:Lazy sync` inside Neovim to install plugins.
- Lint: Prefer `stylua` for formatting (`stylua .`) and `luacheck` for static lint if available (`luacheck lua/`).
- Types: Use Lua Language Server (LuaLS). Workspace settings in `.luarc.json`. Keep annotations minimal; prefer idiomatic Lua.
- Tests: No test suite present. To smoke‑test, run `nvim --headless "+lua print('init ok')" -c qa`. Single plugin check: `nvim --headless -c "Lazy show gusilva" -c qa`.
- Run: Launch Neovim as usual; configs live under `lua/gusilva/**` and `init.lua`.
- Imports: Use `require("gusilva.<module>")`. Keep module names snake_case matching filenames.
- Formatting: Run `stylua` before committing. Use 2 spaces, no tabs; avoid trailing whitespace.
- Naming: Modules/files snake_case; locals lower_snake; constants UPPER_SNAKE; functions lower_snake; avoid one‑letter names.
- Error handling: Guard `require` calls with `pcall(require, ...)` for optional plugins; fail softly and log via `vim.notify`.
- Plugin management: Use `lazy.nvim`. Respect existing split across files in `lua/gusilva/lazy/*.lua`.
- Configuration style: Keep changes minimal and localized; do not rename files unnecessarily.
- Git hygiene: Do not commit generated cache or plugin directories. Only modify repo files.
- Cursor/Copilot rules: None found (`.cursor/`, `.cursorrules`, `.github/copilot-instructions.md` absent).
- Single‑file check: `nvim --headless -c "luafile lua/gusilva/<path>.lua" -c qa`.
- Docs: Update this file when adding tooling (tests/linting). Keep under ~25 lines.
- Performance: Avoid heavy work in `init.lua`; defer via lazy‑loading.
- Contributions: Match existing style; avoid inline comments unless requested.
