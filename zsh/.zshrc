# =========================
# Zsh minimal clean config
# =========================

# Interactive only
[[ -o interactive ]] || return

# =========================
# PATH & env
# =========================
export PATH="$HOME/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export SUDO_EDITOR=/usr/bin/nvim

# =========================
# History
# =========================
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS
HISTDUP=erase

# =========================
# Basic behavior
# =========================
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_MATCH
unsetopt BEEP
bindkey '^[[3~' delete-char

# =========================
# Completion system
# =========================
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache

# =========================
# Fastfetch
# =========================

# Afficher fastfetch à l'ouverture d'un shell interactif
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

# =========================
# Plugins sans zinit
#   (à cloner une fois pour toutes dans ~/.zsh/plugins/)
#   git clone https://github.com/zsh-users/zsh-autosuggestions.git
#   git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git
#   git clone https://github.com/Aloxaf/fzf-tab.git
# =========================
if [ -d "$HOME/.zsh/plugins" ]; then
  [ -r "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] &&
    source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

  [ -r "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ] &&
    source "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

  [ -r "$HOME/.zsh/plugins/fzf-tab/fzf-tab.zsh" ] &&
    source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.zsh"
fi

zstyle ':completion:*' menu select

# =========================
# Starship prompt
# =========================
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# Historique incrémental (history-substring-search)
# (paquet Arch : zsh-history-substring-search)
[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] &&
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# =========================
# Fzf + zoxide
# =========================
export FZF_DEFAULT_COMMAND="
    fd 
    --type f 
    --hidden 
    --follow 
    --exclude .git
"
export FZF_CTRL_T_COMMAND="
    $FZF_DEFAULT_COMMAND
"
export FZF_ALT_C_COMMAND="
    fd 
    --type d 
    --hidden 
    --follow 
    --exclude .git
"
export FZF_DEFAULT_OPTS="
    --height=30%
    --layout=reverse
    --border
    --preview 'bat --style=numbers --color=always --line-range=:200 {}'
    --preview-window=right:50%
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4
"

[ -r /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -r /usr/share/fzf/completion.zsh ]   && source /usr/share/fzf/completion.zsh

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# =========================
# Aliases de base
# =========================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias b='yazi'
alias n='nvim'

# Git
alias g='ga && gc && gp'
alias gs='git status'
alias ga='git add .'
gc() {
  echo -n "Message de commit: "
  read msg
  git commit -m "$msg"
}
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Grep / ripgrep
alias grep='grep --color=auto'
alias rg='rg --hidden --smart-case'

# Eza
alias ls='eza'
alias ll='eza -lha --git'
alias la='eza -la'
alias lt='eza -T'

# =========================
# OSINT shortcuts
# =========================
alias whois-ip='whois'
alias geoip='function _geoip() { curl -s "https://ipapi.co/$1/json/" | jq; }; _geoip'
alias myip='curl -s ifconfig.me'
alias headers='curl -sI'
alias dns='dog'          # ou "dig"
alias subdomains='subfinder -d'

alias topcmd="history | awk '{print \$2}' | sort | uniq -c | sort -rn | head -20"
alias shot='scrot ~/Pictures/osint_%Y%m%d_%H%M%S.png'

# =========================
# Arch workflow
# =========================
alias p='sudo pacman'
alias pS='sudo pacman -S'
alias pR='sudo pacman -Rns'
alias pQ='pacman -Q'
alias pSs='pacman -Ss'
alias pSyu='sudo pacman -Syu'
alias orphans='sudo pacman -Rns $(pacman -Qtdq)'

alias y='yay'
alias yS='yay -S'
alias ySyu='yay -Syu'

alias jlog='journalctl -xe'
alias jfollow='journalctl -f'
alias jboot='journalctl -b'

# =========================
# Keybindings / fzf
# =========================
bindkey '^F' fzf-history-widget

# =========================
# Functions utiles
# =========================
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' format inconnu" ;;
    esac
  else
    echo "'$1' n'est pas un fichier valide"
  fi
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

psgrep() {
  ps aux | grep -v grep | grep -i -e VSZ -e "$@"
}

# =========================
# Python / virtualenv / pyenv
# =========================
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

va() {
  if [[ -f "venv/bin/activate" ]]; then
    source venv/bin/activate
    echo "✅ venv activé"
  elif [[ -f ".venv/bin/activate" ]]; then
    source .venv/bin/activate
    echo "✅ .venv activé"
  else
    echo "❌ Aucun venv trouvé (venv/ ou .venv/)"
    return 1
  fi
};

alias venv='python -m venv venv'
alias vd='deactivate'
alias vrm='rm -rf venv .venv'
alias vreq='pip install -r requirements.txt'
alias vfreeze='pip freeze > requirements.txt'

[ -f ~/.config/theme.env ] && source ~/.config/theme.env ]

# Repos Dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias ca='z && config add ./.zshrc ./.themes ./.config/yazi ./.config/wofi ./.config/starship.toml ./.config/sway ./.config/qt5ct ./.config/qt6ct ./.config/nvim ./.config/kitty ./.config/i3status-rust ./.config/gtk-3.0 ./.config/gtk-4.0 ./.config/fastfetch ./.config/eza ./.config/cliphist ./.config/calcure ./.config/bat ./.config/swaylock ./.config/swaync ./.zsh ./README.md ./.assets ./.scripts'
alias cc='config commit'
alias cpush='config push'
