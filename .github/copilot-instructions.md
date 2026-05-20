# Copilot instructions for this repository

## Commands

There is no project-level build, test, or lint runner in this repository. For focused validation after editing a dotfile, use the relevant single-file check when available:

- `.zshrc`: `zsh -n .zshrc`
- interactive zsh startup: `zsh -i -c exit`
- `.gitconfig`: `git config --file .gitconfig --list`
- Homebrew bundle: `brew bundle check --file Brewfile`

Run a single-file check by targeting only the edited dotfile with the command above.

## Architecture

This repository is a personal macOS dotfiles repo:

- `.zshrc` configures the interactive shell around Homebrew-managed zsh, starship, zoxide, mise, fzf, atuin, zsh plugins, aliases, locale, editor, and optional Kubernetes helper aliases/functions.
- `.vimrc` configures Vim using Vundle for plugins, then layers key mappings, statusline/airline settings, indentation defaults, NERDTree behavior, colors, search/swap/backup behavior, Org file handling, GUI chrome removal, and Alacritty mouse compatibility.
- `.gitconfig` stores global Git identity and defaults, SourceTree diff/merge integration, git-lfs filters, commit template path, color settings, and GitHub URL rewriting.
- `Brewfile` captures the Homebrew, cask, npm, and uv toolchain for deployment.
- `.config/`, `.codex/`, and `.agents/` contain curated non-secret app, AI CLI, agent, and skill configuration in home-relative paths.
- `install.sh` installs the Brewfile and symlinks tracked files into `$HOME`, backing up existing targets first.

Changes usually affect user environment startup directly; prefer small edits to the specific dotfile rather than introducing a new framework or installer unless explicitly requested.

## Conventions

- Keep tracked files usable as direct home-directory dotfiles; prefer `$HOME` and home-relative paths over machine-specific absolute paths.
- `.zshrc` uses Homebrew-managed tools directly, not oh-my-zsh. Keep starship initialization last and guard optional tools so a fresh shell still starts before all packages are installed.
- `.zshrc` aliases intentionally replace common commands (`ls` via `eza`, `cat` via `bat`, guarded `cp -i`) and includes optional Kubernetes shorthand aliases plus the `klogin` helper.
- `.vimrc` plugin declarations must stay between `call vundle#begin()` and `call vundle#end()`; non-plugin Vim settings belong after that block.
- Vim indentation defaults are 4 spaces with `expandtab`, `shiftwidth=4`, and `tabstop=4`.
- Preserve existing Vim keybindings and terminal assumptions, including insert-mode `ii` for escape, `<C-n>` for NERDTree, powerline/airline font settings, and `ttymouse=sgr` for Alacritty.
- `.gitconfig` is a global configuration file, not repo-local Git settings; avoid adding repository-specific behavior there unless the user asks for it.
- Never track auth files, tokens, shell history databases, caches, Codex/Copilot/GitHub credentials, Atuin keys, logs, or generated memories.
