# Homebrew comes first so all managed tools are available during shell startup.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export BAT_THEME="${BAT_THEME:-ansi}"
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:---height 40% --layout=reverse --border}"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# Modern shell helpers installed by Homebrew.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if [[ -f "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Preferred replacements for common commands.
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -l --color=always --group-directories-first'
  alias la='eza -al --color=always --group-directories-first'
  alias ll='eza -a --color=always --group-directories-first'
  alias lt='eza -aT --color=always --group-directories-first'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

alias cp='cp -i'
alias df='df -h'
alias grep='grep --colour=auto'
alias zshconfig='vim ~/.zshrc'

# Kubernetes helpers are defined only when kubectl is installed.
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
  alias kc='kubectl create -f'
  alias kpod='kubectl get pods'
  alias ki='kubectl describe pod'
  alias kdel='kubectl delete pod'
  alias kdelall='kubectl delete pod --all'
  alias kh='echo "K8 help cmds: \n"; alias | grep kubectl; echo'

  klogin() {
    if [[ -z "$1" ]]; then
      echo 'usage: klogin <pod>' >&2
      return 2
    fi

    kubectl exec -it "$1" -- su "${KLOGIN_USER:-peter}"
  }
fi

# Keep prompt initialization last.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
