# Agent instructions

This repository manages a personal macOS dotfiles environment. Keep changes portable and deployment-safe; do not add secrets, tokens, auth files, shell history databases, caches, or machine-generated state.

## Commands

- `.zshrc`: `zsh -n .zshrc` and `zsh -i -c exit`
- `.gitconfig`: `git config --file .gitconfig --list`
- Homebrew bundle: `brew bundle check --file Brewfile`

Run the focused check for each edited file. There is no project-level test suite.

## Organization

- Root dotfiles map directly to `$HOME`: `.zshrc`, `.vimrc`, `.gitconfig`.
- XDG-style configs keep their home-relative paths under `.config/`.
- AI CLI and agent configs keep their home-relative paths under `.codex/` and `.agents/`.
- `Brewfile` is the source of truth for Homebrew packages, casks, npm globals, and uv tools.
- `install.sh` links tracked files into `$HOME` and backs up existing targets before replacing them.

## Shell conventions

- `.zshrc` uses Homebrew-managed tools directly instead of oh-my-zsh.
- Initialize small shell tools in this order: Homebrew path, locale/editor/history, completion, zoxide, mise, fzf, atuin, zsh plugins, aliases, optional kubectl helpers, then starship last.
- Guard optional tools with `command -v` or file existence checks so startup remains usable on a fresh machine before `brew bundle install`.

## AI config conventions

- Track only non-secret, reusable configuration.
- Do not track Codex auth, Copilot auth, GitHub CLI hosts, Atuin keys/databases, skill caches, session logs, or memories.
- Prefer shared agent instructions in this file; add tool-specific shims only when a tool does not read `AGENTS.md`.
