#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"
RUN_BREW=1

for arg in "$@"; do
  case "$arg" in
    --no-brew)
      RUN_BREW=0
      ;;
    *)
      echo "unknown option: $arg" >&2
      exit 2
      ;;
  esac
done

link_file() {
  local source="$1"
  local target="$HOME/$source"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$DOTFILES_DIR/$source" ]]; then
    echo "linked: $target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mv "$target" "$target$BACKUP_SUFFIX"
    echo "backed up: $target -> $target$BACKUP_SUFFIX"
  fi

  ln -s "$DOTFILES_DIR/$source" "$target"
  echo "linked: $target -> $DOTFILES_DIR/$source"
}

if [[ "$RUN_BREW" -eq 1 ]]; then
  if command -v brew >/dev/null 2>&1; then
    brew bundle install --file "$DOTFILES_DIR/Brewfile"
  else
    echo "Homebrew not found; install Homebrew first or rerun with --no-brew." >&2
  fi
fi

files=(
  ".zshrc"
  ".vimrc"
  ".gitconfig"
  ".config/starship.toml"
  ".config/atuin/config.toml"
  ".config/gh/config.yml"
  ".config/micro/settings.json"
  ".config/micro/bindings.json"
  ".codex/config.toml"
  ".agents/verifier.md"
  ".agents/skills/karpathy-guidelines/SKILL.md"
)

for file in "${files[@]}"; do
  link_file "$file"
done

cat <<'EOF'

Manual auth/setup still required where applicable:
- gh auth login
- copilot
- codex
- atuin login/import/sync choices

Open a new shell after linking, or run: exec zsh
EOF
